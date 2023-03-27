cd example
flutter clean
rm -rf ios/Podfile.lock
rm -rf ios/Pods

rm -rf macos/Podfile.lock
rm -rf macos/Pods
flutter pub get
