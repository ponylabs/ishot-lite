#import "KeyEventSettingPopoverViewController.h"
#pragma clang fp contract(off)
@implementation KeyEventSettingPopoverViewController
@synthesize popover;
- (instancetype)initFromXib {
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"KeyEventSettingPopoverView" owner:self topLevelObjects:NULL];
        popover = [[NSPopover alloc] init];
        popover.contentViewController = self;
        popover.behavior = 1;
    }
    return self;
}
- (IBAction)adjustSize:(id)sender {
    float value = [sender floatValue] / 10.f;
    [[NSUserDefaults standardUserDefaults] setFloat:(float)(int32_t)((double)value + .5) * 10.f forKey:@"sizeOfKeyEvent"];
}
- (IBAction)adjustDelayTime:(id)sender {
    float value = [sender floatValue] * 10.f;
    [[NSUserDefaults standardUserDefaults] setFloat:(float)(int32_t)((double)value + .5) / 10.f forKey:@"delayOfKeyEvent"];
}
- (IBAction)adjustMaxKeys:(id)sender {
    [[NSUserDefaults standardUserDefaults] setFloat:(float)(int32_t)((double)[sender floatValue] + .5) forKey:@"maxKeysOfKeyEvent"];
}
- (IBAction)radioButtonSelected:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([sender tag] == 0) {
        [defaults setBool:YES forKey:@"appearanceLightOfKeyEvent"];
        [defaults setBool:NO forKey:@"appearanceDarkOfKeyEvent"];
        [defaults setBool:NO forKey:@"appearanceAutoOfKeyEvent"];
    } else if ([sender tag] == 1) {
        [defaults setBool:NO forKey:@"appearanceLightOfKeyEvent"];
        [defaults setBool:YES forKey:@"appearanceDarkOfKeyEvent"];
        [defaults setBool:NO forKey:@"appearanceAutoOfKeyEvent"];
    } else if ([sender tag] == 2) {
        [defaults setBool:NO forKey:@"appearanceLightOfKeyEvent"];
        [defaults setBool:NO forKey:@"appearanceDarkOfKeyEvent"];
        [defaults setBool:YES forKey:@"appearanceAutoOfKeyEvent"];
    }
    [defaults synchronize];
}
@end
