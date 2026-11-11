#import "CollectionViewItem.h"
#import "ShellControllers.h"
extern ScreenshotWithShellController *IShotGlobal_1001de190;
@implementation CollectionViewItem
- (void)viewDidLoad { // 0x1000707c0
    [super viewDidLoad];
    self.view.wantsLayer=YES;
    self.imageView.image=[NSImage imageNamed:self.title];
    self.textField.stringValue=self.title;
    self.textField.drawsBackground=YES;
    self.textField.backgroundColor=NSColor.clearColor;
}
- (void)mouseDown:(NSEvent *)event { // 0x10007093c
    if (event.clickCount==1) {
        if (!IShotGlobal_1001de190) IShotGlobal_1001de190=[[ScreenshotWithShellController alloc] initFromXib];
        [IShotGlobal_1001de190 selectedShellName:self.textField.stringValue];
    }
}
@end
