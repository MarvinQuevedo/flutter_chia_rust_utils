<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

## install ndk

### Rust < 1.68:
```
cargo install cargo-ndk --version 2.6.0
```

### Rust >= 1.68: 
```
cargo install cargo-ndk
```

## iOS -  Creating universal library for rust 
```
cargo lipo && cp target/universal/debug/librust_bls_flutter.a ../ios/Runner
```

## Android - compile for Android Debug
```
cargo ndk -t armeabi-v7a -t arm64-v8a -t x86 -t x86_64 -o ../android/app/src/main/jniLibs build
```

## Android - compile for Android Release
```
cargo ndk -t armeabi-v7a -t arm64-v8a -t x86 -t x86_64 -o ../android/app/src/main/jniLibs build --release
```
## Linux
```
brew install FiloSottile/musl-cross/musl-cross
cargo build --target=x86_64-unknown-linux-musl
```
## Windows

1. Install target mingw-w64: `brew install mingw-w64`
2. Add target to rustup: `rustup target add x86_64-pc-windows-gnu`
3. Create `.cargo/config`
4. Add the instructions below to `.cargo/config` 
```
[target.x86_64-pc-windows-gnu]
linker = "x86_64-w64-mingw32-gcc"
  
```
6. And finally, run: 
```
cargo build --target=x86_64-pc-windows-gnu --verbose
```



# Compile
./scripts/build-all.sh