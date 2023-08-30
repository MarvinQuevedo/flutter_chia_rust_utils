 

# flutter_rust_bridge_codegen --wasm --rust-input chia_rust_utils/src/api.rs \
#                             --dart-output lib/generated/bridge_generated.dart 
#cargo install flutter_rust_bridge_codegen  --version 1.79.0
 
flutter_rust_bridge_codegen \
    --wasm \
    --rust-input chia_rust_utils/src/api.rs  \
    --llvm-path /opt/homebrew/opt/llvm/ \
    --dart-output lib/generated/bridge_generated.dart  -c ios/Classes/BridgeGenerated.h   -e macos/Classes/    
 
 cp ios/Classes/BridgeGenerated.h  macos/Classes/