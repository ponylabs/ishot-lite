- (void)fullScreenCapture { // 0x10002b810
    [NSCursor unhide]; self.onlyClipCurrentWindow=NO; self.cropBorderView.onlyClipCurrentWindow=YES;
    self.cropBorderView.frame=CGRectMake(-6,-6,self.window.frame.size.width+12,self.window.frame.size.height+12);
    [self addSubview:self.cropBorderView]; [self.tipView removeFromSuperview]; [self.scrollViewOfColorPicker removeFromSuperview];
    [self.shapeLayer3 removeFromSuperlayer]; self.imageViewOfCursor.image=nil;
    self.contentFrame=_cropBorderView.frame; [self reFreshShapeLayer1];
    if (!IShotGlobal_1001de088) {
        IShotGlobal_1001de090=@""; [IShotGlobal_1001de160 setAnnotatedImageViewFrame:self.contentRect];
        [IShotGlobal_1001de160 openWindow]; IShotGlobal_1001dde80=[NSScreen currentScreenForMouseLocation];
        [self changFullImageToMosaicImage];
        if (NSScreen.screens.count>1) [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"startAnnotation" object:nil userInfo:nil];
    }
}
- (void)previousScreenshotAreaCapture { // 0x10002bab0; block 0x10002bf14
    CGRect rect=NSRectFromString([NSUserDefaults.standardUserDefaults stringForKey:@"previousScreenshotArea"]);
    if (NSEqualRects(rect,NSZeroRect)) { NSBeep(); return; }
    [NSCursor unhide]; IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set];
    self.onlyClipCurrentWindow=NO; self.cropBorderView.onlyClipCurrentWindow=NO;
    self.sliderOfRadiusOfFrame.enabled=YES;
    self.radiusOfFrame=[[NSUserDefaults.standardUserDefaults objectForKey:@"sizeOfImageFillet"] intValue];
    if (!(rect.origin.x+rect.size.width<=self.window.frame.size.width)) rect.origin.x=self.window.frame.size.width-rect.size.width;
    if (!(rect.origin.y+rect.size.height<=self.window.frame.size.height)) rect.origin.y=self.window.frame.size.height-rect.size.height;
    self.cropBorderView.frame=rect; [self addSubview:self.cropBorderView];
    [self.tipView removeFromSuperview]; [self.scrollViewOfColorPicker removeFromSuperview]; [self.shapeLayer3 removeFromSuperlayer]; self.imageViewOfCursor.image=nil;
    self.contentFrame=_cropBorderView.frame; [self reFreshShapeLayer1]; [self reFreshShapeLayer2]; [self _resetIndicatorField];
    if (!IShotGlobal_1001de088) {
        IShotGlobal_1001de090=@""; [IShotGlobal_1001de160 setAnnotatedImageViewFrame:self.contentRect];
        [IShotGlobal_1001de160 openWindow]; IShotGlobal_1001dde80=[NSScreen currentScreenForMouseLocation];
        [self changFullImageToMosaicImage];
        if (NSScreen.screens.count>1) [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"startAnnotation" object:nil userInfo:nil];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,50000000),dispatch_get_main_queue(),^{ [NSApp activateIgnoringOtherApps:YES]; });
}
- (void)presetAreaSizeModeScreenShot { // 0x10002bf28
    [NSCursor unhide]; self.onlyClipCurrentWindow=NO; self.cropBorderView.onlyClipCurrentWindow=NO;
    NSInteger width=[NSUserDefaults.standardUserDefaults integerForKey:@"widthOfPresetAreaSizeScreenshots"];
    if (self.window.frame.size.width<(double)width) width=(NSInteger)self.window.frame.size.width;
    if (width<2) width=1;
    NSInteger height=[NSUserDefaults.standardUserDefaults integerForKey:@"heightOfPresetAreaSizeScreenshots"];
    if (self.window.frame.size.height<(double)height) height=(NSInteger)self.window.frame.size.height;
    if (height<2) height=1;
    self.cropBorderView.frame=CGRectMake((self.window.frame.size.width-width)*.5-6,(self.window.frame.size.height-height)*.5-6,width+12,height+12);
    [self addSubview:self.cropBorderView]; [self.tipView removeFromSuperview]; [self.scrollViewOfColorPicker removeFromSuperview];
    [self.shapeLayer3 removeFromSuperlayer]; self.imageViewOfCursor.image=nil;
    self.contentFrame=_cropBorderView.frame; [self reFreshShapeLayer1]; [self reFreshShapeLayer2]; [self _resetIndicatorField];
    if (!IShotGlobal_1001de088) {
        IShotGlobal_1001de090=@""; [IShotGlobal_1001de160 setAnnotatedImageViewFrame:self.contentRect];
        [IShotGlobal_1001de160 openWindow]; IShotGlobal_1001dde80=[NSScreen currentScreenForMouseLocation];
        [self changFullImageToMosaicImage];
    }
}
- (void)refreshIndicatorFieldSize { // 0x10002c2d0
    NSScreen *screen=self.window.screen;
    NSCharacterSet *invalid=[[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString *width=[[self.indicatorFieldWidth.string componentsSeparatedByCharactersInSet:invalid] componentsJoinedByString:@""];
    if (screen.frame.size.width<(double)width.intValue) width=[NSString stringWithFormat:@"%.f",screen.frame.size.width];
    NSString *height=[[self.indicatorFieldHeight.string componentsSeparatedByCharactersInSet:invalid] componentsJoinedByString:@""];
    if (screen.frame.size.height<(double)height.intValue) height=[NSString stringWithFormat:@"%.f",screen.frame.size.height];
    if (![width isEqualToString:self.indicatorFieldWidth.string] || ![height isEqualToString:self.indicatorFieldHeight.string]) {
        self.indicatorFieldWidth.string=width; self.indicatorFieldHeight.string=height;
    }
    if (width.length && height.length) {
        NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
        self.indicatorFieldWidth.string=width; self.indicatorFieldHeight.string=height;
        CGRect rect=self.contentFrame; rect.size.width=(int)((uint32_t)width.intValue+12); rect.size.height=(int)((uint32_t)height.intValue+12);
        if (!(rect.origin.y+rect.size.height<=screen.frame.size.height)) rect.origin.y=screen.frame.size.height-rect.size.height+6;
        if (!(rect.origin.x+rect.size.width<=screen.frame.size.width)) rect.origin.x=screen.frame.size.width-rect.size.width+6;
        self.cropBorderView.frame=rect; self.contentRect=rect; self.contentFrame=rect;
        [self reFreshShapeLayer1]; [self reFreshShapeLayer2]; [self _resetIndicatorField];
        [IShotGlobal_1001de160 setAnnotatedImageViewFrame:self.contentRect];
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"unhiddenButtonOfClipToolbarWindow" object:nil userInfo:nil];
        [defaults setObject:width forKey:@"IndicatorFieldWidth"]; [defaults setObject:height forKey:@"IndicatorFieldHeight"];
        [self.window makeFirstResponder:self];
    }
}
- (void)startAnnotation { // 0x10002c84c
    if (!IShotGlobal_1001ddfb8 && !IShotGlobal_1001de180) return;
    [IShotGlobal_1001de148 removeAllObjects]; IShotGlobal_1001ddec0=0;
    if (!self.imageViewOfCursor.hidden) self.imageViewOfCursor.hidden=YES;
    BOOL mapping=IShotGlobal_1001ddfb8;
    CGRect rect;
    if (mapping) rect=CGRectMake(IShotGlobal_1001ddd18,IShotGlobal_1001ddd20,IShotGlobal_1001ddd28,IShotGlobal_1001ddd30);
    else rect=CGRectMake(IShotGlobal_1001dddb8,IShotGlobal_1001dddc0,IShotGlobal_1001dddc8,IShotGlobal_1001dddd0);
    self.cropBorderView=[[GKCropBorderView alloc] initWithFrame:NSInsetRect(rect,-6,-6)];
    [self addSubview:self.cropBorderView]; self.onlyClipCurrentWindow=YES; self.cropBorderView.onlyClipCurrentWindow=YES;
    self.contentFrame=rect;
    self.layer.backgroundColor=[NSColor colorWithWhite:mapping?0:1 alpha:0].CGColor;
    self.clipState=3; [self changFullImageToMosaicImage];
    if (mapping) { IShotGlobal_1001dde80=[NSScreen currentScreenForMouseLocation]; [self reFreshShapeLayer1]; }
    else IShotGlobal_1001dde80=self.window.screen;
    [self.window makeKeyAndOrderFront:nil]; IShotGlobal_1001de090=@"";
    if (mapping) rect=CGRectMake(IShotGlobal_1001ddd18,IShotGlobal_1001ddd20,IShotGlobal_1001ddd28,IShotGlobal_1001ddd30);
    else rect=CGRectMake(IShotGlobal_1001dddb8,IShotGlobal_1001dddc0,IShotGlobal_1001dddc8,IShotGlobal_1001dddd0);
    [IShotGlobal_1001de160 setAnnotatedImageViewFrame:rect]; [IShotGlobal_1001de160 openWindow];
}
