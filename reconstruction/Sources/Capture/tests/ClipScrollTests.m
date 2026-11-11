// Synthetic CGImage capture and screen fixture. No screen acquisition or event posting.
#import "../MXClipView.h"
#import "../../Editor/AnnotatedImageController.h"
#import "../../Global/Global.h"
#import "../../Imaging/Imaging.h"
#import <ApplicationServices/ApplicationServices.h>
#include <assert.h>
AnnotatedImageController *IShotGlobal_1001de160;
#include "../MXClipView-scroll-support.inc"
BOOL IShotGlobal_1001dddf0,IShotGlobal_1001de088,IShotGlobal_1001de0c0,IShotGlobal_1001dde24,IShotGlobal_1001ddf58,IShotGlobal_1001ddf60;
NSCursor *IShotGlobal_1001dddf8;
double IShotGlobal_1001dde00,IShotGlobal_1001dde08,IShotGlobal_1001dde10,IShotGlobal_1001dde18,IShotGlobal_1001ddee8,IShotGlobal_1001ddef0,IShotGlobal_1001ddef8,IShotGlobal_1001ddf00;
float IShotGlobal_1001dde20,IShotGlobal_1001ddf48;
uint32_t IShotGlobal_1001ddd10;
int32_t IShotGlobal_1001dde58,IShotGlobal_1001dde5c,IShotGlobal_1001dde60,IShotGlobal_1001dde64,IShotGlobal_1001ddf08,IShotGlobal_1001ddf0c,IShotGlobal_1001ddf30,IShotGlobal_1001ddf34,IShotGlobal_1001ddf38,IShotGlobal_1001ddf3c,IShotGlobal_1001ddf4c,IShotGlobal_1001ddf5c;
NSMutableArray *IShotGlobal_1001dde28,*IShotGlobal_1001dde30;
NSArray *IShotGlobal_1001dde48,*IShotGlobal_1001dde50,*IShotGlobal_1001ddf20,*IShotGlobal_1001ddf28;
NSImageView *IShotGlobal_1001dde38,*IShotGlobal_1001ddf40;
NSView *IShotGlobal_1001dde40;
NSImage *IShotGlobal_1001ddf10,*IShotGlobal_1001ddf18,*IShotGlobal_1001ddf50;
NSTimer *IShotGlobal_1001ddee0;
NSString *IShotGlobal_1001ddd48;
static NSRect capturedArea;
CGImageRef IShotCGWindowListCreateImage(CGRect area,CGWindowListOption option,CGWindowID window,CGWindowImageOption flags) {
    assert(option==8 && window==42 && flags==0); capturedArea=area;
    CGColorSpaceRef color=CGColorSpaceCreateDeviceRGB();
    CGContextRef context=CGBitmapContextCreate(NULL,300,200,8,1200,color,(CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextSetRGBFillColor(context,0.2,0.4,0.6,1); CGContextFillRect(context,CGRectMake(0,0,300,200));
    CGImageRef image=CGBitmapContextCreateImage(context); CGContextRelease(context); CGColorSpaceRelease(color); return image;
}
@interface ScrollScreenFixture : NSObject
@end
@implementation ScrollScreenFixture
- (double)backingScaleFactor { return 2; }
- (NSRect)frame { return NSMakeRect(0,0,800,600); }
@end
@implementation NSScreen (ScrollTestScreen)
+ (id)currentScreenForMouseLocation { return [ScrollScreenFixture new]; }
@end
@implementation Global
+ (BOOL)checkIfSameColorFromImageRef:(CGImageRef)image { assert(image); return NO; }
@end
@implementation MXClipView
#include "../MXClipView-scroll.inc"
@end
int main(void) {
    @autoreleasepool {
        MXClipView *view=[[MXClipView alloc] initWithFrame:NSMakeRect(0,0,800,600)]; view.contentRect=NSMakeRect(300,100,150,100);
        IShotGlobal_1001dde00=300; IShotGlobal_1001dde08=400; IShotGlobal_1001dde10=150; IShotGlobal_1001dde18=100; IShotGlobal_1001ddd10=42;
        IShotGlobal_1001dde28=[NSMutableArray new]; IShotGlobal_1001dde30=[NSMutableArray new]; IShotGlobal_1001dde38=[NSImageView new]; IShotGlobal_1001dde40=[NSView new];
        IShotGlobal_1001f18c6=YES; [view screenShotsAtScrollScreenshots];
        assert(NSEqualRects(capturedArea,NSMakeRect(300,400,150,100)));
        assert(IShotGlobal_1001ddf20.count==200 && IShotGlobal_1001ddf28.count==300);
        assert(NSEqualSizes(IShotGlobal_1001ddf10.size,NSMakeSize(300,200)));
        assert(NSEqualRects(IShotGlobal_1001dde40.frame,NSMakeRect(460,100,150,100)));
        assert(IShotGlobal_1001f18c6 && !IShotGlobal_1001f18c1);
        IShotGlobal_1001f18c7=YES; [view screenShotsAtScrollScreenshots]; assert(IShotGlobal_1001dde50.count==200);
        NSArray *cached=IShotGlobal_1001dde50; [view screenShotsAtScrollScreenshots]; assert(IShotGlobal_1001dde50==cached);
        [IShotGlobal_1001dde28 addObject:@40]; [IShotGlobal_1001dde30 addObject:[NSImageView new]];
        [view redrawScrollView]; assert(NSEqualRects(IShotGlobal_1001dde40.frame,NSMakeRect(0,0,150,120)));
        assert(NSEqualRects(IShotGlobal_1001dde38.frame,NSMakeRect(0,20,150,100)));
        NSLog(@"ClipScrollTests passed");
    }
}
