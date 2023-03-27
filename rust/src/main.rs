mod api;
mod blockchain;
mod bridge_generated; /* AUTO INJECTED BY flutter_rust_bridge. This line may not be accurate, and you can change it according to your needs. */
mod chia_wallet;
mod chiapos;
mod program_utils;

use api::hex_to_bytes;
use chia_bls::{derive_keys::master_to_wallet_hardened, secret_key::SecretKey};
use chia_wallet::standart::puzzles::calculate_synthetic_public_key;
use clvmr::{
    allocator::{Allocator, NodePtr},
    node::Node,
    serialize::{node_from_bytes, node_to_bytes},
};

use crate::{
    api::{
        bytes_to_hex, cmd_program_opc, cmd_program_opd, cmds_program_run, program_curry,
        program_disassemble, program_uncurry,
    },
    chia_wallet::standart::puzzles::p2_delegated_puzzle_or_hidden_puzzle::get_puzzle_from_pk,
    program_utils::{program::Program, serialized_program::SerializedProgram},
};

fn main() {
    let  spected_puzzle = SerializedProgram::from_hex("ff02ffff01ff02ffff01ff02ffff03ff0bffff01ff02ffff03ffff09ff05ffff1dff0bffff1effff0bff0bffff02ff06ffff04ff02ffff04ff17ff8080808080808080ffff01ff02ff17ff2f80ffff01ff088080ff0180ffff01ff04ffff04ff04ffff04ff05ffff04ffff02ff06ffff04ff02ffff04ff17ff80808080ff80808080ffff02ff17ff2f808080ff0180ffff04ffff01ff32ff02ffff03ffff07ff0580ffff01ff0bffff0102ffff02ff06ffff04ff02ffff04ff09ff80808080ffff02ff06ffff04ff02ffff04ff0dff8080808080ffff01ff0bffff0101ff058080ff0180ff018080ffff04ffff01b0947ac57f3dcb25a041d449fb96f36edbf27fe3bb4fc305be62b014f6a47b983b8e0a027670fb723a0978d4a82fd97f6fff018080".to_string()).to_program().unwrap();
    let mut sk_array = [0u8; 32];

    let sk_bytes = hex_to_bytes(
        "0befcabff4a664461cc8f190cdd51c05621eb2837c71a1362df5b465a674ecfb".to_string(),
    );
    sk_array.copy_from_slice(&sk_bytes);
    let master_sk = SecretKey::from_bytes(&sk_array).unwrap();
    let wallet_sk = master_to_wallet_hardened(&master_sk, 0);
    let public_key = wallet_sk.public_key();

    println!("master_sk: {:?}", master_sk);
    println!("wallet_sk: {:?}", wallet_sk);
    println!(
        "public_key: {:?}",
        bytes_to_hex(public_key.to_bytes().to_vec())
    );

    let puzzle = get_puzzle_from_pk(public_key);
    let puzzle_hash = puzzle.tree_hash();
    let spected_ph = spected_puzzle.tree_hash();

    println!("puzzle0: {:?}", bytes_to_hex(puzzle.serialized.clone()));
    println!(
        "puzzle1: {:?}",
        bytes_to_hex(spected_puzzle.serialized.clone())
    );
    println!("puzzle_hash: {:?}", bytes_to_hex(puzzle_hash.to_sized_bytes().to_vec()));
    println!("puzzle_hash: {:?}", bytes_to_hex(spected_ph.to_sized_bytes().to_vec()));

}
