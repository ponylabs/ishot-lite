#import "AnnotatedImageView.h"
#import "AnnotatedImageController.h"
#import <math.h>
extern NSMutableArray *IShotGlobal_1001de050, *IShotGlobal_1001de060;
extern NSMutableDictionary *IShotGlobal_1001de058, *IShotGlobal_1001de0c8;
extern NSString *IShotGlobal_1001de090;
extern BOOL IShotGlobal_1001de180;
extern int IShotGlobal_1001de068, IShotGlobal_1001de048;
extern uint64_t IShotGlobal_1001de070, IShotGlobal_1001de078;
extern BOOL IShotFunction_10004c448(NSArray *);
extern uint32_t IShotGlobal_1001f1a08, IShotGlobal_1001de06c;
extern BOOL IShotGlobal_1001de099, IShotGlobal_1001de0c1;
extern BOOL IShotGlobal_1001ddfd1, IShotGlobal_1001de0c0, IShotGlobal_1001de088;
extern NSString *IShotGlobal_1001dde70;
extern NSCursor *IShotGlobal_1001ddf88, *IShotGlobal_1001ddf90, *IShotGlobal_1001ddf98;
extern NSCursor *IShotGlobal_1001dddf8;
extern AnnotatedImageController *IShotGlobal_1001de160;
extern BOOL IShotGlobal_1001dde94;
extern CGPoint IShotFunction_10004cdb8(CGPoint,CGPoint,CGPoint,CGPoint,double);
extern BOOL IShotFunction_10004ce78(CGPoint,CGPoint,CGPoint,CGPoint);
extern CGSize IShotFunction_100048504(NSString *, NSFont *);
extern NSFont *IShotFunction_10004cf0c(NSString *, int);
#import "../Camera/NSValue+CGPoint.h"
#include "AnnotatedImageView-drawing-globals.inc"
@implementation AnnotatedImageView
@synthesize textField = _textField;
- (void)selectFunctionToolChanged { // 0x100062384
    [self discardCursorRects]; [self resetCursorRects]; [self updateTrackingAreas]; self.needsDisplay = YES;
}
- (instancetype)initWithFrame:(NSRect)frame { // 0x1000623bc
    self = [super initWithFrame:frame];
    if (self) {
        IShotGlobal_1001de050 = [[NSMutableArray alloc] initWithCapacity:5];
        IShotGlobal_1001de058 = [[NSMutableDictionary alloc] initWithCapacity:10];
        IShotGlobal_1001de060 = [[NSMutableArray alloc] initWithCapacity:10];
        arrayOfPoints = [[NSMutableArray alloc] initWithCapacity:20];
        IShotGlobal_1001de068 = -1;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textViewDidChange:) name:NSTextViewDidChangeSelectionNotification object:nil];
    }
    return self;
}
- (BOOL)acceptsFirstResponder { return YES; } // 0x100062914
- (void)awakeFromNib { // 0x10006291c
    [NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(refreshOthersDrawRect) name:@"refreshOthersDrawRect" object:nil suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];
}
- (void)refreshOthersDrawRect { // 0x100062974
    self.needsDisplay = YES; [self updateTrackingAreas]; IShotGlobal_1001dddf8 = nil; [NSCursor.arrowCursor set];
}
- (void)mouseMoved:(NSEvent *)event {} // 0x1000629d4: original one-instruction ret
- (void)keyDown:(NSEvent *)event {} // 0x1000629d8: original one-instruction ret
- (void)scrollWheel:(NSEvent *)event { [self.nextResponder scrollWheel:event]; } // 0x100065a14
- (void)reSetUndo { // 0x100065fb4
    while (IShotGlobal_1001de048 > 0 && IShotGlobal_1001de050.count) {
        [IShotGlobal_1001de050 removeObjectAtIndex:IShotGlobal_1001de050.count-1];
        --IShotGlobal_1001de048;
    }
}
- (void)drawRect { self.needsDisplay = YES; } // 0x100066038
- (int)getListNumberFromArrayOfStrokes:(int)type { // 0x100067018
    int maximum = 0;
    for (NSDictionary *stroke in IShotGlobal_1001de050) if ([stroke[@"type"] intValue] == type) {
        int number = [stroke[@"list"] intValue]; if (number > maximum) maximum = number;
    }
    return maximum;
}
- (BOOL)AllIsEnglish:(NSString *)text { // 0x1000684f0
    for (NSUInteger i=0; i<text.length; ++i) if ((uint32_t)[text characterAtIndex:i]-0x4e01U < 0x51feU) return NO;
    return YES;
}
- (BOOL)isChinese:(NSString *)text { // 0x100068584; vararg CFString 0x1001b0480
    return [[NSPredicate predicateWithFormat:@"SELF matches %@", @"(^[一-龥]+$)"] evaluateWithObject:text];
}
- (double)angleBetweenPoint:(CGPoint)a and:(CGPoint)b { return atan2(a.y-b.y,a.x-b.x); } // 0x10006b5dc
- (double)distanceBetweenPoint:(CGPoint)a and:(CGPoint)b { // 0x10006b5ec
    double x=a.x-b.x,y=a.y-b.y; return sqrt(x*x+y*y);
}
- (CGPoint)getPointFrom:(CGPoint)p to:(CGRect)rect { // 0x10006d220
    double x = rect.origin.x, y = rect.origin.y+rect.size.height;
    if (!(p.x < x)) { x += rect.size.width; if (p.x < x) x=p.x; }
    if (!(p.y > y)) y = p.y > rect.origin.y ? p.y : rect.origin.y;
    return CGPointMake(x,y);
}
- (NSBezierPath *)makeBubble:(id)unused withBubbleRect:(CGRect)rect cornerRight:(double)right cornerLeft:(double)left { // 0x10006f45c
    double r = right, l = left;
    if (rect.size.height < right+right) r=l=rect.size.height*0.5;
    if (rect.size.width < r+r) r=l=rect.size.width*0.5;
    return [NSBezierPath bezierPathWithRoundedRect:rect xRadius:l yRadius:r];
}
- (BOOL)point:(CGPoint)a andPoint:(CGPoint)b crossWithCyclePoint:(CGPoint)center radius:(float)radius // 0x10006f354
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

#include "AnnotatedImageView-events.inc"
#include "AnnotatedImageView-geometry.inc"
#include "AnnotatedImageView-transform.inc"
#include "AnnotatedImageView-drawing.inc"
@end
