#import <Cocoa/Cocoa.h>
@interface Global : NSObject
+ (void)hideCursor; // 0x10000cd0c
+ (void)showCursor; // 0x10000cd68
+ (BOOL)notOnlyWhiteColorInQQOrWeChat:(id)arg0; // 0x10000cd7c
+ (BOOL)sameArrColumn:(id)arg0 to:(id)arg1; // 0x10000cf24
+ (int)getSameColorValueInArrColumn:(id)arg0 from:(int)arg1 withUp:(BOOL)arg2; // 0x10000d078
+ (BOOL)sameArr:(id)arg0 to:(id)arg1; // 0x10000d214
+ (double)_calcuateDistanceOfTwoPoints:(CGPoint)arg0 :(CGPoint)arg1; // 0x10000d4f4
+ (CGRect)calcuateRealRectFromIMageRef:(struct CGImage *)arg0 withOriginalRect:(CGRect)arg1; // 0x10000d510
+ (CGRect)calcuateRealRectFromNSImage:(id)arg0 withOriginalRect:(CGRect)arg1; // 0x10000d7e4
+ (BOOL)checkIfSameColorFromImageRef:(struct CGImage *)arg0; // 0x10000da78
+ (void)restart; // 0x10000db80
+ (void)startOCRAtScreenRect:(CGRect)arg0; // 0x10000dc64
+ (void)startOCRFromImage:(id)arg0; // 0x10000e834
+ (struct CGPath *)CGPathFromPath:(id)arg0; // 0x10000ef58
+ (id)convertStringToImage:(id)arg0; // 0x10000f074
+ (id)convertClipboardDataToImage:(BOOL)arg0 withPasteboard:(id)arg1; // 0x10000f218
+ (BOOL)isCorrectRichTextWithAttributedString:(id)arg0; // 0x10000f890
+ (void)drawPencilMosaic:(id)arg0 inRect:(CGRect)arg1 withActived:(BOOL)arg2; // 0x10000fa14
+ (void)saveKeyEventInfo:(id)arg0; // 0x10000fdc4
+ (id)screenShotFromWindowID:(unsigned int)arg0; // 0x1000103d0
+ (void)pinToScreenWithImage:(id)arg0 rect:(CGRect)arg1; // 0x1000104ec
+ (void)saveFlagsChangedEventInfo:(id)arg0; // 0x1000106e8
+ (void)popupRequestScreenCaptureAccess; // 0x100010eec
+ (void)popupRequestPrivacyAccessibilityWithQuit:(BOOL)arg0; // 0x100010ff0
+ (void)checkAllHotKeyForMacosSequoia; // 0x1000111d4
+ (BOOL)haveOnlyOptionAsFlag; // 0x100011690
+ (void)activateAppWithIdentifier:(id)arg0; // 0x100011828
+ (id)fixedKeyCaptionForKeyCode:(unsigned long long)arg0; // 0x100011894
+ (CGRect)currentScreenNotchRect; // 0x1000118b8
+ (void)screenCaptureOverMacOS15:(unsigned int)arg0 withSize:(CGSize)arg1; // 0x1000119b4
+ (id)getImageFromArr:(id)arg0; // 0x100011cf8
+ (BOOL)checkRect:(CGRect)arg0 OverlapWithRect:(CGRect)arg1; // 0x1000121a8
@end
