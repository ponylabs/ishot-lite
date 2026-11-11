#import <AppKit/AppKit.h>
extern NSColor *IShotGlobal_1001ddf80;
@interface CustomNSClipView : NSClipView
- (void)MenuBarAppearanceDidChange;
- (void)getTabViewColor;
@end
@interface LCSizeInputTextField : NSTextField
- (void)commonConfig;
- (void)updateTextFieldColors;
@end
@interface LCVerticalCenteredTextFieldCell : NSTextFieldCell
@end
@interface LCTableViewScrollView : NSScrollView
@property(nonatomic) double cornerRadius;
@property(nonatomic) double borderWidth;
@property(nonatomic,strong) NSColor *borderColor;
@property(nonatomic,strong) NSColor *containerBackgroundColor;
@property(nonatomic) BOOL isTransparentBackground;
@property(nonatomic,strong) NSColor *darkBackgroundColor;
@property(nonatomic,strong) NSColor *lightBackgroundColor;
- (void)commonSetup;
- (void)delayUpdateStyle;
- (void)fixTableHeaderAppearance;
- (void)updateBorderStyle;
@end
