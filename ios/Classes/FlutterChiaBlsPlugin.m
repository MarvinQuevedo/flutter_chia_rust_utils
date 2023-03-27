#import "FlutterChiaBlsPlugin.h"

@implementation FlutterChiaBlsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_chia_bls"
            binaryMessenger:[registrar messenger]];
  FlutterChiaBlsPlugin* instance = [[FlutterChiaBlsPlugin alloc] init];
    int64_t result = dummy_method_to_enforce_bundling();
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
