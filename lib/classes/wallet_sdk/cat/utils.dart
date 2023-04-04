import '../../../ffi.io.dart';
import '../../bytes_utils/bytes.dart';
import '../../clvm/program.dart';

Future<Program> createCatPuzzle(Bytes tailHash, Program innerPuzzle) async {
  final serializedInnerPuzzle = await innerPuzzle.serializeToBytes();
  final puzzle = await api.catsCreateCatPuzzle(
    tailHash: tailHash.byteList,
    innerPuzzleHash: serializedInnerPuzzle.byteList,
  );
  return Program.deserializeBytes(puzzle);
}
