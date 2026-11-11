// Isolated Cocoa geometry/UI tests. Dependency doubles are confined to this executable.
#import "../RecordScreenClipView.m"
#include <assert.h>
NSWindowController *IShotGlobal_1001ddd68;
NSScreen *IShotGlobal_1001ddd60;
NSCursor *IShotGlobal_1001dddf8,*IShotNullCursor_1001ddfa8,*IShotGlobal_1001ddf88,*IShotGlobal_1001ddf90;
BOOL IShotGlobal_1001ddd58,IShotGlobal_1001ddde0,IShotGlobal_1001ddce8;
double IShotGlobal_1001ddd18,IShotGlobal_1001ddd20,IShotGlobal_1001ddd28,IShotGlobal_1001ddd30;
NSRect IShotPreviousCameraConstraint_1001ddd70,IShotRecordScreenRect_1001ddd90;
@interface RecordTestScreen:NSObject @end
@implementation RecordTestScreen
- (NSRect)frame { return NSMakeRect(0,0,800,600); }
@end
@implementation NSScreen (RecordClipTest)
+ (id)currentScreenForMouseLocation { return IShotGlobal_1001ddd60; }
@end
@implementation CameraWindowController
- (void)adjustCameraWindowWithRect:(CGRect)r atPosition:(int)p {}
@end
@implementation MXRecordScreenManager @end
@implementation ColorPickerImageView @end
@implementation CropBorderViewForRecordScreen
- (int)numberOfReSize { return 0; }
- (BOOL)isInResizeRect { return NO; }
@end
static void equal(NSRect a,NSRect b){assert(NSEqualRects(a,b));}
int main(void){@autoreleasepool{
    [NSApplication sharedApplication]; IShotGlobal_1001ddd60=(NSScreen *)[RecordTestScreen new];
    RecordScreenClipView *v=[[RecordScreenClipView alloc] initWithFrame:NSMakeRect(0,0,800,600) type:2];
    assert(v.type==2 && v.onlyClipCurrentWindow && v.overlayAlpha==.5);
    v.contentView=[NSView new]; v.cropBorderViewForRecordScreen=[CropBorderViewForRecordScreen new];
    v.indicatorField=[[NSView alloc] initWithFrame:NSMakeRect(0,0,90,20)]; v.indicatorFieldWidth=[NSTextField new]; v.indicatorFieldHeight=[NSTextField new];
    v.lastContentRectBeforeResize=NSMakeRect(100,100,200,200);
    NSRect expected[]={NSZeroRect,NSMakeRect(50,60,250,240),NSMakeRect(100,60,200,240),NSMakeRect(50,60,50,240),NSMakeRect(50,100,50,200),NSMakeRect(50,60,50,40),NSMakeRect(100,60,200,40),NSMakeRect(50,60,250,40),NSMakeRect(50,100,250,200)};
    for(int p=0;p<9;p++)equal([v getNewRectByReSize:NSMakePoint(50,60) resizeposition:p],expected[p]);
    equal([v getNewRectByReSize:NSMakePoint(-200,900) resizeposition:1],NSMakeRect(0,300,300,300));
    v.contentRect=NSMakeRect(100,100,200,200); v.startPoint=NSMakePoint(150,150);
    [v refreshContentRectByMove:NSMakePoint(900.8,-10.9)]; equal(v.contentRect,NSMakeRect(600,0,200,200)); assert(NSEqualPoints(v.startPoint,NSMakePoint(900,-10)));
    [v setFrameForContentView:NSMakeRect(100.8,100.2,200.9,200.7)]; equal(v.contentRect,NSMakeRect(100,100,200,200)); equal(v.contentView.frame,v.contentRect);
    equal(v.indicatorField.frame,NSMakeRect(99,306,90,20)); assert([v.indicatorFieldWidth.stringValue isEqual:@"200"]);
    v.contentRect=NSMakeRect(200,500,200,100); [v _resetIndicatorField]; equal(v.indicatorField.frame,NSMakeRect(102,580,90,20));
    v.contentRect=NSMakeRect(0,500,200,100); [v _resetIndicatorField]; equal(v.indicatorField.frame,NSMakeRect(205,580,90,20));
    v.contentRect=NSMakeRect(0,500,800,100); [v _resetIndicatorField]; equal(v.indicatorField.frame,NSMakeRect(0,474,90,20));
    v.contentRect=NSMakeRect(0,0,0,100); [v _resetIndicatorField]; assert(v.indicatorField.hidden);
    v.contentFrame=NSMakeRect(10,20,212,112); equal(v.contentRect,NSMakeRect(16,26,200,100)); equal(v.cropBorderViewForRecordScreen.frame,v.contentFrame);
    NSLog(@"RecordClipTests passed: eight resize handles, clipping, move bounds, integer truncation, indicator placement and content-frame inset");
}}
