# Flutter Chia Rust library 

## Flutter Chia Rust library develop by Ozone Team <a href="https://github.com/MarvinQuevedo">Marvin Quevedo</a>

You can support our work sending a tip to:
 
</br>
<p>CHIA: xch1u63gjtvqyptalmhh9e5pwkwerf5x58f6phajdnlmqms262nhlnesck3pjq</p>
<p>TRON-TRC20: TMxKPo5AnfSbJY8CZcTJR7L8h4JtEG2pBp</p>
<p>Bitcoin: 3Qnbej5wkFYHGm1AzBMkfopzENkNipAaLQ</p>
 
</br>
</br>

<p>Using <a href="https://github.com/Chia-Network/chia_rs">chia_rs</a> we develop a Flutter lib binding.</p>
<p>In this library you have <a href="https://github.com/Chia-Network/clvm_tools_rs">chia_tools_rs </a> commands (run, brun, opc, opd) can be used in Flutter</p>
<p>Program for work with ChiaLisp programs for develop news logic for Chia Blockchain tools</p>

</br>
</br>
</br>


For build in iOS, call the dummy method for keep the libs in release mode
```swift
import UIKit
import Flutter

// add import
import flutter_chia_rust_utils
 

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
 
    //...
    // Add this line to call dummyMethodToEnforceBundling 
    // for give the xcode compiler that we need the Rust native library

    FlutterChiaBlsPlugin.dummyMethodToEnforceBundling()

    //...
    
  }
}
```


For build in macOS

```swift
import Cocoa
import FlutterMacOS

// add import
import flutter_chia_rust_utils

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    //...
    // Add this line to call dummyMethodToEnforceBundling 
    // for give the xcode compiler that we need the Rust native library

    FlutterChiaRustUtilsPlugin.dummyMethodToEnforceBundling()

    //...
  }
}
```