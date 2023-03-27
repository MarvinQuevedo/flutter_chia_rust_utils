import 'dart:io';
import 'dart:ffi'; 

import 'generated/bridge_generated.dart';

DynamicLibrary loadDylib(String path) {
  final api = Abi.current();

  if (Platform.isMacOS && (api == Abi.macosX64 || api == Abi.macosArm64)) {
    return DynamicLibrary.executable();
  } else {
    return Platform.isIOS
        ? DynamicLibrary.process()
        : DynamicLibrary.open(path);
  }
}

const base = 'rust_bls_flutter';
final path = Platform.isWindows ? '$base.dll' : 'lib$base.so';
final dylib = loadDylib(path);
final api = RustImpl(dylib);
