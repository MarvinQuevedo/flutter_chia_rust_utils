#!/usr/bin/env bash
#
# Setup

CURR_VERSION=flutter_chia_rust_utils-v`awk '/^version: /{print $2}' ../pubspec.yaml`
 
BUILD_DIR=platform-build
mkdir $BUILD_DIR
cd $BUILD_DIR
 

win_build () {
    local TARGET="$1"
    local PLATFORM_NAME="$2"
    local LIBNAME="$3"
    rustup target add "$TARGET"
    cargo build --target "$TARGET" -r
    mkdir "$PLATFORM_NAME"
    cp "../target/$TARGET/release/$LIBNAME" "$PLATFORM_NAME/"
}

# Build all the dynamic libraries
WINDOWS_LIBNAME=rust_bls_flutter.dll
#win_build aarch64-pc-windows-gnullvm windows-arm64 $WINDOWS_LIBNAME
win_build x86_64-pc-windows-gnu windows-x64 $WINDOWS_LIBNAME

# Archive the dynamic libs
tar -czvf windows.tar.gz windows-*
cp windows.tar.gz ../../windows/$CURR_VERSION.tar.gz



# Cleanup
rm -rf windows-*