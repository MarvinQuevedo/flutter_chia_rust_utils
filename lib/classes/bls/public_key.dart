import 'dart:typed_data';

import '../../ffi.io.dart';
import '../bytes_utils/bytes.dart';

class PublicKey extends Bytes {
  PublicKey(Uint8List bytes) : super(bytes);

  /// Derive public key from path
  Future<PublicKey> derivePathUnhardened(List<int> path) async {
    final Uint32List pathBytes = Uint32List.fromList(path);
    final result = await api.publicKeyDerivePathUnhardened(
      sk: byteList,
      path: pathBytes,
    );
    return PublicKey(result);
  }
}
