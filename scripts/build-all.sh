#!/usr/bin/env bash

./scripts/version.sh

cd rust 
#cargo clean
 

 
../scripts/build-apple.sh 
#../scripts/build-linux.sh
../scripts/build-android.sh 
../scripts/build-windows.sh


CURR_VERSION=flutter_chia_rust_utils-v`awk '/^version: /{print $2}' ../pubspec.yaml`
echo "git add . "
echo "git commit -m \"Build $CURR_VERSION\""