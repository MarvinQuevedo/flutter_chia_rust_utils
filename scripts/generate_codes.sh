 

flutter_rust_bridge_codegen --wasm --rust-input chia_rust_utils/src/api.rs \
                            --dart-output lib/generated/bridge_generated.dart 

flutter_rust_bridge_codegen \
    -r chia_rust_utils/src/api.rs  \
    --llvm-path /opt/homebrew/opt/llvm/ \
    -d lib/generated/bridge_generated.dart \
    -c ios/Classes/BridgeGenerated.h \
    -e macos/Classes/   # if building for MacOS, extra path is essential
 
 cp ios/Classes/BridgeGenerated.h  macos/Classes/