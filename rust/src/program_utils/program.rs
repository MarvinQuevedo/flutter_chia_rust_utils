use crate::api::{bytes_to_hex, cmds_program_brun};
use crate::blockchain::sized_bytes::*;
use crate::program_utils::curry_utils;
use crate::program_utils::curry_utils::curry;
use crate::program_utils::serialized_program::SerializedProgram;

use crate::program_utils::serialize::node_from_bytes as deserialize2;
use crate::program_utils::serialize::{node_from_bytes, node_to_bytes};
use clvm_tools_rs::classic::clvm::__type_compatibility__::{t, Bytes, BytesFromType, Stream};
use clvm_tools_rs::classic::clvm::serialize::{sexp_from_stream, SimpleCreateCLVMObject};
use clvm_tools_rs::classic::clvm_tools::binutils::disassemble;
use clvm_tools_rs::classic::clvm_tools::sha256tree::sha256tree;

use clvmr::allocator::SExp::{Atom, Pair};
use clvmr::allocator::{Allocator, NodePtr, SExp};
use clvmr::cost::Cost;
use clvmr::node::Node;
use hex::encode;
use num_bigint::BigInt;
use serde::ser::StdError;
use std::collections::HashMap;
use std::error::Error;
use std::fmt;
use std::hash::Hash;
use std::hash::Hasher;

/* pub fn program_from_list(program_list: Vec<Program>) -> Program {
    let mut actual = Program::null();
        for element in program_list {
            let program = element.clone();
            actual = actual.cons(&program);
        }
    actual.clone()

} */

pub struct RunOutput {
    pub program: Program,
    pub cost: u64,
    pub error: Option<String>,
}

macro_rules! impl_sized_bytes {
    ($($name: ident, $size:expr);*) => {
        $(
            impl From<$name> for Program {
                fn from(bytes: $name) -> Self {
                    bytes.to_bytes().into()
                }
            }
            impl From<&$name> for Program {
                fn from(bytes: &$name) -> Self {
                    bytes.to_bytes().into()
                }
            }
            impl Into<$name> for Program {
                fn into(self) -> $name {
                    let vec_len = self.serialized.len();
                    if vec_len == $size + 1 {
                        $name::new(self.serialized[1..].to_vec())
                    } else {
                        $name::new(self.serialized)
                    }
                }
            }
            impl Into<$name> for &Program {
                fn into(self) -> $name {
                    let vec_len = self.serialized.len();
                    if vec_len == $size + 1 {
                        $name::new(self.serialized[1..].to_vec())
                    } else {
                        $name::new(self.serialized.clone())
                    }
                }
            }
        )*
    };
    ()=>{};
}

impl_sized_bytes!(
    UnsizedBytes, 0;
    Bytes4, 4;
    Bytes8, 8;
    Bytes16, 16;
    Bytes32, 32;
    Bytes48, 48;
    Bytes96, 96;
    Bytes192, 192
);

macro_rules! impl_ints {
    ($($name: ident, $size: expr);*) => {
        $(
            impl From<$name> for Program {
                fn from(int_val: $name) -> Self {
                    if int_val == 0 {
                        return Program::new(Vec::new());
                    }
                    let as_ary = int_val.to_be_bytes();
                    let mut as_bytes = as_ary.as_slice();
                    while as_bytes.len() > 1 && as_bytes[0] == ( if as_bytes[1] & 0x80 > 0{0xFF} else {0}) {
                        as_bytes = &as_bytes[1..];
                    }
                    as_bytes.to_vec().into()
                }
            }
            impl Into<$name> for Program {
                fn into(self) -> $name {
                    let mut byte_ary: [u8; $size] = [0; $size];
                    byte_ary[..$size].clone_from_slice(&self.serialized);
                    $name::from_be_bytes(byte_ary)
                }
            }
        )*
    };
    ()=>{};
}

impl_ints!(
    u8, 1;
    u16, 2;
    u32, 4;
    u64, 8;
    u128, 16;
    i8, 1;
    i16, 2;
    i32, 4;
    i64, 8;
    i128, 16
);

#[derive(Debug)]
pub struct Program {
    pub serialized: Vec<u8>,
    alloc: Allocator,
    nodeptr: i32,
}
pub struct UncurriedProgram {
    pub program: Program,
    pub args: Vec<Program>,
}
impl Program {
    pub fn curry(&self, args: Vec<Program>) -> Result<Program, Box<dyn Error>> {
        let (_cost, program) = curry(&self, args)?;
        Ok(program)
    }

    pub fn uncurry(&self) -> UncurriedProgram {
        let mut allocator = Allocator::new();
        let nodeptr = node_from_bytes(&mut allocator, self.serialized.clone().as_slice()).unwrap();
        let uncurried = crate::program_utils::uncurry::uncurry(&allocator, nodeptr).unwrap();
        let program_node = Node::new(&allocator, uncurried.0);
        let uncurred_program_bytes = node_to_bytes(&program_node).unwrap();
        let mut args = Vec::new();
        for arg in uncurried.1 {
            let arg_node = Node::new(&allocator, arg);
            let arg_bytes = node_to_bytes(&arg_node).unwrap();
            args.push(
                SerializedProgram::from_bytes(&arg_bytes.clone())
                    .to_program()
                    .unwrap(),
            );
        }
        let program = Program::new(uncurred_program_bytes);
        UncurriedProgram { program, args }
    }

    pub fn as_atom_list(&mut self) -> Vec<Vec<u8>> {
        let mut rtn: Vec<Vec<u8>> = Vec::new();
        let mut current = self.clone();
        loop {
            match current.as_pair() {
                None => {
                    break;
                }
                Some((first, rest)) => match first.as_vec() {
                    None => {
                        break;
                    }
                    Some(atom) => {
                        rtn.push(atom);
                        current = rest;
                    }
                },
            }
        }
        rtn
    }

    pub fn to_map(self) -> Result<HashMap<Program, Program>, Box<dyn Error>> {
        let mut rtn: HashMap<Program, Program> = HashMap::new();
        let mut cur_node = self;
        loop {
            match cur_node.to_sexp() {
                Atom(_) => break,
                Pair(_, _) => {
                    let pair = cur_node.as_pair().unwrap();
                    cur_node = pair.1;
                    match pair.0.to_sexp() {
                        Atom(_) => {
                            rtn.insert(pair.0.as_atom().unwrap(), Program::new(Vec::new()));
                        }
                        Pair(_, _) => {
                            let inner_pair = pair.0.as_pair().unwrap();
                            rtn.insert(inner_pair.0, inner_pair.1);
                        }
                    }
                }
            }
        }
        Ok(rtn)
    }

    pub fn to_sexp(&self) -> SExp {
        self.alloc.sexp(self.nodeptr)
    }

    pub fn to_node(&self) -> Node {
        Node::new(&self.alloc, self.nodeptr).clone()
    }

    pub fn is_atom(&self) -> bool {
        self.as_atom().is_some()
    }

    pub fn is_pair(&self) -> bool {
        self.as_pair().is_some()
    }

    pub fn as_atom(&self) -> Option<Program> {
        match self.to_sexp() {
            Atom(_) => Some(Program::new(self.alloc.atom(self.nodeptr).to_vec())),
            _ => None,
        }
    }
    pub fn as_vec(&self) -> Option<Vec<u8>> {
        match self.to_sexp() {
            Atom(_) => Some(self.alloc.atom(self.nodeptr).to_vec()),
            _ => None,
        }
    }

    pub fn as_pair(&self) -> Option<(Program, Program)> {
        match self.to_sexp() {
            Pair(p1, p2) => {
                let left_node = Node::new(&self.alloc, p1);
                let right_node = Node::new(&self.alloc, p2);
                let left = match node_to_bytes(&left_node) {
                    Ok(serial_data) => Program::new(serial_data),
                    Err(_) => Program::new(Vec::new()),
                };
                let right = match node_to_bytes(&right_node) {
                    Ok(serial_data) => Program::new(serial_data),
                    Err(_) => Program::new(Vec::new()),
                };
                Some((left, right))
            }
            _ => None,
        }
    }

    pub fn cons(&self, other: &Program) -> Program {
        let mut alloc = Allocator::new();
        let first = match node_from_bytes(&mut alloc, &self.serialized.as_slice()) {
            Ok(ptr) => ptr,
            Err(_) => alloc.null(),
        };
        let rest = match node_from_bytes(&mut alloc, &other.serialized.as_slice()) {
            Ok(ptr) => ptr,
            Err(_) => alloc.null(),
        };
        match alloc.new_pair(first, rest) {
            Ok(pair) => {
                let node = Node::new(&alloc, pair);
                let node_bytes = node_to_bytes(&node).unwrap();
                Program::new(node_bytes)
            }
            Err(_) => Program::null(),
        }
    }

    pub fn as_int(&self) -> Result<BigInt, Box<dyn Error>> {
        match &self.as_atom() {
            Some(atom) => Ok(BigInt::from_signed_bytes_be(
                atom.as_vec().unwrap().as_slice(),
            )),
            None => {
                log::debug!("BAD INT: {:?}", self.serialized);
                Err("Program is Pair not Atom".into())
            }
        }
    }

    pub fn first(&self) -> Result<Program, Box<dyn Error>> {
        match self.as_pair() {
            Some((p1, _)) => Ok(p1),
            _ => Err("first of non-cons".into()),
        }
    }

    pub fn rest(&self) -> Result<Program, Box<dyn Error>> {
        match self.as_pair() {
            Some((_, p2)) => Ok(p2),
            _ => Err("rest of non-cons".into()),
        }
    }

    pub fn iter(&self) -> ProgramIter {
        ProgramIter {
            node: Node::new(&self.alloc, self.nodeptr).clone().into_iter(),
        }
    }
    pub fn run_with_cmd(&self, args: Program) -> RunOutput {
        let program_source = self.disassemble();
        let args_source = args.disassemble();
        let cmd_args = ["-c".to_string(), program_source, args_source];
        let output = cmds_program_brun(cmd_args.to_vec());
        let lines = output.split("\n").collect::<Vec<&str>>();
        let mut cleaned_lines = Vec::new();
        for line in lines {
            if line.trim().len() > 0 {
                cleaned_lines.push(line.trim());
            }
        }

        let first_line = cleaned_lines[0];
        let str_cost = first_line.split("cost = ").collect::<Vec<&str>>()[1].to_string();
        let cost: u64 = str_cost.parse::<u64>().unwrap();
        let result = cleaned_lines[1].to_string();

        let program = result.split("0x").last().unwrap();
        let result_bytes = hex::decode(program).unwrap();

        let program = SerializedProgram::from_bytes(&result_bytes)
            .to_program()
            .unwrap();
        RunOutput {
            program,
            cost,
            error: None,
        }
    }
    pub fn run(&self, args: Program) -> RunOutput {
        let mut alloc = Allocator::new();
        let serialized_p = SerializedProgram::from_bytes(&self.serialized.clone());

        let (cost, result) = serialized_p
            .run_with_cost(&mut alloc, Cost::MAX, &args.clone())
            .unwrap();
        let prog = Node::new(&alloc, result);
        let bytes = node_to_bytes(&prog).unwrap();
        let program = Program::new(bytes);
        RunOutput {
            program,
            cost,
            error: None,
        }
    }

    pub fn disassemble(&self) -> String {
        let mut stream = Stream::new(Some(Bytes::new(Some(BytesFromType::Raw(
            self.serialized.clone(),
        )))));
        let mut allocator = Allocator::new();

        let result = sexp_from_stream(
            &mut allocator,
            &mut stream,
            Box::new(SimpleCreateCLVMObject {}),
        )
        .map_err(|e| e.1)
        .map(|sexp| {
            let disassembled = disassemble(&mut allocator, sexp.1);
            t(sexp.1, disassembled)
        })
        .unwrap();

        result.rest().to_string()
    }
}

impl Into<SerializedProgram> for Program {
    fn into(self) -> SerializedProgram {
        SerializedProgram::from_bytes(&self.serialized)
    }
}

impl From<Vec<u8>> for Program {
    fn from(bytes: Vec<u8>) -> Self {
        let mut alloc = Allocator::new();
        let atom = match alloc.new_atom(bytes.as_slice()) {
            Ok(ptr) => ptr,
            Err(_) => alloc.null(),
        };
        let node = Node::new(&alloc, atom);
        let node_bytes = match node_to_bytes(&node) {
            Ok(n_bytes) => n_bytes,
            Err(_) => Vec::new(),
        };
        let prog = Program {
            serialized: node_bytes,
            alloc: alloc,
            nodeptr: atom,
        };
        prog
    }
}

impl From<Vec<Program>> for Program {
    fn from(program_list: Vec<Program>) -> Self {
        let mut actual = Program::new(Vec::new());
        let invert_list = program_list.iter().rev().collect::<Vec<&Program>>();
        for element in invert_list {
            let program = element.clone();
            actual = program.cons(&actual);
        }
        actual.clone()
    }
}

impl From<&Vec<u8>> for Program {
    fn from(bytes: &Vec<u8>) -> Self {
        let mut alloc = Allocator::new();
        let atom = match alloc.new_atom(bytes.as_slice()) {
            Ok(ptr) => ptr,
            Err(_) => alloc.null(),
        };
        let node = Node::new(&alloc, atom);
        let node_bytes = match node_to_bytes(&node) {
            Ok(n_bytes) => n_bytes,
            Err(_) => Vec::new(),
        };
        let prog = Program {
            serialized: node_bytes,
            alloc: alloc,
            nodeptr: atom,
        };
        prog
    }
}

impl TryFrom<(Program, Program)> for Program {
    type Error = Box<(dyn StdError + 'static)>;
    fn try_from((first, second): (Program, Program)) -> Result<Self, Self::Error> {
        let mut alloc = Allocator::new();
        let first = node_from_bytes(&mut alloc, &first.serialized.as_slice())?;
        let rest = node_from_bytes(&mut alloc, &second.serialized.as_slice())?;
        match alloc.new_pair(first, rest) {
            Ok(pair) => {
                let node = Node::new(&alloc, pair);
                let node_bytes = node_to_bytes(&node)?;
                Ok(Program::new(node_bytes))
            }
            Err(error) => Err(error.1.into()),
        }
    }
}

pub struct ProgramIter<'a> {
    node: Node<'a>,
}
impl Iterator for ProgramIter<'_> {
    type Item = Program;
    fn next(&mut self) -> Option<Self::Item> {
        match self.node.next() {
            Some(m_node) => match node_to_bytes(&m_node) {
                Ok(bytes) => {
                    let prog = Program::new(bytes);
                    Some(prog)
                }
                Err(_) => None,
            },
            None => None,
        }
    }
}

impl Clone for Program {
    fn clone(&self) -> Self {
        Program::new(self.serialized.clone())
    }
}

impl Hash for Program {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.serialized.hash(state);
    }
}

impl PartialEq for Program {
    fn eq(&self, other: &Self) -> bool {
        self.serialized == other.serialized
    }
}
impl Eq for Program {}

impl fmt::Display for Program {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({})", encode(&self.serialized))
    }
}

impl Program {
    pub fn new(serialized: Vec<u8>) -> Self {
        let alloc = Allocator::new();
        let null = alloc.null();
        let mut prog = Program {
            serialized: serialized.clone(),
            alloc: alloc,
            nodeptr: null,
        };
        prog.set_node();
        prog
    }
    pub fn null() -> Self {
        let alloc = Allocator::new();
        let null = alloc.null();
        let serial = match node_to_bytes(&Node::new(&alloc, null)) {
            Ok(bytes) => bytes,
            Err(_) => vec![],
        };
        let mut prog = Program {
            serialized: serial,
            alloc: alloc,
            nodeptr: null,
        };
        prog.set_node();
        prog
    }
    fn set_node(&mut self) {
        self.nodeptr = match node_from_bytes(&mut self.alloc, &self.serialized) {
            Ok(node) => node,
            Err(_) => self.alloc.null(),
        };
    }
    pub fn tree_hash(&self) -> Bytes32 {
        let mut alloc2 = Allocator::new();
        let nodeptr = match deserialize2(&mut alloc2, &self.serialized) {
            Ok(node) => node,
            Err(_) => alloc2.null(),
        };
        Bytes32::new(sha256tree(&mut alloc2, nodeptr).raw())
    }
}
