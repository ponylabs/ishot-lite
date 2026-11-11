#import <Cocoa/Cocoa.h>
#import "../AnnotatedImageView.h"
#import "../AnnotatedImageController.h"
#import "../../Camera/NSValue+CGPoint.h"
#import <math.h>
#include "EditorTestGlobals.inc"
static void check(BOOL value, NSString *message) { if (!value) { NSLog(@"FAIL: %@",message); exit(1); } }
static NSMutableDictionary *stroke(int type,int list,float x1,float y1,float x2,float y2) {
    return [@{@"type":@(type),@"list":@(list),@"X1":@(x1),@"Y1":@(y1),@"X2":@(x2),@"Y2":@(y2),@"size":@4,@"color":NSColor.redColor} mutableCopy];
}
int main(void) { @autoreleasepool {
    [NSApplication sharedApplication];
    AnnotatedImageView *view=[[AnnotatedImageView alloc] initWithFrame:NSMakeRect(10,20,300,200)];
    check(IShotGlobal_1001de050.count==0 && IShotGlobal_1001de068==-1,@"init creates stroke state");
    check([view AllIsEnglish:@"一"] && ![view AllIsEnglish:@"丁"] && [view AllIsEnglish:@"abc"],@"exact CJK interval excludes U+4E00");
    check([view isChinese:@"中文"] && ![view isChinese:@"中文a"],@"original predicate");
    CGPoint p=[view getPointFrom:NSMakePoint(-4,100) to:NSMakeRect(10,20,30,40)];
    check(p.x==10 && p.y==60,@"point clamp");
    IShotGlobal_1001de058=stroke(8,1,30,40,130,140);
    NSArray *handles=[view _calculateAllNeededHandleSquareRects:NSMakeRect(30,40,100,80)];
    check(handles.count==18 && NSEqualRects([handles[12] rectValue],[handles[13] rectValue]),@"highlight duplicate handle retained");
    check(NSEqualRects([handles[0] rectValue],NSMakeRect(36,46,0,0)),@"zero size handle retained");
    IShotGlobal_1001de058=stroke(0,1,30,40,130,140); IShotGlobal_1001de068=2; IShotGlobal_1001de070=1;
    IShotGlobal_1001de058[@"moveX"]=@30;IShotGlobal_1001de058[@"moveY"]=@40;IShotGlobal_1001de058[@"moveToX"]=@50;IShotGlobal_1001de058[@"moveToY"]=@70;
    check(NSEqualRects([view getNewRectOfResizeAllStroke],NSMakeRect(50,70,80,70)),@"resize first corner");
    IShotGlobal_1001de068=0;
    p=[view getNewPointForSqureOrEllipse:NSMakePoint(70,100)];check(p.x==70 && p.y==80,@"square constrained minimum extent");
    IShotGlobal_1001de058=stroke(2,1,0,0,100,0);
    p=[view getNewPointForArrowOrLine:NSMakePoint(100,1)];check(fabs(p.y)<0.001 && p.x>100,@"15 degree snap maintains float length");
    NSMutableDictionary *old=stroke(0,1,10,10,30,30),*latest=stroke(0,1,100,100,130,130);
    old[@"filledOfSquare"]=@YES; latest[@"filledOfSquare"]=@YES;
    IShotGlobal_1001de050=[@[old,latest] mutableCopy];IShotGlobal_1001de048=0;
    check(![view getdicOfCurrentStrokeUnderMouse:NSMakePoint(20,20)],@"latest revision hides old geometry before hit test");
    check([view getdicOfCurrentStrokeUnderMouse:NSMakePoint(110,110)],@"latest geometry selected");
    IShotGlobal_1001de048=1;
    check([view getdicOfCurrentStrokeUnderMouse:NSMakePoint(20,20)],@"undo excludes latest revision");
    [view reSetUndo];check(IShotGlobal_1001de050.count==1 && IShotGlobal_1001de048==0,@"new edit discards redo suffix");
    [view undoDraw];check(IShotGlobal_1001de048==1 && IShotGlobal_1001de058.count==0,@"undo clears active stroke");
    [view redoDraw];check(IShotGlobal_1001de048==0,@"redo restores history cursor");
    IShotGlobal_1001de058=stroke(0,2,20,30,70,80);IShotGlobal_1001de058[@"filledOfSquare"]=@YES;
    IShotGlobal_1001de050=NSMutableArray.new;IShotGlobal_1001de068=1;IShotGlobal_1001f1a08=6;
    IShotGlobal_1001de058[@"moveX"]=@25;IShotGlobal_1001de058[@"moveY"]=@35;
    NSEvent *up=[NSEvent mouseEventWithType:NSEventTypeLeftMouseUp location:NSMakePoint(35,55) modifierFlags:0 timestamp:0 windowNumber:0 context:nil eventNumber:0 clickCount:1 pressure:0];
    [view mouseup:up];check([IShotGlobal_1001de058[@"X1"] floatValue]==30 && [IShotGlobal_1001de058[@"Y1"] floatValue]==50 && IShotGlobal_1001de050.count==1,@"drag commits translated geometry and history");
    NSLog(@"Editor behavior tests passed");
} return 0; }
