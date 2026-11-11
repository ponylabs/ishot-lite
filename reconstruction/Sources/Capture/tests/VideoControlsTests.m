// Explicit dependency doubles; no audio-device changes, capture, timers or permissions.
#import "../SGVideoControlsViewController.m"
#include <assert.h>
SGCaptureSession *IShotGlobal_1001dddb0;
BOOL IShotGlobal_1001dd139,IShotGlobal_1001de210;
KeyEventSettingPopoverViewController *IShotGlobal_1001de218;
AudioDeviceID IShotGlobal_1001de220;
uint64_t IShotFunction_100048c68(void) { assert(!"unexpected permission path"); return 0; }
@implementation SGCaptureSession
@end
@implementation CircleDownCounter
@end
@implementation KeyEventSettingPopoverViewController
@end
@interface MeterFixture : NSObject
@end
@implementation MeterFixture
- (float)updateAudioLevels { return 0; }
@end
int main(void) {
    @autoreleasepool {
        [NSApplication sharedApplication];
        SGVideoControlsViewController *controller=[SGVideoControlsViewController new];
        NSPopUpButton *gif=[NSPopUpButton new],*video=[NSPopUpButton new]; NSBox *aspect=[NSBox new];
        controller.framesGifPopUpButton=gif; controller.framesPopUpButton=video; controller.boxOfAspectRatio=aspect;
        NSBox *meter=[NSBox new]; controller.arrOfLevelBox=[NSMutableArray arrayWithObject:meter];
        NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
        NSDictionary *previous=[defaults volatileDomainForName:NSArgumentDomain];
        NSMutableDictionary *arguments=[previous mutableCopy];
        arguments[@"formatOfRecordScreen"]=@"gif"; [defaults setVolatileDomain:arguments forName:NSArgumentDomain]; [controller formatOfRecordScreenRefresh]; assert(!gif.hidden && video.hidden && meter.hidden && !aspect.hidden);
        arguments[@"formatOfRecordScreen"]=@"mp4"; [defaults setVolatileDomain:arguments forName:NSArgumentDomain]; [controller formatOfRecordScreenRefresh]; assert(gif.hidden && !video.hidden && !meter.hidden && aspect.hidden);
        [defaults setVolatileDomain:previous forName:NSArgumentDomain];
        controller.checkButtonOfShowMouseClicks=[NSButton new];
        [controller observeValueForKeyPath:@"showCursorOfRecordScreen" ofObject:nil change:@{@"new":@1} context:NULL]; assert(controller.checkButtonOfShowMouseClicks.enabled);
        [controller observeValueForKeyPath:@"showCursorOfRecordScreen" ofObject:nil change:@{@"new":@2} context:NULL]; assert(!controller.checkButtonOfShowMouseClicks.enabled);
        NSLog(@"VideoControlsTests passed");
    }
}
