use crate::program_utils::program::Program;
use crate::program_utils::serialized_program::SerializedProgram;

pub fn p2_conditions_mod() -> SerializedProgram {
    SerializedProgram::from_hex("ff04ffff0101ff0280".to_string())
}

pub fn puzzleForConditions(conditions: Program) -> Program {
    let p2_program = p2_conditions_mod().to_program().unwrap();
    let mut args = Vec::new();
    args.push(conditions);
    let result = p2_program.run(Program::from(args));
    return result.program;
}

pub fn solution_for_conditions(conditions: Program) -> Program {
    return Program::from([puzzleForConditions(conditions), Program::from(0)].to_vec());
}
