import 'dart:typed_data';

import '../../ffi.io.dart';
import '../bytes_utils/bytes.dart';
import 'public_key.dart';

class PrivateKey extends Bytes {
  static const int size = 32;
  PrivateKey(Uint8List bytes) : super(bytes);

  factory PrivateKey.fromBytes(Uint8List bytes) {
    return PrivateKey(bytes);
  }

  factory PrivateKey.fromHex(String bytesHex) {
    return PrivateKey(Bytes.fromHex(bytesHex).byteList);
  }

  factory PrivateKey.fromStream(Iterator<int> iterator) {
    final bytes = iterator.extractBytesAndAdvance(size);
    return PrivateKey.fromBytes(bytes.byteList);
  }

  Future<PrivateKey> derivePathHardened(List<int> path) async {
    final Uint32List pathBytes = Uint32List.fromList(path);
    final result = await api.secretKeyDerivePathHardened(
      sk: byteList,
      path: pathBytes,
    );
    return PrivateKey(result);
  }

  Future<PrivateKey> derivePathUnhardened(List<int> path) async {
    final Uint32List pathBytes = Uint32List.fromList(path);
    final result = await api.secretKeyDerivePathUnhardened(
      sk: byteList,
      path: pathBytes,
    );
    return PrivateKey(result);
  }

  /// Obtain the public key from private key G1
  Future<PublicKey> publicKey() async {
    final result = await api.secretKeyPublicKey(sk: byteList);
    return PublicKey(result);
  }

  Future<PublicKey> getG1() {
    return publicKey();
  }

  /// Private key from seed
  static Future<PrivateKey> fromSeed(Uint8List seed) async {
    final result = await api.secretKeyFromSeed(seed: seed);
    return PrivateKey(result);
  }
}
