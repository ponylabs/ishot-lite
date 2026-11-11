- (void)setFrame:(CGRect)frame { // 0x10001cb1c
    [super setFrame:frame]; CGRect rect=self.contentRect; self.contentView.frame=rect;
    self.cropBorderViewForRecordScreen.frame=NSInsetRect(rect,-6,-6);
    self.contentFrame=self.cropBorderViewForRecordScreen.frame;
}
- (id)initWithFrame:(CGRect)frame type:(unsigned long long)type { // 0x10001cc24
    self=[super initWithFrame:frame]; if(self){self.overlayAlpha=.5; self.onlyClipCurrentWindow=YES; self.type=type;} return self;
}
- (void)showClipViewWithFrame:(CGRect)frame withToolbar:(id)toolbar { // 0x10001cc94
    [self setUpShapeLayer]; [self reFreshShapeLayer1]; self.clipState=0; self.contentRect=frame;
    self.toolbarView=toolbar; self.toolbarView.alphaValue=0; [self setUpUI];
}
- (void)setFrameForContentView:(CGRect)rect { // 0x10001cd4c
    rect=CGRectMake((int)rect.origin.x,(int)rect.origin.y,(int)rect.size.width,(int)rect.size.height);
    self.contentRect=rect; self.contentView.frame=rect; [self _resetIndicatorField];
}
- (void)refreshColorPickerImageView { // 0x10001cde0; block 0x10001cfb4
    if(self.scrollViewOfColorPicker.hidden)self.scrollViewOfColorPicker.hidden=NO;
    CGEventRef event=CGEventCreate(NULL); CGPoint location=CGEventGetLocation(event); if(event)CFRelease(event);
    double now=NSDate.date.timeIntervalSince1970;
    if(now-IShotRecordClip_1001f18b8>.05){
        NSEvent *current=NSApp.currentEvent;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,50000000),dispatch_get_main_queue(),^{[self.colorPickerImageView mouseDragged:current];});
        IShotRecordClip_1001f18b8=now;
    }
    [self.scrollViewOfColorPicker setFrameOrigin:[self getPositionOfDragging:location]];
}
- (BOOL)acceptsFirstResponder { return YES; } // 0x10001cff0
- (void)rightMouseUp:(id)event { [super rightMouseUp:event]; } // 0x10001ddd4
- (void)flagsChanged:(id)event {} // 0x10001f48c RET
- (void)keyDown:(id)event {} // 0x10001f490 RET
- (CGPoint)fetchLocationFromScreen:(CGPoint)point { return [self.window convertRectFromScreen:CGRectMake(point.x,point.y,0,0)].origin; } // 0x100020838
- (void)drawRect:(CGRect)rect { [super drawRect:rect]; } // 0x10002089c
- (void)setOverlayAlpha:(double)alpha { _overlayAlpha=alpha; self.needsDisplay=YES; } // 0x1000208d0
- (void)setContentFrame:(CGRect)frame { // 0x1000208e4
    self.contentRect=NSInsetRect(frame,6,6); _contentFrame=frame;
    self.cropBorderViewForRecordScreen.frame=frame; self.contentView.frame=self.contentRect; self.needsDisplay=YES;
}
- (void)selectedWindowChanged { [self reFreshShapeLayer1]; [self reFreshShapeLayer2]; self.shapeLayer2.hidden=YES; } // 0x100020d98
