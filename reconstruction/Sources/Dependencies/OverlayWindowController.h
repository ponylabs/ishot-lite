#import <AppKit/AppKit.h>
#import "LCAuthGuideHostApp.h"
@interface PassiveOverlayPanel : NSPanel
- (BOOL)canBecomeKey;
- (BOOL)canBecomeMain;
@end
@interface OverlayWindowController : NSWindowController {
    double _windowWidth,_minWindowHeight,_launchAnimationDuration,_launchAnimationResponse,_launchAnimationDampingFraction,_initialAlpha;
    NSTimer *_launchTimer;
    double _launchStartTime;
    NSRect _launchFromFrame,_launchToFrame;
    BOOL _isAnimatingLaunch;
}
- (instancetype)initWithHostApp:(LCAuthGuideHostApp *)app type:(NSInteger)type onBack:(void (^)(void))back;
- (NSSize)windowSize;
- (void)presentFromSourceFrame:(NSRect)source settingsFrame:(NSRect)settings visibleFrame:(NSRect)visible;
- (void)updatePositionWithSettingsFrame:(NSRect)settings visibleFrame:(NSRect)visible;
- (void)hide;
- (void)configureWindow:(NSWindow *)window;
- (void)stepLaunchAnimation;
- (void)stopLaunchAnimation;
- (double)springProgressAt:(double)time;
- (NSRect)curvedFrameFrom:(NSRect)from to:(NSRect)to progress:(double)progress;
- (NSPoint)anchoredOriginForSettingsFrame:(NSRect)settings visibleFrame:(NSRect)visible isAlignRight:(BOOL)right;
- (void)updateWindowSize;
@end
