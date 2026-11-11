#import "PreferenceControls.h"
#import <QuartzCore/QuartzCore.h>
extern CGImageRef IShotCGWindowListCreateImage(CGRect,CGWindowListOption,CGWindowID,CGWindowImageOption) __asm__("_CGWindowListCreateImage");
NSColor *IShotGlobal_1001ddf80;
@implementation CustomNSClipView
- (instancetype)initWithFrame:(NSRect)rect {if((self=[super initWithFrame:rect]))[NSWorkspace.sharedWorkspace.notificationCenter addObserver:self selector:@selector(MenuBarAppearanceDidChange) name:@"NSWorkspaceMenuBarAppearanceDidChangeNotification" object:nil];return self;}
- (void)MenuBarAppearanceDidChange {self.needsDisplay=YES;}
- (void)drawRect:(NSRect)rect {CGContextRef context=NSGraphicsContext.currentContext.graphicsPort;CGContextSetFillColorWithColor(context,NSColor.clearColor.CGColor);CGContextFillRect(context,self.bounds);[super drawRect:rect];}
- (void)dealloc {}
- (void)getTabViewColor {CGImageRef image=IShotCGWindowListCreateImage(CGRectNull,8,(CGWindowID)self.window.windowNumber,0);if(image){NSBitmapImageRep *rep=[[NSBitmapImageRep alloc] initWithCGImage:image];IShotGlobal_1001ddf80=[rep colorAtX:500 y:200];CFRelease(image);}}
@end
@implementation LCSizeInputTextField
- (instancetype)initWithFrame:(NSRect)rect {if((self=[super initWithFrame:rect]))[self commonConfig];return self;}
- (instancetype)initWithCoder:(NSCoder *)coder {if((self=[super initWithCoder:coder]))[self commonConfig];return self;}
- (void)awakeFromNib {[super awakeFromNib];[self commonConfig];}
- (void)commonConfig {self.bordered=NO;self.drawsBackground=NO;self.wantsLayer=YES;self.layer.cornerRadius=6;self.editable=YES;self.selectable=YES;[self updateTextFieldColors];}
- (void)viewDidChangeEffectiveAppearance {[super viewDidChangeEffectiveAppearance];[self updateTextFieldColors];}
- (void)updateTextFieldColors {
    NSAppearance *appearance=self.effectiveAppearance;BOOL dark=NO;
    if(@available(macOS 10.14,*))dark=[appearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua,NSAppearanceNameAqua]]==NSAppearanceNameDarkAqua;
    self.layer.backgroundColor=[(dark?NSColor.whiteColor:NSColor.blackColor) colorWithAlphaComponent:0.08].CGColor;self.needsDisplay=YES;
}
@end
@implementation LCVerticalCenteredTextFieldCell
- (NSRect)drawingRectForBounds:(NSRect)bounds {NSRect result=[super drawingRectForBounds:bounds];NSSize size=[self cellSizeForBounds:bounds];double delta=result.size.height-size.height;if(delta>0){result.origin.y+=delta*0.5;result.size.height-=delta;}return result;}
@end
@implementation LCTableViewScrollView
@synthesize cornerRadius=_cornerRadius,borderWidth=_borderWidth,borderColor=_borderColor,containerBackgroundColor=_containerBackgroundColor,isTransparentBackground=_isTransparentBackground;
- (instancetype)initWithFrame:(NSRect)frame {if((self=[super initWithFrame:frame]))[self commonSetup];return self;}
- (instancetype)initWithCoder:(NSCoder *)coder {if((self=[super initWithCoder:coder]))[self commonSetup];return self;}
- (void)setCornerRadius:(double)value {if(_cornerRadius!=value){_cornerRadius=value;[self updateBorderStyle];}}
- (void)setBorderWidth:(double)value {if(_borderWidth!=value){_borderWidth=value;[self updateBorderStyle];}}
- (void)setBorderColor:(NSColor *)value {if(_borderColor!=value){_borderColor=value;[self updateBorderStyle];}}
- (void)setContainerBackgroundColor:(NSColor *)value {if(_containerBackgroundColor!=value){_containerBackgroundColor=value;[self updateBorderStyle];}}
- (void)setIsTransparentBackground:(BOOL)value {if(_isTransparentBackground!=value){_isTransparentBackground=value;[self updateBorderStyle];}}
- (void)commonSetup {_cornerRadius=16;_borderWidth=1;_borderColor=NSColor.separatorColor;_containerBackgroundColor=NSColor.clearColor;_isTransparentBackground=YES;_darkBackgroundColor=[NSColor colorWithWhite:0 alpha:0.15];_lightBackgroundColor=[NSColor colorWithWhite:1 alpha:0.4];self.wantsLayer=YES;self.borderType=0;self.drawsBackground=NO;}
- (void)layout {[super layout];[self updateBorderStyle];[self fixTableHeaderAppearance];}
- (void)awakeFromNib {[super awakeFromNib];[self updateBorderStyle];}
- (void)viewDidChangeEffectiveAppearance {[super viewDidChangeEffectiveAppearance];[self updateBorderStyle];}
- (BOOL)wantsUpdateLayer {return YES;}
- (void)updateLayer {[super updateLayer];[self updateBorderStyle];}
- (void)delayUpdateStyle {dispatch_async(dispatch_get_main_queue(),^{[self updateBorderStyle];[self.layer displayIfNeeded];});}
- (void)fixTableHeaderAppearance {if([self.documentView isKindOfClass:NSTableView.class]){NSTableView *table=(NSTableView *)self.documentView;table.backgroundColor=NSColor.clearColor;table.headerView.layer.backgroundColor=NSColor.clearColor.CGColor;}}
- (void)updateBorderStyle {
    if(!self.layer)return;CALayer *layer=self.layer;
    if(@available(macOS 11,*))layer.cornerRadius=self.cornerRadius;else layer.cornerRadius=0;
    layer.masksToBounds=YES;layer.borderWidth=self.isTransparentBackground?self.borderWidth:0;
    BOOL dark=[self.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua,NSAppearanceNameAqua]]==NSAppearanceNameDarkAqua;
    layer.backgroundColor=(self.isTransparentBackground?NSColor.clearColor:(dark?self.darkBackgroundColor:self.lightBackgroundColor)).CGColor;
    layer.borderColor=[(dark?NSColor.whiteColor:NSColor.blackColor) colorWithAlphaComponent:0.12].CGColor;[layer displayIfNeeded];
}
@end
