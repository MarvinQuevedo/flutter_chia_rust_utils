cd rust 
 
# prepare platforms
rustup target add x86_64-pc-windows-gnu
rustup target add x86_64-unknown-linux-musl
rustup target add aarch64-apple-ios aarch64-apple-darwin x86_64-apple-ios x86_64-apple-darwin aarch64-apple-ios-sim x86_64-apple-ios

#local
cargo build

# iOS
cargo lipo 
cp target/universal/debug/librust_bls_flutter.a ../ios 

# macOS
cp target/universal/debug/librust_bls_flutter.a ../macos 

# Android
cargo ndk -t armeabi-v7a -t arm64-v8a -t x86 -t x86_64 -o ../android/src/main/jniLibs build 

# Windows
cargo build --target=x86_64-pc-windows-gnu 

# Linux
#cargo build --target=x86_64-unknown-linux-musl 