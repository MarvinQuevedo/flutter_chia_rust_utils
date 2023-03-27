import 'package:flutter_chia_rust_utils/ffi.io.dart';

import '../bytes_utils/bytes.dart';

class ChiaToolsCmds {
  ChiaToolsCmds._();

  /// run clsp program
  static Future<String> run(List<String> args) async {
    return api.cmdsProgramRun(args: args);
  }

  /// run clvm program with env
  static Future<String> brun(List<String> args) async {
    return api.cmdsProgramBrun(args: args);
  }

  /// Compile a clvm script. convert to serialezed bytes
  static Future<List<Bytes>> opc(List<String> args) async {
    final result = await api.cmdProgramOpc(args: args);
    return result.map((e) => Bytes.fromHex(e)).toList();
  }

  /// Disassemble a compiled clvm script from hex.
  static Future<List<String>> opd(List<Bytes> args) async {
    List<String> strArgs = [ ];

    strArgs.addAll(await Future.wait(
        args.map((e) => api.bytesToHex(bytes: e.byteList)).toList()));
    final result = await api.cmdProgramOpd(args: strArgs);
    final strList = result.map((e) => e.toString()).toList();
    return strList;
  }
}
