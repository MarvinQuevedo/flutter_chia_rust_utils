#include "include/flutter_chia_rust_utils/flutter_chia_rust_utils_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_chia_rust_utils_plugin.h"

void FlutterChiaRustUtilsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_chia_rust_utils::FlutterChiaRustUtilsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
