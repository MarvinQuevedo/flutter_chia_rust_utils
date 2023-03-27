use std::borrow::Borrow;
use std::collections::{BTreeMap, HashMap};

use std::rc::Rc;

use clvm_tools_rs::classic::clvm_tools::cmds::PathOrCodeConv;

use linked_hash_map::LinkedHashMap;
use yaml_rust::{Yaml, YamlEmitter};

use clvmr::allocator::Allocator;

use clvm_tools_rs::classic::clvm_tools::stages::stage_0::DefaultProgramRunner;
use clvm_tools_rs::classic::platform::PathJoin;

use clvm_tools_rs::classic::platform::argparse::{
    Argument, ArgumentParser, ArgumentValue, NArgsSpec, TArgOptionAction, TArgumentParserProps,
};

use clvm_tools_rs::compiler::cldb::{hex_to_modern_sexp, CldbNoOverride, CldbRun, CldbRunEnv};
use clvm_tools_rs::compiler::clvm::start_step;
use clvm_tools_rs::compiler::compiler::{compile_file, run_optimizer, DefaultCompilerOpts};
use clvm_tools_rs::compiler::comptypes::{CompileErr, CompilerOpts};

use clvm_tools_rs::compiler::prims;
use clvm_tools_rs::compiler::sexp;
use clvm_tools_rs::compiler::sexp::parse_sexp;
use clvm_tools_rs::compiler::srcloc::Srcloc;

pub fn to_yaml(entries: &[BTreeMap<String, String>]) -> Yaml {
    let result_array: Vec<Yaml> = entries
        .iter()
        .map(|tm| {
            let mut h = LinkedHashMap::new();
            for (k, v) in tm.iter() {
                h.insert(Yaml::String(k.clone()), Yaml::String(v.clone()));
            }
            Yaml::Hash(h)
        })
        .collect();
    Yaml::Array(result_array)
}

pub fn cldb_with_return(args: &[String]) -> Result<Vec<BTreeMap<String, String>>, String> {
    let tool_name = "cldb".to_string();
    let props = TArgumentParserProps {
        description: "Execute a clvm script.".to_string(),
        prog: format!("clvm_tools {tool_name}"),
    };

    let mut search_paths = Vec::new();
    let mut parser = ArgumentParser::new(Some(props));
    parser.add_argument(
        vec!["-i".to_string(), "--include".to_string()],
        Argument::new()
            .set_type(Rc::new(PathJoin {}))
            .set_help("add a search path for included files".to_string())
            .set_action(TArgOptionAction::Append)
            .set_default(ArgumentValue::ArgArray(vec![])),
    );
    parser.add_argument(
        vec!["-O".to_string(), "--optimize".to_string()],
        Argument::new()
            .set_action(TArgOptionAction::StoreTrue)
            .set_help("run optimizer".to_string()),
    );
    parser.add_argument(
        vec!["-x".to_string(), "--hex".to_string()],
        Argument::new()
            .set_action(TArgOptionAction::StoreTrue)
            .set_help("parse input program and arguments from hex".to_string()),
    );
    parser.add_argument(
        vec!["-y".to_string(), "--symbol-table".to_string()],
        Argument::new()
            .set_type(Rc::new(PathOrCodeConv {}))
            .set_help("path to symbol file".to_string()),
    );
    parser.add_argument(
        vec!["path_or_code".to_string()],
        Argument::new()
            .set_type(Rc::new(PathOrCodeConv {}))
            .set_help("filepath to clvm script, or a literal script".to_string()),
    );
    parser.add_argument(
        vec!["env".to_string()],
        Argument::new()
            .set_n_args(NArgsSpec::Optional)
            .set_type(Rc::new(PathOrCodeConv {}))
            .set_help("clvm script environment, as clvm src, or hex".to_string()),
    );
    let arg_vec = args[1..].to_vec();

    let mut input_file = None;
    let mut input_program = "()".to_string();

    let prog_srcloc = Srcloc::start("*program*");
    let args_srcloc = Srcloc::start("*args*");

    let mut args = Rc::new(sexp::SExp::atom_from_string(args_srcloc.clone(), ""));
    let mut parsed_args_result: String = "".to_string();

    let parsed_args: HashMap<String, ArgumentValue> = match parser.parse_args(&arg_vec) {
        Err(e) => {
            println!("FAIL: {e}");
            return Err(e);
        }
        Ok(pa) => pa,
    };

    if let Some(ArgumentValue::ArgArray(v)) = parsed_args.get("include") {
        for p in v {
            if let ArgumentValue::ArgString(_, s) = p {
                search_paths.push(s.to_string());
            }
        }
    }

    if let Some(ArgumentValue::ArgString(file, path_or_code)) = parsed_args.get("path_or_code") {
        input_file = file.clone();
        input_program = path_or_code.to_string();
    }

    if let Some(ArgumentValue::ArgString(_, s)) = parsed_args.get("env") {
        parsed_args_result = s.to_string();
    }

    let mut allocator = Allocator::new();

    let symbol_table = parsed_args
        .get("symbol_table")
        .and_then(|jstring| match jstring {
            ArgumentValue::ArgString(_, s) => {
                let decoded_symbol_table: Option<HashMap<String, String>> =
                    serde_json::from_str(s).ok();
                decoded_symbol_table
            }
            _ => None,
        });

    let do_optimize = parsed_args
        .get("optimize")
        .map(|x| matches!(x, ArgumentValue::ArgBool(true)))
        .unwrap_or_else(|| false);
    let runner = Rc::new(DefaultProgramRunner::new());
    let use_filename = input_file
        .clone()
        .unwrap_or_else(|| "*command*".to_string());
    let opts = Rc::new(DefaultCompilerOpts::new(&use_filename))
        .set_optimize(do_optimize)
        .set_search_paths(&search_paths);

    let mut use_symbol_table = symbol_table.unwrap_or_default();
    let unopt_res = compile_file(
        &mut allocator,
        runner.clone(),
        opts.clone(),
        &input_program,
        &mut use_symbol_table,
    );

    let mut output: Vec<BTreeMap<String, String>> = Vec::new();
    let yamlette_string = |to_print: Vec<BTreeMap<String, String>>| {
        let mut result = String::new();
        let mut emitter = YamlEmitter::new(&mut result);
        match emitter.dump(&to_yaml(&to_print)) {
            Ok(_) => result,
            Err(e) => format!("error producing yaml: {e:?}"),
        }
    };

    let res = match parsed_args.get("hex") {
        Some(ArgumentValue::ArgBool(true)) => hex_to_modern_sexp(
            &mut allocator,
            &use_symbol_table,
            prog_srcloc.clone(),
            &input_program,
        )
        .map_err(|_| CompileErr(prog_srcloc, "Failed to parse hex".to_string())),
        _ => {
            if do_optimize {
                unopt_res.and_then(|x| run_optimizer(&mut allocator, runner.clone(), Rc::new(x)))
            } else {
                unopt_res.map(Rc::new)
            }
        }
    };

    let program = match res {
        Ok(r) => r,
        Err(c) => {
            let mut parse_error = BTreeMap::new();
            parse_error.insert("Error-Location".to_string(), c.0.to_string());
            parse_error.insert("Error".to_string(), c.1);
            output.push(parse_error.clone());

            return Err(format!(
                "Error parsing program {}",
                yamlette_string(output.clone())
            ));
        }
    };

    match parsed_args.get("hex") {
        Some(ArgumentValue::ArgBool(true)) => {
            match hex_to_modern_sexp(
                &mut allocator,
                &HashMap::new(),
                args_srcloc,
                &parsed_args_result,
            ) {
                Ok(r) => {
                    args = r;
                }
                Err(p) => {
                    let mut parse_error = BTreeMap::new();
                    parse_error.insert("Error".to_string(), p.to_string());
                    output.push(parse_error.clone());

                    return Err(format!(
                        "Error parsing hex {}",
                        yamlette_string(output.clone())
                    ));
                }
            }
        }
        _ => match parse_sexp(Srcloc::start("*arg*"), parsed_args_result.bytes()) {
            Ok(r) => {
                if !r.is_empty() {
                    args = r[0].clone();
                }
            }
            Err(c) => {
                let mut parse_error = BTreeMap::new();
                parse_error.insert("Error-Location".to_string(), c.0.to_string());
                parse_error.insert("Error".to_string(), c.1);
                output.push(parse_error.clone());
                return Err(format!(
                    "Error parsing args {}",
                    yamlette_string(output.clone())
                ));
            }
        },
    };

    let mut prim_map = HashMap::new();
    for p in prims::prims().iter() {
        prim_map.insert(p.0.clone(), Rc::new(p.1.clone()));
    }
    let program_lines: Vec<String> = input_program.lines().map(|x| x.to_string()).collect();
    let step = start_step(program, args);
    let cldbenv = CldbRunEnv::new(
        input_file,
        program_lines,
        Box::new(CldbNoOverride::new_symbols(use_symbol_table)),
    );
    let mut cldbrun = CldbRun::new(runner, Rc::new(prim_map), Box::new(cldbenv), step);

    loop {
        if cldbrun.is_ended() {
            return Ok(output.clone());
        }

        if let Some(result) = cldbrun.step(&mut allocator) {
            output.push(result);
        }
    }
}
