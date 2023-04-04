import '../../../ffi.io.dart';
import '../../bls/public_key.dart';
import '../../clvm/program.dart';
 

final defaultHiddenPuzzleProgram = Program.deserializeHex('ff0980');

/// Get puzzle from public key
Future<Program> getPuzzleFromPk(PublicKey publicKey) async {
  final serializedProgram =  await api.getPuzzleFromPublicKey(pk: publicKey.byteList);
  return Program.deserializeBytes(serializedProgram);
}
 
