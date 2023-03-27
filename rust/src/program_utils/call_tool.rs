use std::collections::HashMap;
 
use std::rc::Rc;

use clvmr::allocator::Allocator;

use clvm_tools_rs::classic::clvm_tools::sha256tree::sha256tree;

use clvm_tools_rs::classic::platform::argparse::{
    Argument, ArgumentParser, ArgumentValue, NArgsSpec, TArgOptionAction, TArgumentParserProps,
};

use clvm_tools_rs::classic::clvm_tools::cmds::{PathOrCodeConv, TConversion};

pub fn call_tool_with_return(
    allocator: &mut Allocator,
    tool_name: &str,
    desc: &str,
    conversion: Box<dyn TConversion>,
    input_args: &[String],
) -> Result<Vec<String>, String> {
    let props = TArgumentParserProps {
        description: desc.to_string(),
        prog: tool_name.to_string(),
    };

    let mut parser = ArgumentParser::new(Some(props));
    parser.add_argument(
        vec!["-H".to_string(), "--script-hash".to_string()],
        Argument::new()
            .set_action(TArgOptionAction::StoreTrue)
            .set_help("Show only sha256 tree hash of program".to_string()),
    );
    parser.add_argument(
        vec!["path_or_code".to_string()],
        Argument::new()
            .set_n_args(NArgsSpec::KleeneStar)
            .set_type(Rc::new(PathOrCodeConv {}))
            .set_help("path to clvm script, or literal script".to_string()),
    );

    let rest_args: Vec<String> = input_args.iter().skip(1).cloned().collect();
    let args_res = parser.parse_args(&rest_args);
    let args: HashMap<String, ArgumentValue> = match args_res {
        Ok(a) => a,
        Err(e) => {
            println!("{e}");
            return Err(e);
        }
    };

    let args_path_or_code_val = match args.get(&"path_or_code".to_string()) {
        None => ArgumentValue::ArgArray(vec![]),
        Some(v) => v.clone(),
    };

    let args_path_or_code = match args_path_or_code_val {
        ArgumentValue::ArgArray(v) => v,
        _ => vec![],
    };
    // array of strings
    let mut results: Vec<String> = vec![];
   

    for program in args_path_or_code {
        match program {
            ArgumentValue::ArgString(_, s) => {
                if s == "-" {
                    panic!("Read stdin is not supported at this time");
                }

                let conv_result = conversion.invoke(allocator, &s);
                match conv_result {
                    Ok(conv_result) => {
                        let sexp = *conv_result.first();
                        let text = conv_result.rest();
                        if args.contains_key(&"script_hash".to_string()) { 
                            results.push(sha256tree(allocator, sexp).hex());
                        } else if !text.is_empty() {
                            results.push(format!("{text}"));
                        }
                    }
                    Err(e) => {
                        results.push(format!("Conversion returned error: {:?}", e));
                        return Ok(results.clone());
                    }
                }
            }
            _ => {
                results.push(format!("inappropriate argument conversion"));
                return Ok(results.clone());
            }
        }
    }
    Ok(results.clone())
}
