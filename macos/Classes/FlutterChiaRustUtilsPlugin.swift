 
import Cocoa
import FlutterMacOS 

public class FlutterChiaRustUtilsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let _ = dummyMethodToEnforceBundling()
   
  }
  
  // static function to return the result in c int64_t of  dummy_method_to_enforce_bundling
  public static func dummyMethodToEnforceBundling() -> Int64 {
    return dummy_method_to_enforce_bundling();
  }
}