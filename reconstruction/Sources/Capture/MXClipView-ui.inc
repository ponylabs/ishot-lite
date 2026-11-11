- (void)changeCursorToCreateNew { // 0x10002fdc0
    IShotGlobal_1001dde70=@"cursorCreateNew"; IShotGlobal_1001dddf8=IShotGlobal_1001de0e0; [IShotGlobal_1001de0e0 set];
}
- (void)setUpUI { // 0x10002fe0c
    IShotGlobal_1001de0c1=NO; IShotGlobal_1001ddec0=0; IShotGlobal_1001dde90=0; IShotGlobal_1001f18c0=0;
    CGRect content=self.contentRect;
    self.contentView=[[NSView alloc] initWithFrame:content]; self.contentView.wantsLayer=YES;
    self.contentView.layer.backgroundColor=[NSColor colorWithPatternImage:[NSImage imageNamed:@"clipBackground"]].CGColor;
    [self addSubview:self.contentView];
    self.boxOfScreenAreaForScrollScreen=[[NSBox alloc] init]; self.boxOfScreenAreaForScrollScreen.boxType=NSBoxCustom;
    self.boxOfScreenAreaForScrollScreen.borderWidth=1; self.boxOfScreenAreaForScrollScreen.borderColor=NSColor.redColor;
    [self addSubview:self.boxOfScreenAreaForScrollScreen];
    self.cropBorderView=[[GKCropBorderView alloc] initWithFrame:CGRectMake(content.origin.x-6,content.origin.y-6,content.size.width+12,content.size.height+12)];
    self.contentFrame=self.cropBorderView.frame;
    NSString *shadow=[NSBundle.mainBundle localizedStringForKey:@"Shadow" value:@"" table:nil];
    double shadowWidth=IShotFunction_1000483f0(shadow,12).width;
    self.indicatorField=[[NSView alloc] initWithFrame:CGRectMake(0,2,IShotGlobal_1001de183?82:shadowWidth+213,20)];
    self.indicatorField.wantsLayer=YES; self.indicatorField.hidden=YES;
    self.indicatorField.layer.backgroundColor=[NSColor colorWithDeviceRed:0x1.4141414141414p-4 green:0x1.4343434343434p-1 blue:1 alpha:1].CGColor;
    self.indicatorField.layer.cornerRadius=3; self.indicatorField.layer.masksToBounds=YES;
    self.indicatorFieldWidth=[[NSTextView alloc] initWithFrame:CGRectMake(-3,2.5,41,16)];
    self.indicatorFieldWidth.string=@""; self.indicatorFieldWidth.textColor=NSColor.whiteColor;
    self.indicatorFieldWidth.backgroundColor=NSColor.clearColor; self.indicatorFieldWidth.font=[NSFont systemFontOfSize:12];
    self.indicatorFieldWidth.alphaValue=1; self.indicatorFieldWidth.identifier=@"IndicatorFieldWidth";
    self.indicatorFieldWidth.alignment=NSTextAlignmentRight; [self.indicatorField addSubview:self.indicatorFieldWidth];
    NSTextField *separator=[[NSTextField alloc] initWithFrame:CGRectMake(36,1,10,20)];
    separator.stringValue=@"x"; separator.textColor=NSColor.whiteColor; separator.editable=NO; separator.bordered=NO;
    separator.backgroundColor=NSColor.clearColor; [self.indicatorField addSubview:separator];
    self.indicatorFieldHeight=[[NSTextView alloc] initWithFrame:CGRectMake(44,2.5,41,16)];
    self.indicatorFieldHeight.string=@""; self.indicatorFieldHeight.textColor=NSColor.whiteColor;
    self.indicatorFieldHeight.backgroundColor=NSColor.clearColor; self.indicatorFieldHeight.font=[NSFont systemFontOfSize:12];
    self.indicatorFieldHeight.alphaValue=1; self.indicatorFieldHeight.identifier=@"IndicatorFieldHeight";
    self.indicatorFieldHeight.alignment=NSTextAlignmentRight; [self.indicatorField addSubview:self.indicatorFieldHeight];
    self.sliderOfRadiusOfFrame=[[NSSlider alloc] initWithFrame:CGRectMake(84,0,100,20)];
    self.sliderOfRadiusOfFrame.controlSize=NSControlSizeMini; self.sliderOfRadiusOfFrame.minValue=0; self.sliderOfRadiusOfFrame.maxValue=100;
    int radius=IShotFunction_10004c9b8([[NSUserDefaults.standardUserDefaults objectForKey:@"sizeOfImageFillet"] intValue]);
    self.cropBorderView.borderRadius=(float)radius; self.sliderOfRadiusOfFrame.integerValue=radius;
    if (IShotGlobal_1001de181) self.radiusOfFrame=[[NSUserDefaults.standardUserDefaults objectForKey:@"sizeOfImageFillet"] intValue];
    self.sliderOfRadiusOfFrame.enabled=IShotGlobal_1001de181; self.sliderOfRadiusOfFrame.continuous=YES;
    self.sliderOfRadiusOfFrame.action=@selector(adjustRadius:); [self.indicatorField addSubview:self.sliderOfRadiusOfFrame];
    self.buttonOfWindowShadow=[[NSButton alloc] initWithFrame:CGRectMake(186,0,shadowWidth+30,20)];
    NSMutableAttributedString *title=[[NSMutableAttributedString alloc] initWithString:shadow];
    [title addAttribute:NSForegroundColorAttributeName value:NSColor.whiteColor range:NSMakeRange(0,title.length)];
    self.buttonOfWindowShadow.attributedTitle=title; self.buttonOfWindowShadow.font=[NSFont systemFontOfSize:12];
    [self.buttonOfWindowShadow setButtonType:NSButtonTypeSwitch];
    BOOL needShadow=[NSUserDefaults.standardUserDefaults boolForKey:@"needShadowOfnotSingleWindow"];
    [NSUserDefaults.standardUserDefaults setBool:needShadow forKey:@"needShadow"];
    self.buttonOfWindowShadow.state=needShadow; self.buttonOfWindowShadow.action=@selector(checkShadow:);
    [self.indicatorField addSubview:self.buttonOfWindowShadow]; [self addSubview:self.indicatorField];
    NSString *tip=[NSBundle.mainBundle localizedStringForKey:IShotMXTipWithMultipleWindows value:@"" table:nil];
    if (IShotGlobal_1001de181) tip=[NSBundle.mainBundle localizedStringForKey:IShotMXTipSingleWindow value:@"" table:nil];
    CGSize tipSize=IShotFunction_1000483f0(tip,12);
    self.tipView=[[NSView alloc] initWithFrame:CGRectMake(10,10,tipSize.width+25,tipSize.height+20)];
    self.tipView.wantsLayer=YES; self.tipView.layer.backgroundColor=NSColor.blackColor.CGColor; self.tipView.layer.cornerRadius=5;
    self.textFieldOfTipView=[[NSTextField alloc] initWithFrame:CGRectMake(10,10,tipSize.width+25,tipSize.height)];
    self.textFieldOfTipView.stringValue=tip; self.textFieldOfTipView.backgroundColor=NSColor.blackColor;
    NSData *color=[NSUserDefaults.standardUserDefaults objectForKey:@"colorOfTipsText"];
    self.textFieldOfTipView.textColor=color?[NSKeyedUnarchiver unarchiveObjectWithData:color]:NSColor.redColor;
    self.textFieldOfTipView.editable=NO; self.textFieldOfTipView.bordered=NO; self.textFieldOfTipView.font=[NSFont systemFontOfSize:12];
    [self.tipView addSubview:self.textFieldOfTipView];
    if (!IShotGlobal_1001de180 && ![NSUserDefaults.standardUserDefaults boolForKey:@"closeTipsWhenScreenshot"]) [self addSubview:self.tipView];
    if (IShotGlobal_1001ddfb8) self.tipView.hidden=YES;
    CGRect screen=[NSScreen currentScreenForMouseLocation].frame;
    CGEventRef event=CGEventCreate(NULL); CGPoint point=CGEventGetLocation(event); if (event) CFRelease(event);
    int x=(int)(point.x-screen.origin.x);
    double intermediate=screen.origin.y+(screen.size.height+point.y);
    int y=(int)(screen.size.height-(intermediate-NSScreen.deepestScreen.frame.size.height));
    self.imageViewOfCursor=[[NSImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    self.imageViewOfCursor.image=NSCursor.crosshairCursor.image;
    [self.imageViewOfCursor setFrameOrigin:CGPointMake((int)((uint32_t)x-13),(int)((uint32_t)y-15))];
    if (!IShotGlobal_1001ddd50) [self addSubview:self.imageViewOfCursor];
    self.imageViewOfCursor.hidden=YES;
}
- (void)_resetIndicatorField { // 0x10003123c; REA ev_493b19c53a07a38724b2070223bc213d19b653da4a6211cd530c7c0c08a5774e
    CGSize screen=[NSScreen currentScreenForMouseLocation].frame.size;
    CGRect outer=NSInsetRect(self.contentRect,-6,-6);
    if (!(self.contentRect.size.width>=1 && self.contentRect.size.height>=1)) self.indicatorField.hidden=YES;
    else {
        self.indicatorField.hidden=NO;
        self.indicatorFieldWidth.string=[NSString stringWithFormat:@"%.f",outer.size.width-12];
        self.indicatorFieldHeight.string=[NSString stringWithFormat:@"%.f",outer.size.height-12];
        float left=(float)outer.origin.x; if (left<-5.f) left=-5.f;
        float top=(float)(outer.origin.y+outer.size.height);
        if (screen.height+5<(double)top) top=(float)(screen.height+5);
        double x,y=(double)top,fieldWidth;
        if (screen.height-20<(double)top) {
            y=screen.height-20;
            if (self.indicatorField.frame.size.width<(double)left) {
                x=(double)left-self.indicatorField.frame.size.width-2; fieldWidth=self.indicatorField.frame.size.width;
            } else {
                float right=(float)(outer.origin.x+outer.size.width);
                double remaining=screen.width-self.indicatorField.frame.size.width;
                if (remaining>(double)right) {
                    x=(double)(right-1.f); fieldWidth=self.indicatorField.frame.size.width;
                } else {
                    float bottom=(float)outer.origin.y;
                    if (bottom>20.f) { x=(double)(left+5.f); y=(double)(bottom-20.f); }
                    else { x=(double)(left+12.f); y=(double)(top-31.f); }
                    fieldWidth=self.indicatorField.frame.size.width;
                }
            }
        } else {
            fieldWidth=self.indicatorField.frame.size.width;
            double right=self.indicatorField.frame.size.width+(double)left;
            if (right<=screen.width-5) x=(double)(left+5.f);
            else x=screen.width-self.indicatorField.frame.size.width;
        }
        self.indicatorField.frame=CGRectMake(x,y,fieldWidth,20);
    }
    BOOL only=self.onlyClipCurrentWindow;
    self.indicatorFieldWidth.editable=!only; self.indicatorFieldWidth.selectable=!only;
    self.indicatorFieldHeight.editable=!only; self.indicatorFieldHeight.selectable=!only;
}
