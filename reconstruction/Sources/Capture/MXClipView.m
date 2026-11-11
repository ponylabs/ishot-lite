#import "MXClipView.h"
#import <ApplicationServices/ApplicationServices.h>
#import "../Global/Global.h"
#import "../Dependencies/SnipUtil.h"
#import "../Imaging/Imaging.h"
#import "../Imaging/MJMosaicUtil.h"
#import "../Camera/NSValue+CGPoint.h"
#import "../Editor/AnnotatedImageController.h"
#include "MXClipView-globals.inc"
#include "MXClipView-extern.inc"
#include "MXClipView-keyboard-support.inc"
#include "MXClipView-scroll-support.inc"
#include "MXClipView-drag-support.inc"
#include "MXClipView-drawing-support.inc"
#include "MXClipView-ui-support.inc"
#pragma clang fp contract(off)
extern BOOL IShotGlobal_1001ddcf1;
extern NSString *IShotGlobal_1001ddd08;
extern int32_t IShotGlobal_1001ddd38;
extern CGImageRef IShotCGDisplayCreateImage(CGDirectDisplayID) __asm__("_CGDisplayCreateImage");
extern NSFont *IShotFunction_10004cf0c(NSString *,int);
extern NSSize IShotFunction_100048504(NSString *,NSFont *);
extern int IShotFunction_10004c930(int);
extern int IShotFunction_10004c9b8(uint32_t);
extern NSImage *IShotFunction_10004cfe4(CALayer *);
@interface NSObject (IShotMXDownDelegate)
- (void)clipViewMouseDown:(NSEvent *)event;
@end
static double IShotMXEndX(CGRect r){return r.origin.x+r.size.width;}
static double IShotMXEndY(CGRect r){return r.origin.y+r.size.height;}
// 0x100028b24.
static NSString *IShotMXDecodeNotification(NSString *input){
 NSUInteger end=input.length-1;NSString *result=@"";
 if(end){NSUInteger i=0,j=end;do{result=[result stringByAppendingString:[input substringWithRange:NSMakeRange(i,1)]];result=[result stringByAppendingString:[input substringWithRange:NSMakeRange(j,1)]];i+=2;j-=2;}while(i<end);}
 return [result componentsSeparatedByString:@"1010"][1];
}
@implementation MXClipView
@synthesize overlayAlpha=_overlayAlpha,contentFrame=_contentFrame;
#include "MXClipView-core.inc"
#include "MXClipView-tracking.inc"
#include "MXClipView-geometry.inc"
#include "MXClipView-selection.inc"
#include "MXClipView-shapes.inc"
#include "MXClipView-drawRect.inc"
#include "MXClipView-mosaic-drawing.inc"
#include "MXClipView-mosaic-generation.inc"
#include "MXClipView-ui.inc"
#include "MXClipView-flags.inc"
#include "MXClipView-mousedown.inc"
#include "MXClipView-mouseup.inc"
#include "MXClipView-keyboard.inc"
#include "MXClipView-drag.inc"
#include "MXClipView-scroll.inc"
@end
