- (void)mousedown:(NSEvent *)event { // 0x10001cff8; global block 0x10001d454
    dispatch_async(dispatch_get_global_queue(0,0),^{[NSCursor unhide]; IShotGlobal_1001dddf8=nil;});
    CGPoint point=[self convertPoint:event.locationInWindow fromView:nil];
    if(self.clipState==0){self.clipState=1; CGPoint begin=[self fetchLocationFromScreen:NSEvent.mouseLocation]; self.rectBeginPoint=CGPointMake((int)begin.x,(int)begin.y);}
    if(self.clipState==1 && [self.delegate respondsToSelector:@selector(clipViewMouseDown:)])[self.delegate clipViewMouseDown:event];
    if(!IShotGlobal_1001ddd58 && [self.delegate respondsToSelector:@selector(recordViewDidShowToolBar:)])self.layer.backgroundColor=NSColor.clearColor.CGColor;
    BOOL established=IShotGlobal_1001ddd58 && !IShotGlobal_1001ddde0;
    if(self.cropBorderViewForRecordScreen.isCanMove || (NSPointInRect(point,_contentView.frame) && !self.cropBorderViewForRecordScreen.isInResizeRect)){
        self.dragMode=2; if(established && !self.onlyClipCurrentWindow)self.needsDisplay=YES;
    }else if(NSPointInRect(point,self.cropBorderViewForRecordScreen.frame)){
        self.dragMode=1; self.lastContentRectBeforeResize=self.contentRect; if(established)self.needsDisplay=YES;
    }else self.dragMode=0;
    self.startPoint=point; [super mouseDown:event]; [self.cropBorderViewForRecordScreen mouseDown:event];
}
- (void)mouseup:(NSEvent *)event { // 0x10001de08
    self.dragMode=0; self.scrollViewOfColorPicker.hidden=YES; self.shapeLayer3.hidden=YES; self.imageViewOfCursor.hidden=YES;
    [self.delegate recordViewDidShowToolBar:self];
    if(self.contentRect.size.height<2 || self.contentRect.size.width<2){self.contentRect=CGRectMake(IShotGlobal_1001ddd18,IShotGlobal_1001ddd20,IShotGlobal_1001ddd28,IShotGlobal_1001ddd30); [self _resetIndicatorField];}
    self.cropBorderViewForRecordScreen.frame=NSInsetRect(self.contentRect,-6,-6);
    if(!self.onlyClipCurrentWindow)[self addSubview:self.cropBorderViewForRecordScreen];
    [self reFreshShapeLayer1]; [self reFreshShapeLayer2]; IShotGlobal_1001ddd58=YES;
    if(self.toolbarView.superview!=self)[self addSubview:self.toolbarView];
    double y=self.cropBorderViewForRecordScreen.frame.origin.y-self.toolbarView.frame.size.height; if(y<=0)y=0;
    CGRect border=self.cropBorderViewForRecordScreen.frame;
    double x=border.origin.x+border.size.width*.5-self.toolbarView.bounds.size.width*.5;
    CGRect screen=self.window.screen.frame;
    if(x<0)x=0;
    else if(x+self.toolbarView.frame.size.width>screen.size.width)x=screen.size.width-self.toolbarView.frame.size.width;
    else if(y+self.toolbarView.frame.size.height>screen.size.height)y=screen.size.height-self.toolbarView.frame.size.height;
    self.toolbarView.frame=CGRectMake(x,y,self.toolbarView.frame.size.width,self.toolbarView.frame.size.height);
    self.toolbarView.alphaValue=1; self.toolbarView.accessibilityFrame=self.cropBorderViewForRecordScreen.frame;
    self.toolbarView.hidden=NO; self.clipState=3; IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set];
    if(![[NSUserDefaults.standardUserDefaults objectForKey:@"selectedCameraOfRecordScreen"] isEqualToString:@"None"])[self addCameraWindow];
}
- (void)mousedragged:(NSEvent *)event { // 0x10001d480
    if(IShotGlobal_1001ddce8 && !IShotGlobal_1001ddde0)return;
    if(self.onlyClipCurrentWindow){
        self.rectEndPoint=[self fetchLocationFromScreen:NSEvent.mouseLocation];
        if(fabs((double)(float)self.rectEndPoint.x-self.rectBeginPoint.x)>5 || fabs((double)(float)self.rectEndPoint.y-self.rectBeginPoint.y)>5){
            self.onlyClipCurrentWindow=NO; self.cropBorderViewForRecordScreen.hideHandleRect=NO;
            self.radiusOfFrame=[[NSUserDefaults.standardUserDefaults objectForKey:@"sizeOfImageFillet"] intValue]; self.sliderOfRadiusOfFrame.enabled=YES;
        }
    }
    self.clipState=2;
    if(IShotGlobal_1001ddd58 && !IShotGlobal_1001ddde0){
        CGPoint point=[self convertPoint:event.locationInWindow fromView:nil];
        if(self.dragMode==2 && !self.onlyClipCurrentWindow){
            [self refreshContentRectByMove:point]; [self _resetIndicatorField];
            self.cropBorderViewForRecordScreen.frame=NSInsetRect(self.contentRect,-6,-6); self.cropBorderViewForRecordScreen.needsDisplay=YES;
            [self reFreshShapeLayer1]; [self reFreshShapeLayer2];
        }else if(self.dragMode==1 && !self.onlyClipCurrentWindow){
            [self.window disableCursorRects]; int resize=self.cropBorderViewForRecordScreen.numberOfReSize;
            [self setFrameForContentView:[self getNewRectByReSize:point resizeposition:resize]]; [self refreshColorPickerImageView];
            self.colorPickerImageView.tag=resize;
            if(resize&1){
                double x=(int)point.x,y=(int)point.y; CGRect r=self.contentRect;
                if(r.origin.x==x && r.origin.y==y){[IShotGlobal_1001ddf90 set]; self.colorPickerImageView.tag=1;}
                else if(r.origin.x+r.size.width==x && r.origin.y+r.size.height==y){[IShotGlobal_1001ddf90 set]; self.colorPickerImageView.tag=5;}
                else if(r.origin.x+r.size.width==x && r.origin.y==y){[IShotGlobal_1001ddf88 set]; self.colorPickerImageView.tag=3;}
                else if(r.origin.x==x && r.origin.y+r.size.height==y){[IShotGlobal_1001ddf88 set]; self.colorPickerImageView.tag=7;}
            }
            if(self.scrollViewOfColorPicker.hidden)self.scrollViewOfColorPicker.hidden=NO;
            if(!self.imageViewOfCursor.hidden)self.imageViewOfCursor.hidden=YES;
            if(self.shapeLayer3.hidden)self.shapeLayer3.hidden=NO;
            self.cropBorderViewForRecordScreen.frame=NSInsetRect(self.contentRect,-6,-6);
            [self reFreshShapeLayer1]; [self reFreshShapeLayer2]; [self reFreshShapeLayer3:point];
        }
    }else{
        self.rectEndPoint=[self fetchLocationFromScreen:NSEvent.mouseLocation];
        float fx=(float)self.rectEndPoint.x,fy=(float)self.rectEndPoint.y;
        if(fx<=0)fx=0; if(fy<=0)fy=0;
        if(IShotGlobal_1001ddd60.frame.size.width<fx)fx=(float)IShotGlobal_1001ddd60.frame.size.width;
        double ey=fy; if(IShotGlobal_1001ddd60.frame.size.height<ey)ey=(float)IShotGlobal_1001ddd60.frame.size.height;
        double ex=fx,x=self.rectBeginPoint.x<=ex?self.rectBeginPoint.x:ex,y=self.rectBeginPoint.y<=ey?self.rectBeginPoint.y:ey;
        double w=fabs(ex-self.rectBeginPoint.x),h=fabs(ey-self.rectBeginPoint.y);
        if(self.rectBeginPoint.y>self.rectEndPoint.y)y+=1;
        if(self.imageViewOfCursor.hidden)self.imageViewOfCursor.hidden=NO;
        [self refreshColorPickerImageView]; [self setFrameForContentView:CGRectMake(x,y,w,h)]; [self reFreshShapeLayer3:CGPointMake(ex,ey)];
        CGPoint begin=self.rectBeginPoint,end=self.rectEndPoint;
        if(end.x<begin.x && end.y<begin.y){self.colorPickerImageView.tag=1; [IShotGlobal_1001ddf90 set];}
        else if(begin.x<end.x && begin.y<end.y){self.colorPickerImageView.tag=5; [IShotGlobal_1001ddf90 set];}
        else if(begin.x<end.x && end.y<begin.y){self.colorPickerImageView.tag=3; [IShotGlobal_1001ddf88 set];}
        else if(end.x<begin.x && begin.y<end.y){self.colorPickerImageView.tag=7; [IShotGlobal_1001ddf88 set];}
        [self reFreshShapeLayer1]; [self reFreshShapeLayer2];
    }
    if(IShotGlobal_1001ddd58 && !self.toolbarView.hidden && !self.onlyClipCurrentWindow && !IShotGlobal_1001ddde0)self.toolbarView.hidden=YES;
    if(!self.imageViewOfCursor.hidden)self.imageViewOfCursor.hidden=YES;
}
- (void)mouseMoved:(NSEvent *)event { // 0x10001eb70
    if(self.toolbarView && (IShotGlobal_1001ddde0&1))return;
    NSScreen *screen=[NSScreen currentScreenForMouseLocation];
    if(![self.window.screen isEqual:screen] && (!IShotGlobal_1001ddd58 || (IShotGlobal_1001ddde0&1)))self.indicatorField.hidden=YES;
    CGPoint point=event.locationInWindow;
    if(IShotGlobal_1001ddd58 && NSPointInRect(point,self.toolbarView.frame)){IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set];return;}
    if(IShotGlobal_1001dddf8)[self.window disableCursorRects];
    if(self.clipState==0){
        if([self.delegate respondsToSelector:@selector(clipViewMouseMoved:)])[self.delegate clipViewMouseMoved:event];
        IShotGlobal_1001dddf8=IShotNullCursor_1001ddfa8;
        if([self.window.screen isEqual:screen]){
            CGEventRef cgEvent=CGEventCreate(NULL); CGPoint location=CGEventGetLocation(cgEvent); if(cgEvent)CFRelease(cgEvent);
            CGRect frame=[(NSScreen *)[NSScreen currentScreenForMouseLocation] frame];
            int x=(int)((double)(int)location.x-frame.origin.x);
            int y=(int)(frame.size.height-((frame.origin.y+(frame.size.height+(double)(int)location.y))-NSScreen.deepestScreen.frame.size.height));
            CGPoint picker=CGPointMake(x+(x<130?10:-130),y+(y+130>(int)frame.size.height?-130:10));
            if(!self.colorPickerImageView){
                self.colorPickerImageView=[[ColorPickerImageView alloc] initWithFrame:NSMakeRect(0,0,120,120)];
                self.colorPickerImageView.image=self.fullImage;
                self.scrollViewOfColorPicker=[[NSScrollView alloc] initWithFrame:NSMakeRect(picker.x,picker.y,120,120)];
                [self.scrollViewOfColorPicker addSubview:self.colorPickerImageView]; [self addSubview:self.scrollViewOfColorPicker];
                self.scrollViewOfColorPicker.hidden=YES; self.imageViewOfCursor.hidden=YES;
            }else{
                [self.colorPickerImageView mouseMoved:event]; [self.scrollViewOfColorPicker setFrameOrigin:picker];
                [_imageViewOfCursor setFrameOrigin:NSMakePoint(x-13,y-16)]; [self reFreshShapeLayer3:CGPointMake(x,y)];
                if(self.scrollViewOfColorPicker.hidden && [self.delegate respondsToSelector:@selector(recordViewDidShowToolBar:)]){
                    for(MXRecordScreenWindowController *controller in [MXRecordScreenManager sharedInstance].recordWindowControllerArray){
                        if(![controller.window.screen isEqual:screen]){
                            controller.recordScreenClipView.scrollViewOfColorPicker.hidden=YES;
                            controller.recordScreenClipView.imageViewOfCursor.hidden=YES;
                            controller.recordScreenClipView.shapeLayer3.hidden=YES;
                        }
                    }
                    self.scrollViewOfColorPicker.hidden=NO; self.imageViewOfCursor.hidden=NO; self.shapeLayer3.hidden=NO;
                }
            }
        }
    }
    self.tipView.hidden=NSPointInRect(point,NSInsetRect(self.tipView.frame,-20,-20));
    if(IShotGlobal_1001ddd58)self.tipView.hidden=YES;
    [super mouseMoved:event];
}
