#import "LCFreePlanManager.h"

@implementation LCFreePlanManager
// REA arm64 0x1000093cc; constants from the shipped CFString records.
+ (NSArray<NSString *> *)requiredBundleIdentifiers {
    return @[@"com.better365.TrackPad", @"com.better365.MacMouse",
             @"com.better365.Keyboard", @"cn.better365.XApp"];
}

// REA arm64 0x100009454: count distinct identifiers with at least one process.
+ (BOOL)isEnabled {
    NSInteger count = 0;
    for (NSString *identifier in [self requiredBundleIdentifiers]) {
        if ([NSRunningApplication runningApplicationsWithBundleIdentifier:identifier].count != 0) count++;
    }
    return count > 1;
}
@end
