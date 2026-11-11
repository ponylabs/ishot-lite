#import "../GKCropBorderView.m"
#include <assert.h>
// Isolated link fixtures only. This test never calls the image-boundary helper.
@implementation Global
+ (CGRect)calcuateRealRectFromNSImage:(id)image withOriginalRect:(CGRect)rect { abort(); }
@end
NSCursor *IShotGlobal_1001ddf98;
uint64_t IShotGlobal_1001de070;
BOOL IShotGlobal_1001ddfd0;
NSCursor *IShotGlobal_1001dddf8;
BOOL IShotGlobal_1001de098, IShotGlobal_1001de0c0, IShotGlobal_1001de180, IShotGlobal_1001de0d0, IShotGlobal_1001de0d5;
NSMutableDictionary *IShotGlobal_1001de058, *IShotGlobal_1001de0c8;
NSMutableArray *IShotGlobal_1001de050, *IShotGlobal_1001de138;
int IShotGlobal_1001de048;
BOOL IShotGlobal_1001de088, IShotGlobal_1001de210, IShotGlobal_1001de0c3, IShotGlobal_1001dde91, IShotGlobal_1001ddfd1;
NSString *IShotGlobal_1001de090, *IShotGlobal_1001dde70, *IShotGlobal_1001ddde8, *IShotGlobal_1001dde78;
NSCursor *IShotGlobal_1001ddf88, *IShotGlobal_1001ddf90, *IShotGlobal_1001de0e0;
NSWindow *IShotGlobal_1001de0b8;
int IShotGlobal_1001dd0d0, IShotGlobal_1001dd0d4;
static NSMutableDictionary *stroke(int type,int list) {
    return [@{@"type":@(type),@"list":@(list),@"X1":@30,@"Y1":@40,@"X2":@130,@"Y2":@140,@"size":@2} mutableCopy];
}
int main(void) { @autoreleasepool {
    [NSApplication sharedApplication];
    GKCropBorderView *view=[[GKCropBorderView alloc] initWithFrame:NSMakeRect(10,20,200,160)];
    assert(view.trackingAreas.count==9);
    NSArray *handles=[view _calculateAllNeededHandleTrackRects:view.frame];
    assert(NSEqualRects([handles[0] CGRectValue],NSMakeRect(13,13,176,134)));
    assert([view _calculateMouseIsOnCropBorderViewWithPoint:NSMakePoint(80,80)]==0);
    assert([view _calculateMouseIsOnCropBorderViewWithPoint:NSMakePoint(15,25)]==1);
    assert([view _calculateMouseIsOnCropBorderViewWithPoint:NSMakePoint(205,175)]==5);
    assert([view _calculateMouseIsOnCropBorderViewWithPoint:NSMakePoint(-1,-1)]==9);
    IShotGlobal_1001de058=stroke(5,1);
    NSArray *squares=[view _calculateAllNeededHandleSquareRects:NSMakeRect(30,40,100,80)];
    assert(squares.count==18 && NSEqualRects([squares[12] CGRectValue],[squares[13] CGRectValue]));
    assert([view _calculateMouseIsOnActivedResizeRectWithPoint:NSMakePoint(30,40)] && IShotGlobal_1001de070==1);
    assert([view _calculateMouseIsOnActivedResizeRectWithPoint:NSMakePoint(130,90)] && IShotGlobal_1001de070==4);
    IShotGlobal_1001de050=[NSMutableArray arrayWithObject:stroke(0,1)];
    assert([view isOnStrokesUnderMouse:NSMakePoint(30,90)]!=nil);
    assert([view isOnStrokesUnderMouse:NSMakePoint(80,90)]==nil);
    [IShotGlobal_1001de050 addObject:stroke(0,1)]; IShotGlobal_1001de050.lastObject[@"X1"]=@300;
    assert([view isOnStrokesUnderMouse:NSMakePoint(30,90)]==nil);
    IShotGlobal_1001de048=1; assert([view isOnStrokesUnderMouse:NSMakePoint(30,90)]!=nil);
    IShotGlobal_1001de048=0; IShotGlobal_1001de050=[NSMutableArray arrayWithObject:stroke(2,1)];
    assert([view isOnStrokesUnderMouse:NSMakePoint(80,90)]!=nil);
    assert([view isLineIntersectingCircleWithPoint1:NSMakePoint(0,0) point2:NSMakePoint(10,0) center:NSMakePoint(5,0) radius:1]);
    assert(![view isLineIntersectingCircleWithPoint1:NSMakePoint(0,0) point2:NSMakePoint(0,0) center:NSMakePoint(0,0) radius:1]);
    NSBitmapImageRep *bitmap=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:200 pixelsHigh:160 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    [NSGraphicsContext saveGraphicsState]; NSGraphicsContext.currentContext=[NSGraphicsContext graphicsContextWithBitmapImageRep:bitmap];
    IShotGlobal_1001de058=stroke(8,1); IShotGlobal_1001de058[@"Rect"]=[NSValue valueWithRect:NSMakeRect(30,40,100,80)];
    [view drawCurrentHighlightStroke]; [NSGraphicsContext restoreGraphicsState];
    view.hideHandleRect=YES; assert(view.trackingAreas.count==0);
    NSLog(@"PASS crop handles, hit routing, history de-duplication, undo, line/circle and highlight bitmap");
} return 0; }
