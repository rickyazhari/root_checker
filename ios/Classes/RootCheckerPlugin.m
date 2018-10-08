#import "RootCheckerPlugin.h"

@implementation RootCheckerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"root_checker"
            binaryMessenger:[registrar messenger]];
  RootCheckerPlugin* instance = [[RootCheckerPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"isDeviceRooted" isEqualToString:call.method]) {
      result(isJailBroken);
  } else {
    result(FlutterMethodNotImplemented);
  }
}


- bool isJailBroken(){
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"]
       || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]
       ){
        return @YES;
    }
    
    FILE *f = NULL;
    if((f = fopen("/bin/bash","r"))
       || (f = fopen("/Applications/Cydia.app","r"))
       || (f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib","r"))
       || (f = fopen("/usr/sbin/sshd","r"))
       || (f = fopen("/etc/apt","r"))
    ){
        fclose(f);
        return @YES;
    }
    fclose(f);
    
    NSError *error;
    NSString *stringTestWrite="checking jailbreak...";
    [stringTestWrite writeToFile:@"/private/check_jailbreak.txt" atomically:@YES encoding:NSUTF8StringEncoding error:&error];
    [[NSFileManager defaultManager] remmoveItemAtPath:@"/private/check_jailbreak.txt" error:nil];
    if(error == nil){
        return @YES;
    }
    return @NO;
}

@end
