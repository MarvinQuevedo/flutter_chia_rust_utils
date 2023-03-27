#!/usr/bin/env bash

# Setup
BUILD_DIR=platform-build
mkdir $BUILD_DIR
cd $BUILD_DIR

 
zig_build () {
    ./build_with_dockers.sh
    mkdir "$PLATFORM_NAME"
    cp "../target/$TARGET/release/$LIBNAME" "$PLATFORM_NAME/"
}

# Build all the dynamic libraries
LINUX_LIBNAME=rust_bls_flutter.so
 
zig_build x86_64-unknown-linux-gnu $LINUX_LIBNAME

# Archive the dynamic libs
tar -czvf linux.tar.gz linux-*

# Cleanup
rm -rf linux-*