import 'package:chia_crypto_utils/chia_crypto_utils.dart';

PrivateKey rootWalletSkToWalletSk(PrivateKey master, int index) {
  final root = derivePath(PrivateKey.fromBytes(master.toBytes()), [index]);
  return PrivateKey.fromBytes(root.toBytes());
}

PrivateKey masterSkToRootWalletSk(PrivateKey master) {
  final root =
      derivePath(PrivateKey.fromBytes(master.toBytes()), [12381, 8444, 2]);
  //final r1 = DeriveKeys.masterSkToRootWalletSk(master);
  return PrivateKey.fromBytes(root.toBytes());
}

PrivateKey rootWalletSkToWalletSkUnhardened(PrivateKey master, int index) {
  final root =
      derivePathUnhardened(PrivateKey.fromBytes(master.toBytes()), [index]);
  return PrivateKey.fromBytes(root.toBytes());
}

PrivateKey masterSkToRootWalletSkUnhardened(PrivateKey master) {
  final root = derivePathUnhardened(
      PrivateKey.fromBytes(master.toBytes()), [12381, 8444, 2]);
  //final r1 = DeriveKeys.masterSkToRootWalletSk(master);
  return PrivateKey.fromBytes(root.toBytes());
}
