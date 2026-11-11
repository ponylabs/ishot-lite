#pragma once
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
@class CropBorderViewForRecordScreen;
// recovery/objc/otool-arm64-objc.txt:5176: all seven methods are optional.
@protocol RecordScreenClipViewDelegate <NSObject>
@optional
- (void)clipViewClipCurrentWindow:(id)sender;
- (void)clipViewClipFullScreen:(id)sender;
- (void)clipViewMouseDoubleClick:(id)sender;
- (void)clipViewCancleSelected:(id)sender;
- (void)recordViewDidShowToolBar:(id)sender;
- (void)clipViewMouseDown:(id)sender;
- (void)clipViewMouseMoved:(id)sender;
@end
@interface RecordScreenClipView : NSView
- (void)setFrame:(CGRect)arg0; // 0x10001cb1c
- (id)initWithFrame:(CGRect)arg0 type:(unsigned long long)arg1; // 0x10001cc24
- (void)showClipViewWithFrame:(CGRect)arg0 withToolbar:(id)arg1; // 0x10001cc94
- (void)setFrameForContentView:(CGRect)arg0; // 0x10001cd4c
- (void)refreshColorPickerImageView; // 0x10001cde0
- (BOOL)acceptsFirstResponder; // 0x10001cff0
- (void)mousedown:(id)arg0; // 0x10001cff8
- (void)mousedragged:(id)arg0; // 0x10001d480
- (void)rightMouseUp:(id)arg0; // 0x10001ddd4
- (void)mouseup:(id)arg0; // 0x10001de08
- (void)addCameraWindow; // 0x10001e36c
- (void)closeCameraWindow; // 0x10001e6bc
- (void)recordFullScreen; // 0x10001e754
- (void)mouseMoved:(id)arg0; // 0x10001eb70
- (void)flagsChanged:(id)arg0; // 0x10001f48c
- (void)keyDown:(id)arg0; // 0x10001f490
- (void)setUpUI; // 0x10001f494
- (void)_resetIndicatorField; // 0x100020198
- (void)refreshContentRectByMove:(CGPoint)arg0; // 0x1000204e0
- (CGRect)getNewRectByReSize:(CGPoint)arg0 resizeposition:(int)arg1; // 0x1000205ec
- (CGPoint)fetchLocationFromScreen:(CGPoint)arg0; // 0x100020838
- (void)drawRect:(CGRect)arg0; // 0x10002089c
- (void)setOverlayAlpha:(double)arg0; // 0x1000208d0
- (void)setContentFrame:(CGRect)arg0; // 0x1000208e4
- (CGPoint)getPositionOfDragging:(CGPoint)arg0; // 0x1000209c8
- (void)selectedWindowChanged; // 0x100020d98
- (void)setUpShapeLayer; // 0x100020de0
- (void)reFreshShapeLayer1; // 0x100021270
- (void)reFreshShapeLayer2; // 0x100021454
- (void)reFreshShapeLayer3:(CGPoint)arg0; // 0x1000216ac
@property (nonatomic, strong) NSView * contentView;
@property (nonatomic, strong) CropBorderViewForRecordScreen * cropBorderViewForRecordScreen;
@property (nonatomic, assign) CGRect contentRect;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) int dragMode;
@property (nonatomic, assign) CGPoint rectBeginPoint;
@property (nonatomic, assign) CGPoint rectEndPoint;
@property (nonatomic, assign) CGRect lastContentRectBeforeResize;
@property (nonatomic, weak) id<RecordScreenClipViewDelegate> delegate;
@property (nonatomic, strong) NSView * toolbarView;
@property (nonatomic, strong) NSView * indicatorField;
@property (nonatomic, strong) NSTextField * indicatorFieldWidth;
@property (nonatomic, strong) NSTextField * indicatorFieldHeight;
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
@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, assign) BOOL haveSetClearColor;
@property (nonatomic, strong) NSImage * fullImage;
@property (nonatomic, strong) CAShapeLayer * shapeLayer1;
@property (nonatomic, strong) CAShapeLayer * shapeLayer2;
@property (nonatomic, strong) CAShapeLayer * shapeLayer3;
@end
