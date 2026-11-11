#pragma once
#import <Cocoa/Cocoa.h>
@interface NSImage (Screenshot)
- (id)normalRGBBitmapImageRepresentationWithScaleFactor:(double)arg0; // 0x1000bd110
- (id)bitmapImageRepresentationWithScaleFactor:(float)arg0; // 0x1000bd238
- (long long)pixelsWide; // 0x1000a69e4
- (long long)pixelsHigh; // 0x1000a6b58
- (CGSize)pixelSize; // 0x1000a6ccc
+ (id)imageOfBestRepresentationFrom:(id)arg0; // 0x1000bcfa0
+ (id)imageFullScreen; // 0x10003cfb4
+ (id)imageMainFullScreen; // 0x10003d0ac
+ (id)imageMainScreenForRect:(CGRect)arg0; // 0x10003d134
+ (id)imageRectangleScreen:(CGRect)arg0 exceptWinodws:(id)arg1; // 0x10003d1f0
+ (id)captureCurrentScreenshot:(CGRect)arg0; // 0x10003d3e0
+ (id)captureScreenshot; // 0x10003d44c
+ (id)captureScreenhotBelowWindow:(id)arg0 onRect:(CGRect)arg1; // 0x10003d4dc
+ (id)captureWindowWithWindowID:(unsigned int)arg0; // 0x10003d58c
+ (void)saveImageToPaste:(id)arg0; // 0x10003d644
+ (id)cutImageToRect:(id)arg0 Rect:(CGRect)arg1; // 0x10003d77c
+ (struct CGImage *)createCGImageRefFromImage:(id)arg0; // 0x10003d940
+ (void)saveImage:(id)arg0 toFile:(id)arg1 withType:(unsigned long long)arg2; // 0x10003da84
+ (void)saveData:(id)arg0 toFile:(id)arg1; // 0x10003e1fc
+ (void)postNotificationOrOpenFile:(id)arg0; // 0x10003e25c
+ (id)getImageWindowUnderMouse; // 0x10003e438
+ (id)resizeImage:(id)arg0 size:(CGSize)arg1; // 0x10003ed20
+ (id)resizeImage:(id)arg0 scale:(float)arg1 addShadowWithColor:(id)arg2; // 0x10003ee8c
+ (id)resizeImage:(id)arg0 scale:(float)arg1; // 0x10003f054
+ (id)addRoundImgae:(id)arg0 withRadius:(float)arg1; // 0x10003f1b0
+ (id)addFilletImgae:(id)arg0 withRadius:(float)arg1; // 0x10003f2cc
+ (id)resizeImage:(id)arg0 value:(float)arg1; // 0x10003f644
+ (id)addShadow:(id)arg0 withSize:(float)arg1; // 0x10003f7a8
+ (id)analysisQRCode:(id)arg0; // 0x10003f99c
+ (id)ocrFromImage:(id)arg0; // 0x10003fc04
+ (id)ocrGetTextYFromImage:(id)arg0; // 0x1000400c4
+ (id)md5WithImage:(id)arg0; // 0x1000404dc
@end

@interface NSScreen (PointConversion)
- (CGPoint)convertPointToScreenCoordinates:(CGPoint)arg0; // 0x1000b5898
- (CGPoint)flipPoint:(CGPoint)arg0; // 0x1000b58f4
+ (id)currentScreenForMouseLocation; // 0x1000b57bc
@end
