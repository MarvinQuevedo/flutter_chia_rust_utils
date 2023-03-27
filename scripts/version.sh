#!/usr/bin/env bash
pwd


CURR_VERSION=flutter_chia_rust_utils-v`awk '/^version: /{print $2}' pubspec.yaml`
echo "Setting version to $CURR_VERSION"

# iOS & macOS
APPLE_HEADER="release_tag_name = '$CURR_VERSION' # generated; do not edit"
echo $APPLE_HEADER
sed -i.bak "1 s/.*/$APPLE_HEADER/" ./ios/flutter_chia_rust_utils.podspec
sed -i.bak "1 s/.*/$APPLE_HEADER/" ./macos/flutter_chia_rust_utils.podspec
rm ./macos/*.bak ./ios/*.bak

# CMake platforms (Linux, Windows, and Android)
CMAKE_HEADER="set(LibraryVersion \"$CURR_VERSION\") # generated; do not edit"
for CMAKE_PLATFORM in android linux windows
do
    sed -i.bak "1 s/.*/$CMAKE_HEADER/" $CMAKE_PLATFORM/CMakeLists.txt
    rm ./$CMAKE_PLATFORM/*.bak
done

