#import "CustomView.h"
#import "CustomScrollView.h"
#import "../Imaging/Imaging.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
extern NSMutableArray *IShotGlobal_1001ddcd0;
extern uint32_t IShotGlobal_1001ddd10;
extern BOOL IShotFunction_10004c448(NSArray *names);
#pragma clang fp contract(off)
@implementation CustomView
// 0x100009590; asynchronous start block 0x100009890.
- (instancetype)initWithFrame:(NSRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        if (!IShotGlobal_1001ddcd0) IShotGlobal_1001ddcd0=[NSMutableArray arrayWithCapacity:5];
        [IShotGlobal_1001ddcd0 addObject:self];
        _imageScale=1;
        self.wantsLayer=YES; self.layer.frame=self.frame;
        self.layer.cornerRadius=5; self.layer.masksToBounds=YES; self.layer.shadowOpacity=.5f;
        self.window.titlebarAppearsTransparent=YES;
        self.originFrame=self.frame; self.imageScale=100; self.maxImageScale=400;
        dispatch_async(dispatch_get_main_queue(), ^{ [self start]; });
        [self updateTrackingAreas];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowDidBecomeKey:) name:NSWindowDidBecomeKeyNotification object:self.window];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowDidResignKey:) name:NSWindowDidResignKeyNotification object:self.window];
    }
    return self;
}
- (void)windowDidResignKey:(NSNotification *)notification {
    if ([self.window isEqual:notification.object] && self.mapScrollView.enableShadow)
        _mapImageView.image=[NSImage resizeImage:self.image scale:(float)(self.maxImageScale/100) addShadowWithColor:[NSColor.shadowColor colorWithAlphaComponent:.5]];
}
- (void)windowDidBecomeKey:(NSNotification *)notification {
    if ([self.window isEqual:notification.object] && self.mapScrollView.enableShadow)
        _mapImageView.image=[NSImage resizeImage:self.image scale:(float)(self.maxImageScale/100) addShadowWithColor:[NSColor colorWithDeviceRed:0 green:(double).51f blue:(double).84f alpha:1]];
}
- (void)keyDown:(NSEvent *)event {
    if (event.keyCode==53 || (event.keyCode==13 && IShotFunction_10004c448(@[@"Command"]))) [self closePinWindow];
    else if (event.keyCode==49) { [self.mapScrollView annotate:self]; IShotGlobal_1001ddd10=(uint32_t)self.window.windowNumber; }
    else [_mapScrollView keyDown:event];
}
- (void)updateTrackingAreas {
    if (self.myTrackingArea) [self removeTrackingArea:self.myTrackingArea];
    self.myTrackingArea=[[NSTrackingArea alloc] initWithRect:self.bounds options:0x81 owner:self userInfo:nil];
    [self addTrackingArea:self.myTrackingArea];
}
- (void)mouseEntered:(NSEvent *)event {
    self.mouseEnter=YES;
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"showButtoninPinWindow"]) {
        self.closeButton.hidden=NO; self.helpButton.hidden=NO; self.sliderOfTransparent.hidden=NO;
    }
}
- (void)mouseExited:(NSEvent *)event {
    self.mouseEnter=NO; self.closeButton.hidden=YES; self.helpButton.hidden=YES;
    self.sliderOfTransparent.hidden=YES; self.transparencyTextField.hidden=YES;
}
- (void)closeButtonClick:(id)sender { [self closePinWindow]; }
- (void)adjustTransparencyOfPinImage:(id)sender {
    float value=[sender floatValue];
    self.transparencyTextField.stringValue=[NSString stringWithFormat:@"%@: %d",NSLocalizedString(@"Transparency",@""),(int)(value+.5)];
    self.transparencyTextField.hidden=NO;
    [self.transparencyTimer invalidate];
    self.transparencyTimer=[NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer) { self.transparencyTextField.hidden=YES; }];
    self.imageTransparency=(float)((float)(int)(value+.5)/-100.0+1.0);
    _mapImageView.alphaValue=self.imageTransparency;
}
- (void)helpButtonClick:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/pinpicture.html"]]; }
- (NSImage *)getImage { return _mapImageView.image; }
- (void)mouseDown:(NSEvent *)event {
    if (event.clickCount==2 && [NSUserDefaults.standardUserDefaults boolForKey:@"doubleClickToClosePin"]) [self closePinWindow];
}
// Original 0x10000b2d8 is RET.
- (void)drawRect:(NSRect)rect {}
- (void)dealloc { [NSNotificationCenter.defaultCenter removeObserver:self]; }
- (void)magnifyWithEvent:(NSEvent *)event {
    if (!self.mouseEnter) return;
    float value=(float)event.magnification;
    if (value==0) return;
    int sign=value>0?1:-1;
    float magnitude=fabsf(value*500.0f);
    int step=magnitude<6?1:magnitude<10?3:magnitude<20?8:15;
    self.imageScale+=sign*step;
    [self resize:self.imageScale];
}
- (void)closePinWindow {
    [self.window close];
    NSMutableArray *windows=IShotGlobal_1001ddcd0;
    for (NSUInteger i=0;i<windows.count;i++) {
        CustomView *view=windows[i];
        if (!view.window.visible) { [IShotGlobal_1001ddcd0 removeObject:view]; return; }
    }
}
// 0x100009ee4; geometry/register provenance: REA procedure_assembly.
- (void)start {
    NSInteger transparency=[NSUserDefaults.standardUserDefaults integerForKey:@"defaultTransparencyOfPin"];
    BOOL contains=NSPointInRect(NSEvent.mouseLocation,self.originFrame);
    _mapImageView=[[NSImageView alloc] init];
    _mapImageView.frame=NSMakeRect(0,0,self.frame.size.width,self.frame.size.height);
    NSSize imageSize=self.image.size;
    NSScreen *screen=[NSScreen currentScreenForMouseLocation];
    NSSize screenSize=screen.frame.size;
    if (imageSize.width>screenSize.width*2 && imageSize.height>screenSize.height*2) self.maxImageScale=100;
    else if (imageSize.width>screenSize.width*8 || imageSize.height>screenSize.height*8) self.maxImageScale=100;
    else if ((imageSize.width>screenSize.width*.9 && imageSize.height>screenSize.height*.9) || imageSize.width>screenSize.width*4 || imageSize.height>screenSize.height*4) self.maxImageScale=200;
    _mapImageView.image=[NSImage resizeImage:self.image scale:(float)(self.maxImageScale/100) addShadowWithColor:[NSColor colorWithDeviceRed:0 green:(double).51f blue:(double).84f alpha:1]];
    self.imageTransparency=(float)((float)transparency/-100.0+1.0);
    _mapImageView.alphaValue=self.imageTransparency;
    _mapImageView.autoresizingMask=0x12;
    _mapScrollView=[[CustomScrollView alloc] init];
    _mapScrollView.drawsBackground=NO;
    _mapScrollView.frame=NSMakeRect(0,0,self.frame.size.width,self.frame.size.height);
    [_mapScrollView addSubview:_mapImageView]; [self addSubview:_mapScrollView];
    self.scaleTextField=[[NSTextField alloc] init];
    self.scaleTextField.stringValue=@""; self.scaleTextField.textColor=NSColor.whiteColor;
    self.scaleTextField.backgroundColor=[NSColor colorWithDeviceRed:0 green:130.0/255.0 blue:213.0/255.0 alpha:.85];
    self.scaleTextField.font=[NSFont systemFontOfSize:12]; self.scaleTextField.alphaValue=.8;
    self.scaleTextField.editable=NO; self.scaleTextField.bordered=NO;
    [self.scaleTextField setFrameOrigin:NSMakePoint(self.frame.origin.x+self.frame.size.width*.5-self.scaleTextField.frame.size.width*.5,6)];
    [self addSubview:self.scaleTextField];
    self.closeButton=[[NSButton alloc] initWithFrame:NSMakeRect(8,self.frame.size.height-20-6-2,20,20)];
    self.closeButton.action=@selector(closeButtonClick:); self.closeButton.target=self;
    self.closeButton.image=[NSImage imageNamed:@"pindelte"]; self.closeButton.imagePosition=1;
    self.closeButton.imageScaling=3; self.closeButton.bordered=NO;
    if (!contains || ![NSUserDefaults.standardUserDefaults boolForKey:@"showButtoninPinWindow"]) self.closeButton.hidden=YES;
    self.closeButton.appearance=[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    [self addSubview:self.closeButton];
    NSString *label=NSLocalizedString(@"Transparency",@"");
    float labelWidth=(float)[[label stringByAppendingString:@": 1000"] sizeWithAttributes:@{NSFontAttributeName:[NSFont systemFontOfSize:12]}].width;
    self.transparencyTextField=[[NSTextField alloc] initWithFrame:NSMakeRect(self.frame.origin.x+self.frame.size.width*.5+(double)(labelWidth*-.5f)+3,self.frame.size.height-20-6-2-20,labelWidth,20)];
    self.transparencyTextField.stringValue=[NSString stringWithFormat:@"%@: %ld",label,transparency];
    self.transparencyTextField.backgroundColor=NSColor.clearColor;
    self.transparencyTextField.bordered=NO; self.transparencyTextField.editable=NO; self.transparencyTextField.hidden=YES;
    [self addSubview:self.transparencyTextField];
    self.sliderOfTransparent=[[NSSlider alloc] initWithFrame:NSMakeRect(self.frame.origin.x+self.frame.size.width*.5-50,self.frame.size.height-20-6-2,100,20)];
    self.sliderOfTransparent.controlSize=2; self.sliderOfTransparent.minValue=0; self.sliderOfTransparent.maxValue=100;
    self.sliderOfTransparent.integerValue=transparency; self.sliderOfTransparent.target=self;
    self.sliderOfTransparent.continuous=YES; self.sliderOfTransparent.action=@selector(adjustTransparencyOfPinImage:);
    if (!contains || ![NSUserDefaults.standardUserDefaults boolForKey:@"showButtoninPinWindow"]) self.sliderOfTransparent.hidden=YES;
    if (self.window.frame.size.width<160 || self.window.frame.size.height<60)
        self.sliderOfTransparent.frame=NSMakeRect(self.frame.origin.x+self.frame.size.width*.5-50-1000,self.frame.size.height-20-6-2,100,20);
    self.sliderOfTransparent.appearance=[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    [self addSubview:self.sliderOfTransparent];
    self.helpButton=[[NSButton alloc] initWithFrame:NSMakeRect(self.frame.size.width-6-2-20,self.frame.size.height-20-6-2,20,20)];
    self.helpButton.action=@selector(helpButtonClick:); self.helpButton.target=self;
    self.helpButton.image=[NSImage imageNamed:@"Help"]; self.helpButton.imagePosition=1;
    self.helpButton.imageScaling=3; self.helpButton.bordered=NO;
    if (!contains || ![NSUserDefaults.standardUserDefaults boolForKey:@"showButtoninPinWindow"]) self.helpButton.hidden=YES;
    self.helpButton.appearance=[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    [self addSubview:self.helpButton];
}
- (void)mouseUp:(NSEvent *)event {
    NSRect frame=self.window.frame, original=self.originFrame;
    self.originFrame=NSMakeRect(frame.origin.x+frame.size.width*.5-original.size.width*.5,frame.origin.y+frame.size.height*.5-original.size.height*.5,original.size.width,original.size.height);
}
- (void)scrollWheel:(NSEvent *)event {
    if (!self.mouseEnter) return;
    double amount=CGEventGetDoubleValueField(event.CGEvent,(CGEventField)96);
    float delta=(float)event.deltaY;
    if (delta==0) return;
    int raw=(int)amount, sign=delta>0?1:-1;
    uint32_t magnitude=raw<0?0u-(uint32_t)raw:(uint32_t)raw;
    if (!(event.modifierFlags&0x80000)) {
        int step=magnitude<6?1:magnitude<10?5:magnitude<20?10:magnitude<50?20:30;
        self.imageScale+=sign*step; [self resize:self.imageScale]; return;
    }
    int step=magnitude<6?1:magnitude<10?2:magnitude<30?5:magnitude<80?10:30;
    self.imageTransparency=(float)((double)(sign*step)/100.0+(double)self.imageTransparency);
    if ((double)self.imageTransparency<.1) self.imageTransparency=.1f;
    else if (!(self.imageTransparency<=1.f)) self.imageTransparency=1.f;
    _mapImageView.alphaValue=self.imageTransparency;
    self.sliderOfTransparent.intValue=(int)(100.f-self.imageTransparency*100.f);
    self.transparencyTextField.stringValue=[NSString stringWithFormat:@"%@: %.f",NSLocalizedString(@"Transparency",@""),(double)(100.f-self.imageTransparency*100.f)];
    self.transparencyTextField.hidden=NO;
    [self.transparencyTimer invalidate];
    self.transparencyTimer=[NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer) { self.transparencyTextField.hidden=YES; }];
}
- (void)resize:(int)value {
    CGEventRef event=CGEventCreate(NULL); CGPoint mouse=CGEventGetLocation(event); if (event) CFRelease(event);
    mouse.y=NSScreen.deepestScreen.frame.size.height-mouse.y;
    if (self.imageScale>self.maxImageScale) self.imageScale=self.maxImageScale;
    else {
        if ((int)(self.originFrame.size.width*self.imageScale/100.0)<60) self.imageScale=(int)(60.0/self.originFrame.size.width*100.0);
        if ((int)(self.originFrame.size.height*self.imageScale/100.0)<30) self.imageScale=(int)(30.0/self.originFrame.size.height*100.0);
    }
    int width=(int)(self.originFrame.size.width*self.imageScale/100.0);
    int height=(int)(self.originFrame.size.height*self.imageScale/100.0);
    NSRect frame=self.window.frame;
    double previousScale=(int)(frame.size.width/self.originFrame.size.width*100.0+.5);
    int x=(int)mouse.x-(int)((mouse.x-frame.origin.x)/previousScale*self.imageScale);
    int y=(int)mouse.y-(int)((mouse.y-frame.origin.y)/previousScale*self.imageScale);
    [self.window setFrame:NSMakeRect(x,y,width,height) display:NO]; [self updateAll];
}
- (void)scaleImageTo:(float)scale {
    self.imageScale=(int)(scale*100.f);
    NSRect frame=self.window.frame, original=self.originFrame;
    [self.window setFrame:NSMakeRect(frame.origin.x+frame.size.width*.5-original.size.width*(double)scale*.5,frame.origin.y+frame.size.height*.5-original.size.height*(double)scale*.5,original.size.width*(double)scale,original.size.height*(double)scale) display:NO];
    [self updateAll];
}
- (void)changeImage:(NSString *)direction {
    CIImage *input=[[CIImage alloc] initWithData:self.image.TIFFRepresentation];
    NSAffineTransform *transform=NSAffineTransform.transform;
    if ([direction isEqualToString:@"UpDown"]) [transform scaleXBy:1 yBy:-1];
    else if ([direction isEqualToString:@"LeftRight"]) [transform scaleXBy:-1 yBy:1];
    else if ([direction isEqualToString:@"turnLeft"]) [transform rotateByDegrees:90];
    else if ([direction isEqualToString:@"turnRight"]) [transform rotateByDegrees:-90];
    CIFilter *filter=[CIFilter filterWithName:@"CIAffineTransform"];
    [filter setValue:transform forKey:@"inputTransform"]; [filter setValue:input forKey:@"inputImage"];
    NSRect frame=self.window.frame;
    if (![direction isEqualToString:@"UpDown"] && ![direction isEqualToString:@"LeftRight"])
        frame=NSMakeRect(frame.origin.x+frame.size.width*.5-(int)(frame.size.height*.5),frame.origin.y+frame.size.height*.5-(int)(frame.size.width*.5),frame.size.height,frame.size.width);
    _mapImageView.frame=frame; _mapScrollView.frame=frame; [self.window setFrame:frame display:NO];
    [filter setValue:input forKey:@"inputImage"];
    CIImage *output=[filter valueForKey:@"outputImage"];
    CIContext *context=[[CIContext alloc] init];
    CGImageRef cg=[context createCGImage:output fromRect:output.extent];
    NSBitmapImageRep *rep=[[NSBitmapImageRep alloc] initWithCGImage:cg];
    NSImage *image=[[NSImage alloc] initWithSize:NSMakeSize(CGImageGetWidth(cg),CGImageGetHeight(cg))];
    [image addRepresentation:rep]; if (cg) CFRelease(cg); self.image=image;
    if ([direction isEqualToString:@"turnLeft"] || [direction isEqualToString:@"turnRight"]) {
        NSRect original=self.originFrame;
        self.originFrame=NSMakeRect(original.origin.y,original.origin.x,original.size.height,original.size.width);
    }
    [self updateAll];
    NSColor *color;
    if (!self.mapScrollView.enableShadow) color=NSColor.clearColor;
    else if (self.window.keyWindow) color=[NSColor colorWithDeviceRed:0 green:(double).51f blue:(double).84f alpha:1];
    else color=[NSColor.shadowColor colorWithAlphaComponent:.5];
    _mapImageView.image=[NSImage resizeImage:image scale:(float)(self.maxImageScale/100) addShadowWithColor:color];
}
- (void)updateAll {
    NSString *text;
    if (self.window.frame.size.width<=80) text=[NSString stringWithFormat:@" %d%@ ",self.imageScale,@"%"];
    else text=[NSString stringWithFormat:@" %@: %d%@ ",NSLocalizedString(@"Size",@""),self.imageScale,@"%"];
    double width=[text sizeWithAttributes:@{NSFontAttributeName:[NSFont systemFontOfSize:12]}].width;
    self.scaleTextField.hidden=NO;
    [self.scaleTextField setFrameSize:NSMakeSize(width+5,16)];
    [self.scaleTextField setFrameOrigin:NSMakePoint(self.frame.origin.x+self.frame.size.width*.5-self.scaleTextField.frame.size.width*.5,(self.imageScale*6)/100)];
    self.scaleTextField.stringValue=text;
    _mapImageView.frame=NSMakeRect(0,0,self.window.frame.size.width,self.window.frame.size.height);
    _mapScrollView.frame=NSMakeRect(0,0,self.window.frame.size.width,self.window.frame.size.height);
    self.closeButton.frame=NSMakeRect(8,self.frame.size.height-20-6-2,20,20);
    double x=self.frame.origin.x+self.frame.size.width*.5-50;
    if (!(self.window.frame.size.width>160 && self.window.frame.size.height>60)) x-=1000;
    self.sliderOfTransparent.frame=NSMakeRect(x,self.frame.size.height-20-6-2,100,20);
    int labelWidth=(int)self.transparencyTextField.frame.size.width;
    self.transparencyTextField.frame=NSMakeRect(self.frame.origin.x+self.frame.size.width*.5-labelWidth/2+3,self.frame.size.height-20-6-2-20,labelWidth,20);
    self.helpButton.frame=NSMakeRect(self.frame.size.width-6-2-20,self.frame.size.height-20-6-2,20,20);
    [self updateTrackingAreas]; [self.scaleTimer invalidate];
    self.scaleTimer=[NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer) { self.scaleTextField.hidden=YES; }];
}
@end
