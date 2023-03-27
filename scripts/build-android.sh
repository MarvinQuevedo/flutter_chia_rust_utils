#!/usr/bin/env bash

CURR_VERSION=flutter_chia_rust_utils-v`awk '/^version: /{print $2}' ../pubspec.yaml`

# Setup
 
BUILD_DIR=platform-build
mkdir $BUILD_DIR
cd $BUILD_DIR

# Create the jniLibs build directory
JNI_DIR=jniLibs
mkdir -p $JNI_DIR

# Set up cargo-ndk
cargo install cargo-ndk@2.12.6
rustup target add \
        aarch64-linux-android \
        armv7-linux-androideabi \
        x86_64-linux-android \
        i686-linux-android

# Build the android libraries in the jniLibs directory
cargo ndk -o $JNI_DIR \
        --manifest-path ../Cargo.toml \
        -t armeabi-v7a \
        -t arm64-v8a \
        -t x86 \
        -t x86_64 \
        build --release

cp -r $JNI_DIR/ ../../android/src/main/jniLibs
# Archive the dynamic libs
cd $JNI_DIR
tar -czvf ../android.tar.gz *
pwd 
cp ../android.tar.gz ../../../android/$CURR_VERSION.tar.gz
cd -

# Cleanup
rm -rf $JNI_DIR