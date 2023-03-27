// https://github.com/irulast/chia-crypto-utils/blob/main/lib/src/clvm/bytes.dart
import 'dart:convert';

import 'package:hex/hex.dart';

import 'bytes.dart';

mixin ToBytesMixin {
  Bytes toBytes();

  String toHex() => const HexEncoder().convert(toBytes());
  String toHexWithPrefix() => Bytes.bytesPrefix + toHex();
}

extension StringToBytesX on String {
  Bytes hexToBytes() => Bytes(const HexDecoder().convert(this));
  Bytes toBytes() => Bytes(utf8.encode(this));
}
