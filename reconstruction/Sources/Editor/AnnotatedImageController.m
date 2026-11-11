#import "AnnotatedImageController.h"
#import "../MainApplication/AppDelegate.h"
@interface ZoomWindow : NSWindow
@end
@interface Global : NSObject
+ (void)startOCRAtScreenRect:(CGRect)rect;
+ (CGRect)currentScreenNotchRect;
+ (BOOL)checkRect:(CGRect)rect OverlapWithRect:(CGRect)other;
@end
extern CGImageRef IShotCGWindowListCreateImage(CGRect, CGWindowListOption, CGWindowID, CGWindowImageOption) __asm__("_CGWindowListCreateImage");
#import <Carbon/Carbon.h>
#import <math.h>
#import <unistd.h>

// Globals are named by their unslid addresses; shared definitions are integrated separately.
extern NSScreen *IShotGlobal_1001dde80;
extern NSMutableArray *IShotGlobal_1001de050, *IShotGlobal_1001f1a30;
extern NSMutableDictionary *IShotGlobal_1001de058;
extern BOOL IShotGlobal_1001de088, IShotGlobal_1001de099, IShotGlobal_1001de180;
extern BOOL IShotGlobal_1001de0d7, IShotGlobal_1001f1a40, IShotGlobal_1001f1a41, IShotGlobal_1001f1a42;
extern NSMutableDictionary *IShotGlobal_1001de0c8;
extern BOOL IShotGlobal_1001de0d4, IShotGlobal_1001dddf0, IShotGlobal_1001de0d0, IShotGlobal_1001de0d1, IShotGlobal_1001de0c0;
extern CGPoint IShotFunction_10004cdb8(CGPoint, CGPoint, CGPoint, CGPoint, double);
extern BOOL IShotFunction_10004ce78(CGPoint, CGPoint, CGPoint, CGPoint);
extern CGSize IShotFunction_100048504(NSString *, NSFont *);
extern NSFont *IShotFunction_10004cf0c(NSString *, int);
extern NSString *IShotGlobal_1001de090, *IShotGlobal_1001f1a38;
extern BOOL IShotGlobal_1001f1a68;
extern BOOL IShotGlobal_1001dd139, IShotGlobal_1001de184;
extern int IShotGlobal_1001de048;
extern BOOL IShotGlobal_1001ddd50, IShotGlobal_1001ddfb8, IShotGlobal_1001de0c2, IShotGlobal_1001de0d5, IShotGlobal_1001de0d6, IShotGlobal_1001de0d2;
extern uint32_t IShotGlobal_1001f1a44;
extern BOOL IShotGlobal_1001de0c1, IShotGlobal_1001de0c3;
extern int IShotGlobal_1001dd440, IShotGlobal_1001de0b0;
extern NSCursor *IShotGlobal_1001dddf8, *IShotGlobal_1001de0e0;
extern NSArray *IShotGlobal_1001de130;
extern double IShotGlobal_1001f1ad8, IShotGlobal_1001f1ae0;
extern NSString *IShotGlobal_1001dde70, *IShotGlobal_1001f1a90;
extern BOOL IShotGlobal_1001de098;
extern NSTimer *IShotGlobal_1001de0d8;
extern NSWindow *IShotGlobal_1001de0b8;
extern double IShotGlobal_1001f1ae8, IShotGlobal_1001f1af0, IShotGlobal_1001f1af8, IShotGlobal_1001f1b00, IShotGlobal_1001f1ab8, IShotGlobal_1001f1ac0, IShotGlobal_1001f1ac8, IShotGlobal_1001f1ad0, IShotGlobal_1001f1aa8, IShotGlobal_1001f1ab0;
extern NSMutableArray *IShotGlobal_1001dde88, *IShotGlobal_1001de138;
extern BOOL IShotGlobal_1001de0d3, IShotGlobal_1001de089, IShotGlobal_1001f1a48;
extern double IShotGlobal_1001f1a50, IShotGlobal_1001f1a58, IShotGlobal_1001f1a60;
extern BOOL IShotFunction_10004d490(NSEvent *);
extern uint32_t IShotFunction_100048db8(NSString *);
extern double IShotGlobal_1001f1a98, IShotGlobal_1001f1aa0;
extern NSTimer *IShotGlobal_1001de0a0, *IShotGlobal_1001de0a8;
extern AnnotatedImageController *IShotGlobal_1001de160;
extern EventHotKeyRef IShotGlobal_1001f1a70, IShotGlobal_1001f1a78, IShotGlobal_1001f1a80;
extern EventHandlerRef IShotGlobal_1001f1a88;
@interface NSScreen (EditorEvidence)
+ (NSScreen *)currentScreenForMouseLocation;
+ (NSScreen *)deepestScreen;
@end
// Selector declarations only, from AnnotatedImageView runtime metadata.
@interface NSView (EditorViewEvidence)
- (void)mousedown:(id)event;
- (void)mouseup:(id)event;
- (void)undoDraw;
- (void)redoDraw;
- (void)reSetUndo;
@end
static void IShotFunction_1000787cc(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {
    if ([(__bridge NSString *)name isEqualToString:@"com.apple.HIToolbox.endMenuTrackingNotification"] && IShotGlobal_1001de099)
        [IShotGlobal_1001de160 checkMouseIfOnTipsBox];
}
static void IShotFunction_100079980(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {
    if ([(__bridge NSString *)name isEqualToString:@"com.apple.HIToolbox.endMenuTrackingNotification"]) IShotGlobal_1001f1a48 = YES;
}
static OSStatus IShotFunction_100087040(EventHandlerCallRef call, EventRef event, void *context) {
    EventHotKeyID key;
    GetEventParameter(event, 0x2d2d2d2d, 0x686b6964, NULL, 8, NULL, &key);
    switch (key.id) {
        case 0: [IShotGlobal_1001de160 cancelButtonClick:nil]; break;
        case 1: [IShotGlobal_1001de160 saveButtonClick:nil]; break;
        case 2: [IShotGlobal_1001de160 copyToPasteButtonClick:nil]; break;
        case 3: [IShotGlobal_1001de160 saveAsFile]; break;
    }
    return 0;
}
@implementation AnnotatedImageController
#include "AnnotatedImageController-accessors.inc"
- (instancetype)initWithWindow:(NSWindow *)window { // 0x100078760
    self = [super initWithWindow:window];
    if (self) CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), NULL, IShotFunction_1000787cc, CFSTR("com.apple.HIToolbox.endMenuTrackingNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    return self;
}
- (void)setAnnotatedImageViewFrame:(CGRect)frame { // 0x100078820; CGRect argument preserved across screen-frame calls
    CGRect screen = NSScreen.currentScreenForMouseLocation.frame;
    if (IShotGlobal_1001dde80) screen = IShotGlobal_1001dde80.frame;
    [self.window setFrame:screen display:NO];
    [(NSView *)annotatedImageView setFrame:frame];
}
- (void)selectTextFont:(id)sender { // 0x10007a064
    id font = self.popUpButtonTextFont.selectedItem.representedObject ?: @"System default";
    [NSUserDefaults.standardUserDefaults setObject:font forKey:@"fontNameOfText"];
    [NSUserDefaults.standardUserDefaults synchronize];
    [IShotGlobal_1001de058 setObject:font forKey:@"fontName"];
    if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
    [self adjustTextSizeOrFont];
}
- (void)selectNoteFont:(id)sender { // 0x10007a1c0
    id font = self.popUpButtonNoteFont.selectedItem.representedObject ?: @"System default";
    [NSUserDefaults.standardUserDefaults setObject:font forKey:@"fontNameOfNote"];
    [NSUserDefaults.standardUserDefaults synchronize];
    [IShotGlobal_1001de058 setObject:font forKey:@"fontName"];
    if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
    [self adjustTextSizeOrFont];
}
- (void)displayChanged:(NSNotification *)notification { // 0x10007a31c
    if ([notification.name isEqualToString:@"NSWorkspaceActiveDisplayDidChangeNotification"] && IShotGlobal_1001de088 && [self.window.screen isEqual:NSScreen.currentScreenForMouseLocation])
        NSLog(@"WorkSpaceActiveDisplayDidChangeNotification");
}
- (void)ignoresMouseEvents:(BOOL)ignore { self.window.ignoresMouseEvents = ignore; } // 0x10007bb3c
- (void)handleMouseEvent:(NSEvent *)event { // 0x10007bb74
    switch (event.type) {
        case 1: [(NSView *)annotatedImageView mousedown:event]; break;
        case 2: [(NSView *)annotatedImageView mouseup:event]; break;
        case 3: [self.window.contentView rightMouseDown:event]; break;
        case 4: [self.window.contentView rightMouseUp:event]; break;
        case 5: [self mouseMoved:event]; break;
        case 6: [(NSView *)annotatedImageView mouseDragged:event]; break;
        case 7: [self.window.contentView rightMouseDragged:event]; break;
        case 10: [self.window.contentView keyDown:event]; break;
        case 11: [(NSView *)annotatedImageView keyUp:event]; break;
        case 22: [self scrollWheel:event]; break;
        case 25: [self.window.contentView otherMouseDown:event]; break;
        case 26: [self.window.contentView otherMouseUp:event]; break;
        case 27: [self.window.contentView otherMouseDragged:event]; break;
        default: break;
    }
}
- (BOOL)canBecomeKeyWindow { return YES; } // 0x10007bdac
- (BOOL)canBecomeMainWindow { return YES; } // 0x10007bdb4
- (BOOL)windowShouldClose:(id)sender { return YES; } // 0x10007e84c
- (void)keyDown:(id)event { // 0x10007bdbc
    IShotGlobal_1001f1a40 = NO; IShotGlobal_1001f1a41 = NO; IShotGlobal_1001f1a42 = NO;
}
- (void)disableTips { // 0x10007e0c4 and blocks 0x10007e18c, 0x10007e264
    if (IShotGlobal_1001de099) {
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            float alpha = 1.0f;
            double value = 1.0;
            while (YES) {
                usleep(50000);
                float capturedAlpha = alpha;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.openedBoxOfTips.alphaValue = (double)capturedAlpha;
                    if (capturedAlpha < 0.1) {
                        self.openedBoxOfTips.transparent = YES;
                        self.openedBoxOfTips.hidden = YES;
                    }
                });
                if (value < 0.1) break;
                alpha = (float)(value - 0.1);
                value = (double)alpha;
            }
        });
    }
}
- (void)enableUndoButton { self.undoButton.enabled = YES; } // 0x10007e878
- (void)disEnableUndoButton { self.undoButton.enabled = NO; } // 0x10007e8ac
- (void)disEnableScrollScreenShotButton { self.scrollScreenshotButton.enabled = NO; } // 0x10007e8e0
- (void)zoomButtonClick:(id)sender { if (IShotGlobal_1001de180) [self mosaicButtonClick:self]; } // 0x100080118
- (void)hiddenButton { // 0x1000861a8
    self.colorBox.hidden = YES; self.sanjiao.hidden = YES; self.buttonBox.hidden = YES;
}
- (void)unhiddenButton { // 0x100086228
    [self resetButtonBox]; self.buttonBox.hidden = NO;
    if ([IShotGlobal_1001de090 isEqualToString:@""]) return;
    self.colorBox.hidden = NO; self.sanjiao.hidden = NO;
}
- (void)scrollFinished { IShotGlobal_1001de0d7 = NO; } // 0x100087168
- (void)unregisterAllHotKey { // 0x100087100
    if (IShotGlobal_1001f1a70) { UnregisterEventHotKey(IShotGlobal_1001f1a70); IShotGlobal_1001f1a70 = NULL; }
    if (IShotGlobal_1001f1a78) { UnregisterEventHotKey(IShotGlobal_1001f1a78); IShotGlobal_1001f1a78 = NULL; }
    if (IShotGlobal_1001f1a80) { UnregisterEventHotKey(IShotGlobal_1001f1a80); IShotGlobal_1001f1a80 = NULL; }
    if (IShotGlobal_1001f1a88) { RemoveEventHandler(IShotGlobal_1001f1a88); IShotGlobal_1001f1a88 = NULL; }
}
- (double)angleBetweenPoint:(CGPoint)a and:(CGPoint)b { return atan2(a.y - b.y, a.x - b.x); } // 0x100089920
- (double)distanceBetweenPoint:(CGPoint)a and:(CGPoint)b { // 0x100089930
    double x = b.x - a.x, y = b.y - a.y;
    return sqrt(x * x + y * y);
}
- (void)squareButtonClick:(id)sender { // 0x10007f870
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    if ([IShotGlobal_1001f1a38 isEqualToString:@"square"]) return;
    [IShotGlobal_1001de058 removeAllObjects];
    [self adjustColorAndSizeButton:0];
    NSDistributedNotificationCenter *center;
    if ([IShotGlobal_1001f1a38 isEqualToString:@"highlight"]) {
        center = NSDistributedNotificationCenter.defaultCenter;
        [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    } else {
        if (![IShotGlobal_1001f1a38 isEqualToString:@"mosaic"]) return;
        center = NSDistributedNotificationCenter.defaultCenter;
    }
    [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
}
- (void)ellipseButtonClick:(id)sender { // 0x10007fa58
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    if ([IShotGlobal_1001f1a38 isEqualToString:@"ellipse"]) return;
    [IShotGlobal_1001de058 removeAllObjects];
    [self adjustColorAndSizeButton:1];
    NSDistributedNotificationCenter *center;
    if ([IShotGlobal_1001f1a38 isEqualToString:@"highlight"]) {
        center = NSDistributedNotificationCenter.defaultCenter;
        [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    } else {
        if (![IShotGlobal_1001f1a38 isEqualToString:@"mosaic"]) return;
        center = NSDistributedNotificationCenter.defaultCenter;
    }
    [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
}
- (void)lineButtonClick:(id)sender { // 0x10007fc08
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    if ([IShotGlobal_1001f1a38 isEqualToString:@"line"]) return;
    [IShotGlobal_1001de058 removeAllObjects];
    [self adjustColorAndSizeButton:2];
    NSDistributedNotificationCenter *center;
    if ([IShotGlobal_1001f1a38 isEqualToString:@"highlight"]) {
        center = NSDistributedNotificationCenter.defaultCenter;
        [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    } else {
        if (![IShotGlobal_1001f1a38 isEqualToString:@"mosaic"]) return;
        center = NSDistributedNotificationCenter.defaultCenter;
    }
    [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
}
- (void)arrowButtonClick:(id)sender { // 0x10007fdb8
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    if ([IShotGlobal_1001f1a38 isEqualToString:@"arrow"]) return;
    [IShotGlobal_1001de058 removeAllObjects];
    [self adjustColorAndSizeButton:3];
    NSDistributedNotificationCenter *center;
    if ([IShotGlobal_1001f1a38 isEqualToString:@"highlight"]) {
        center = NSDistributedNotificationCenter.defaultCenter;
        [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    } else {
        if (![IShotGlobal_1001f1a38 isEqualToString:@"mosaic"]) return;
        center = NSDistributedNotificationCenter.defaultCenter;
    }
    [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
}
- (void)pencilButtonClick:(id)sender { // 0x10007ff68
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    if ([IShotGlobal_1001f1a38 isEqualToString:@"pencilPen"]) return;
    [IShotGlobal_1001de058 removeAllObjects];
    [self adjustColorAndSizeButton:4];
    NSDistributedNotificationCenter *center;
    if ([IShotGlobal_1001f1a38 isEqualToString:@"highlight"]) {
        center = NSDistributedNotificationCenter.defaultCenter;
        [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    } else {
        if (![IShotGlobal_1001f1a38 isEqualToString:@"mosaic"]) return;
        center = NSDistributedNotificationCenter.defaultCenter;
    }
    [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
}
- (void)textButtonClick:(id)sender { // 0x100080434
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    if ([IShotGlobal_1001f1a38 isEqualToString:@"text"]) return;
    [IShotGlobal_1001de058 removeAllObjects];
    [self adjustColorAndSizeButton:6];
    NSDistributedNotificationCenter *center;
    if ([IShotGlobal_1001f1a38 isEqualToString:@"highlight"]) {
        center = NSDistributedNotificationCenter.defaultCenter;
        [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    } else {
        if (![IShotGlobal_1001f1a38 isEqualToString:@"mosaic"]) return;
        center = NSDistributedNotificationCenter.defaultCenter;
    }
    [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
}
- (void)noteButtonClick:(id)sender { // 0x1000805e4
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    if ([IShotGlobal_1001f1a38 isEqualToString:@"note"]) return;
    [IShotGlobal_1001de058 removeAllObjects];
    [self adjustColorAndSizeButton:7];
    NSDistributedNotificationCenter *center;
    if ([IShotGlobal_1001f1a38 isEqualToString:@"highlight"]) {
        center = NSDistributedNotificationCenter.defaultCenter;
        [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    } else {
        if (![IShotGlobal_1001f1a38 isEqualToString:@"mosaic"]) return;
        center = NSDistributedNotificationCenter.defaultCenter;
    }
    [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
}
- (void)highlightButtonClick:(id)sender { // 0x100080794
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    if (![IShotGlobal_1001f1a38 isEqualToString:@"highlight"]) {
        [IShotGlobal_1001de058 removeAllObjects];
        [self adjustColorAndSizeButton:8];
        if ([IShotGlobal_1001f1a38 isEqualToString:@"mosaic"])
            [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
    }
}
- (id)getFunctionFromNumber:(int)number { // 0x10007e854; literal table 0x1001a9450
    static NSString * const table[] = {@"square", @"ellipse", @"line", @"arrow", @"pencilPen", @"mosaic", @"text", @"note", @"highlight"};
    return number < 9 ? table[number] : @"";
}
- (void)saveAsFile { IShotGlobal_1001de0d4 = YES; [self copyToPasteButtonClick:self]; } // 0x100083630
- (void)undoButton:(id)sender { // 0x100083644
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    [(NSView *)annotatedImageView undoDraw];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
}
- (void)redoButton:(id)sender { // 0x100083740
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    [(NSView *)annotatedImageView redoDraw];
}
- (void)clearButtonClick:(id)sender { if (IShotGlobal_1001de180) [self mapButtonClick:self]; } // 0x1000837a4
- (void)sliderOfSizeSlide:(id)sender { // 0x100084070
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
    [settings setObject:self.sliderOfSize.stringValue forKey:@"size"];
    [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
    [self refreshAllSizeAndDrawRect:IShotGlobal_1001de090];
}
- (BOOL)point:(CGPoint)a andPoint:(CGPoint)b crossWithCyclePoint:(CGPoint)center radius:(float)radius // 0x10008994c
{
  BOOL bVar1;
  BOOL bVar2;
  double dVar3;
  double dVar4;
  double dVar5;
  double dVar6;
  double dVar7;
  double dVar8;
  double dVar9;
  double dVar10;
  double dVar11;
  double dVar12;
  double dVar13;
  double dVar14;
  
  dVar7 = b.y;
  dVar5 = b.x;
  dVar4 = a.y;
  dVar3 = a.x;
  dVar13 = (double)radius;
  dVar11 = center.x - dVar13;
  dVar8 = center.x + dVar13;
  dVar9 = center.y + dVar13;
  dVar10 = dVar5 - dVar3;
  dVar12 = dVar7 - dVar4;
  dVar14 = dVar3 + (dVar10 * (dVar9 - dVar4)) / dVar12;
  bVar1 = false;
  bVar2 = true;
  if (dVar11 <= dVar14) {
    bVar1 = false;
    bVar2 = true;
    if (!isnan(dVar14) && !isnan(dVar8)) {
      bVar1 = dVar14 == dVar8;
      bVar2 = dVar8 <= dVar14;
    }
  }
  if (!bVar2 || bVar1) {
    dVar6 = dVar7;
    dVar14 = dVar4;
    if (dVar7 <= dVar4) {
      dVar6 = dVar4;
      dVar14 = dVar7;
    }
    bVar1 = false;
    bVar2 = true;
    if (dVar14 <= dVar9) {
      bVar1 = false;
      bVar2 = true;
      if (!isnan(dVar9) && !isnan(dVar6)) {
        bVar1 = dVar9 == dVar6;
        bVar2 = dVar6 <= dVar9;
      }
    }
    if (!bVar2 || bVar1) {
      return 1;
    }
  }
  dVar13 = center.y - dVar13;
  dVar14 = dVar3 + (dVar10 * (dVar13 - dVar4)) / dVar12;
  bVar1 = false;
  bVar2 = true;
  if (dVar11 <= dVar14) {
    bVar1 = false;
    bVar2 = true;
    if (!isnan(dVar14) && !isnan(dVar8)) {
      bVar1 = dVar14 == dVar8;
      bVar2 = dVar8 <= dVar14;
    }
  }
  if (!bVar2 || bVar1) {
    dVar6 = dVar7;
    dVar14 = dVar4;
    if (dVar7 <= dVar4) {
      dVar6 = dVar4;
      dVar14 = dVar7;
    }
    if ((dVar14 <= dVar13) && (dVar13 <= dVar6)) {
      return 1;
    }
  }
  dVar7 = dVar4 + (dVar12 * (dVar11 - dVar3)) / dVar10;
  bVar1 = false;
  bVar2 = true;
  if (dVar13 <= dVar7) {
    bVar1 = false;
    bVar2 = true;
    if (!isnan(dVar7) && !isnan(dVar9)) {
      bVar1 = dVar7 == dVar9;
      bVar2 = dVar9 <= dVar7;
    }
  }
  if (!bVar2 || bVar1) {
    dVar14 = dVar5;
    dVar7 = dVar3;
    if (dVar5 <= dVar3) {
      dVar14 = dVar3;
      dVar7 = dVar5;
    }
    if ((dVar7 <= dVar11) && (dVar11 <= dVar14)) {
      return 1;
    }
  }
  dVar4 = dVar4 + (dVar12 * (dVar8 - dVar3)) / dVar10;
  bVar1 = false;
  bVar2 = true;
  if (dVar13 <= dVar4) {
    bVar1 = false;
    bVar2 = true;
    if (!isnan(dVar4) && !isnan(dVar9)) {
      bVar1 = dVar4 == dVar9;
      bVar2 = dVar9 <= dVar4;
    }
  }
  if (!bVar2 || bVar1) {
    dVar4 = dVar5;
    if (dVar5 <= dVar3) {
      dVar4 = dVar3;
      dVar3 = dVar5;
    }
    if ((dVar3 <= dVar8) && (dVar8 <= dVar4)) {
      return 1;
    }
  }
  return 0;
}

- (void)selectColor1ButtonClick:(id)sender { // 0x1000852c8
    NSColor *color = self.colorBox1.fillColor;
    [self getActivedColorBox:color];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
    [settings setObject:@1 forKey:@"colorList"];
    [settings setObject:data forKey:@"color"];
    [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
    [self refreshAllSizeAndDrawRect:IShotGlobal_1001de090];
}
- (void)selectColor2ButtonClick:(id)sender { // 0x100085410
    NSColor *color = self.colorBox2.fillColor;
    [self getActivedColorBox:color];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
    [settings setObject:@2 forKey:@"colorList"];
    [settings setObject:data forKey:@"color"];
    [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
    [self refreshAllSizeAndDrawRect:IShotGlobal_1001de090];
}
- (void)selectColor3ButtonClick:(id)sender { // 0x100085558
    NSColor *color = self.colorBox3.fillColor;
    [self getActivedColorBox:color];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
    [settings setObject:@3 forKey:@"colorList"];
    [settings setObject:data forKey:@"color"];
    [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
    [self refreshAllSizeAndDrawRect:IShotGlobal_1001de090];
}
- (void)selectColor4ButtonClick:(id)sender { // 0x1000856a0
    NSColor *color = self.colorBox4.fillColor;
    [self getActivedColorBox:color];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
    [settings setObject:@4 forKey:@"colorList"];
    [settings setObject:data forKey:@"color"];
    [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
    [self refreshAllSizeAndDrawRect:IShotGlobal_1001de090];
}
- (void)selectColor5ButtonClick:(id)sender { // 0x1000857e8
    NSColor *color = self.colorBox5.fillColor;
    [self getActivedColorBox:color];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
    [settings setObject:@5 forKey:@"colorList"];
    [settings setObject:data forKey:@"color"];
    [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
    [self refreshAllSizeAndDrawRect:IShotGlobal_1001de090];
}
- (void)selectColor6ButtonClick:(id)sender { // 0x100085930
    NSData *data = [NSUserDefaults.standardUserDefaults dictionaryForKey:@"DataOfUsers"][IShotGlobal_1001de090][@"userColor"];
    if (data) {
        [self getActivedColorBox:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
        [settings setObject:@6 forKey:@"colorList"];
        [settings setObject:data forKey:@"color"];
        [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
        [self refreshAllSizeAndDrawRect:IShotGlobal_1001de090];
    }
}
- (void)getActivedColorBox:(NSColor *)color { // 0x100085acc
    NSArray *boxes = [NSArray arrayWithObjects:self.colorBox1, self.colorBox2, self.colorBox3, self.colorBox4, self.colorBox5, self.userColorSingleBox, nil];
    for (NSBox *box in boxes) {
        NSColor *border;
        if ([box.fillColor isEqualTo:color])
            border = [self.window.effectiveAppearance.name isEqualToString:@"NSAppearanceNameDarkAqua"] ? NSColor.whiteColor : NSColor.grayColor;
        else border = NSColor.clearColor;
        box.borderColor = border;
    }
}
- (void)showPicker:(id)sender { // 0x100086be4
    [NSColorPanel.sharedColorPanel setContinuous:YES];
    [NSColorPanel.sharedColorPanel setShowsAlpha:YES];
    [NSColorPanel.sharedColorPanel setTarget:self];
    [NSColorPanel.sharedColorPanel setAction:@selector(colorChanged:)];
    [NSColorPanel.sharedColorPanel.contentView.window setLevel:0x7fffffef];
    [NSColorPanel.sharedColorPanel makeKeyAndOrderFront:self];
}
- (void)colorChanged:(id)sender { // 0x100086d20
    NSColor *color = NSColorPanel.sharedColorPanel.color;
    if (color) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
        if (data) {
            self.userColorSingleBox.fillColor = color;
            NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
            [settings setObject:data forKey:@"userColor"];
            [settings setObject:data forKey:@"color"];
            [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
            [self refreshAllSizeAndDrawRect:IShotGlobal_1001de090];
            [NSUserDefaults.standardUserDefaults setObject:IShotGlobal_1001de0c8 forKey:@"DataOfUsers"];
            [NSUserDefaults.standardUserDefaults synchronize];
        }
    }
}
- (void)adjustTextSizeOrFont { // 0x100082694; CGFloat return registers verified against ARM64 assembly
    NSTextView *view = IShotGlobal_1001de058[@"textView"];
    NSString *text = view.string;
    int size = [IShotGlobal_1001de058[@"size"] intValue];
    NSFont *font = IShotFunction_10004cf0c(IShotGlobal_1001de058[@"fontName"], size);
    view.font = font;
    CGSize measured = IShotFunction_100048504(text, font);
    NSScrollView *scrollView = IShotGlobal_1001de058[@"scrollView"];
    CGRect frame = scrollView.frame;
    frame.size.width = measured.width + 2.0;
    frame.size.height = measured.height;
    scrollView.frame = frame;
    [(NSView *)annotatedImageView setNeedsDisplay:YES];
    self.displaySize.intValue = size;
    self.sliderOfSize.intValue = size;
}
- (void)copyToPasteButtonClick:(id)sender { // 0x100083e0c
    if ([IShotGlobal_1001de090 isEqualToString:@"text"] || [IShotGlobal_1001de090 isEqualToString:@"note"])
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"disableTextView" object:nil userInfo:nil];
    IShotGlobal_1001dddf0 = NO;
    [self hiddenButton];
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    IShotGlobal_1001de0d0 = YES;
    IShotGlobal_1001de0d1 = YES;
    if (!IShotGlobal_1001de0c0) {
        [IShotGlobal_1001de058 removeAllObjects];
        [(NSView *)annotatedImageView setNeedsDisplay:YES];
        NSDistributedNotificationCenter *center = NSDistributedNotificationCenter.defaultCenter;
        [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
        [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    }
    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"StartScreenShots" object:nil userInfo:nil];
}
- (void)sliderOfOpacitySlide:(id)sender { // 0x10008414c
    if (IShotGlobal_1001de058[@"type"]) {
        [IShotGlobal_1001de050 removeObject:IShotGlobal_1001de058];
        float alpha = (float)self.sliderOfOpacity.intValue / 100.0f;
        [IShotGlobal_1001de058 setObject:@(alpha) forKey:@"colorAlpha"];
        if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
        NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
        [settings setObject:@(alpha) forKey:@"colorAlpha"];
        [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
        unsigned type = [IShotGlobal_1001de058[@"type"] intValue];
        if (type == 8) {
            [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
        } else if ((type & 0xfffffffeU) == 6) {
            NSTextView *text = IShotGlobal_1001de058[@"textView"];
            NSColor *color = [text.textColor colorWithAlphaComponent:(double)alpha];
            text.textColor = color;
            text.insertionPointColor = [color colorWithAlphaComponent:1.0];
        } else [(NSView *)annotatedImageView setNeedsDisplay:YES];
    }
    self.displayOpacity.intValue = self.sliderOfOpacity.intValue;
}
- (void)cancelButtonClick:(id)sender { // 0x100083198; block 0x1000832c4
    IShotGlobal_1001dddf0 = NO;
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    IShotGlobal_1001de180 = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100000000), dispatch_get_main_queue(), ^{
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"cancelScreenShot" object:nil userInfo:nil];
    });
}
- (void)scrollScreenshotErrorWarnButtonClick:(id)sender { // 0x100084020; block 0x100084064
    dispatch_async(dispatch_get_main_queue(), ^{ system("open https://www.better365.cn/ishot/scrollscreenshot.html"); });
    [self cancelButtonClick:nil];
}
- (void)squareButtonState { // 0x1000808fc
    IShotGlobal_1001de0d3 = YES;
    self.boxSelectMosaic.hidden = YES;
    self.boxSelectHighlight.hidden = YES;
    IShotGlobal_1001de090 = @"square";
    [self refreshAllButtonState];
    IShotGlobal_1001f1a38 = IShotGlobal_1001de090;
    self.sanjiao.hidden = NO;
    self.colorBox.hidden = NO;
    [self.sanjiao setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + self.squareButton.frame.origin.x, IShotGlobal_1001f1aa0 - 15.0)];
    [self.colorBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + 0.0, IShotGlobal_1001f1aa0 - 50.0)];
    CGRect frame = self.colorBox.frame;
    frame.size.width = [[NSLocale.preferredLanguages objectAtIndex:0] rangeOfString:@"zh"].location == NSNotFound ? 242.0 : 233.0;
    self.colorBox.frame = frame;
    self.boxSquare2.hidden = NO;
    self.boxEllipse2.hidden = YES;
    self.boxArrow2.hidden = YES;
    self.boxPencil2.hidden = YES;
    self.boxText2.hidden = YES;
    self.boxNote2.hidden = YES;
    if (IShotGlobal_1001de058[@"enableRoundOfSquare"]) [NSUserDefaults.standardUserDefaults setBool:[IShotGlobal_1001de058[@"enableRoundOfSquare"] boolValue] forKey:@"enableRoundOfSquare"];
    if (IShotGlobal_1001de058[@"filledOfSquare"]) [NSUserDefaults.standardUserDefaults setBool:[IShotGlobal_1001de058[@"filledOfSquare"] boolValue] forKey:@"filledOfSquare"];
}
- (void)ellipseButtonState { // 0x100080d2c
    IShotGlobal_1001de0d3 = YES;
    self.boxSelectMosaic.hidden = YES;
    self.boxSelectHighlight.hidden = YES;
    IShotGlobal_1001de090 = @"ellipse";
    [self refreshAllButtonState];
    IShotGlobal_1001f1a38 = IShotGlobal_1001de090;
    self.sanjiao.hidden = NO;
    self.colorBox.hidden = NO;
    [self.sanjiao setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + self.ellipseButton.frame.origin.x, IShotGlobal_1001f1aa0 - 15.0)];
    [self.colorBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + 0.0, IShotGlobal_1001f1aa0 - 50.0)];
    CGRect frame = self.colorBox.frame;
    frame.size.width = [[NSLocale.preferredLanguages objectAtIndex:0] rangeOfString:@"zh"].location == NSNotFound ? 235.0 : 233.0;
    self.colorBox.frame = frame;
    self.boxSquare2.hidden = YES;
    self.boxEllipse2.hidden = NO;
    self.boxArrow2.hidden = YES;
    self.boxPencil2.hidden = YES;
    self.boxText2.hidden = YES;
    self.boxNote2.hidden = YES;
    if (IShotGlobal_1001de058[@"filledOfEllipse"]) [NSUserDefaults.standardUserDefaults setBool:[IShotGlobal_1001de058[@"filledOfEllipse"] boolValue] forKey:@"filledOfEllipse"];
}
- (void)lineButtonState { // 0x1000810e0
    IShotGlobal_1001de0d3 = YES;
    self.boxSelectMosaic.hidden = YES;
    self.boxSelectHighlight.hidden = YES;
    IShotGlobal_1001de090 = @"line";
    [self refreshAllButtonState];
    IShotGlobal_1001f1a38 = IShotGlobal_1001de090;
    self.sanjiao.hidden = NO;
    self.colorBox.hidden = NO;
    [self.sanjiao setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + self.lineButton.frame.origin.x, IShotGlobal_1001f1aa0 - 15.0)];
    [self.colorBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + 0.0, IShotGlobal_1001f1aa0 - 50.0)];
    CGRect frame = self.colorBox.frame;
    frame.size.width = 178.0;
    self.colorBox.frame = frame;
}
- (void)arrowButtonState { // 0x1000812d4
    IShotGlobal_1001de0d3 = YES;
    self.boxSelectMosaic.hidden = YES;
    self.boxSelectHighlight.hidden = YES;
    IShotGlobal_1001de090 = @"arrow";
    [self refreshAllButtonState];
    IShotGlobal_1001f1a38 = IShotGlobal_1001de090;
    self.sanjiao.hidden = NO;
    self.colorBox.hidden = NO;
    [self.sanjiao setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + self.arrowButton.frame.origin.x, IShotGlobal_1001f1aa0 - 15.0)];
    [self.colorBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + 0.0, IShotGlobal_1001f1aa0 - 50.0)];
    CGRect frame = self.colorBox.frame;
    frame.size.width = [[NSLocale.preferredLanguages objectAtIndex:0] rangeOfString:@"zh"].location == NSNotFound ? 280.0 : 255.0;
    self.colorBox.frame = frame;
    self.boxSquare2.hidden = YES;
    self.boxEllipse2.hidden = YES;
    self.boxArrow2.hidden = NO;
    self.boxPencil2.hidden = YES;
    self.boxText2.hidden = YES;
    self.boxNote2.hidden = YES;
}
- (void)pencilPenButtonState { // 0x100081600
    IShotGlobal_1001de0d3 = YES;
    self.boxSelectMosaic.hidden = YES;
    self.boxSelectHighlight.hidden = YES;
    IShotGlobal_1001de090 = @"pencilPen";
    [self refreshAllButtonState];
    IShotGlobal_1001f1a38 = IShotGlobal_1001de090;
    self.sanjiao.hidden = NO;
    self.colorBox.hidden = NO;
    [self.sanjiao setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + self.pencilPenButton.frame.origin.x, IShotGlobal_1001f1aa0 - 15.0)];
    [self.colorBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + 64.0 - 40.0 + (IShotGlobal_1001de180 ? 40.0 : 0.0), IShotGlobal_1001f1aa0 - 50.0)];
    CGRect frame = self.colorBox.frame;
    frame.size.width = IShotGlobal_1001de180 ? 178.0 : 264.0;
    self.colorBox.frame = frame;
    self.boxSquare2.hidden = YES;
    self.boxEllipse2.hidden = YES;
    self.boxArrow2.hidden = YES;
    self.boxPencil2.hidden = NO;
    self.boxText2.hidden = YES;
    self.boxNote2.hidden = YES;
}
- (void)textButtonState { // 0x100081be8
    IShotGlobal_1001de0d3 = YES;
    self.boxSelectMosaic.hidden = YES;
    self.boxSelectHighlight.hidden = YES;
    IShotGlobal_1001de090 = @"text";
    [self refreshAllButtonState];
    IShotGlobal_1001f1a38 = IShotGlobal_1001de090;
    self.sanjiao.hidden = NO;
    self.colorBox.hidden = NO;
    [self.sanjiao setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + self.textButton.frame.origin.x, IShotGlobal_1001f1aa0 - 15.0)];
    [self.colorBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + 72.0, IShotGlobal_1001f1aa0 - 50.0)];
    CGRect frame = self.colorBox.frame;
    frame.size.width = 288.0;
    self.colorBox.frame = frame;
    self.boxSquare2.hidden = YES;
    self.boxEllipse2.hidden = YES;
    self.boxArrow2.hidden = YES;
    self.boxPencil2.hidden = YES;
    self.boxText2.hidden = NO;
    self.boxNote2.hidden = YES;
    if (IShotGlobal_1001de058[@"typeIndexOfText"]) [NSUserDefaults.standardUserDefaults setInteger:[IShotGlobal_1001de058[@"typeIndexOfText"] integerValue] forKey:@"typeIndexOfText"];
    if (IShotGlobal_1001de058[@"colorIndexOfText"]) [NSUserDefaults.standardUserDefaults setInteger:[IShotGlobal_1001de058[@"colorIndexOfText"] integerValue] forKey:@"colorIndexOfText"];
}
- (void)noteButtonState { // 0x100081fec
    IShotGlobal_1001de0d3 = YES;
    self.boxSelectMosaic.hidden = YES;
    self.boxSelectHighlight.hidden = YES;
    IShotGlobal_1001de090 = @"note";
    [self refreshAllButtonState];
    IShotGlobal_1001f1a38 = IShotGlobal_1001de090;
    self.sanjiao.hidden = NO;
    self.colorBox.hidden = NO;
    [self.sanjiao setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + self.noteButton.frame.origin.x, IShotGlobal_1001f1aa0 - 15.0)];
    [self.colorBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + 104.0, IShotGlobal_1001f1aa0 - 50.0)];
    CGRect frame = self.colorBox.frame;
    frame.size.width = 288.0;
    self.colorBox.frame = frame;
    self.boxSquare2.hidden = YES;
    self.boxEllipse2.hidden = YES;
    self.boxArrow2.hidden = YES;
    self.boxPencil2.hidden = YES;
    self.boxText2.hidden = YES;
    self.boxNote2.hidden = NO;
    if (IShotGlobal_1001de058[@"typeIndexOfNote"]) [NSUserDefaults.standardUserDefaults setInteger:[IShotGlobal_1001de058[@"typeIndexOfNote"] integerValue] forKey:@"typeIndexOfNote"];
    if (IShotGlobal_1001de058[@"colorIndexOfNote"]) [NSUserDefaults.standardUserDefaults setInteger:[IShotGlobal_1001de058[@"colorIndexOfNote"] integerValue] forKey:@"colorIndexOfNote"];
}
- (void)highlightButtonState { // 0x1000823f0
    IShotGlobal_1001de0d3 = YES;
    self.boxSelectMosaic.hidden = YES;
    self.boxSelectHighlight.hidden = NO;
    IShotGlobal_1001de090 = @"highlight";
    [self refreshAllButtonState];
    IShotGlobal_1001f1a38 = IShotGlobal_1001de090;
    self.sanjiao.hidden = NO;
    self.colorBox.hidden = NO;
    [self.sanjiao setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + self.highlightButton.frame.origin.x, IShotGlobal_1001f1aa0 - 15.0)];
    [self.colorBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + 182.0, IShotGlobal_1001f1aa0 - 50.0)];
    CGRect frame = self.colorBox.frame;
    frame.size.width = 178.0;
    self.colorBox.frame = frame;
    if (IShotGlobal_1001de058.count) [NSUserDefaults.standardUserDefaults setBool:YES forKey:[IShotGlobal_1001de058[@"squareOfHighlight"] boolValue] ? @"squareOfHighlight" : @"ellipseOfHighlight"];
}
- (void)mosaicButtonState { // 0x100081910
    IShotGlobal_1001de0d3 = YES;
    self.boxSelectMosaic.hidden = NO;
    self.boxSelectHighlight.hidden = YES;
    IShotGlobal_1001de090 = IShotGlobal_1001de180 ? @"zoom" : @"mosaic";
    [self refreshAllButtonState];
    IShotGlobal_1001f1a38 = IShotGlobal_1001de090;
    [self.sanjiao setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + self.mosaicButton.frame.origin.x, IShotGlobal_1001f1aa0 - 15.0)];
    BOOL zoom = IShotGlobal_1001de180;
    [self.colorBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98 + 96.0 - 7.0 + (zoom ? 37.0 : 0.0), IShotGlobal_1001f1aa0 - 50.0)];
    CGRect frame = self.colorBox.frame;
    self.sanjiao.hidden = zoom;
    self.colorBox.hidden = zoom;
    frame.size.width = zoom ? 104.0 : 178.0;
    self.colorBox.frame = frame;
}

#include "AnnotatedImageController-events.inc"
#include "AnnotatedImageController-startup.inc"
@end
