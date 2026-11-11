#import <Cocoa/Cocoa.h>
#import <math.h>
#import <assert.h>
// This test double captures geometry and suppresses selection handles to isolate drawing.
// It is not included in the application; all eleven method bodies below are production includes.
@interface DrawingProbe : NSView
@property NSRect capturedRect;
@property double capturedRadius;
- (id)makeBubble:(id)unused withBubbleRect:(NSRect)rect cornerRight:(double)right cornerLeft:(double)left;
- (NSArray *)_calculateAllNeededHandleSquareRects:(NSRect)rect;
- (double)angleBetweenPoint:(CGPoint)a and:(CGPoint)b;
- (double)distanceBetweenPoint:(CGPoint)a and:(CGPoint)b;
- (CGPoint)getPointFrom:(CGPoint)p to:(CGRect)rect;
@end
#define AnnotatedImageView DrawingProbe
#include "../AnnotatedImageView-drawing-globals.inc"
#undef AnnotatedImageView
NSMutableDictionary *IShotGlobal_1001de058;
@implementation DrawingProbe
- (id)makeBubble:(id)unused withBubbleRect:(NSRect)rect cornerRight:(double)right cornerLeft:(double)left { self.capturedRect=rect; self.capturedRadius=right; return [NSBezierPath bezierPathWithRoundedRect:rect xRadius:left yRadius:right]; }
- (NSArray *)_calculateAllNeededHandleSquareRects:(NSRect)rect { return @[]; }
- (double)angleBetweenPoint:(CGPoint)a and:(CGPoint)b { return atan2(a.y-b.y,a.x-b.x); }
- (double)distanceBetweenPoint:(CGPoint)a and:(CGPoint)b { return hypot(a.x-b.x,a.y-b.y); }
- (CGPoint)getPointFrom:(CGPoint)p to:(CGRect)rect { assert(!"Not exercised by this test"); return p; }
#include "../AnnotatedImageView-drawing.inc"
@end
int main(void) { @autoreleasepool {
    [NSApplication sharedApplication];
    DrawingProbe *view=[[DrawingProbe alloc] initWithFrame:NSMakeRect(.25,.25,128,128)];
    NSDictionary *large=@{@"X1":@16777217,@"Y1":@20,@"X2":@16777220,@"Y2":@30};
    IShotDrawingCoordinates p=IShotDrawingGetCoordinates(view,large);
    assert(p.x1==16777216.f && p.x2==16777220.f && p.y1==19.75f);
    NSColor *zero=IShotDrawingColor(NSColor.redColor,@{@"colorAlpha":@0}); assert(zero.alphaComponent==(double).01f);
    view.frame=NSMakeRect(10,20,128,128);
    NSBitmapImageRep *rep=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:128 pixelsHigh:128 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    [NSGraphicsContext saveGraphicsState]; [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    NSMutableDictionary *stroke=[@{@"color":NSColor.redColor,@"X1":@20,@"Y1":@30,@"X2":@50,@"Y2":@60,@"size":@2,@"enableRoundOfSquare":@1,@"filledOfSquare":@YES,@"filledOfEllipse":@YES} mutableCopy];
    [view drawAllSquare:stroke]; assert(NSEqualRects(view.capturedRect,NSMakeRect(10,10,30,30)) && view.capturedRadius==8);
    stroke[@"X1"]=@50;stroke[@"X2"]=@20;stroke[@"Y1"]=@60;stroke[@"Y2"]=@30;
    [view drawSquareOfCurrentStroke:stroke]; assert(NSEqualRects(view.capturedRect,NSMakeRect(10,10,30,30)));
    stroke[@"X1"]=@20;stroke[@"X2"]=@50;stroke[@"Y1"]=@30;stroke[@"Y2"]=@60;
    [view drawAllEllipse:stroke]; [view drawEllipseOfCurrentStroke:stroke];
    stroke[@"allPoints"]=@[[NSValue valueWithPoint:NSMakePoint(30,40)],[NSValue valueWithPoint:NSMakePoint(60,70)]];
    [view drawAllPencilPen:stroke]; [view drawPencilPenOfCurrentStroke:stroke];
    stroke[@"type"]=@2; [view drawAllLine:stroke]; [view drawLineOfCurrentStroke:stroke];
    stroke[@"type"]=@3;stroke[@"normalTypeOfArrow"]=@"1";stroke[@"controlPoint1"]=NSStringFromPoint(NSMakePoint(25,40));stroke[@"controlPoint2"]=NSStringFromPoint(NSMakePoint(45,55));
    [view drawAllLine:stroke]; [view drawLineOfCurrentStroke:stroke];
    [NSGraphicsContext restoreGraphicsState];
    NSUInteger nonzero=0; for(NSInteger y=0;y<128;y++)for(NSInteger x=0;x<128;x++)if([rep colorAtX:x y:y].alphaComponent>0)nonzero++;
    assert(nonzero>100 && nonzero<4096);
    puts("Drawing tests passed: float rounding, zero-alpha floor, normalized current square, ellipse, pencil, straight line, curved arrow, nonempty bitmap; test doubles only in this executable");
} return 0; }
