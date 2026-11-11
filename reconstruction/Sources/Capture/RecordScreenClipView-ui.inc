- (void)setUpUI { // 0x10001f494
    CGRect rect=self.contentRect;
    self.contentView=[[NSView alloc] initWithFrame:rect]; self.contentView.wantsLayer=YES; [self addSubview:self.contentView];
    self.cropBorderViewForRecordScreen=[[CropBorderViewForRecordScreen alloc] initWithFrame:NSInsetRect(rect,-6,-6)];
    self.contentFrame=self.cropBorderViewForRecordScreen.frame;
    self.indicatorField=[[NSView alloc] initWithFrame:NSMakeRect(0,2,90,20)]; self.indicatorField.wantsLayer=YES; self.indicatorField.hidden=YES;
    self.indicatorField.layer.backgroundColor=[NSColor colorWithDeviceRed:43.0/255 green:171.0/255 blue:1 alpha:1].CGColor; self.indicatorField.layer.cornerRadius=4;
    self.indicatorFieldWidth=[[NSTextField alloc] initWithFrame:NSMakeRect(0,-1,38,20)];
    self.indicatorFieldWidth.stringValue=@""; self.indicatorFieldWidth.textColor=NSColor.whiteColor; self.indicatorFieldWidth.backgroundColor=NSColor.clearColor;
    self.indicatorFieldWidth.font=[NSFont systemFontOfSize:12]; self.indicatorFieldWidth.alphaValue=1; self.indicatorFieldWidth.alignment=1;
    self.indicatorFieldWidth.editable=NO; self.indicatorFieldWidth.bordered=NO; [self.indicatorField addSubview:self.indicatorFieldWidth];
    NSTextField *cross=[[NSTextField alloc] initWithFrame:NSMakeRect(38,1,10,20)]; cross.stringValue=@"x"; cross.textColor=NSColor.whiteColor;
    cross.editable=NO; cross.bordered=NO; cross.backgroundColor=NSColor.clearColor; [self.indicatorField addSubview:cross];
    self.indicatorFieldHeight=[[NSTextField alloc] initWithFrame:NSMakeRect(48,-1,38,20)];
    self.indicatorFieldHeight.stringValue=@""; self.indicatorFieldHeight.textColor=NSColor.whiteColor; self.indicatorFieldHeight.backgroundColor=NSColor.clearColor;
    self.indicatorFieldHeight.font=[NSFont systemFontOfSize:12]; self.indicatorFieldHeight.alphaValue=1; self.indicatorFieldHeight.alignment=1;
    self.indicatorFieldHeight.editable=NO; self.indicatorFieldHeight.bordered=NO; [self.indicatorField addSubview:self.indicatorFieldHeight]; [self addSubview:self.indicatorField];
    NSString *tip=[NSBundle.mainBundle localizedStringForKey:@"Click F to select FullScreen" value:@"" table:nil];
    NSSize size=IShotFunction_1000483f0(tip,12);
    self.tipView=[[NSView alloc] initWithFrame:NSMakeRect(10,10,size.width+25,size.height+20)]; self.tipView.wantsLayer=YES;
    self.tipView.layer.backgroundColor=NSColor.blackColor.CGColor; self.tipView.layer.cornerRadius=5;
    self.textFieldOfTipView=[[NSTextField alloc] initWithFrame:NSMakeRect(10,10,size.width+25,size.height)];
    self.textFieldOfTipView.stringValue=tip; self.textFieldOfTipView.backgroundColor=NSColor.blackColor;
    NSData *data=[NSUserDefaults.standardUserDefaults objectForKey:@"colorOfTipsText"];
    self.textFieldOfTipView.textColor=data?[NSKeyedUnarchiver unarchiveObjectWithData:data]:NSColor.redColor;
    self.textFieldOfTipView.editable=NO; self.textFieldOfTipView.bordered=NO; self.textFieldOfTipView.font=[NSFont systemFontOfSize:12];
    [self.tipView addSubview:self.textFieldOfTipView]; [self addSubview:self.tipView];
    CGRect screen=[(NSScreen *)[NSScreen currentScreenForMouseLocation] frame];
    CGEventRef event=CGEventCreate(NULL); CGPoint location=CGEventGetLocation(event); if(event)CFRelease(event);
    int x=(int)(location.x-screen.origin.x),y=(int)(screen.size.height-((screen.origin.y+(screen.size.height+location.y))-NSScreen.deepestScreen.frame.size.height));
    self.imageViewOfCursor=[[NSImageView alloc] initWithFrame:NSMakeRect(0,0,30,30)]; self.imageViewOfCursor.image=NSCursor.crosshairCursor.image;
    [self.imageViewOfCursor setFrameOrigin:NSMakePoint(x-13,y-15)]; [self addSubview:self.imageViewOfCursor]; self.imageViewOfCursor.hidden=YES;
    if(NSEqualRects(self.window.frame,screen))self.imageViewOfCursor.hidden=NO;
}
- (void)_resetIndicatorField { // 0x100020198; original single-precision placement calculations
    CGRect screen=[(NSScreen *)[NSScreen currentScreenForMouseLocation] frame], rect=NSInsetRect(self.contentRect,-6,-6);
    if(self.contentRect.size.width<1 || self.contentRect.size.height<1){self.indicatorField.hidden=YES;return;}
    self.indicatorField.hidden=NO; self.indicatorFieldWidth.stringValue=[NSString stringWithFormat:@"%.f",rect.size.width-12];
    self.indicatorFieldHeight.stringValue=[NSString stringWithFormat:@"%.f",rect.size.height-12];
    float left=fmaxf((float)rect.origin.x,-5),top=(float)(rect.origin.y+rect.size.height);
    double x,y=screen.size.height-20;
    if(top<=y){x=(double)(left+5.f); y=top;}
    else if(self.indicatorField.frame.size.width<(double)left)x=(double)left-self.indicatorField.frame.size.width-2;
    else{
        float right=(float)(rect.origin.x+rect.size.width);
        if(screen.size.width-self.indicatorField.frame.size.width>right)x=(double)(right-1.f);
        else {x=(double)(left+5.f); float bottom=(float)rect.origin.y; if(bottom>20)y=(double)(bottom-20.f);}
    }
    self.indicatorField.frame=NSMakeRect(x,y,self.indicatorField.frame.size.width,20);
}
