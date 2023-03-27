/* import 'dart:typed_data';

import 'package:chia_crypto_utils/chia_crypto_utils.dart';
import 'package:chia_crypto_utils/chia_crypto_utils.dart' as utils;

 

class OzoneDeriverKeys {
  PrivateKey masterSkToWalletSk(PrivateKey master, int index) {
    final result1 =
        utils.masterSkToWalletSk(PrivateKey.fromBytes(master.toBytes()), index);

    return PrivateKey.fromBytes(result1.toBytes());
  }

  PrivateKey rootWalletSkToWalletSk(PrivateKey rootSK, int index) {
    final root = utils.rootWalletSkToWalletSk(
        PrivateKey.fromBytes(rootSK.toBytes()), index);
    return PrivateKey.fromBytes(root.toBytes());
  }

  PrivateKey rootWalletSkToWalletSkUnhardened(PrivateKey rootSK, int index) {
    final root = utils.rootWalletSkToWalletSkUnhardened(
        PrivateKey.fromBytes(rootSK.toBytes()), index);
    return PrivateKey.fromBytes(root.toBytes());
  }

  PrivateKey masterSkToRootWalletSk(PrivateKey master) {
    final root = utils.masterSkToRootWalletSk(
      PrivateKey.fromBytes(master.toBytes()),
    );
    return PrivateKey.fromBytes(root.toBytes());
  }

  PrivateKey masterSkToRootWalletSkUnhardened(PrivateKey master) {
    final root = utils.masterSkToRootWalletSkUnhardened(
      PrivateKey.fromBytes(master.toBytes()),
    );
    return PrivateKey.fromBytes(root.toBytes());
  }

  PrivateKey masterSkToSingletonOwnerSk(PrivateKey master,
      {int poolWalletIndex = 0}) {
    return derivePath(master, [
      blsSpecNumber,
      chiaBlockchainNumber,
      singletonPathNumber,
      poolWalletIndex,
    ]);
  }
}

class MasterPrivateKey {
  PrivateKey getRootWalletPk({
    required PrivateKey masterPrivateKey,
  }) {
    final walletSk = OzoneDeriverKeys().masterSkToRootWalletSk(masterPrivateKey);
    return walletSk;
  }

  PrivateKey getRootWalletPkUnhardened({
    required PrivateKey masterPrivateKey,
  }) {
    final walletSk =
        OzoneDeriverKeys().masterSkToRootWalletSkUnhardened(masterPrivateKey);
    return walletSk;
  }

  SignedTransactionResponse generateAddress(
      Uint8List masterPrivateKey, int publicKeyIndex,
      {bool testnet = true}) {
    var privateKeyObject = PrivateKey.fromBytes(masterPrivateKey);

    final walletSk =
        OzoneDeriverKeys().masterSkToWalletSk(privateKeyObject, publicKeyIndex);
    final walletPublicKey = walletSk.getG1();

    var puzzleHashProgram = getPuzzleFromPk(walletPublicKey);

    var puzzleHash = puzzleHashProgram.hash();
    final address1 = getAddressFromPuzzle(puzzleHashProgram, testnet: testnet);

    return SignedTransactionResponse(
        puzzleHashProgram, walletSk, puzzleHash.byteList, address1);
  }

  /*  CatWalletKeysAndAddress generateHashCatWallet(
      Uint8List masterPrivateKeyStr, int publicKeyIndex, String tailHash) {
    final masterPrivateKey = PrivateKey.fromBytes(masterPrivateKeyStr);
    //final publicKey = masterPrivateKey.getG1();

    final walletSk =
        DeriverKeys.masterSkToWalletSk(masterPrivateKey, publicKeyIndex);
    final walletPublicKey = walletSk.getG1();

    var puzzleHashProgram = getPuzzleFromPk(walletPublicKey);
    final ctkWallet = LocalSigner()._generateCatWallet(
        publicKeyIndex: publicKeyIndex,
        tailHash: tailHash,
        ourInnerPuzzle: puzzleHashProgram,
        walletSk: walletSk);

    return ctkWallet;
  } */

  WalletKeysAndAddress generateWallet(
      PrivateKey masterPrivateKey, int publicKeyIndex,
      {bool testnet = true}) {
    final walletSk =
        OzoneDeriverKeys().masterSkToWalletSk(masterPrivateKey, publicKeyIndex);
    final walletPublicKey = walletSk.getG1();

    var puzzleHashProgram = getPuzzleFromPk(walletPublicKey);
    //var puzzleHash = puzzleHashProgram.hash();
    var address = getAddressFromPuzzle(puzzleHashProgram, testnet: testnet);
    return WalletKeysAndAddress(
      address,
      masterPrivateKey,
      walletPublicKey,
      publicKeyIndex,
      walletSk,
      CoinType.blockchain,
    );
  }

  List<int> getWalletDerivation(int derivationIndex) {
    return [
      blsSpecNumber,
      chiaBlockchainNumber,
      walletPathNumber,
      derivationIndex
    ];
  }

  /// Get the NFT puzzle hash of the mnemonic words
  Future<WalletVector> getNftSingleton(Bytes masterPrivateKeyBytes,
      {int id = 0}) async {
    final walletSk = OzoneDeriverKeys().masterSkToSingletonOwnerSk(
      PrivateKey.fromBytes(
        masterPrivateKeyBytes.byteList,
      ),
      poolWalletIndex: id,
    );
    final walletPublicKey = walletSk.getG1();
    var puzzleHashProgram = getPuzzleFromPk(walletPublicKey);

    final WalletVector walletVector = WalletVector(
      childPrivateKey: walletSk,
      derivationIndex: id,
      puzzlehash: Puzzlehash(puzzleHashProgram.hash()),
    );
    return walletVector;
  }
}
 */