use crate::program_utils::{serialized_program::SerializedProgram, program::Program};

pub fn calculate_synthetic_public_key_program() -> Program {
    SerializedProgram::from_hex("ff1dff02ffff1effff0bff02ff05808080".to_string()).to_program().unwrap()
}
