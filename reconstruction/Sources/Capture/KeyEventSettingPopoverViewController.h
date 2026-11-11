#pragma once
#import <Cocoa/Cocoa.h>
@interface KeyEventSettingPopoverViewController : NSViewController {
    NSPopover *popover;
}
@property (atomic, strong) NSPopover *popover;
- (instancetype)initFromXib;
- (IBAction)adjustSize:(id)sender;
- (IBAction)adjustDelayTime:(id)sender;
- (IBAction)adjustMaxKeys:(id)sender;
- (IBAction)radioButtonSelected:(id)sender;
@end
