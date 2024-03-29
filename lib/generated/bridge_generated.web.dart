// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.81.0.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'bridge_generated.dart';
export 'bridge_generated.dart';

class RustPlatform extends FlutterRustBridgeBase<RustWire>
    with FlutterRustBridgeSetupMixin {
  RustPlatform(FutureOr<WasmModule> dylib) : super(RustWire(dylib)) {
    setupMixinConstructor();
  }
  Future<void> setup() => inner.init;

// Section: api2wire

  @protected
  String api2wire_String(String raw) {
    return raw;
  }

  @protected
  List<String> api2wire_StringList(List<String> raw) {
    return raw;
  }

  @protected
  int api2wire_box_autoadd_usize(int raw) {
    return api2wire_usize(raw);
  }

  @protected
  int? api2wire_opt_box_autoadd_usize(int? raw) {
    return raw == null ? null : api2wire_box_autoadd_usize(raw);
  }

  @protected
  Uint32List api2wire_uint_32_list(Uint32List raw) {
    return raw;
  }

  @protected
  Uint8List api2wire_uint_8_list(Uint8List raw) {
    return raw;
  }

// Section: finalizer
}

// Section: WASM wire module

@JS('wasm_bindgen')
external RustWasmModule get wasmModule;

@JS()
@anonymous
class RustWasmModule implements WasmModule {
  external Object /* Promise */ call([String? moduleName]);
  external RustWasmModule bind(dynamic thisArg, String moduleName);
  external dynamic /* void */ wire_secret_key_from_seed(
      NativePortType port_, Uint8List seed);

  external dynamic /* void */ wire_secret_key_public_key(
      NativePortType port_, Uint8List sk);

  external dynamic /* void */ wire_secret_key_derive_path_hardened(
      NativePortType port_, Uint8List sk, Uint32List path);

  external dynamic /* void */ wire_secret_key_derive_path_unhardened(
      NativePortType port_, Uint8List sk, Uint32List path);

  external dynamic /* void */ wire_public_key_derive_path_unhardened(
      NativePortType port_, Uint8List sk, Uint32List path);

  external dynamic /* void */ wire_signature_sign(
      NativePortType port_, Uint8List sk, Uint8List msg);

  external dynamic /* void */ wire_signature_is_valid(
      NativePortType port_, Uint8List sig);

  external dynamic /* void */ wire_signature_aggregate(
      NativePortType port_, Uint8List sigs_stream, int length);

  external dynamic /* void */ wire_signature_verify(
      NativePortType port_, Uint8List pk, Uint8List msg, Uint8List sig);

  external dynamic /* void */ wire_pub_mnemonic_to_entropy(
      NativePortType port_, String mnemonic_words);

  external dynamic /* void */ wire_pub_entropy_to_mnemonic(
      NativePortType port_, Uint8List entropy);

  external dynamic /* void */ wire_pub_entropy_to_seed(
      NativePortType port_, Uint8List entropy);

  external dynamic /* void */ wire_bytes_to_hex(
      NativePortType port_, Uint8List bytes);

  external dynamic /* void */ wire_hex_to_bytes(
      NativePortType port_, String hex);

  external dynamic /* void */ wire_bytes_to_sha256(
      NativePortType port_, Uint8List bytes);

  external dynamic /* void */ wire_pub_master_to_wallet_unhardened_intermediate(
      NativePortType port_, Uint8List master);

  external dynamic /* void */ wire_pub_master_to_wallet_unhardened(
      NativePortType port_, Uint8List master, int idx);

  external dynamic /* void */ wire_pub_master_to_wallet_hardened_intermediate(
      NativePortType port_, Uint8List master);

  external dynamic /* void */ wire_pub_master_to_wallet_hardened(
      NativePortType port_, Uint8List master, int idx);

  external dynamic /* void */ wire_pub_master_to_pool_singleton(
      NativePortType port_, Uint8List master, int pool_wallet_idx);

  external dynamic /* void */ wire_pub_master_to_pool_authentication(
      NativePortType port_, Uint8List sk, int pool_wallet_idx, int idx);

  external dynamic /* void */ wire_cmds_program_run(
      NativePortType port_, List<String> args);

  external dynamic /* void */ wire_cmds_program_brun(
      NativePortType port_, List<String> args);

  external dynamic /* void */ wire_cmd_program_opc(
      NativePortType port_, List<String> args);

  external dynamic /* void */ wire_cmd_program_opd(
      NativePortType port_, List<String> args);

  external dynamic /* void */ wire_program_tree_hash(
      NativePortType port_, Uint8List ser_program_bytes);

  external dynamic /* void */ wire_program_curry(
      NativePortType port_, Uint8List ser_program_bytes, List<String> args_str);

  external dynamic /* void */ wire_program_uncurry(
      NativePortType port_, Uint8List ser_program_bytes);

  external dynamic /* void */ wire_program_from_list(
      NativePortType port_, List<String> program_list);

  external dynamic /* void */ wire_program_disassemble(
      NativePortType port_, Uint8List ser_program_bytes, int? version);

  external dynamic /* void */ wire_program_run(
      NativePortType port_, Uint8List ser_program_bytes, List<String> args_str);

  external dynamic /* void */ wire_program_from_atom_bytes(
      NativePortType port_, Uint8List ser_program_bytes);

  external dynamic /* void */ wire_program_to_atom_bytes(
      NativePortType port_, Uint8List ser_program_bytes);

  external dynamic /* void */ wire_get_puzzle_from_public_key(
      NativePortType port_, Uint8List pk);

  external dynamic /* void */ wire_cats_create_cat_puzzle(
      NativePortType port_, Uint8List tail_hash, Uint8List inner_puzzle_hash);
}

// Section: WASM wire connector

class RustWire extends FlutterRustBridgeWasmWireBase<RustWasmModule> {
  RustWire(FutureOr<WasmModule> module)
      : super(WasmModule.cast<RustWasmModule>(module));

  void wire_secret_key_from_seed(NativePortType port_, Uint8List seed) =>
      wasmModule.wire_secret_key_from_seed(port_, seed);

  void wire_secret_key_public_key(NativePortType port_, Uint8List sk) =>
      wasmModule.wire_secret_key_public_key(port_, sk);

  void wire_secret_key_derive_path_hardened(
          NativePortType port_, Uint8List sk, Uint32List path) =>
      wasmModule.wire_secret_key_derive_path_hardened(port_, sk, path);

  void wire_secret_key_derive_path_unhardened(
          NativePortType port_, Uint8List sk, Uint32List path) =>
      wasmModule.wire_secret_key_derive_path_unhardened(port_, sk, path);

  void wire_public_key_derive_path_unhardened(
          NativePortType port_, Uint8List sk, Uint32List path) =>
      wasmModule.wire_public_key_derive_path_unhardened(port_, sk, path);

  void wire_signature_sign(NativePortType port_, Uint8List sk, Uint8List msg) =>
      wasmModule.wire_signature_sign(port_, sk, msg);

  void wire_signature_is_valid(NativePortType port_, Uint8List sig) =>
      wasmModule.wire_signature_is_valid(port_, sig);

  void wire_signature_aggregate(
          NativePortType port_, Uint8List sigs_stream, int length) =>
      wasmModule.wire_signature_aggregate(port_, sigs_stream, length);

  void wire_signature_verify(
          NativePortType port_, Uint8List pk, Uint8List msg, Uint8List sig) =>
      wasmModule.wire_signature_verify(port_, pk, msg, sig);

  void wire_pub_mnemonic_to_entropy(
          NativePortType port_, String mnemonic_words) =>
      wasmModule.wire_pub_mnemonic_to_entropy(port_, mnemonic_words);

  void wire_pub_entropy_to_mnemonic(NativePortType port_, Uint8List entropy) =>
      wasmModule.wire_pub_entropy_to_mnemonic(port_, entropy);

  void wire_pub_entropy_to_seed(NativePortType port_, Uint8List entropy) =>
      wasmModule.wire_pub_entropy_to_seed(port_, entropy);

  void wire_bytes_to_hex(NativePortType port_, Uint8List bytes) =>
      wasmModule.wire_bytes_to_hex(port_, bytes);

  void wire_hex_to_bytes(NativePortType port_, String hex) =>
      wasmModule.wire_hex_to_bytes(port_, hex);

  void wire_bytes_to_sha256(NativePortType port_, Uint8List bytes) =>
      wasmModule.wire_bytes_to_sha256(port_, bytes);

  void wire_pub_master_to_wallet_unhardened_intermediate(
          NativePortType port_, Uint8List master) =>
      wasmModule.wire_pub_master_to_wallet_unhardened_intermediate(
          port_, master);

  void wire_pub_master_to_wallet_unhardened(
          NativePortType port_, Uint8List master, int idx) =>
      wasmModule.wire_pub_master_to_wallet_unhardened(port_, master, idx);

  void wire_pub_master_to_wallet_hardened_intermediate(
          NativePortType port_, Uint8List master) =>
      wasmModule.wire_pub_master_to_wallet_hardened_intermediate(port_, master);

  void wire_pub_master_to_wallet_hardened(
          NativePortType port_, Uint8List master, int idx) =>
      wasmModule.wire_pub_master_to_wallet_hardened(port_, master, idx);

  void wire_pub_master_to_pool_singleton(
          NativePortType port_, Uint8List master, int pool_wallet_idx) =>
      wasmModule.wire_pub_master_to_pool_singleton(
          port_, master, pool_wallet_idx);

  void wire_pub_master_to_pool_authentication(
          NativePortType port_, Uint8List sk, int pool_wallet_idx, int idx) =>
      wasmModule.wire_pub_master_to_pool_authentication(
          port_, sk, pool_wallet_idx, idx);

  void wire_cmds_program_run(NativePortType port_, List<String> args) =>
      wasmModule.wire_cmds_program_run(port_, args);

  void wire_cmds_program_brun(NativePortType port_, List<String> args) =>
      wasmModule.wire_cmds_program_brun(port_, args);

  void wire_cmd_program_opc(NativePortType port_, List<String> args) =>
      wasmModule.wire_cmd_program_opc(port_, args);

  void wire_cmd_program_opd(NativePortType port_, List<String> args) =>
      wasmModule.wire_cmd_program_opd(port_, args);

  void wire_program_tree_hash(
          NativePortType port_, Uint8List ser_program_bytes) =>
      wasmModule.wire_program_tree_hash(port_, ser_program_bytes);

  void wire_program_curry(NativePortType port_, Uint8List ser_program_bytes,
          List<String> args_str) =>
      wasmModule.wire_program_curry(port_, ser_program_bytes, args_str);

  void wire_program_uncurry(
          NativePortType port_, Uint8List ser_program_bytes) =>
      wasmModule.wire_program_uncurry(port_, ser_program_bytes);

  void wire_program_from_list(
          NativePortType port_, List<String> program_list) =>
      wasmModule.wire_program_from_list(port_, program_list);

  void wire_program_disassemble(
          NativePortType port_, Uint8List ser_program_bytes, int? version) =>
      wasmModule.wire_program_disassemble(port_, ser_program_bytes, version);

  void wire_program_run(NativePortType port_, Uint8List ser_program_bytes,
          List<String> args_str) =>
      wasmModule.wire_program_run(port_, ser_program_bytes, args_str);

  void wire_program_from_atom_bytes(
          NativePortType port_, Uint8List ser_program_bytes) =>
      wasmModule.wire_program_from_atom_bytes(port_, ser_program_bytes);

  void wire_program_to_atom_bytes(
          NativePortType port_, Uint8List ser_program_bytes) =>
      wasmModule.wire_program_to_atom_bytes(port_, ser_program_bytes);

  void wire_get_puzzle_from_public_key(NativePortType port_, Uint8List pk) =>
      wasmModule.wire_get_puzzle_from_public_key(port_, pk);

  void wire_cats_create_cat_puzzle(NativePortType port_, Uint8List tail_hash,
          Uint8List inner_puzzle_hash) =>
      wasmModule.wire_cats_create_cat_puzzle(
          port_, tail_hash, inner_puzzle_hash);
}
