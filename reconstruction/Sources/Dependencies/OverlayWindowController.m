#import "OverlayWindowController.h"
#import "OverlayContentView.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>
@implementation PassiveOverlayPanel
- (BOOL)canBecomeKey { return NO; }
- (BOOL)canBecomeMain { return NO; }
@end
static double IShotOverlayWidth_1001f1b68;
@implementation OverlayWindowController
- (instancetype)initWithHostApp:(LCAuthGuideHostApp *)app type:(NSInteger)type onBack:(void (^)(void))back {
    if(@available(macOS 13,*)) IShotOverlayWidth_1001f1b68=500;else IShotOverlayWidth_1001f1b68=400;
    _windowWidth=IShotOverlayWidth_1001f1b68;_minWindowHeight=110;_launchAnimationDuration=0.72;_launchAnimationResponse=0.72;_launchAnimationDampingFraction=1;_initialAlpha=0.9;
    PassiveOverlayPanel *window=[[PassiveOverlayPanel alloc] initWithContentRect:NSMakeRect(0,0,IShotOverlayWidth_1001f1b68,110) styleMask:0x80 backing:2 defer:NO];
    if((self=[super initWithWindow:window])) {
        [self configureWindow:window];OverlayContentView *content=[[OverlayContentView alloc] initWithHostApp:app permissionType:type onBack:back];content.windowWidth=_windowWidth;[content.widthAnchor constraintEqualToConstant:_windowWidth].active=YES;window.contentView=content;dispatch_async(dispatch_get_main_queue(),^{[self updateWindowSize];});
    }return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder { [NSException raise:@"NSInvalidArgumentException" format:@"initWithCoder: 未实现"];return nil; }
- (NSSize)windowSize { NSView *content=self.window.contentView;double height=_minWindowHeight;if(content) {double fitted=content.fittingSize.height;if(height<=fitted)height=fitted;}return NSMakeSize(_windowWidth,height); }
- (void)close { [self stopLaunchAnimation];[self.window orderOut:nil];[super close]; }
- (void)presentFromSourceFrame:(NSRect)source settingsFrame:(NSRect)settings visibleFrame:(NSRect)visible {
    [self stopLaunchAnimation];NSWindow *window=self.window;if(window) {
        NSPoint origin=[self anchoredOriginForSettingsFrame:settings visibleFrame:visible isAlignRight:YES];NSSize size=self.windowSize;NSRect target=NSMakeRect(origin.x,origin.y,size.width,size.height);
        if(!NSIsEmptyRect(source)) {
            _isAnimatingLaunch=YES;_launchFromFrame=source;_launchToFrame=target;_launchStartTime=CACurrentMediaTime();window.alphaValue=_initialAlpha;[window setFrame:source display:NO];[window orderFrontRegardless];[self stepLaunchAnimation];_launchTimer=[NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(stepLaunchAnimation) userInfo:nil repeats:YES];
        }else {_isAnimatingLaunch=NO;window.alphaValue=1;[window setFrame:target display:NO];[window orderFrontRegardless];}
    }
}
- (void)updatePositionWithSettingsFrame:(NSRect)settings visibleFrame:(NSRect)visible {
    NSWindow *window=self.window;if(window) {NSPoint origin=[self anchoredOriginForSettingsFrame:settings visibleFrame:visible isAlignRight:YES];_launchToFrame.origin=origin;if(!_isAnimatingLaunch){[window setFrameOrigin:origin];[window orderFrontRegardless];}}
}
- (void)hide { _isAnimatingLaunch=NO;[self stopLaunchAnimation];[self.window orderOut:nil]; }
- (void)configureWindow:(NSWindow *)window { window.opaque=NO;window.backgroundColor=NSColor.clearColor;window.level=25;window.hasShadow=YES;window.hidesOnDeactivate=NO;window.collectionBehavior=0x151;window.animationBehavior=2; }
- (void)stepLaunchAnimation {
    NSWindow *window=self.window;if(!window){[self stopLaunchAnimation];return;}
    double elapsed=CACurrentMediaTime()-_launchStartTime;NSRect frame;
    if(_launchAnimationDuration<=elapsed) {_isAnimatingLaunch=NO;[self stopLaunchAnimation];window.alphaValue=1;frame=_launchToFrame;}
    else {double progress=[self springProgressAt:elapsed];window.alphaValue=_initialAlpha+progress*(1-_initialAlpha);frame=[self curvedFrameFrom:_launchFromFrame to:_launchToFrame progress:progress];}
    [window setFrame:frame display:YES];
}
- (void)stopLaunchAnimation { [_launchTimer invalidate];_launchTimer=nil; }
- (double)springProgressAt:(double)t {
    t=fmax(t,0);double p;
    if(!(fabs(_launchAnimationDampingFraction-1)<0.0001)) {p=t/_launchAnimationDuration;if(1<p)p=1;}
    else {double omega=6.283185307179586/_launchAnimationResponse;p=1-exp(t*-omega)*(t*omega+1);}
    if(p<=0)p=0;return fmin(p,1);
}
- (NSRect)curvedFrameFrom:(NSRect)from to:(NSRect)to progress:(double)t {
    double width=from.size.width+(to.size.width-from.size.width)*t,height=from.size.height+(to.size.height-from.size.height)*t;
    double x0=from.origin.x+from.size.width*0.5,y0=from.origin.y+from.size.height*0.5,x1=to.origin.x+to.size.width*0.5,y1=to.origin.y+to.size.height*0.5;
    double top=y1;if(y1<=y0)top=y0;double lift=hypot(x1-x0,y1-y0)*0.18;if(lift<=44)lift=44;if(140<lift)lift=140;
    double u=1-t,twice=(u+u)*t;
    return NSMakeRect((t*t*x1+x0*u*u+twice*(x0+x1)*0.5)-width*0.5,(t*t*y1+y0*u*u+twice*(top+lift))-height*0.5,width,height);
}
- (NSPoint)anchoredOriginForSettingsFrame:(NSRect)settings visibleFrame:(NSRect)visible isAlignRight:(BOOL)right {
    double y=settings.origin.y-self.windowSize.height;NSSize size=self.windowSize;double x;
    if(right)x=(settings.origin.x+settings.size.width)-size.width;
    else {double available=settings.size.width-170;if(available<size.width)available=size.width;x=settings.origin.x+170+(available-size.width)*0.5-8;}
    double minX=visible.origin.x+8,maxX=(visible.origin.x+visible.size.width)-size.width-8,minY=visible.origin.y+8,maxY=(visible.origin.y+visible.size.height)-size.height-8;
    x=x<minX?minX:x;x=x<maxX?x:maxX;y=y<minY?minY:y;y=y<maxY?y:maxY;return NSMakePoint(x,y);
}
- (void)updateWindowSize { NSWindow *window=self.window;NSView *content=window.contentView;if(window && content){double height=_minWindowHeight,fitted=content.fittingSize.height;if(height<=fitted)height=fitted;[window setContentSize:NSMakeSize(_windowWidth,height)];} }
@end
