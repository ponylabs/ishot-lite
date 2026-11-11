#pragma once
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
@class GKCropBorderView;
@protocol MXClipViewDelegate;
@interface MXClipView : NSView
- (void)dealloc; // 0x100024784
- (void)setFrame:(CGRect)arg0; // 0x1000247b8
- (void)disableTextView; // 0x1000248c0
- (void)startAutoScroll:(id)arg0; // 0x10002491c
- (void)scrollScreenShot; // 0x100024bac
- (id)initWithFrame:(CGRect)arg0 type:(unsigned long long)arg1; // 0x1000257dc
- (void)CaptureFullScreen; // 0x100025888
- (void)updateTrackingAreas; // 0x100025a78
- (void)mouseEntered:(id)arg0; // 0x1000265bc
- (void)mouseExited:(id)arg0; // 0x10002699c
- (void)showClipViewWithFrame:(CGRect)arg0 withToolbar:(id)arg1; // 0x100026c48
- (void)setFrameForContentView:(CGRect)arg0; // 0x100026d2c
- (void)refreshColorPickerImageView; // 0x100026dc0
- (BOOL)acceptsFirstResponder; // 0x100026fd0
- (void)changFullImageToMosaicImage; // 0x100026fd8
- (void)mousedown:(id)arg0; // 0x100027990
- (void)mousedragged:(id)arg0; // 0x100028d78
- (void)rightMouseUp:(id)arg0; // 0x100029cec
- (void)mouseup:(id)arg0; // 0x100029d2c
- (void)fullScreenCapture; // 0x10002b810
- (void)previousScreenshotAreaCapture; // 0x10002bab0
- (void)presetAreaSizeModeScreenShot; // 0x10002bf28
- (void)refreshIndicatorFieldSize; // 0x10002c2d0
- (void)startAnnotation; // 0x10002c84c
- (void)mouseMoved:(id)arg0; // 0x10002cccc
- (void)flagsChanged:(id)arg0; // 0x10002e578
- (void)keyDown:(id)arg0; // 0x10002eb38
- (void)changeCursorToCreateNew; // 0x10002fdc0
- (void)setUpUI; // 0x10002fe0c
- (void)_resetIndicatorField; // 0x10003123c
- (CGSize)getCurrentScreenSize; // 0x100031748
- (void)refreshContentRectByMove:(CGPoint)arg0; // 0x10003179c
- (CGRect)getNewRectByReSize:(CGPoint)arg0 resizeposition:(int)arg1; // 0x100031860
- (void)_resetFramesToThisOne:(CGRect)arg0; // 0x100031a78
- (CGPoint)fetchLocationFromScreen:(CGPoint)arg0; // 0x100031b20
- (void)drawRect:(CGRect)arg0; // 0x100031b84
- (void)drawAllMosaic; // 0x100032188
- (void)drawAllBackgroundOfText; // 0x1000326dc
- (void)drawCurrentMosaicStroke; // 0x100032ad8
- (void)setOverlayAlpha:(double)arg0; // 0x100032ffc
- (void)setContentFrame:(CGRect)arg0; // 0x100033010
- (void)makeForcusLater; // 0x100033198
- (id)_calculateAllNeededHandleSquareRects:(CGRect)arg0; // 0x100033200
- (CGPoint)getPositionOfDragging:(CGPoint)arg0; // 0x10003377c
- (void)selectedWindowChanged; // 0x100033b4c
- (void)setUpShapeLayer; // 0x100033b94
- (void)reFreshShapeLayer1; // 0x100033b98
- (void)adjustRadius:(id)arg0; // 0x100034020
- (void)checkShadow:(id)arg0; // 0x100034090
- (void)reFreshShapeLayer2; // 0x100034108
- (void)reFreshShapeLayer3:(CGPoint)arg0; // 0x1000344b4
- (void)scrollWheel:(id)arg0; // 0x1000347d4
- (void)scrollFinished; // 0x1000349f0
- (void)screenShotsAtScrollScreenshots; // 0x1000349f4
- (void)drawScrollView; // 0x100035f08
- (void)redrawScrollView; // 0x1000365dc

+ (id)defaultAnimationForKey:(id)arg0; // 0x1000330f4
@property (nonatomic, strong) NSTrackingArea * trackingArea;
@property (nonatomic, strong) NSView * contentView;
@property (nonatomic, strong) GKCropBorderView * cropBorderView;
@property (nonatomic, strong) NSView * toolbarView;
@property (nonatomic, assign) CGRect contentRect;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) int dragMode;
@property (nonatomic, assign) CGPoint rectBeginPoint;
@property (nonatomic, assign) CGPoint rectEndPoint;
@property (nonatomic, assign) BOOL rectDrawing;
@property (nonatomic, assign) CGRect lastContentRectBeforeResize;
@property (nonatomic, strong) NSDate * lastDate;
@property (nonatomic, assign) BOOL isCanDrawSelectFunction;
@property (nonatomic, weak) id<MXClipViewDelegate> delegate;
@property (nonatomic, strong) NSView * indicatorField;
@property (nonatomic, strong) NSTextView * indicatorFieldWidth;
@property (nonatomic, strong) NSTextView * indicatorFieldHeight;
@property (nonatomic, strong) NSButton * buttonOfWindowShadow;
@property (nonatomic, strong) NSView * tipView;
@property (nonatomic, strong) NSTextField * textFieldOfTipView;
@property (nonatomic, assign) int clipState;
@property (nonatomic, strong) NSImageView * colorPickerImageView;
@property (nonatomic, strong) NSImageView * imageViewOfCursor;
@property (nonatomic, strong) NSScrollView * scrollViewOfColorPicker;
@property (nonatomic, assign) CGRect contentFrame;
@property (nonatomic, assign) double overlayAlpha;
@property (nonatomic, strong) NSSlider * sliderOfRadiusOfFrame;
@property (nonatomic, strong) NSButton * autoScrollScreenShotButton;
@property (nonatomic, assign) int radiusOfFrame;
@property (nonatomic, assign) BOOL onlyClipCurrentWindow;
@property (nonatomic, assign) BOOL multiWindowScreenshots;
@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, assign) BOOL haveSetClearColor;
@property (nonatomic, strong) NSImage * fullImage;
@property (nonatomic, strong) CAShapeLayer * shapeLayer1;
@property (nonatomic, strong) CAShapeLayer * shapeLayer2;
@property (nonatomic, strong) CAShapeLayer * shapeLayer3;
@property (nonatomic, strong) NSBox * boxOfScreenAreaForScrollScreen;
@property (nonatomic, strong) CALayer * mosaicLayer;
@property (nonatomic, strong) CAShapeLayer * mosaicShapeLayer;
@property (nonatomic, assign) CGPathRef mosaicPath;
@end
