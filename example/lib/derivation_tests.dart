import 'package:example/ozone_files/derive_keys.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_chia_rust_utils/flutter_chia_rust_utils.dart';
import 'package:chia_crypto_utils/chia_crypto_utils.dart' as utils;

final testCases = [
  [
    "kitten seat dial receive water peasant obvious tuition rifle ethics often improve mutual invest gospel unaware cushion trigger credit scare critic edge digital valid",
    "066dca1a2bb7e8a1db2832148ce9933eea0f3ac9548d793112d9a95c9407efad",
    "fc795be0c3f18c50dddb34e72179dc597d64055497ecc1e69e2e56a5409651bc139aae8070d4df0ea14d8d2a518a9a00bb1cc6e92e053fe34051f6821df9164c"
  ],
];

Future<void> runDerivationTest(ValueChanged send) async {
  for (var values in testCases) {
    final words = values[0];
    final entropy = values[1];
    final seed = values[2];
    final entropyRs = await Mnemonics.mnemonicToEntropy(words);
    final seedRs = await Mnemonics.entropyToSeed(entropyRs);
    send("-------------------");
    send("Original");
    send("Words: $words");
    send("Entropy: $entropy");
    send("Seed: $seed");
    send("-------------------");
    send("Rust");
    send("Words: $words");
    send("Entropy: ${entropyRs.toHex()}");
    send("Seed: ${seedRs.toHex()}");
    final privateKey = await PrivateKey.fromSeed(seedRs.byteList);
    send("PrivateKey: ${privateKey.toHex()}");
    final privateKeyDart = utils.PrivateKey.fromSeed(seedRs.byteList);
    send("PrivateKeyDart: ${privateKeyDart.toHex()}");

    final hardenedRoot =
        await BlsDeriverKeys.masterSkToRootWalletSk(privateKey);
    send("HardenedRoot: ${hardenedRoot.toHex()}");
    final hardenedRootDart = masterSkToRootWalletSk(privateKeyDart);
    send("HardenedRootDart: ${hardenedRootDart.toHex()}");
    final unharRoot =
        await BlsDeriverKeys.masterSkToRootWalletSkUnhardened(privateKey);
    send("UnhardenedRoot: ${unharRoot.toHex()}");
    final unharRootDart = masterSkToRootWalletSkUnhardened(privateKeyDart);
    send("UnhardenedRootDart: ${unharRootDart.toHex()}");

    final hardenedWallet =
        await BlsDeriverKeys.rootWalletSkToWalletSk(hardenedRoot, 0);
    send("HardenedWallet: ${hardenedWallet.toHex()}");
    final hardenedWalletDart = rootWalletSkToWalletSk(hardenedRootDart, 0);
    send("HardenedWalletDart: ${hardenedWalletDart.toHex()}");
    final unharWallet =
        await BlsDeriverKeys.rootWalletSkToWalletSkUnhardened(unharRoot, 0);
    send("UnhardenedWallet: ${unharWallet.toHex()}");
    final unharWalletDart = rootWalletSkToWalletSkUnhardened(unharRootDart, 0);
    send("UnhardenedWalletDart: ${unharWalletDart.toHex()}");
  }
}
