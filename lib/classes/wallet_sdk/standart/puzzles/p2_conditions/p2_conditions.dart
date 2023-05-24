// ignore_for_file: lines_longer_than_80_chars, non_constant_identifier_names

 
import '../../../../clvm/program.dart';

final P2_CONDITIONS_MOD = Program.deserializeHex(
  "ff04ffff0101ff0280",
);

Future<Program> puzzleForConditions(Program conditions) async{
  final result =  await P2_CONDITIONS_MOD.run([conditions]);
  return result.program;
}

Future<Program> solution_for_conditions(Program conditions) async{
  return await Program.list([await puzzleForConditions(conditions), Program.fromInt(0)]);
}
