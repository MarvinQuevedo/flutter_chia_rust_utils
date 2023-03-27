import '../../ffi.io.dart';
import '../bytes_utils/bytes.dart';

class Entropye extends Bytes {
  Entropye(super.bytesList);
}

class Mnemonics {
  Mnemonics._();

  /// generate mnemonic from entropy
  static Future<String> entropyToMnemonic(Entropye entropy) async {
    final result = await api.pubEntropyToMnemonic(entropy: entropy.byteList);
    return result;
  }

  /// generate seed from entropy
  static Future<SeedBytes> entropyToSeed(Entropye entropy) async {
    final result = await api.pubEntropyToSeed(entropy: entropy.byteList);
    return SeedBytes(result);
  }

  /// generate entropy from mnemonic
  static Future<Entropye> mnemonicToEntropy(String mnemonic) async {
    final result = await api.pubMnemonicToEntropy(mnemonicWords: mnemonic);
    return Entropye(result);
  }
}

class SeedBytes extends Bytes {
  SeedBytes(super.bytesList);
}
