#pragma once
#import <Cocoa/Cocoa.h>
@class MXClipView;
@interface MXClipWindowController : NSWindowController
@property(nonatomic,weak) id delegate;
@property(nonatomic,strong) NSScreen *screen;
@property(nonatomic,strong) MXClipView *clipView;
@property(nonatomic,strong) id eventMonitor,eventMonitorGlobal;
@property(nonatomic) CGRect lastWindowRect;
@property(nonatomic) long long lastWindowNumber,currentWindowNumber;
- (instancetype)initWithDelegate:(id)delegate;
- (void)startAnnotation;
- (void)cancel;
- (void)startCaptureWithScreen:(NSScreen *)screen;
- (void)endCapture;
- (void)clipViewMouseDown:(NSEvent *)event;
- (void)clipViewMouseMoved:(NSEvent *)event;
- (void)startScreenShots;
- (void)clipViewClipCurrentWindow:(id)sender;
- (void)clipViewClipFullScreen:(id)sender;
- (void)clipViewMouseDoubleClick:(id)sender;
- (void)clipViewCancleSelected:(id)sender;
- (void)clipScreen;
- (void)saveAsFile:(NSImage *)image;
- (void)saveToFileOnlyForWhenPin:(NSImage *)image;
- (void)refreshMosaic;
- (void)refreshHighlight;
- (void)scrollScreenShot;
- (void)disableTextView;
@end
