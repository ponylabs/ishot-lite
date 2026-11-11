#import <Cocoa/Cocoa.h>
#import "../CustomView.h"
#import "../CustomScrollView.h"
#import "../PinWindow.h"
#import "../Zoom.h"
// Link-only fixtures for unrelated entry points. These classes are never shipped,
// and tests below never invoke capture, payment, persistence or AppDelegate actions.
@interface Global : NSObject @end
@implementation Global @end
@interface AppDelegate : NSObject @end
@implementation AppDelegate @end
@interface MXClipScreenManager : NSObject @end
@implementation MXClipScreenManager @end
NSMutableArray *IShotGlobal_1001ddcd0;
uint32_t IShotGlobal_1001ddd10;
NSScreen *IShotGlobal_1001dde80;
BOOL IShotGlobal_1001de089, IShotGlobal_1001ddd50, IShotGlobal_1001ddfb8;
double IShotGlobal_1001ddd18, IShotGlobal_1001ddd20, IShotGlobal_1001ddd28, IShotGlobal_1001ddd30;
id IShotGlobal_1001de160;
NSString *IShotGlobal_1001de090;
void IShotFunction_100047ffc(NSString *name) { [NSException raise:@"Unexpected side effect" format:@"%@",name]; }
static void check(BOOL condition,NSString *message) { if (!condition) { NSLog(@"FAIL: %@",message); exit(1); } }
int main(void) { @autoreleasepool {
    [NSApplication sharedApplication];
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSDictionary *previous=[defaults volatileDomainForName:NSArgumentDomain];
    NSMutableDictionary *arguments=[previous mutableCopy];
    [arguments addEntriesFromDictionary:@{@"defaultTransparencyOfPin":@20,@"showButtoninPinWindow":@YES}];
    [defaults setVolatileDomain:arguments forName:NSArgumentDomain];
    PinWindow *window=[[PinWindow alloc] initWithContentRect:NSMakeRect(100,100,240,160) styleMask:0 backing:2 defer:NO];
    window.releasedWhenClosed=NO;
    CustomView *view=[[CustomView alloc] initWithFrame:window.frame];
    NSImage *image=[[NSImage alloc] initWithSize:NSMakeSize(240,160)];
    [image lockFocus]; [NSColor.redColor setFill]; NSRectFill(NSMakeRect(0,0,240,160)); [image unlockFocus];
    view.image=image; window.contentView=view;
    NSDate *deadline=[NSDate dateWithTimeIntervalSinceNow:2];
    while (!view.mapImageView.image && deadline.timeIntervalSinceNow>0)
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.001]];
    check(view.mapScrollView!=nil && view.mapImageView.image!=nil,@"deferred initialization creates real pin hierarchy");
    check(view.imageScale==100 && view.maxImageScale==400,@"initial scale and small image maximum");
    check(fabs(view.imageTransparency-.8f)<.000001,@"default transparency");
    check(view.mapScrollView.enableShadow,@"scroll view shadow initialization");
    NSRect before=window.frame;
    [view scaleImageTo:.5f];
    check(view.imageScale==50 && window.frame.size.width==120 && window.frame.size.height==80,@"explicit half scale");
    check(NSMidX(window.frame)==NSMidX(before) && NSMidY(window.frame)==NSMidY(before),@"explicit scale preserves center");
    check(view.scaleTextField.stringValue.length>0 && view.sliderOfTransparent.frame.origin.x < -800,@"small window controls move offscreen");
    [view.mapScrollView scaleImageTo100:nil];
    check(view.imageScale==100 && window.frame.size.width==240,@"context scale finds exact description-matched view");
    [view.mapScrollView cancelShadow:nil]; check(!view.mapScrollView.enableShadow,@"shadow toggle");
    NSMenu *menu=[view.mapScrollView menuForEvent:nil];
    check(menu.numberOfItems==23,@"complete original context menu count");
    check([menu itemAtIndex:6].separatorItem && ![menu itemAtIndex:7].separatorItem,@"original separator inserted before shadow item");
    view.maxImageScale=100; menu=[view.mapScrollView menuForEvent:nil];
    check([menu itemAtIndex:10].action==NULL,@"200 percent action absent at maximum 100");
    NSBitmapImageRep *rep=[view.mapScrollView unscaledBitmapImageRep:image];
    check(rep.pixelsWide==240 && rep.pixelsHigh==160,@"real bitmap conversion dimensions");
    [view.mapScrollView moveLeftOnePixel:nil]; check(window.frame.origin.x==before.origin.x-1,@"pixel movement");
    NSBitmapImageRep *sourceRep=[NSBitmapImageRep imageRepWithData:view.image.TIFFRepresentation];
    NSInteger sourceWidth=sourceRep.pixelsWide, sourceHeight=sourceRep.pixelsHigh;
    [view changeImage:@"turnLeft"];
    check(view.image.size.width==sourceHeight && view.image.size.height==sourceWidth,@"CoreImage rotation swaps dimensions");
    check(view.originFrame.size.width==160 && view.originFrame.size.height==240,@"rotation swaps original geometry");
    check(window.canBecomeKeyWindow && window.canBecomeMainWindow,@"pin window activation rules");
    [view.mapScrollView closeAll:nil]; check(IShotGlobal_1001ddcd0.count==0,@"close-all clears ownership array");
    [view.scaleTimer invalidate]; [view.transparencyTimer invalidate];
    [NSNotificationCenter.defaultCenter removeObserver:view];
    [defaults setVolatileDomain:previous forName:NSArgumentDomain];
    NSLog(@"Pin behavior tests passed");
} return 0; }
