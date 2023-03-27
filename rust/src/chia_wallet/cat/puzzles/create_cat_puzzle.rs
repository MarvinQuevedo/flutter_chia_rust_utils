use crate::program_utils::{program::Program, };

use super::cat_puzzle_program::cat_puzzle_program;

  

pub fn create_cat_puzzle(tail_hash: Program, inner_puzzle: Program) -> Program {
    let args = Program::from([tail_hash, inner_puzzle].to_vec());
    let cat_puzzle = cat_puzzle_program().run(args);
    cat_puzzle.program
}