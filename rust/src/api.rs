use std::collections::BTreeMap;

use chia_bls::derivable_key::DerivableKey;
use chia_bls::derive_keys;
use chia_bls::mnemonic::entropy_to_mnemonic;
use chia_bls::mnemonic::entropy_to_seed;
use chia_bls::mnemonic::mnemonic_to_entropy;
use chia_bls::public_key::PublicKey;
use chia_bls::secret_key::SecretKey;
use chia_bls::signature;
use chia_bls::signature::sign;
use clvm_tools_rs::classic::clvm::__type_compatibility__::{t, Bytes, BytesFromType, Stream};
use clvm_tools_rs::classic::clvm::serialize::{sexp_from_stream, SimpleCreateCLVMObject};
use clvm_tools_rs::classic::clvm_tools::binutils::disassemble;
use clvm_tools_rs::classic::clvm_tools::cmds::{launch_tool, OpcConversion, OpdConversion};
use clvmr::allocator::Allocator;
use sha2::{Digest, Sha256};
use yaml_rust::YamlEmitter;

use crate::chia_wallet::standart::puzzles::p2_delegated_puzzle_or_hidden_puzzle::get_puzzle_from_pk;
use crate::program_utils::call_tool::call_tool_with_return;
use crate::program_utils::cldb::cldb_with_return;
use crate::program_utils::cldb::to_yaml;
use crate::program_utils::curry_utils::curry;

use crate::program_utils::program::Program;
use crate::program_utils::serialized_program::SerializedProgram;

pub struct UncurriedProgramToDart {
    pub program: Vec<u8>,
    pub args: Vec<String>,
    pub error: String,
}
pub struct ApiOutputProgram {
    pub program: Vec<u8>,
    pub cost: u64,
}

pub fn secret_key_from_seed(seed: Vec<u8>) -> Vec<u8> {
    let mut seed_array = [0u8; 64];
    seed_array.copy_from_slice(&seed);
    let sk = SecretKey::from_seed(&seed_array);
    sk.to_bytes().to_vec()
}

pub fn secret_key_public_key(sk: Vec<u8>) -> Vec<u8> {
    let mut sk_array = [0u8; 32];
    sk_array.copy_from_slice(&sk);
    let sk = SecretKey::from_bytes(&sk_array).unwrap();
    let pk = sk.public_key();
    pk.to_bytes().to_vec()
}

pub fn secret_key_derive_path_hardened(sk: Vec<u8>, path: Vec<u32>) -> Vec<u8> {
    let mut sk_array = [0u8; 32];
    sk_array.copy_from_slice(&sk);
    let mut sk = SecretKey::from_bytes(&sk_array).unwrap();
    for idx in path {
        sk = sk.derive_hardened(idx);
    }
    sk.to_bytes().to_vec()
}

pub fn secret_key_derive_path_unhardened(sk: Vec<u8>, path: Vec<u32>) -> Vec<u8> {
    let mut sk_array = [0u8; 32];
    sk_array.copy_from_slice(&sk);
    let mut sk = SecretKey::from_bytes(&sk_array).unwrap();
    for idx in path {
        sk = sk.derive_unhardened(idx);
    }
    sk.to_bytes().to_vec()
}

pub fn public_key_derive_path_unhardened(sk: Vec<u8>, path: Vec<u32>) -> Vec<u8> {
    let mut sk_array = [0u8; 48];
    sk_array.copy_from_slice(&sk);
    let mut pk = PublicKey::from_bytes(&sk_array).unwrap();
    for idx in path {
        pk = pk.derive_unhardened(idx);
    }
    pk.to_bytes().to_vec()
}

pub fn signature_sign(sk: Vec<u8>, msg: Vec<u8>) -> Vec<u8> {
    let mut sk_array = [0u8; 32];
    sk_array.copy_from_slice(&sk);
    let sk = SecretKey::from_bytes(&sk_array).unwrap();
    let sig = sign(&sk, &msg);
    sig.to_bytes().to_vec()
}

pub fn signature_is_valid(sig: Vec<u8>) -> bool {
    let mut sig_array = [0u8; 96];
    sig_array.copy_from_slice(&sig);
    let sig = signature::Signature::from_bytes(&sig_array).unwrap();
    sig.is_valid()
}

pub fn signature_aggregate(sigs_stream: Vec<u8>, length: usize) -> Vec<u8> {
    let mut sigs = Vec::new();
    for i in 0..length {
        let mut sig_array = [0u8; 96];
        sig_array.copy_from_slice(&sigs_stream[i * 96..i * 96 + 96]);
        let sig = signature::Signature::from_bytes(&sig_array).unwrap();
        sigs.push(sig);
    }
    let sig = signature::aggregate(&sigs);
    sig.to_bytes().to_vec()
}

pub fn signature_verify(pk: Vec<u8>, msg: Vec<u8>, sig: Vec<u8>) -> bool {
    let mut pk_array = [0u8; 48];
    pk_array.copy_from_slice(&pk);
    let public_key = PublicKey::from_bytes(&pk_array).unwrap();
    let mut sig_array = [0u8; 96];
    sig_array.copy_from_slice(&sig);
    let sig = signature::Signature::from_bytes(&sig_array).unwrap();
    signature::verify(&sig, &public_key, &msg)
}

pub fn pub_mnemonic_to_entropy(mnemonic_words: String) -> Vec<u8> {
    let entropy = mnemonic_to_entropy(&mnemonic_words).unwrap();
    entropy.to_vec()
}

pub fn pub_entropy_to_mnemonic(entropy: Vec<u8>) -> String {
    let mut entropy_array = [0u8; 32];
    entropy_array.copy_from_slice(&entropy);
    let mnemonic = entropy_to_mnemonic(&entropy_array);
    mnemonic
}
pub fn pub_entropy_to_seed(entropy: Vec<u8>) -> Vec<u8> {
    let mut entropy_array = [0u8; 32];
    entropy_array.copy_from_slice(&entropy);
    let seed = entropy_to_seed(&entropy_array);
    seed.to_vec()
}

pub fn bytes_to_hex(bytes: Vec<u8>) -> String {
    let mut hex = String::new();
    for byte in bytes {
        hex.push_str(&format!("{:02x}", byte));
    }
    hex
}

pub fn hex_to_bytes(hex: String) -> Vec<u8> {
    let mut bytes = Vec::new();
    for i in 0..hex.len() / 2 {
        let byte = u8::from_str_radix(&hex[i * 2..i * 2 + 2], 16).unwrap();
        bytes.push(byte);
    }
    bytes
}

pub fn bytes_to_sha256(bytes: Vec<u8>) -> Vec<u8> {
    let mut hasher = Sha256::new();
    hasher.update(bytes);
    hasher.finalize().to_vec()
}

pub fn pub_master_to_wallet_unhardened_intermediate(master: Vec<u8>) -> Vec<u8> {
    let mut sk_array = [0u8; 32];
    sk_array.copy_from_slice(&master);
    let master_sk = SecretKey::from_bytes(&sk_array).unwrap();
    let sk = derive_keys::master_to_wallet_unhardened_intermediate(&master_sk);
    sk.to_bytes().to_vec()
}

pub fn pub_master_to_wallet_unhardened(master: Vec<u8>, idx: u32) -> Vec<u8> {
    let mut sk_array = [0u8; 32];
    sk_array.copy_from_slice(&master);
    let master_sk = SecretKey::from_bytes(&sk_array).unwrap();
    let sk = derive_keys::master_to_wallet_unhardened(&master_sk, idx);
    sk.to_bytes().to_vec()
}

pub fn pub_master_to_wallet_hardened_intermediate(master: Vec<u8>) -> Vec<u8> {
    let mut sk_array = [0u8; 32];
    sk_array.copy_from_slice(&master);
    let master_sk = SecretKey::from_bytes(&sk_array).unwrap();
    let sk = derive_keys::master_to_wallet_hardened_intermediate(&master_sk);
    sk.to_bytes().to_vec()
}

pub fn pub_master_to_wallet_hardened(master: Vec<u8>, idx: u32) -> Vec<u8> {
    let mut sk_array = [0u8; 32];
    sk_array.copy_from_slice(&master);
    let master_sk = SecretKey::from_bytes(&sk_array).unwrap();
    let sk = derive_keys::master_to_wallet_hardened(&master_sk, idx);
    sk.to_bytes().to_vec()
}

pub fn pub_master_to_pool_singleton(master: Vec<u8>, pool_wallet_idx: u32) -> Vec<u8> {
    let mut sk_array = [0u8; 32];
    sk_array.copy_from_slice(&master);
    let master_sk = SecretKey::from_bytes(&sk_array).unwrap();
    let sk = derive_keys::master_to_pool_singleton(&master_sk, pool_wallet_idx);
    sk.to_bytes().to_vec()
}

pub fn pub_master_to_pool_authentication(sk: Vec<u8>, pool_wallet_idx: u32, idx: u32) -> Vec<u8> {
    let mut sk_array = [0u8; 32];
    sk_array.copy_from_slice(&sk);
    let master_sk = SecretKey::from_bytes(&sk_array).unwrap();
    let sk = derive_keys::master_to_pool_authentication(&master_sk, pool_wallet_idx, idx);
    sk.to_bytes().to_vec()
}

pub fn cmds_program_run(args: Vec<String>) -> String {
    let mut s = Stream::new(None);
    let mut args = args;
    args.insert(0, "".to_string());
    launch_tool(&mut s, args.as_slice(), "run", 2);
    let result = s.get_value().data().to_vec();
    String::from_utf8(result).unwrap()
}

pub fn cmds_program_brun(args: Vec<String>) -> String {
    let mut s = Stream::new(None);
    let mut args = args;
    args.insert(0, "".to_string());
    launch_tool(&mut s, args.as_slice(), "brun", 0);
    let result = s.get_value().data().to_vec();
    String::from_utf8(result).unwrap()
}

// Compile a clvm script. convert to serialezed bytes
pub fn cmd_program_opc(args: Vec<String>) -> Vec<String> {
    let mut args = args;
    args.insert(0, "".to_string());
    let mut allocator = Allocator::new();
    let call_result = call_tool_with_return(
        &mut allocator,
        "opc",
        "Compile a clvm script.",
        Box::new(OpcConversion {}),
        args.as_slice(),
    );
    match call_result {
        Ok(result) => result,
        Err(e) => {
            vec![format!("Error: {}", e)]
        }
    }
}

//Disassemble a compiled clvm script from hex.
pub fn cmd_program_opd(args: Vec<String>) -> Vec<String> {
    let mut args = args;
    args.insert(0, "".to_string());
    let mut args_str = String::new();
    for arg in args.iter() {
        args_str.push_str(arg);
    }
    let mut allocator = Allocator::new();
    let call_result = call_tool_with_return(
        &mut allocator,
        "opd",
        "Disassemble a compiled clvm script from hex.",
        Box::new(OpdConversion {}),
        args.as_slice(),
    );
    match call_result {
        Ok(result) => {
            let copy = result.clone();
            copy
        }
        Err(e) => {
            vec![format!("Error: {}", e)]
        }
    }
}

pub fn cmd_program_cldb(args: Vec<String>) -> String {
    let yamlette_string = |to_print: Vec<BTreeMap<String, String>>| {
        let mut result = String::new();
        let mut emitter = YamlEmitter::new(&mut result);
        match emitter.dump(&to_yaml(&to_print)) {
            Ok(_) => result,
            Err(e) => format!("error producing yaml: {e:?}"),
        }
    };
    let mut args = args;
    args.insert(0, "".to_string());

    let call_result = cldb_with_return(args.as_slice());
    match call_result {
        Ok(result) => format!("{}", yamlette_string(result)),
        Err(e) => {
            format!("Error: {}", e)
        }
    }
}

pub fn program_tree_hash(program_bytes: Vec<u8>) -> [u8; 32] {
    let program = SerializedProgram::from_bytes(&program_bytes)
        .to_program()
        .unwrap();
    return program.tree_hash().to_sized_bytes();
}

pub fn program_curry(program_bytes: Vec<u8>, args_str: Vec<String>) -> Vec<u8> {
    let args = args_str;
    let mut args_vec: Vec<Program> = Vec::new();
    for arg in args {
        let program_serialized = SerializedProgram::from(arg.to_string());
        args_vec.push(program_serialized.to_program().unwrap());
    }
    let raw_program = SerializedProgram::from_bytes(&program_bytes)
        .to_program()
        .unwrap();
    let curried = curry(&raw_program, args_vec);
    let (_cost, program_result) = curried.unwrap();
    program_result.serialized.clone()
}

pub fn program_uncurry(program_bytes: Vec<u8>) -> UncurriedProgramToDart {
    let raw_program = SerializedProgram::from_bytes(&program_bytes)
        .to_program()
        .unwrap();
    let uncurried = raw_program.uncurry();
    let program_bytes = uncurried.program.serialized.clone();
    let mut args = Vec::new();
    for arg in uncurried.args {
        args.push(bytes_to_hex(arg.serialized.clone()));
    }
    UncurriedProgramToDart {
        program: program_bytes,
        args: args,
        error: "".to_string(),
    }
}

pub fn program_from_list(program_list: Vec<String>) -> Vec<u8> {
    let mut actual = Program::null();
    for element in program_list {
        let program = SerializedProgram::from(element).to_program().unwrap();
        actual = actual.cons(&program);
    }
    actual.serialized.clone()
}

pub fn program_disassemble(program_bytes: Vec<u8>) -> String {
    let mut stream = Stream::new(Some(Bytes::new(Some(BytesFromType::Raw(program_bytes)))));
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

pub fn program_run(program_bytes: Vec<u8>, args_str: Vec<String>) -> ApiOutputProgram {
    let args = args_str;
    let mut args_vec: Vec<Program> = Vec::new();
    for arg in args {
        let program_serialized = SerializedProgram::from(arg.to_string());
        args_vec.push(program_serialized.to_program().unwrap());
    }
    let raw_program = SerializedProgram::from_bytes(&program_bytes)
        .to_program()
        .unwrap();
    let args_program = Program::from(args_vec);
    let run_result = raw_program.run(args_program);
    ApiOutputProgram {
        program: run_result.program.serialized.clone(),
        cost: run_result.cost,
    }
}

pub fn get_puzzle_from_public_key(pk: Vec<u8>) -> Vec<u8> {
    let mut pk_array = [0u8; 48];
    pk_array.copy_from_slice(&pk);
    let public_key = PublicKey::from_bytes(&pk_array.clone()).unwrap();
    let program = get_puzzle_from_pk(public_key);
    program.serialized.clone()
}
