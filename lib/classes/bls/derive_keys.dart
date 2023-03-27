import 'dart:typed_data';

import '../../ffi.io.dart';

import 'private_key.dart';
import 'public_key.dart';

const blsSpecNumber = 12381;
const chiaBlockchainNumber = 8444;
const farmerPathNumber = 0;
const poolPathNumber = 1;
const walletPathNumber = 2;
const localPathNumber = 3;
const backupKeyPathNumber = 4;
const singletonPathNumber = 5;
const poolingAuthenticationPathNumber = 6;

/// BLS derive keys toolchain
class DeriverKeys {
  /// Derive a private key from a path
  static Future<PrivateKey> derivePath(PrivateKey sk, List<int> path) async {
    final Uint32List pathBytes = Uint32List.fromList(path);
    final result = await api.secretKeyDerivePathHardened(
      sk: sk.byteList,
      path: pathBytes,
    );
    return PrivateKey(result);
  }

  /// Derive  a unhardened private key from a path
  static Future<PrivateKey> derivePathUnhardened(
      PrivateKey sk, List<int> path) async {
    final Uint32List pathBytes = Uint32List.fromList(path);
    final result = await api.secretKeyDerivePathUnhardened(
      sk: sk.byteList,
      path: pathBytes,
    );
    return PrivateKey(result);
  }

  /// Obtain farmer private key from master private key
  static Future<PrivateKey> masterSkToFarmerSk(
      PrivateKey masterSk, int index) async {
    final sk = await derivePath(
      masterSk,
      [blsSpecNumber, chiaBlockchainNumber, farmerPathNumber, 0],
    );
    return sk;
  }

  /// Obtain pool private key from master private key
  static Future<PrivateKey> masterSkToPoolSk(
      PrivateKey masterSk, int index) async {
    final sk = await derivePath(
      masterSk,
      [blsSpecNumber, chiaBlockchainNumber, poolPathNumber, 0],
    );
    return sk;
  }

  /// Obtain wallet private key from master private key
  Future<PrivateKey> masterSkToWalletSk(PrivateKey masterSk, int index) async {
    final result = await api.pubMasterToWalletHardened(
        master: masterSk.byteList, idx: index);
    return PrivateKey(result);
  }

  /// Obtain unhardenedwallet private key from master private key
  Future<PrivateKey> masterSkToWalletSkUnhardened(
      PrivateKey masterSk, int index) async {
    final result = await api.pubMasterToWalletUnhardened(
        master: masterSk.byteList, idx: index);
    return PrivateKey(result);
  }

  /// Obtain local private key from master private key
  static Future<PrivateKey> masterSkToLocalSk(PrivateKey masterSk) async {
    final sk = await derivePath(
      masterSk,
      [blsSpecNumber, chiaBlockchainNumber, localPathNumber, 0],
    );
    return sk;
  }

  /// Obtain backup private key from master private key
  static Future<PrivateKey> masterSkToBackupSk(PrivateKey masterSk) async {
    final sk = await derivePath(
      masterSk,
      [blsSpecNumber, chiaBlockchainNumber, backupKeyPathNumber, 0],
    );
    return sk;
  }

  /// Obtain singleton private key from master private key
  Future<PrivateKey> masterSkToSingletonOwnerSk(
      PrivateKey masterSk, int poolWalletIndex) async {
    final sk = await api.pubMasterToPoolSingleton(
      master: masterSk.byteList,
      poolWalletIdx: poolWalletIndex,
    );
    return PrivateKey(sk);
  }

  /// Obtain pooling authentication private key from master private key
  Future<PrivateKey> masterSkToPoolingAuthenticationSk(
    PrivateKey masterSk,
    int poolWalletIndex,
    int index,
  ) async {
    final sk = await api.pubMasterToPoolAuthentication(
      sk: masterSk.byteList,
      poolWalletIdx: poolWalletIndex,
      idx: poolWalletIndex,
    );
    return PrivateKey(sk);
  }

  /// Obtain pooling owner private key from master private key
  Future<dynamic> getPuzzleFromPk(PublicKey publicKey) {
    throw UnimplementedError();
  }

  /// Obtain pooling owner private key from master private key
  Future<dynamic> getPuzzleFromPkAndHiddenPuzzle(
      PublicKey publicKey, dynamic hiddenPuzzleProgram) {
    throw UnimplementedError();
  }

  /// Get private key from intermediate private key
  Future<PrivateKey> rootWalletSkToWalletSk(
      PrivateKey rootWalletSk, int index) async {
    final result = await derivePath(rootWalletSk, [index]);
    return result;
  }

  ///  Obtain intermediate  private key from master private key
  Future<PrivateKey> masterSkToRootWalletSk(
    PrivateKey rootWalletSk,
  ) async {
    final result = await api.pubMasterToWalletHardenedIntermediate(
      master: rootWalletSk.byteList,
    );
    return PrivateKey(result);
  }

  /// Get unhardened private key from intermediate private key
  Future<PrivateKey> rootWalletSkToWalletSkUnhardened(
      PrivateKey rootWalletSk, int index) async {
    final result = await derivePathUnhardened(rootWalletSk, [index]);
    return result;
  }

  /// Obtain unhardened intermediate  private key from master private key
  Future<PrivateKey> masterSkToRootWalletSkUnhardened(
    PrivateKey rootWalletSk,
  ) async {
    final result = await api.pubMasterToWalletUnhardenedIntermediate(
      master: rootWalletSk.byteList,
    );
    return PrivateKey(result);
  }
}
