// Original method addresses accompany each implementation. Included inside @implementation.
- (void)dealloc {} // 0x100024784: only super dealloc; ARC supplies it.
- (void)setFrame:(CGRect)frame { // 0x1000247b8
    [super setFrame:frame];
    CGRect content = self.contentRect;
    self.contentView.frame = content;
    self.cropBorderView.frame = NSMakeRect(content.origin.x-6,content.origin.y-6,content.size.width+12,content.size.height+12);
    self.contentFrame = self.cropBorderView.frame;
}
- (void)disableTextView { // 0x1000248c0
    [self.window makeFirstResponder:self]; [self updateTrackingAreas];
    IShotGlobal_1001ddde8 = nil; self.needsDisplay = YES;
}
- (id)initWithFrame:(CGRect)frame type:(unsigned long long)type { // 0x1000257dc
    self = [super initWithFrame:frame];
    if (self) {
        self.overlayAlpha=.5; self.onlyClipCurrentWindow=!IShotGlobal_1001de181;
        self.multiWindowScreenshots=NO; self.type=type;
        IShotGlobal_1001dde68=NO;
        IShotGlobal_1001f18cc=NO; IShotGlobal_1001f18cd=NO; IShotGlobal_1001f18ce=NO;
    }
    return self;
}
- (void)CaptureFullScreen { // 0x100025888
    NSScreen *screen=self.window.screen;
    if (!screen) screen=[NSScreen currentScreenForMouseLocation];
    CGImageRef image=IShotCGDisplayCreateImage([screen.deviceDescription[@"NSScreenNumber"] unsignedIntValue]);
    self.fullImage=[[NSImage alloc] initWithCGImage:image size:screen.frame.size];
    if (!IShotGlobal_1001de180 && image) {
        NSWindow *window=self.window;
        window.backgroundColor=[NSColor colorWithPatternImage:[[NSImage alloc] initWithCGImage:image size:screen.frame.size]];
    }
    if (image) CFRelease(image);
    [self.window orderFront:self]; IShotGlobal_1001dde70=@"cursorNull";
}
- (void)showClipViewWithFrame:(CGRect)frame withToolbar:(id)toolbar { // 0x100026c48
    [self setUpShapeLayer]; [self reFreshShapeLayer1]; self.clipState=0;
    self.contentRect=frame; self.toolbarView=toolbar; self.toolbarView.alphaValue=0;
    [self setUpUI]; if (IShotGlobal_1001de182) [self presetAreaSizeModeScreenShot];
}
- (void)setFrameForContentView:(CGRect)rect { // 0x100026d2c
    CGRect integral=CGRectMake((int)rect.origin.x,(int)rect.origin.y,(int)rect.size.width,(int)rect.size.height);
    self.contentRect=integral; self.contentView.frame=integral; [self _resetIndicatorField];
}
- (void)refreshColorPickerImageView { // 0x100026dc0; block 0x100026f94
    if (self.scrollViewOfColorPicker.hidden) self.scrollViewOfColorPicker.hidden=NO;
    CGEventRef event=CGEventCreate(NULL); CGPoint point=CGEventGetLocation(event);
    if (event) CFRelease(event);
    double now=NSDate.date.timeIntervalSince1970;
    if (now-IShotGlobal_1001f18d8>.05) {
        NSEvent *current=NSApp.currentEvent;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,50000000),dispatch_get_main_queue(), ^{
            [self.colorPickerImageView mouseDragged:current];
        });
        IShotGlobal_1001f18d8=now;
    }
    [self.scrollViewOfColorPicker setFrameOrigin:[self getPositionOfDragging:point]];
}
- (BOOL)acceptsFirstResponder { return YES; } // 0x100026fd0
- (CGSize)getCurrentScreenSize { return [NSScreen currentScreenForMouseLocation].frame.size; } // 0x100031748
- (void)refreshContentRectByMove:(CGPoint)point { // 0x10003179c; vector casts checked against asm
    CGSize screen=[self getCurrentScreenSize];
    int x=(int)(int64_t)((point.x+_contentRect.origin.x)-_startPoint.x);
    int y=(int)(int64_t)((point.y+_contentRect.origin.y)-_startPoint.y);
    if (x<0) x=0; if (y<0) y=0;
    if (screen.width<_contentRect.size.width+(double)x) x=(int)(int64_t)(screen.width-_contentRect.size.width);
    if (screen.height<_contentRect.size.height+(double)y) y=(int)(int64_t)(screen.height-_contentRect.size.height);
    _contentRect.origin=CGPointMake(x,y); _startPoint=CGPointMake((int)point.x,(int)point.y);
}
- (void)_resetFramesToThisOne:(CGRect)rect { // 0x100031a78
    if (self.scrollViewOfColorPicker.hidden) self.scrollViewOfColorPicker.hidden=NO;
    _cropBorderView.frame=rect;
}
- (CGPoint)fetchLocationFromScreen:(CGPoint)point { // 0x100031b20
    return [self.window convertRectFromScreen:CGRectMake(point.x,point.y,0,0)].origin;
}
- (void)setOverlayAlpha:(double)alpha { _overlayAlpha=alpha; self.needsDisplay=YES; } // 0x100032ffc
- (void)setContentFrame:(CGRect)frame { // 0x100033010; NSInsetRect d4=d5=6
    self.contentRect=NSInsetRect(frame,6,6); _contentFrame=frame;
    self.cropBorderView.frame=frame; self.contentView.frame=self.contentRect;
    self.needsDisplay=YES;
}
+ (id)defaultAnimationForKey:(id)key { // 0x1000330f4
    if ([key isEqualToString:@"contentFrame"] || [key isEqualToString:@"overlayAlpha"]) return [CABasicAnimation animation];
    return [super defaultAnimationForKey:key];
}
- (void)makeForcusLater { [self.window makeFirstResponder:IShotGlobal_1001de058[@"textView"]]; } // 0x100033198
- (void)selectedWindowChanged { // 0x100033b4c
    [self reFreshShapeLayer1]; [self reFreshShapeLayer2]; self.shapeLayer2.hidden=YES;
}
- (void)setUpShapeLayer {} // 0x100033b94: original ret
- (void)adjustRadius:(id)sender { // 0x100034020
    _radiusOfFrame=IShotFunction_10004c930([sender intValue]);
    self.cropBorderView.borderRadius=(float)self.radiusOfFrame; [self reFreshShapeLayer1];
}
- (void)checkShadow:(id)sender { // 0x100034090
    [NSUserDefaults.standardUserDefaults setBool:[sender state]!=0 forKey:@"needShadow"];
}
- (void)scrollFinished {} // 0x1000349f0: original ret
