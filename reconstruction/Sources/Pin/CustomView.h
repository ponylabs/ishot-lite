#import <Cocoa/Cocoa.h>
@class CustomScrollView;
@interface CustomView : NSView
@property (nonatomic, strong) NSImage * image;
@property (nonatomic) NSRect originFrame;
@property (nonatomic, strong) NSTextField * scaleTextField;
@property (nonatomic, strong) NSImageView * mapImageView;
@property (nonatomic, strong) CustomScrollView * mapScrollView;
@property (nonatomic) BOOL mouseEnter;
@property (nonatomic) int imageScale;
@property (nonatomic) int maxImageScale;
@property (nonatomic) float imageTransparency;
@property (nonatomic, strong) NSTrackingArea * myTrackingArea;
@property (nonatomic, strong) NSButton * helpButton;
@property (nonatomic, strong) NSSlider * sliderOfTransparent;
@property (nonatomic, strong) NSButton * closeButton;
@property (nonatomic, strong) NSTextField * transparencyTextField;
@property (nonatomic, strong) NSTimer * transparencyTimer;
@property (nonatomic, strong) NSTimer * scaleTimer;
- (void)start;
- (void)resize:(int)value;
- (void)updateAll;
- (void)scaleImageTo:(float)scale;
- (void)changeImage:(NSString *)direction;
- (void)closePinWindow;
- (NSImage *)getImage;
@end
