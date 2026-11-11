#import "RecoveredDependencies.h"
#import <StoreKit/StoreKit.h>

@implementation YLAppRating
// 0x10009c254
+ (void)showWithAppID:(id)appID {
    [self showWithAppID:appID minExecCount:10 daysSinceFirstLaunch:3 daysSinceLastPrompt:365 delayInSeconds:10];
}
// 0x10009c268. Exact log formats from CFStrings 0x1001b7760..0x1001b77e0.
+ (void)showWithAppID:(id)appID minExecCount:(long long)minExecCount daysSinceFirstLaunch:(long long)daysSinceFirstLaunch daysSinceLastPrompt:(long long)daysSinceLastPrompt delayInSeconds:(long long)delayInSeconds {
    NSURL *receipt = NSBundle.mainBundle.appStoreReceiptURL;
    if (!receipt || ![NSFileManager.defaultManager fileExistsAtPath:receipt.path]) return;
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    double firstLaunch = [defaults doubleForKey:@"FirstLaunchDate"];
    if (firstLaunch == 0.0) {
        firstLaunch = NSDate.date.timeIntervalSince1970;
        [defaults setDouble:firstLaunch forKey:@"FirstLaunchDate"];
    }
    NSInteger launches = [defaults integerForKey:@"NumberOfLaunches"] + 1;
    [defaults setInteger:launches forKey:@"NumberOfLaunches"];
    if (launches < minExecCount) {
        [defaults synchronize];
        NSLog(@"app评分 - 当前执行次数：%zd 未达到%zd次, 直接返回", launches, (NSInteger)minExecCount);
        return;
    }
    double now = NSDate.date.timeIntervalSince1970;
    double elapsed = now - firstLaunch;
    if (elapsed < (double)(daysSinceFirstLaunch * 86400)) {
        [defaults synchronize];
        NSLog(@"app评分 - 从第一次执行至今，已经%.1f天，未超过%zd天，直接返回", elapsed / 86400.0, (NSInteger)daysSinceFirstLaunch);
        return;
    }
    double lastPrompt = [defaults doubleForKey:@"LastDatePromptedForReview"];
    if (!(lastPrompt <= 0.0)) {
        elapsed = now - lastPrompt;
        if (elapsed < (double)(daysSinceLastPrompt * 86400)) {
            [defaults synchronize];
            NSLog(@"app评分 - 从上一次执行评分弹窗至今，已经%.1f天，未超过%zd天，直接返回", elapsed / 86400.0, (NSInteger)daysSinceLastPrompt);
            return;
        }
    }
    // 0x10009c574 captures now and delay, rather than reading the clock again.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * 1000000000), dispatch_get_main_queue(), ^{
        [defaults setDouble:now + (double)delayInSeconds forKey:@"LastDatePromptedForReview"];
        [defaults setInteger:0 forKey:@"NumberOfLaunches"];
        [defaults synchronize];
        if (@available(macOS 15.0, *)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [SKStoreReviewController requestReview];
#pragma clang diagnostic pop
        } else {
            NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", appID];
            [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:url]];
        }
        NSLog(@"app评分 - 执行了弹窗评分");
    });
}
@end
