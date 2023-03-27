import 'dart:typed_data';

import '../../ffi.io.dart';
import '../bytes_utils/bytes.dart';
import 'private_key.dart';
import 'public_key.dart';

class Message extends Bytes {
  Message(super.bytesList);
}

class Signature extends Bytes {
  Signature(super.bytesList);

  /// Check is signature valid
  Future<bool> isValid() {
    return api.signatureIsValid(sig: byteList);
  }

  /// aggregate signatures
  static aggregate({required List<Signature> signs}) async {
    Bytes sigsStream = signs.fold<Bytes>(
      Bytes([]),
      (previousValue, element) => previousValue + element,
    );

    final result = await api.signatureAggregate(
      sigsStream: sigsStream.byteList,
      length: signs.length,
    );
    return Signature(result);
  }

  /// sign message with private key
  static sign({required PrivateKey sk, required Uint8List message}) async {
    final result = await api.signatureSign(sk: sk.byteList, msg: message);
    return Signature(result);
  }

  /// verify signature
  static Future<bool> verify(
      {required PublicKey pk,
      required Message message,
      required Signature sig}) async {
    return api.signatureVerify(
      pk: pk.byteList,
      msg: message.byteList,
      sig: sig.byteList,
    );
  }
}
