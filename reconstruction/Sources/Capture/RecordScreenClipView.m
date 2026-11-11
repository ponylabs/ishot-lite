#import "RecordScreenClipView.h"
#import "../Common/CropBorderViewForRecordScreen.h"
#import "../Camera/CameraWindowController.h"
#import "../Camera/CameraView.h"
#import "../Camera/RecoveredCursors.h"
#import "MXRecordScreenManager.h"
#import "MXRecordScreenWindowController.h"
#import "ColorPickerImageView.h"
#import "../Imaging/Imaging.h"
#include <math.h>
extern NSSize IShotFunction_1000483f0(NSString *,int);
extern NSWindowController *IShotGlobal_1001ddd68;
extern NSScreen *IShotGlobal_1001ddd60;
extern NSCursor *IShotGlobal_1001dddf8;
extern BOOL IShotGlobal_1001ddd58,IShotGlobal_1001ddde0,IShotGlobal_1001ddce8;
extern double IShotGlobal_1001ddd18,IShotGlobal_1001ddd20,IShotGlobal_1001ddd28,IShotGlobal_1001ddd30;
static double IShotRecordClip_1001f18b8;
static double IShotRecordEndX(CGRect r){return r.origin.x+r.size.width;}
static double IShotRecordEndY(CGRect r){return r.origin.y+r.size.height;}
@implementation RecordScreenClipView
@synthesize overlayAlpha=_overlayAlpha,contentFrame=_contentFrame;
#include "RecordScreenClipView-core.inc"
#include "RecordScreenClipView-geometry.inc"
#include "RecordScreenClipView-shapes.inc"
#include "RecordScreenClipView-camera.inc"
#include "RecordScreenClipView-events.inc"
#include "RecordScreenClipView-ui.inc"
@end
