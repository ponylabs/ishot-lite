- (void)addCameraWindow { // 0x10001e36c, FP arguments checked against arm64
    if(!(self.contentRect.size.width>120))return;
    if(!(self.contentRect.size.height>67.5))return;
    if(!IShotGlobal_1001ddd68){
        IShotGlobal_1001ddd68=[[CameraWindowController alloc] init];
        double y=self.contentRect.origin.y;
        (void)self.window.screen.frame;
        y+=self.window.screen.frame.origin.y;
        CGRect rect=self.contentRect;
        [IShotGlobal_1001ddd68.window setFrameOrigin:CGPointMake(rect.origin.x+rect.size.width-120,y)];
        [IShotGlobal_1001ddd68.window makeKeyAndOrderFront:self];
        IShotPreviousCameraConstraint_1001ddd70=self.contentRect;
        IShotPreviousCameraConstraint_1001ddd70.origin.x+=self.window.screen.frame.origin.x;
        IShotPreviousCameraConstraint_1001ddd70.origin.y+=self.window.screen.frame.origin.y;
        if(self.contentRect.size.width>240 && self.contentRect.size.height>135)
            [IShotGlobal_1001ddd68.window setFrame:CGRectMake(IShotPreviousCameraConstraint_1001ddd70.origin.x+IShotPreviousCameraConstraint_1001ddd70.size.width-240,IShotPreviousCameraConstraint_1001ddd70.origin.y,240,135) display:NO];
    }
    IShotRecordScreenRect_1001ddd90=self.contentRect;
    IShotRecordScreenRect_1001ddd90.origin.x+=self.window.screen.frame.origin.x;
    IShotRecordScreenRect_1001ddd90.origin.y+=self.window.screen.frame.origin.y;
}
- (void)closeCameraWindow { // 0x10001e6bc
    if(IShotGlobal_1001ddd68){[IShotGlobal_1001ddd68.window.contentView removeFromSuperview]; [IShotGlobal_1001ddd68.window close]; IShotGlobal_1001ddd68=nil;}
}
- (void)recordFullScreen { // 0x10001e754
    [NSCursor unhide]; [self.delegate recordViewDidShowToolBar:self];
    CGRect border=CGRectMake(-6,-6,self.window.frame.size.width+12,self.window.frame.size.height+12);
    self.cropBorderViewForRecordScreen.frame=border; self.contentRect=NSInsetRect(border,6,6);
    self.onlyClipCurrentWindow=YES; [self _resetIndicatorField]; [self reFreshShapeLayer1]; [self reFreshShapeLayer2];
    self.shapeLayer3.hidden=YES; self.imageViewOfCursor.hidden=YES; self.scrollViewOfColorPicker.hidden=YES; self.tipView.hidden=YES;
    IShotGlobal_1001ddd58=YES; [self addSubview:self.toolbarView];
    double y=self.cropBorderViewForRecordScreen.frame.origin.y+25;
    CGRect r=self.cropBorderViewForRecordScreen.frame;
    double x=r.origin.x+r.size.width*.5-self.toolbarView.bounds.size.width*.5;
    self.toolbarView.frame=CGRectMake(x,y,self.toolbarView.frame.size.width,self.toolbarView.frame.size.height);
    self.toolbarView.alphaValue=1; self.toolbarView.accessibilityFrame=self.cropBorderViewForRecordScreen.frame;
    self.toolbarView.hidden=NO; self.clipState=3; IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set];
    if(![[NSUserDefaults.standardUserDefaults objectForKey:@"selectedCameraOfRecordScreen"] isEqualToString:@"None"])[self addCameraWindow];
}
