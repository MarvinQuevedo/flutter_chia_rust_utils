#!/usr/bin/env bash
set -e

# Navigate to the Rust project directory
cd chia_rust_utils 
CURR_VERSION=flutter_chia_rust_utils-v`awk '/^version: /{print $2}' ../pubspec.yaml`

# Try to clean previous builds, but don't fail if it doesn't work
echo "Cleaning previous builds..."
cargo clean || echo "Clean failed, continuing anyway..."

# Build the release version for Linux
echo "Building Rust library for Linux..."
cargo build --release --target=x86_64-unknown-linux-gnu

# Setup build directory
BUILD_DIR=platform-build
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

LINUX_LIBNAME=librust_bls_flutter.so
TARGET="x86_64-unknown-linux-gnu"
PLATFORM_NAME="linux-amd64"
LIBNAME="$LINUX_LIBNAME"

echo "Creating platform directory..."
mkdir -p "$PLATFORM_NAME"

# Copy the built library
if [ -f "../target/$TARGET/release/$LIBNAME" ]; then
    echo "Copying library: ../target/$TARGET/release/$LIBNAME"
    cp "../target/$TARGET/release/$LIBNAME" "$PLATFORM_NAME/"
else
    echo "Error: Library not found at ../target/$TARGET/release/$LIBNAME"
    ls -la ../target/$TARGET/release/
    exit 1
fi

# Archive the dynamic libs
echo "Creating archive..."
tar -czvf linux.tar.gz linux-*

# Copy to linux directory
echo "Copying archive to linux directory..."
mkdir -p ../../linux
cp linux.tar.gz ../../linux/$CURR_VERSION.tar.gz

# Also copy the library directly for development
cp "$PLATFORM_NAME/$LIBNAME" ../../linux/

echo "Linux build completed successfully!"
echo "Library: $LIBNAME"
echo "Archive: $CURR_VERSION.tar.gz"

# Cleanup
cd ..
rm -rf $BUILD_DIR