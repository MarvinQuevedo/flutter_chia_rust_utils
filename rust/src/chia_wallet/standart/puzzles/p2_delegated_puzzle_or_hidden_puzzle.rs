use chia_bls::public_key::PublicKey;

use crate::api::{bytes_to_hex, hex_to_bytes, program_disassemble};
use crate::program_utils::program::Program;
use crate::program_utils::serialized_program::SerializedProgram;

use super::calculate_synthetic_public_key::calculate_synthetic_public_key_program;
use super::p2_conditions::puzzleForConditions;

pub fn p2_delegated_puzzle_or_hidden_puzzle_program() -> Program {
    return SerializedProgram::from_hex("ff02ffff01ff02ffff03ff0bffff01ff02ffff03ffff09ff05ffff1dff0bffff1effff0bff0bffff02ff06ffff04ff02ffff04ff17ff8080808080808080ffff01ff02ff17ff2f80ffff01ff088080ff0180ffff01ff04ffff04ff04ffff04ff05ffff04ffff02ff06ffff04ff02ffff04ff17ff80808080ff80808080ffff02ff17ff2f808080ff0180ffff04ffff01ff32ff02ffff03ffff07ff0580ffff01ff0bffff0102ffff02ff06ffff04ff02ffff04ff09ff80808080ffff02ff06ffff04ff02ffff04ff0dff8080808080ffff01ff0bffff0101ff058080ff0180ff018080".to_string()).to_program().unwrap();
}
pub fn default_hidden_puzzle() -> Program {
    return SerializedProgram::from_hex("ff0980".to_string())
        .to_program()
        .unwrap();
}

pub fn solution_for_delegated_puzzle(delegated_puzzle: Program, solution: Program) -> Program {
    let empty_list: Vec<Program> = Vec::new();
    let empty_program = Program::from(empty_list);
    let args = Program::from([empty_program, delegated_puzzle, solution].to_vec());
    args
}

pub fn solutionForConditions(conditions: Program) -> Program {
    let delegatedPuzzle = puzzleForConditions(conditions);
    let empty_list: Vec<Program> = Vec::new();
    return solution_for_delegated_puzzle(delegatedPuzzle, Program::from(empty_list));
}

pub fn get_puzzle_from_pk_and_hidden_puzzle(pk: PublicKey, hidden_puzzle: Program) -> Program {
    let pk_bytes = pk.to_bytes().to_vec();
    let hidden_puzzle_hash = hidden_puzzle.tree_hash().to_sized_bytes().to_vec();
    let args = Program::from(
        [
            Program::from(pk_bytes.clone()),
            Program::from(hidden_puzzle_hash.clone()),
        ]
        .to_vec(),
    );

    let synthetic_pub_key = calculate_synthetic_public_key_program().run(args);

    let p2_args = [synthetic_pub_key.program].to_vec();
    let curried = p2_delegated_puzzle_or_hidden_puzzle_program()
        .curry(p2_args)
        .unwrap();
    return curried;
}

pub fn get_puzzle_from_pk(pk: PublicKey) -> Program {
    let hidden_puzzle = default_hidden_puzzle();
    return get_puzzle_from_pk_and_hidden_puzzle(pk, hidden_puzzle);
}
