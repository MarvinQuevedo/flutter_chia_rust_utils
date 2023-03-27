#ifndef FLUTTER_PLUGIN_FLUTTER_CHIA_RUST_UTILS_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_CHIA_RUST_UTILS_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _FlutterChiaRustUtilsPlugin FlutterChiaRustUtilsPlugin;
typedef struct {
  GObjectClass parent_class;
} FlutterChiaRustUtilsPluginClass;

FLUTTER_PLUGIN_EXPORT GType flutter_chia_rust_utils_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void flutter_chia_rust_utils_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_FLUTTER_CHIA_RUST_UTILS_PLUGIN_H_
