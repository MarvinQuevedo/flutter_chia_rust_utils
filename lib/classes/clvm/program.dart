import 'dart:typed_data';

import '../../ffi.io.dart';
import '../../generated/bridge_generated.dart' as bridge;
import '../bytes_utils/bytes.dart';
import '../bytes_utils/bytes_utils.dart';
import 'chia_tools_cmds.dart';

/// Output data of program Run
class Output {
  final Program program;
  final BigInt cost;
  Output(this.program, this.cost);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'cost': cost.toString(),
        'program': program.toSource(),
      };

  static Future<Output> fromJson(Map<String, dynamic> json) async {
    final cost = BigInt.parse(json['cost'] as String);
    final program = Program.parse(json['program'] as String);
    return Output(program, cost);
  }
}

class Program {
  late final _ProgramSourceType _sourceType;

  late bool _loaded;
  dynamic _sourceValue;
  Bytes? _bytes;
  Program._({
    required _ProgramSourceType sourceType,
    required dynamic sourceValue,
  }) {
    _sourceType = sourceType;
    _sourceValue = sourceValue;
    _loaded = false;
  }

  Future<Uint8List> get _programBytes async {
    if (_loaded && _bytes != null) {
      return _bytes!.byteList;
    }
    switch (_sourceType) {
      case _ProgramSourceType.bytes:
        _bytes = Bytes(_sourceValue);
        break;
      case _ProgramSourceType.hex:
        final converted = await api.hexToBytes(hex: _sourceValue as String);
        _bytes = Bytes(converted);
        break;
      case _ProgramSourceType.source:
        if (_sourceValue == null) {
          throw Exception("sourceValue is null");
        }
        final result = await ChiaToolsCmds.opc([_sourceValue as String]);
        _bytes = result.first;
        break;
    }
    _loaded = true;
    return _bytes!.byteList;
  }

  /// Curry the program with args
  Future<Program> curry({required List<Program> args}) async {
    final programArgs = await Future.wait(args
        .map(
          (e) async => e.serializeToHex(),
        )
        .toList());

    final programBytes = await api.programCurry(
      serProgramBytes: await _programBytes,
      argsStr: programArgs,
    );

    return Program._(
      sourceType: _ProgramSourceType.bytes,
      sourceValue: programBytes,
    );
  }

  /// convert to source code
  Future<String> disassemble() async {
    final parsed =
        await api.programDisassemble(serProgramBytes: await _programBytes);
    return parsed;
  }

  /// Run the program with args using the clvm tools  commands
  Future<Output> runWithCmdCommands(Program args) async {
    final programSource = await disassemble();
    final argsSource = await args.disassemble();
    final bridgeProgram =
        await ChiaToolsCmds.brun(["-c", programSource, argsSource]);
    final lines = bridgeProgram
        .split("\n")
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();

    BigInt cost = BigInt.from(0);
    if (lines.first.contains("cost = ")) {
      final strCost = lines.first.split("cost = ").last;
      cost = BigInt.parse(strCost);
    }
    String programWithOutPrefix = lines.last;
    if (programWithOutPrefix.startsWith("0x")) {
      programWithOutPrefix = programWithOutPrefix.substring(2);
    }

    return Output(
        Program._(
          sourceType: _ProgramSourceType.hex,
          sourceValue: programWithOutPrefix,
        ),
        cost);
  }

  /// Run the program with args
  Future<Output> run(List<Program> args) async {
    final argsStr = await Future.wait(
      args.map((e) async => e.serializeToHex()).toList(),
    );

    final result = await api.programRun(
      serProgramBytes: await _programBytes,
      argsStr: argsStr,
    );

    final program = Program._(
      sourceType: _ProgramSourceType.bytes,
      sourceValue: result.program,
    );

    final cost = BigInt.from(result.cost);
    return Output(program, cost);
  }

  /// serialize program to bytes
  Future<Bytes> serializeToBytes() async {
    return Bytes(await _programBytes);
  }

  /// serialize program to hex
  Future<String> serializeToHex() async {
    final bytes = await serializeToBytes();
    return await api.bytesToHex(bytes: bytes.byteList);
  }

  /// parse program to source code
  Future<String> toSource() async {
    return await disassemble();
  }

  /// obtain the program hash
  Future<Puzzlehash> treeHash() async {
    final innerBytes =
        await api.programTreeHash(serProgramBytes: await _programBytes);
    return Puzzlehash(innerBytes);
  }

  /// sinonim of treeHash
  Future<Puzzlehash> hash() => treeHash();

  /// uncurry the program
  Future<UncurriedProgram> uncurry() async {
    final uncurried =
        await api.programUncurry(serProgramBytes: await _programBytes);
    return UncurriedProgram._fromUncurriedProgram(uncurried);
  }

  /// parse bytes to program
  static Program deserializeBytes(List<int> bytes) {
    final program = Program._(
      sourceType: _ProgramSourceType.bytes,
      sourceValue: Bytes(bytes),
    );
    return program;
  }

  /// parse hex to program
  static Future<Program> deserializedHexWithNative(String hex) async {
    final bytes = await api.hexToBytes(hex: hex);
    final program = Program._(
      sourceType: _ProgramSourceType.bytes,
      sourceValue: bytes,
    );
    return program;
  }

  /// parse hex to program
  static Program deserializeHex(String hex) {
    final program = Program._(
      sourceType: _ProgramSourceType.hex,
      sourceValue: hex,
    );
    return program;
  }

  ///  Program from bytes
  static Future<Program> serializedFromBytes(Bytes bytes) async {
    return Program._(
      sourceType: _ProgramSourceType.bytes,
      sourceValue: bytes,
    );
  }

  Future<Bytes> toBytes() async {
    final atomBytes =
        await api.programToAtomBytes(serProgramBytes: await _programBytes);
    return Bytes(atomBytes);
  }

  /// Atom program from bytes
  static Future<Program> fromAtomBytes(Bytes atomBytes) async {
    final serializedProgram =
        await api.programFromAtomBytes(serProgramBytes: atomBytes.byteList);
    return Program._(
      sourceType: _ProgramSourceType.bytes,
      sourceValue: serializedProgram,
    );
  }

  /// Program from int value
  static Program fromInt(int number) {
    return Program._(
        sourceType: _ProgramSourceType.bytes,
        sourceValue: encodeInt(number).byteList);
  }

  /// Program from list
  static Future<Program> list(List<Program> list) async {
    final programListStr = await Future.wait(list
        .map(
          (e) async => e.serializeToHex(),
        )
        .toList());
    final resultBytes = await api.programFromList(programList: programListStr);
    final programResult = Program._(
      sourceType: _ProgramSourceType.bytes,
      sourceValue: resultBytes,
    );

    return programResult;
  }

  /// Program from source code
  static Program parse(String strProgram) {
    return Program._(
      sourceType: _ProgramSourceType.source,
      sourceValue: strProgram,
    );
  }
}

/// Uncurried program result
class UncurriedProgram {
  final Program program;
  final List<Program> args;
  UncurriedProgram._(this.program, {this.args = const []});

  static Future<UncurriedProgram> _fromUncurriedProgram(
      bridge.UncurriedProgramToDart uncurried) async {
    final program = Program.deserializeBytes(Bytes(uncurried.program));
    final args = await Future.wait(uncurried.args.map(
      (e) async => Program.deserializeHex(e),
    ));

    return UncurriedProgram._(program, args: args);
  }
}

enum _ProgramSourceType {
  bytes,
  hex,
  source,
}
