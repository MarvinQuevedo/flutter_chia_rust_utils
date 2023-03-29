cd example
flutter clean
rm -rf ios/Podfile.lock
rm -rf ios/Pods
rm -rf ios/.symlinks

rm -rf macos/Podfile.lock
rm -rf macos/Pods
rm -rf macos/.symlinks
flutter pub get
