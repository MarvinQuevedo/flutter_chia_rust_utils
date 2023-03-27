//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_chia_rust_utils/flutter_chia_bls_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_chia_rust_utils_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterChiaBlsPlugin");
  flutter_chia_bls_plugin_register_with_registrar(flutter_chia_rust_utils_registrar);
}
