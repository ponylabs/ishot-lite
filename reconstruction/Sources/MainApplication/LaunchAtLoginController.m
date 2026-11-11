#import "LaunchAtLoginController.h"
#import <ServiceManagement/ServiceManagement.h>

// 0x100047ffc. Notification object's string is cn.better365.iShot, not helper ID.
void IShotFunction_100047ffc(NSString *name) {
    [NSDistributedNotificationCenter.defaultCenter postNotificationName:name object:@"cn.better365.iShot" userInfo:nil deliverImmediately:YES];
}

@implementation LaunchAtLoginController
// 0x1000af8fc; delayed global block 0x1000afa04.
- (instancetype)init {
    self = [super init];
    if (self) {
        if ([NSRunningApplication runningApplicationsWithBundleIdentifier:@"cn.better365.iShotHelper"].count == 0) {
            [self setLaunchAtLogin:NO];
            [self setLaunchAtLogin:YES];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500000000), dispatch_get_main_queue(), ^{
            BOOL enabled = [NSUserDefaults.standardUserDefaults boolForKey:@"autoStartAtLogin"];
            IShotFunction_100047ffc(enabled ? @"TelliShotHelperToAutoStartAtLogin" : @"TelliShotHelperToNotAutoStartAtLogin");
        });
        [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"autoStartAtLogin" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}
// 0x1000afa64: original reads the default regardless of incoming key path.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    BOOL enabled = [NSUserDefaults.standardUserDefaults boolForKey:@"autoStartAtLogin"];
    IShotFunction_100047ffc(enabled ? @"TelliShotHelperToAutoStartAtLogin" : @"TelliShotHelperToNotAutoStartAtLogin");
}
// 0x1000afac4 only tail-calls super dealloc; ARC emits that call. There is no
// removeObserver operation in the original destructor.
- (void)dealloc {}
// 0x1000afaf8 and dispatch_once block 0x1000afb6c. Captured class is self.
+ (instancetype)shared {
    static dispatch_once_t once_1001f1bc8;
    static id instance_1001f1bc0;
    dispatch_once(&once_1001f1bc8, ^{ instance_1001f1bc0 = [[self alloc] init]; });
    return instance_1001f1bc0;
}
// 0x1000afb98. Original ignores the API's Boolean result.
- (void)setLaunchAtLogin:(BOOL)enabled {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SMLoginItemSetEnabled(CFSTR("cn.better365.iShotHelper"), enabled);
#pragma clang diagnostic pop
}
@end
