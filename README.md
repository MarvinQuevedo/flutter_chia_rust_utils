Flutter Chia Rust library develop by Ozone Team <a href="https://github.com/MarvinQuevedo">Marvin Quevedo</a>

You can support our work sending a tip to:
 
<p>CHIA: xch1u63gjtvqyptalmhh9e5pwkwerf5x58f6phajdnlmqms262nhlnesck3pjq</p>
<p>TRON-TRC20: TMxKPo5AnfSbJY8CZcTJR7L8h4JtEG2pBp</p>
<p>Bitcoin: 3Qnbej5wkFYHGm1AzBMkfopzENkNipAaLQ</p>
 
<p>Using <a href="https://github.com/Chia-Network/chia_rs">chia_rs</a> we develop a Flutter lib binding.</p>
<p>In this library you have <a href="https://github.com/Chia-Network/clvm_tools_rs">chia_tools_rs </a> commands (run, brun, opc, opd) can be used in Flutter</p>
<p>Program for work with ChiaLisp programs for develop news logic for Chia Blockchain tools</p>



For build in iOS, call the dummy method for keep the libs in release mode
import UIKit
import Flutter
import flutter_chia_rust_utils
 

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  FlutterChiaBlsPlugin.dummyMethodToEnforceBundling()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}



For build in macOS

import Cocoa
import FlutterMacOS
import flutter_chia_rust_utils

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    FlutterChiaRustUtilsPlugin.dummyMethodToEnforceBundling()
    
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
