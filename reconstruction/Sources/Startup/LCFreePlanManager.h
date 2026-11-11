#import <AppKit/AppKit.h>

@interface LCFreePlanManager : NSObject
+ (NSArray<NSString *> *)requiredBundleIdentifiers;
+ (BOOL)isEnabled;
@end
