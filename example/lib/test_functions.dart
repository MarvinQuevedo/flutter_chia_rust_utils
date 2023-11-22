import 'package:flutter_chia_rust_utils/flutter_chia_rust_utils.dart';
import 'package:chia_crypto_utils/chia_crypto_utils.dart' as chia_crypto_utils;

import 'package:flutter/material.dart';

final testCases = [
  [
    "all hour make first leader extend hole alien behind guard gospel lava path output census museum junior mass reopen famous sing advance salt reform",
    "066dca1a2bb7e8a1db2832148ce9933eea0f3ac9548d793112d9a95c9407efad",
    "fc795be0c3f18c50dddb34e72179dc597d64055497ecc1e69e2e56a5409651bc139aae8070d4df0ea14d8d2a518a9a00bb1cc6e92e053fe34051f6821df9164c"
  ],
  [
    "void come effort suffer camp survey warrior heavy shoot primary clutch crush open amazing screen patrol group space point ten exist slush involve unfold",
    "f585c11aec520db57dd353c69554b21a89b20fb0650966fa0a9d6f74fd989d8f",
    "b873212f885ccffbf4692afcb84bc2e55886de2dfa07d90f5c3c239abc31c0a6ce047e30fd8bf6a281e71389aa82d73df74c7bbfb3b06b4639a5cee775cccd3c"
  ],
  [
    "panda eyebrow bullet gorilla call smoke muffin taste mesh discover soft ostrich alcohol speed nation flash devote level hobby quick inner drive ghost inside",
    "9f6a2878b2520799a44ef18bc7df394e7061a224d2c33cd015b157d746869863",
    "3e066d7dee2dbf8fcd3fe240a3975658ca118a8f6f4ca81cf99104944604b05a5090a79d99e545704b914ca0397fedb82fd00fd6a72098703709c891a065ee49"
  ]
];

Future<void> runTest(ValueChanged send) async {
  // meter function time

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
  }
  send("-------------------");
  const programTest = "(sha256 'password')";
  final runResult = await ChiaToolsCmds.run([programTest]);
  send(programTest);
  send("Run result: $runResult");

  const clvmProgram = "(+ (q . 2) (q . 3))";
  final brunResult = await ChiaToolsCmds.brun([clvmProgram]);
  send(clvmProgram);
  send("Brun result: $brunResult\n");

  final opcResult = await ChiaToolsCmds.opc([clvmProgram]);
  send(clvmProgram);
  send("Opc result: ${opcResult.first}\n");

  final opdResult = await ChiaToolsCmds.opd([opcResult.first]);
  send(clvmProgram);
  send("opd result: ${opdResult.first}\n");
  const programHex =
      "ff02ffff01ff02ff5effff04ff02ffff04ffff04ff05ffff04ffff0bff34ff0580ffff04ff0bff80808080ffff04ffff02ff17ff2f80ffff04ff5fffff04ffff02ff2effff04ff02ffff04ff17ff80808080ffff04ffff02ff2affff04ff02ffff04ff82027fffff04ff82057fffff04ff820b7fff808080808080ffff04ff81bfffff04ff82017fffff04ff8202ffffff04ff8205ffffff04ff820bffff80808080808080808080808080ffff04ffff01ffffffff3d46ff02ff333cffff0401ff01ff81cb02ffffff20ff02ffff03ff05ffff01ff02ff32ffff04ff02ffff04ff0dffff04ffff0bff7cffff0bff34ff2480ffff0bff7cffff0bff7cffff0bff34ff2c80ff0980ffff0bff7cff0bffff0bff34ff8080808080ff8080808080ffff010b80ff0180ffff02ffff03ffff22ffff09ffff0dff0580ff2280ffff09ffff0dff0b80ff2280ffff15ff17ffff0181ff8080ffff01ff0bff05ff0bff1780ffff01ff088080ff0180ffff02ffff03ff0bffff01ff02ffff03ffff09ffff02ff2effff04ff02ffff04ff13ff80808080ff820b9f80ffff01ff02ff56ffff04ff02ffff04ffff02ff13ffff04ff5fffff04ff17ffff04ff2fffff04ff81bfffff04ff82017fffff04ff1bff8080808080808080ffff04ff82017fff8080808080ffff01ff088080ff0180ffff01ff02ffff03ff17ffff01ff02ffff03ffff20ff81bf80ffff0182017fffff01ff088080ff0180ffff01ff088080ff018080ff0180ff04ffff04ff05ff2780ffff04ffff10ff0bff5780ff778080ffffff02ffff03ff05ffff01ff02ffff03ffff09ffff02ffff03ffff09ff11ff5880ffff0159ff8080ff0180ffff01818f80ffff01ff02ff26ffff04ff02ffff04ff0dffff04ff0bffff04ffff04ff81b9ff82017980ff808080808080ffff01ff02ff7affff04ff02ffff04ffff02ffff03ffff09ff11ff5880ffff01ff04ff58ffff04ffff02ff76ffff04ff02ffff04ff13ffff04ff29ffff04ffff0bff34ff5b80ffff04ff2bff80808080808080ff398080ffff01ff02ffff03ffff09ff11ff7880ffff01ff02ffff03ffff20ffff02ffff03ffff09ffff0121ffff0dff298080ffff01ff02ffff03ffff09ffff0cff29ff80ff3480ff5c80ffff01ff0101ff8080ff0180ff8080ff018080ffff0109ffff01ff088080ff0180ffff010980ff018080ff0180ffff04ffff02ffff03ffff09ff11ff5880ffff0159ff8080ff0180ffff04ffff02ff26ffff04ff02ffff04ff0dffff04ff0bffff04ff17ff808080808080ff80808080808080ff0180ffff01ff04ff80ffff04ff80ff17808080ff0180ffff02ffff03ff05ffff01ff04ff09ffff02ff56ffff04ff02ffff04ff0dffff04ff0bff808080808080ffff010b80ff0180ff0bff7cffff0bff34ff2880ffff0bff7cffff0bff7cffff0bff34ff2c80ff0580ffff0bff7cffff02ff32ffff04ff02ffff04ff07ffff04ffff0bff34ff3480ff8080808080ffff0bff34ff8080808080ffff02ffff03ffff07ff0580ffff01ff0bffff0102ffff02ff2effff04ff02ffff04ff09ff80808080ffff02ff2effff04ff02ffff04ff0dff8080808080ffff01ff0bffff0101ff058080ff0180ffff04ffff04ff30ffff04ff5fff808080ffff02ff7effff04ff02ffff04ffff04ffff04ff2fff0580ffff04ff5fff82017f8080ffff04ffff02ff26ffff04ff02ffff04ff0bffff04ff05ffff01ff808080808080ffff04ff17ffff04ff81bfffff04ff82017fffff04ffff02ff2affff04ff02ffff04ff8204ffffff04ffff02ff76ffff04ff02ffff04ff09ffff04ff820affffff04ffff0bff34ff2d80ffff04ff15ff80808080808080ffff04ff8216ffff808080808080ffff04ff8205ffffff04ff820bffff808080808080808080808080ff02ff5affff04ff02ffff04ff5fffff04ff3bffff04ffff02ffff03ff17ffff01ff09ff2dffff02ff2affff04ff02ffff04ff27ffff04ffff02ff76ffff04ff02ffff04ff29ffff04ff57ffff04ffff0bff34ff81b980ffff04ff59ff80808080808080ffff04ff81b7ff80808080808080ff8080ff0180ffff04ff17ffff04ff05ffff04ff8202ffffff04ffff04ffff04ff78ffff04ffff0eff5cffff02ff2effff04ff02ffff04ffff04ff2fffff04ff82017fff808080ff8080808080ff808080ffff04ffff04ff20ffff04ffff0bff81bfff5cffff02ff2effff04ff02ffff04ffff04ff15ffff04ffff10ff82017fffff11ff8202dfff2b80ff8202ff80ff808080ff8080808080ff808080ff138080ff80808080808080808080ff018080";
  final programBytes = Bytes.fromHex(programHex);
  final opdResult2 = await ChiaToolsCmds.opd([programBytes]);

  send("opd result from Bytes: $opdResult2\n");
  final deserealized = Program.deserializeHex(programHex);
/*   final deserealizedBytes = await deserealized.serializeToBytes();
  final deserealizedHex = await deserealized.serializeToHex(); */
  send("deserealized: ${await deserealized.serializeToHex()}\n");
  final disassembled =
      await Program.deserializeBytes(opcResult.first).disassemble();
  send(opcResult.first.toHex());
  send("dissabled: $disassembled\n");

  final catModBytes = Bytes.fromHex(
      "ff02ffff01ff02ff5effff04ff02ffff04ffff04ff05ffff04ffff0bff34ff0580ffff04ff0bff80808080ffff04ffff02ff17ff2f80ffff04ff5fffff04ffff02ff2effff04ff02ffff04ff17ff80808080ffff04ffff02ff2affff04ff02ffff04ff82027fffff04ff82057fffff04ff820b7fff808080808080ffff04ff81bfffff04ff82017fffff04ff8202ffffff04ff8205ffffff04ff820bffff80808080808080808080808080ffff04ffff01ffffffff3d46ff02ff333cffff0401ff01ff81cb02ffffff20ff02ffff03ff05ffff01ff02ff32ffff04ff02ffff04ff0dffff04ffff0bff7cffff0bff34ff2480ffff0bff7cffff0bff7cffff0bff34ff2c80ff0980ffff0bff7cff0bffff0bff34ff8080808080ff8080808080ffff010b80ff0180ffff02ffff03ffff22ffff09ffff0dff0580ff2280ffff09ffff0dff0b80ff2280ffff15ff17ffff0181ff8080ffff01ff0bff05ff0bff1780ffff01ff088080ff0180ffff02ffff03ff0bffff01ff02ffff03ffff09ffff02ff2effff04ff02ffff04ff13ff80808080ff820b9f80ffff01ff02ff56ffff04ff02ffff04ffff02ff13ffff04ff5fffff04ff17ffff04ff2fffff04ff81bfffff04ff82017fffff04ff1bff8080808080808080ffff04ff82017fff8080808080ffff01ff088080ff0180ffff01ff02ffff03ff17ffff01ff02ffff03ffff20ff81bf80ffff0182017fffff01ff088080ff0180ffff01ff088080ff018080ff0180ff04ffff04ff05ff2780ffff04ffff10ff0bff5780ff778080ffffff02ffff03ff05ffff01ff02ffff03ffff09ffff02ffff03ffff09ff11ff5880ffff0159ff8080ff0180ffff01818f80ffff01ff02ff26ffff04ff02ffff04ff0dffff04ff0bffff04ffff04ff81b9ff82017980ff808080808080ffff01ff02ff7affff04ff02ffff04ffff02ffff03ffff09ff11ff5880ffff01ff04ff58ffff04ffff02ff76ffff04ff02ffff04ff13ffff04ff29ffff04ffff0bff34ff5b80ffff04ff2bff80808080808080ff398080ffff01ff02ffff03ffff09ff11ff7880ffff01ff02ffff03ffff20ffff02ffff03ffff09ffff0121ffff0dff298080ffff01ff02ffff03ffff09ffff0cff29ff80ff3480ff5c80ffff01ff0101ff8080ff0180ff8080ff018080ffff0109ffff01ff088080ff0180ffff010980ff018080ff0180ffff04ffff02ffff03ffff09ff11ff5880ffff0159ff8080ff0180ffff04ffff02ff26ffff04ff02ffff04ff0dffff04ff0bffff04ff17ff808080808080ff80808080808080ff0180ffff01ff04ff80ffff04ff80ff17808080ff0180ffff02ffff03ff05ffff01ff04ff09ffff02ff56ffff04ff02ffff04ff0dffff04ff0bff808080808080ffff010b80ff0180ff0bff7cffff0bff34ff2880ffff0bff7cffff0bff7cffff0bff34ff2c80ff0580ffff0bff7cffff02ff32ffff04ff02ffff04ff07ffff04ffff0bff34ff3480ff8080808080ffff0bff34ff8080808080ffff02ffff03ffff07ff0580ffff01ff0bffff0102ffff02ff2effff04ff02ffff04ff09ff80808080ffff02ff2effff04ff02ffff04ff0dff8080808080ffff01ff0bffff0101ff058080ff0180ffff04ffff04ff30ffff04ff5fff808080ffff02ff7effff04ff02ffff04ffff04ffff04ff2fff0580ffff04ff5fff82017f8080ffff04ffff02ff26ffff04ff02ffff04ff0bffff04ff05ffff01ff808080808080ffff04ff17ffff04ff81bfffff04ff82017fffff04ffff02ff2affff04ff02ffff04ff8204ffffff04ffff02ff76ffff04ff02ffff04ff09ffff04ff820affffff04ffff0bff34ff2d80ffff04ff15ff80808080808080ffff04ff8216ffff808080808080ffff04ff8205ffffff04ff820bffff808080808080808080808080ff02ff5affff04ff02ffff04ff5fffff04ff3bffff04ffff02ffff03ff17ffff01ff09ff2dffff02ff2affff04ff02ffff04ff27ffff04ffff02ff76ffff04ff02ffff04ff29ffff04ff57ffff04ffff0bff34ff81b980ffff04ff59ff80808080808080ffff04ff81b7ff80808080808080ff8080ff0180ffff04ff17ffff04ff05ffff04ff8202ffffff04ffff04ffff04ff78ffff04ffff0eff5cffff02ff2effff04ff02ffff04ffff04ff2fffff04ff82017fff808080ff8080808080ff808080ffff04ffff04ff20ffff04ffff0bff81bfff5cffff02ff2effff04ff02ffff04ffff04ff15ffff04ffff10ff82017fffff11ff8202dfff2b80ff8202ff80ff808080ff8080808080ff808080ff138080ff80808080808080808080ff018080");
  var stopWatch = Stopwatch()..start();
  final program = await Program.serializedFromBytes(catModBytes);
  final puzzleHash = await program.treeHash();
  send(
      "ProgramRust: ${'${(await program.serializeToHex()).substring(0, 20)}...'}");
  send("ProgramRust puzzleHash: ${puzzleHash.toHex()}");
  stopWatch.stop();
  send("ProgramRust time: ${stopWatch.elapsedMilliseconds} μs");
  send("-------------------");
  stopWatch.reset();
  stopWatch.start();
  final programDart =
      chia_crypto_utils.Program.deserialize(catModBytes.byteList);
  final puzzleHashDart = programDart.hash();
  send(
      "ProgramDart: ${'${(await program.serializeToHex()).substring(0, 20)}...'}");
  send("ProgramDart puzzleHash: ${puzzleHashDart.toHex()}");
  stopWatch.stop();
  send("ProgramDart time: ${stopWatch.elapsedMicroseconds} μs");

  send("-------------------");
  stopWatch.reset();
  stopWatch.start();
  final program01 = Program.parse(
    '(a (q 2 (q 2 94 (c 2 (c (c 5 (c (sha256 44 5) (c 11 ()))) (c (a 23 47) (c 95 (c (a 46 (c 2 (c 23 ()))) (c (sha256 639 1407 2943) (c -65 (c 383 (c 767 (c 1535 (c 3071 ())))))))))))) (c (q (((-54 . 61) 70 2 . 51) (60 . 4) 1 1 . -53) ((a 2 (i 5 (q 2 50 (c 2 (c 13 (c (sha256 34 (sha256 44 52) (sha256 34 (sha256 34 (sha256 44 92) 9) (sha256 34 11 (sha256 44 ())))) ())))) (q . 11)) 1) (a (i 11 (q 2 (i (= (a 46 (c 2 (c 19 ()))) 2975) (q 2 38 (c 2 (c (a 19 (c 95 (c 23 (c 47 (c -65 (c 383 (c 27 ()))))))) (c 383 ())))) (q 8)) 1) (q 2 (i 23 (q 2 (i (not -65) (q . 383) (q 8)) 1) (q 8)) 1)) 1) (c (c 5 39) (c (+ 11 87) 119)) 2 (i 5 (q 2 (i (= (a (i (= 17 120) (q . 89) ()) 1) (q . -113)) (q 2 122 (c 2 (c 13 (c 11 (c (c -71 377) ()))))) (q 2 90 (c 2 (c (a (i (= 17 120) (q 4 120 (c (a 54 (c 2 (c 19 (c 41 (c (sha256 44 91) (c 43 ())))))) 57)) (q 2 (i (= 17 36) (q 4 36 (c (sha256 32 41) 57)) (q . 9)) 1)) 1) (c (a (i (= 17 120) (q . 89) ()) 1) (c (a 122 (c 2 (c 13 (c 11 (c 23 ()))))) ())))))) 1) (q 4 () (c () 23))) 1) ((a (i 5 (q 4 9 (a 38 (c 2 (c 13 (c 11 ()))))) (q . 11)) 1) 11 34 (sha256 44 88) (sha256 34 (sha256 34 (sha256 44 92) 5) (sha256 34 (a 50 (c 2 (c 7 (c (sha256 44 44) ())))) (sha256 44 ())))) (a (i (l 5) (q 11 (q . 2) (a 46 (c 2 (c 9 ()))) (a 46 (c 2 (c 13 ())))) (q 11 44 5)) 1) (c (c 40 (c 95 ())) (a 126 (c 2 (c (c (c 47 5) (c 95 383)) (c (a 122 (c 2 (c 11 (c 5 (q ()))))) (c 23 (c -65 (c 383 (c (sha256 1279 (a 54 (c 2 (c 9 (c 2815 (c (sha256 44 45) (c 21 ())))))) 5887) (c 1535 (c 3071 ()))))))))))) 2 42 (c 2 (c 95 (c 59 (c (a (i 23 (q 9 45 (sha256 39 (a 54 (c 2 (c 41 (c 87 (c (sha256 44 -71) (c 89 ())))))) -73)) ()) 1) (c 23 (c 5 (c 767 (c (c (c 36 (c (sha256 124 47 383) ())) (c (c 48 (c (sha256 -65 (sha256 124 21 (+ 383 (- 735 43) 767))) ())) 19)) ()))))))))) 1)) (c (q . 0x72dec062874cd4d3aab892a0906688a1ae412b0109982e1797a170add88bdcdc) (c (q . 0x625c2184e97576f5df1be46c15b2b8771c79e4e6f0aa42d3bfecaebe733f4b8c) (c (q 2 (q 2 (q 2 (i 11 (q 2 (i (= 5 (point_add 11 (pubkey_for_exp (sha256 11 (a 6 (c 2 (c 23 ()))))))) (q 2 23 47) (q 8)) 1) (q 4 (c 4 (c 5 (c (a 6 (c 2 (c 23 ()))) ()))) (a 23 47))) 1) (c (q 50 2 (i (l 5) (q 11 (q . 2) (a 6 (c 2 (c 9 ()))) (a 6 (c 2 (c 13 ())))) (q 11 (q . 1) 5)) 1) 1)) (c (q . 0x94a96f7397ff4acb08b6532fd20bb975a2c350c19216fef4ae9f64499bc59fe919bcf7b531dd80a371ad7858bfb288d2) 1)) 1))))',
  );

  // final uncurried = await program01.uncurry();
  final promHex01 = await program01.serializeToHex();
  send("ProgramRust01: ${promHex01.substring(0, 20)}");

  await dartCurry(send);
  await rustCurry(send);

/*   await dartCurry(send);
  await rustCurry(send); */
}

Future<void> dartCurry(ValueChanged send) async {
  send("-------------------");
  var stopWatch = Stopwatch()..start();
  final programRust0 = chia_crypto_utils.Program.deserializeHex(
      "ff02ffff01ff02ff02ffff04ff02ffff04ff05ff80808080ffff04ffff01ff02ffff03ffff07ff0580ffff01ff0bffff0102ffff02ff02ffff04ff02ffff04ff09ff80808080ffff02ff02ffff04ff02ffff04ff0dff8080808080ffff01ff0bffff0101ff058080ff0180ff018080");
  final programArgs0 = chia_crypto_utils.Program.deserializeHex("ff0180");
  final programRust0Curry = programRust0.curry([programArgs0]);
  send(
      "ProgramDart curry: ${'${programRust0Curry.toBytes().toHex().substring(0, 20)}...'}");
  final hash = programRust0Curry.hash();
  send("ProgramDart hash: $hash");
  stopWatch.stop();
  send("ProgramDart curry time: ${stopWatch.elapsedMilliseconds} μs");
  final uncurry = programRust0Curry.uncurry();
  send(
      "ProgramDart uncurry: ${'${uncurry.mod.toBytes().toHex().substring(0, 20)}...'}");
}

Future<void> rustCurry(ValueChanged send) async {
  send("-------------------");
  var stopWatch = Stopwatch()..start();
  final programRust0 = Program.parse(
      "(a (q 2 2 (c 2 (c 5 ()))) (c (q 2 (i (l 5) (q 11 (q . 2) (a 2 (c 2 (c 9 ()))) (a 2 (c 2 (c 13 ())))) (q 11 (q . 1) 5)) 1) 1)))");
  final programArgs0 = Program.parse("(1)");
  final promHex = await programRust0.serializeToHex();
  final argsHex = await programArgs0.serializeToHex();
  send("ProgramRust0: ${'${promHex.substring(0, 20)}...'}");
  send("ProgramRust0 args: $argsHex");
/*   final programList = await Program.list([programArgs0]);
  send("ProgramRust0 args list: ${(await programList.serializeToHex())}");
  final programRust0Run = await programRust0.run(programList);
  send(
      "ProgramRust0 run: ${'${(await programRust0Run.program.serializeToHex()).substring(0, 20)}...'}");
  */
  final programRust0Curry = await programRust0.curry(args: [programArgs0]);
  send(
      "ProgramRust0 curry: ${'${(await programRust0Curry.serializeToHex()).substring(0, 20)}...'}");
  // final uncurriHex = await programRust0Curry.serializeToHex();
  final hash = await programRust0Curry.treeHash();
  send("ProgramRust0 hash: $hash");
  send("ProgramRust curry time: ${stopWatch.elapsedMilliseconds} μs");
  // final curriedHex =  await programRust0Curry.serializeToHex();
  final uncurried = await programRust0Curry.uncurry();

  send(
      "ProgramRust0 uncurry: ${'${(await uncurried.program.serializeToHex()).substring(0, 20)}...'}");
  for (final item in uncurried.args) {
    send("ProgramRust0 uncurry args: ${(await item.serializeToHex())}");
  }
}
