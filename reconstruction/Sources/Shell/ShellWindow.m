#import "ShellControllers.h"
extern ShellWindowController *IShotGlobal_1001de2c0;
@implementation ShellWindow
- (BOOL)canBecomeKeyWindow { return YES; } // 0x10007870c
- (BOOL)canBecomeMainWindow { return YES; } // 0x100078714
- (void)keyDown:(NSEvent *)event { [IShotGlobal_1001de2c0 keyDown:event]; } // 0x10007871c
- (void)magnifyWithEvent:(NSEvent *)event { [super magnifyWithEvent:event]; } // 0x10007872c
@end
