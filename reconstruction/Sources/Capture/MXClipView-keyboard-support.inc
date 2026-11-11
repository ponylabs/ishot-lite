#import "../Editor/AnnotatedImageController.h"
#import "../Common/GKCropBorderView.h"
#import "../Camera/RecoveredCursors.h"
#import "MXClipScreenManager.h"
@interface NSScreen (IShotMXKeyboardScreen)
+ (NSScreen *)currentScreenForMouseLocation;
@end
#import "ColorPickerImageView.h"
@interface NSObject (IShotMXKeyboardDelegate)
- (void)clipViewMouseMoved:(NSEvent *)event;
- (MXClipView *)clipView;
@end
extern NSArray *IShotGlobal_1001de130;
extern NSMutableArray *IShotGlobal_1001de050,*IShotGlobal_1001de138;
extern NSMutableDictionary *IShotGlobal_1001de058;
extern AnnotatedImageController *IShotGlobal_1001de160;
extern NSString *IShotGlobal_1001de090,*IShotGlobal_1001dde70,*IShotGlobal_1001ddde8,*IShotGlobal_1001dde78,*IShotGlobal_1001ddec8,*IShotGlobal_1001dded0;
extern NSCursor *IShotGlobal_1001dddf8;
extern int IShotGlobal_1001de048,IShotGlobal_1001de0b0,IShotGlobal_1001dde68;
extern BOOL IShotGlobal_1001de088,IShotGlobal_1001de0c0,IShotGlobal_1001de180,IShotGlobal_1001ddec0,IShotGlobal_1001dde95,IShotGlobal_1001de099,IShotGlobal_1001ddfd0;
extern BOOL IShotGlobal_1001f18cc,IShotGlobal_1001f18cd,IShotGlobal_1001f18ce,IShotGlobal_1001f18c0,IShotGlobal_1001dded8,IShotGlobal_1001dded9,IShotGlobal_1001dde91;
extern NSSize IShotFunction_1000483f0(NSString *,int);
static void IShotMXKeyPost(NSString *name){[[NSDistributedNotificationCenter defaultCenter]postNotificationName:name object:nil userInfo:nil];}
static NSString *IShotMXKeyLocalized(NSString *key){return [[NSBundle mainBundle]localizedStringForKey:key value:@"" table:nil];}
// Shared instruction sequences at 0x10002d7xx, 0x10002ddfc and 0x10002df48.
static void IShotMXMouseTip(MXClipView *view,NSString *text){
 NSSize size=IShotFunction_1000483f0(text,12);size.width+=25.;
 view.tipView.frame=NSMakeRect(10,10,size.width,size.height+20.);
 view.textFieldOfTipView.stringValue=text;view.textFieldOfTipView.frame=NSMakeRect(10,10,size.width,size.height);
 view.tipView.hidden=NO;[view.window disableCursorRects];
}
