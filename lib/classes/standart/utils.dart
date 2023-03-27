import '../bls/public_key.dart';
import '../clvm/program.dart';
import 'puzzles/index.dart';

final defaultHiddenPuzzleProgram = Program.deserializeHex('ff0980');

/// Get puzzle from public key
Future<Program> getPuzzleFromPk(PublicKey publicKey) async {
  return getPuzzleFromPkAndHiddenPuzzle(publicKey, defaultHiddenPuzzleProgram);
}

/// Get puzzle from public key and hidden puzzle
Future<Program> getPuzzleFromPkAndHiddenPuzzle(
    PublicKey publicKey, Program hiddenPuzzleProgram) async {
  final syntheticPubKey = await calculateSyntheticPublicKeyProgram.run([
    await Program.fromBytes(publicKey.toBytes()),
    await Program.fromBytes(await hiddenPuzzleProgram.treeHash()),
  ]);

  final curried = await p2DelegatedPuzzleOrHiddenPuzzleProgram
      .curry(args: [syntheticPubKey.program]);

  return curried;
}
