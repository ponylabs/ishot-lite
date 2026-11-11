#import <Cocoa/Cocoa.h>
#import "../../Camera/NSValue+CGPoint.h"
@interface ClipGeometryFixture:NSObject
@property NSRect lastContentRectBeforeResize,contentRect;
@property BOOL onlyClipCurrentWindow;
@property NSObject *cropBorderView;
@property NSView *indicatorField;
@end
@interface NSObject (GeometryFixtureSelectors)
- (int)numberOfReSize;
@end
NSScreen *IShotGlobal_1001dde80;
NSMutableDictionary *IShotGlobal_1001de058;
static double IShotMXEndX(CGRect r){return r.origin.x+r.size.width;}
static double IShotMXEndY(CGRect r){return r.origin.y+r.size.height;}
@implementation ClipGeometryFixture
#include "../MXClipView-geometry.inc"
@end
@interface ScreenFixture:NSObject
@property NSRect frame;
@end
@implementation ScreenFixture
@end
int main(){@autoreleasepool{
 ScreenFixture *screen=[ScreenFixture new];screen.frame=NSMakeRect(0,0,1000,800);IShotGlobal_1001dde80=(id)screen;
 ClipGeometryFixture *view=[ClipGeometryFixture new];view.lastContentRectBeforeResize=NSMakeRect(100,100,200,100);
 NSRect expected[]={NSZeroRect,{{50,60},{250,140}},{{100,60},{200,140}},{{50,60},{50,140}},{{50,100},{50,100}},{{50,60},{50,40}},{{100,60},{200,40}},{{50,60},{250,40}},{{50,100},{250,100}}};
 for(int i=1;i<=8;i++){NSRect actual=[view getNewRectByReSize:NSMakePoint(50.9,60.9) resizeposition:i];NSCAssert(NSEqualRects(actual,expected[i]),@"resize direction %d",i);}
 NSCAssert(NSEqualRects([view getNewRectByReSize:NSMakePoint(-100,900) resizeposition:1],NSMakeRect(0,200,300,600)),@"screen clamp/corner crossover");
 IShotGlobal_1001de058=[@{@"type":@1}mutableCopy];NSArray *handles=[view _calculateAllNeededHandleSquareRects:NSMakeRect(10,20,100,80)];NSCAssert(handles.count==9,@"base handle count");NSCAssert(NSEqualRects([handles[0]CGRectValue],NSMakeRect(16,26,0,0)),@"original zero interior handle");NSCAssert(NSEqualRects([handles[5]CGRectValue],NSMakeRect(105,95,10,10)),@"top right");
 IShotGlobal_1001de058[@"type"]=@5;handles=[view _calculateAllNeededHandleSquareRects:NSMakeRect(10,20,100,80)];NSCAssert(handles.count==18,@"extended handle count");NSCAssert(NSEqualRects([handles[12]CGRectValue],[handles[13]CGRectValue]),@"original duplicated segment retained");
 NSLog(@"PASS all eight resize directions, fractional truncation, screen clamp, crossover and handle geometry");
}}
