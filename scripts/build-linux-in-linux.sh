#!/usr/bin/env bash
 
cd chia_rust_utils 
CURR_VERSION=flutter_chia_rust_utils-v`awk '/^version: /{print $2}' ../pubspec.yaml`

# Setup
BUILD_DIR=platform-build
mkdir $BUILD_DIR
cd $BUILD_DIR
pwd
LINUX_LIBNAME=librust_bls_flutter.so
 

 
TARGET="stable-x86_64-unknown-linux-gnu"
PLATFORM_NAME="linux-amd64"
LIBNAME="$LINUX_LIBNAME"

#cargo build -r
mkdir "$PLATFORM_NAME"
 
ls "../target/release/"
cp "../target/release/$LIBNAME" "$PLATFORM_NAME/"
 
 

# Archive the dynamic libs
tar -czvf linux.tar.gz linux-*
cp linux.tar.gz ../../linux/$CURR_VERSION.tar.gz

# Cleanup
rm -rf linux-*