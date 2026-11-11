- (void)mousedragged:(NSEvent *)event { // 0x100028d78, ARM64 corroborated in recovery/assembly/iShot.arm64.s
    if(IShotGlobal_1001de0c0) return;
    if(IShotGlobal_1001de0c1) { [IShotGlobal_1001de160 draggedAllToolBar:event]; return; }
    if(IShotGlobal_1001de099 || IShotGlobal_1001dde91 || IShotGlobal_1001dde92 || IShotGlobal_1001dde68==1) return;
    IShotGlobal_1001f18d0=(int32_t)((uint32_t)IShotGlobal_1001f18d0+1);
    if([self isCanDrawSelectFunction]) {
        [IShotGlobal_1001de160 handleMouseEvent:event]; NSPoint point=event.locationInWindow;
        int type=[IShotGlobal_1001de058[@"type"] intValue];
        if(type==4) {
            if([IShotGlobal_1001dde70 isEqualToString:@"cursorCreateNew"] && [IShotGlobal_1001de058[@"indexOfPencilMosaic"] intValue]>0) {
                CGPathAddLineToPoint((CGMutablePathRef)self.mosaicPath,NULL,point.x,point.y); CGMutablePathRef copy=CGPathCreateMutableCopy(self.mosaicPath); self.mosaicShapeLayer.path=copy; CGPathRelease(copy);
            }
        } else if((uint32_t)((uint32_t)IShotGlobal_1001f18d0*0xaaaaaaabU+0x2aaaaaaaU)<0x55555555U) {
            if(type==8) self.cropBorderView.needsDisplay=YES; else if(type==5) self.needsDisplay=YES;
        }
        if(NSPointInRect(point,NSInsetRect(self.tipView.frame,-20,-20))) { self.tipView.hidden=YES; return; }
        NSString *message=nil;
        BOOL creating=[IShotGlobal_1001dde70 isEqualToString:@"cursorCreateNew"];
        if(type==0 || type==1) {
            if(!creating && ![IShotGlobal_1001dde70 isEqualToString:@"Resize_135"] && ![IShotGlobal_1001dde70 isEqualToString:@"Resize_45"]) return;
            if(!self.tipView.hidden) return;
            message=type==0?@"Hold down the modifier key and a square will be drawn.":@"Hold down the modifier key and a circle will be drawn.";
        } else if(type==2 || type==3) {
            if(!creating && ![IShotGlobal_1001dde70 isEqualToString:@"Resize"]) return;
            if(!self.tipView.hidden) return;
            message=type==2?@"Holding down the modifier key will draw a straight line at a specific angle.":@"Holding down the modifier key will draw an arrow at a specific angle.";
        } else return;
        message=[NSBundle.mainBundle localizedStringForKey:message value:@"" table:nil]; NSSize size=IShotFunction_1000483f0(message,12);
        self.tipView.frame=NSMakeRect(10,10,size.width+25,size.height+20); self.textFieldOfTipView.stringValue=message; self.textFieldOfTipView.frame=NSMakeRect(10,10,size.width+25,size.height); self.tipView.hidden=NO; return;
    }
    if(!IShotGlobal_1001de088 && self.onlyClipCurrentWindow) {
        self.rectEndPoint=[self fetchLocationFromScreen:NSEvent.mouseLocation];
        double x=fabs((double)(float)self.rectEndPoint.x-self.rectBeginPoint.x),y=fabs((double)(float)self.rectEndPoint.y-self.rectBeginPoint.y);
        if(x>5 || y>5) { self.onlyClipCurrentWindow=NO; self.cropBorderView.hideHandleRect=NO; self.radiusOfFrame=[[NSUserDefaults.standardUserDefaults objectForKey:@"sizeOfImageFillet"] intValue]; self.sliderOfRadiusOfFrame.enabled=YES; }
    }
    self.clipState=2;
    if(!IShotGlobal_1001de088) {
        self.rectEndPoint=[self fetchLocationFromScreen:NSEvent.mouseLocation];
        float x=(float)self.rectEndPoint.x,y=(float)self.rectEndPoint.y;
        if(x<=0) x=0; if(y<=0) y=0;
        if(IShotGlobal_1001dde80.frame.size.width<(double)x) x=(float)IShotGlobal_1001dde80.frame.size.width;
        if(IShotGlobal_1001dde80.frame.size.height<(double)y) y=(float)IShotGlobal_1001dde80.frame.size.height;
        NSPoint begin=self.rectBeginPoint,end=self.rectEndPoint;
        double originX=begin.x<=(double)x?begin.x:x, originY=begin.y<=(double)y?begin.y:y;
        if(!(begin.y<=end.y)) originY+=1;
        if(self.imageViewOfCursor.hidden) self.imageViewOfCursor.hidden=NO;
        NSRect rectangle=NSMakeRect(originX,originY,fabs((double)x-begin.x),fabs((double)y-begin.y));
        if(!(IShotGlobal_1001ddcf8>0)) [self refreshColorPickerImageView];
        else { rectangle=IShotFunction_10004d14c(self.rectBeginPoint,self.rectEndPoint,rectangle,IShotGlobal_1001ddcf8); self.scrollViewOfColorPicker.hidden=YES; }
        [self setFrameForContentView:rectangle]; [self reFreshShapeLayer3:NSMakePoint(x,y)];
        begin=self.rectBeginPoint; end=self.rectEndPoint;
        if(end.x<begin.x && end.y<begin.y) { self.colorPickerImageView.tag=1; [IShotGlobal_1001ddf90 set]; }
        else if(begin.x<end.x && begin.y<end.y) { self.colorPickerImageView.tag=5; [IShotGlobal_1001ddf90 set]; }
        else if(begin.x<end.x && end.y<begin.y) { self.colorPickerImageView.tag=3; [IShotGlobal_1001ddf88 set]; }
        else if(end.x<begin.x && begin.y<end.y) { self.colorPickerImageView.tag=7; [IShotGlobal_1001ddf88 set]; }
        [self reFreshShapeLayer1]; [self reFreshShapeLayer2];
    } else {
        NSPoint point=[self convertPoint:event.locationInWindow fromView:nil];
        if(self.dragMode==2 && !(self.onlyClipCurrentWindow&1)) {
            [self refreshContentRectByMove:point]; [self _resetIndicatorField]; self.cropBorderView.frame=NSInsetRect(self.contentRect,-6,-6); self.cropBorderView.needsDisplay=YES; [self reFreshShapeLayer1]; [self reFreshShapeLayer2];
        } else if(self.dragMode==1 && !(self.onlyClipCurrentWindow&1)) {
            [self.window disableCursorRects]; int position=self.cropBorderView.numberOfReSize;
            [self setFrameForContentView:[self getNewRectByReSize:point resizeposition:position]]; [self refreshColorPickerImageView]; self.colorPickerImageView.tag=position;
            if(position&1) {
                int x=(int)point.x,y=(int)point.y; NSRect rect=self.contentRect;
                if(rect.origin.x==x && rect.origin.y==y) { [IShotGlobal_1001ddf90 set]; self.colorPickerImageView.tag=1; }
                else if(rect.origin.x+rect.size.width==x && rect.origin.y+rect.size.height==y) { [IShotGlobal_1001ddf90 set]; self.colorPickerImageView.tag=5; }
                else if(rect.origin.x+rect.size.width==x && rect.origin.y==y) { [IShotGlobal_1001ddf88 set]; self.colorPickerImageView.tag=3; }
                else if(rect.origin.x==x && rect.origin.y+rect.size.height==y) { [IShotGlobal_1001ddf88 set]; self.colorPickerImageView.tag=7; }
            }
            if(self.scrollViewOfColorPicker.hidden) self.scrollViewOfColorPicker.hidden=NO;
            if(!self.imageViewOfCursor.hidden) self.imageViewOfCursor.hidden=YES;
            if(self.shapeLayer3.hidden) self.shapeLayer3.hidden=NO;
            self.cropBorderView.frame=NSInsetRect(self.contentRect,-6,-6); [self reFreshShapeLayer1]; [self reFreshShapeLayer2]; [self reFreshShapeLayer3:point];
        }
    }
    if(!IShotGlobal_1001dde95 && IShotGlobal_1001de088 && !(self.onlyClipCurrentWindow&1)) {
        IShotGlobal_1001dde95=YES; [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"hiddenButtonOfClipToolbarWindow" object:nil userInfo:nil];
    }
    if(!self.imageViewOfCursor.hidden) self.imageViewOfCursor.hidden=YES;
}
