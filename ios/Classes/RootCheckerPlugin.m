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
      result([NSNumber numberWithBool:[self ishpBodong]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}


- (bool)ishpBodong{
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/blackra1n.app"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/FakeCarrier.app"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Icy.app"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/IntelliScreen.app"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/MxTube.app"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/RockApp.app"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/SBSettings.app"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/WinterBoard.app"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Veency.plist"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/cydia"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/mobile/Library/SBSettings/Themes"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/stash"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/tmp/cydia.log"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/LaunchDaemons/com.ikey.bbot.plist"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/libexec/sftp-server"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"]
       || [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"]
       || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]
       ){
        return YES;
    }
    
    FILE *f = NULL;
    if((f = fopen("/bin/bash","r"))
       || (f = fopen("/Applications/Cydia.app","r"))
       || (f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib","r"))
       || (f = fopen("/usr/sbin/sshd","r"))
       || (f = fopen("/etc/apt","r"))
       || (f = fopen("/usr/bin/ssh","r"))
    ){
        fclose(f);
        return YES;
    }
    fclose(f);
    
    NSError *error;
    NSString *stringTestWrite=@"checking jailbreak...";
    [stringTestWrite writeToFile:@"/private/check_jailbreak.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(!error){
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/check_jailbreak.txt" error:nil];
        return YES;
    }
    return NO;
}

@end
