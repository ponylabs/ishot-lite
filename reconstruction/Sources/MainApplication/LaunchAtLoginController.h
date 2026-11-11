#import <Cocoa/Cocoa.h>
@interface LaunchAtLoginController : NSObject
+ (instancetype)shared;
- (void)setLaunchAtLogin:(BOOL)enabled;
@end
// Original helper 0x100047ffc. Its constant return value is unused by callers.
void IShotFunction_100047ffc(NSString *name);
