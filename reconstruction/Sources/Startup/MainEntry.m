#import "MainEntry.h"
#import <IOKit/IOKitLib.h>

NSString *IShotGlobal_1001ddfe0;
NSUserDefaults *IShotGlobal_1001ddfe8;
NSString *IShotGlobal_1001ddff0;
NSString *IShotGlobal_1001dcfa0 = @"";
BOOL IShotGlobal_1001ddfd8 = YES; // Lite: all local features are available.
BOOL IShotGlobal_1001dd139 = NO; // Lite: no trial, subscription or payment restriction.

// REA 0x10004a604; literals confirmed in cfstrings-arm64.json and assembly.
NSString *IShotFunction_10004a604(void) {
    io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                       IOServiceMatching("IOPlatformExpertDevice"));
    if (service == IO_OBJECT_NULL) return @"NSUTF8String";
    NSString *uuid = CFBridgingRelease(IORegistryEntryCreateCFProperty(service,
                                     CFSTR("IOPlatformUUID"), kCFAllocatorDefault, 0));
    NSString *result;
    if (uuid == nil) {
        result = @"NSUTF8String";
    } else {
        IShotGlobal_1001dcfa0 = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
        result = [[uuid componentsSeparatedByString:@"-"][4] mutableCopy];
    }
    IOObjectRelease(service);
    return result;
}

// REA entry 0x10005d460; called by reconstruction/main.m with the recovered AppDelegate.
int IShotRecoveredEntry(int argc, const char *argv[]) {
    IShotGlobal_1001ddfe0 = NSWorkspace.sharedWorkspace.frontmostApplication.bundleIdentifier;
    IShotGlobal_1001ddfe8 = [[NSUserDefaults alloc] initWithSuiteName:@"4K6FWZU8C4.group.cn.better365"];
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    [IShotGlobal_1001ddfe8 setObject:[defaults objectForKey:@"AppleLanguages"] forKey:@"iShotAppleLanguages"];
    IShotGlobal_1001ddff0 = IShotFunction_10004a604();
    // Intentional Lite policy, distinct from the original REA reconstruction.
    // No receipt is created, verified or rewritten; access does not expire.
    IShotGlobal_1001ddfd8 = YES;
    IShotGlobal_1001dd139 = NO;
    [IShotGlobal_1001ddfe8 setBool:YES forKey:@"iShotHavePurchased"];
    [IShotGlobal_1001ddfe8 synchronize];
    [defaults removeObjectForKey:@"InstallTimeInfo"];
    [defaults synchronize];
    return NSApplicationMain(argc, argv);
}
