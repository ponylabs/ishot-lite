#import "PinWindow.h"
@implementation PinWindow
- (instancetype)init { return [super init]; } // 0x1000afba8
- (void)insertText:(id)text { // 0x1000afbdc; complete event ABI verified in REA assembly
    if ([text isEqual:@" "]) {
        NSPoint point=self.mouseLocationOutsideOfEventStream;
        NSTimeInterval time=NSProcessInfo.processInfo.systemUptime;
        NSEvent *event=[NSEvent keyEventWithType:10 location:point modifierFlags:0 timestamp:time windowNumber:self.windowNumber context:NSGraphicsContext.currentContext characters:@" " charactersIgnoringModifiers:@" " isARepeat:NO keyCode:49];
        [NSApp.mainMenu performKeyEquivalent:event];
    } else [super insertText:text];
}
- (BOOL)canBecomeKeyWindow { return YES; } // 0x1000afd50
- (BOOL)canBecomeMainWindow { return YES; } // 0x1000afd58
- (void)keyDown:(NSEvent *)event { [self.contentView keyDown:event]; } // 0x1000afd60
- (void)magnifyWithEvent:(NSEvent *)event {} // 0x1000afdb0: original RET
@end
