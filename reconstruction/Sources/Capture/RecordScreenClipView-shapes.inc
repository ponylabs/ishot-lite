- (void)setUpShapeLayer { // 0x100020de0
    NSColor *stroke=[NSColor colorWithDeviceRed:43.0/255 green:171.0/255 blue:1 alpha:1];
    self.shapeLayer1=[CAShapeLayer layer]; self.shapeLayer1.fillRule=kCAFillRuleEvenOdd; self.shapeLayer1.lineWidth=1; self.shapeLayer1.strokeColor=stroke.CGColor; self.shapeLayer1.fillColor=[NSColor.blackColor colorWithAlphaComponent:0.5].CGColor; [self.layer addSublayer:self.shapeLayer1];
    self.shapeLayer2=[CAShapeLayer layer]; self.shapeLayer2.lineWidth=3; self.shapeLayer2.strokeColor=stroke.CGColor; self.shapeLayer2.fillColor=NSColor.clearColor.CGColor; [self.layer addSublayer:self.shapeLayer2];
    if([NSUserDefaults.standardUserDefaults boolForKey:@"displayCoordinateLine"]) { self.shapeLayer3=[CAShapeLayer layer]; self.shapeLayer3.lineWidth=1; self.shapeLayer3.strokeColor=stroke.CGColor; self.shapeLayer3.fillColor=NSColor.clearColor.CGColor; [self.layer addSublayer:self.shapeLayer3]; }
}
- (void)reFreshShapeLayer1 { // 0x100021270
    CGMutablePathRef path=CGPathCreateMutable();
    if(self.contentRect.size.width>0) {
        NSScreen *screen=NSScreen.currentScreenForMouseLocation; if(IShotGlobal_1001ddd60) screen=IShotGlobal_1001ddd60;
        NSRect rect=self.contentRect; int x=(int)rect.origin.x,y=(int)rect.origin.y,maxX=(int)(rect.origin.x+rect.size.width),maxY=(int)(rect.origin.y+rect.size.height);
        if(screen.frame.size.width<maxX) maxX=(int)screen.frame.size.width; if(x<0)x=0; if(y<0)y=0; if(screen.frame.size.height<maxY) maxY=(int)screen.frame.size.height;
        CGPathAddRect(path,NULL,CGRectMake(x,y,maxX-x,maxY-y));
    }
    CGPathAddRect(path,NULL,CGRectMake(-2,-2,self.window.frame.size.width+4,self.window.frame.size.height+4)); self.shapeLayer1.path=path; if(path) CGPathRelease(path);
}
- (void)reFreshShapeLayer2 { // 0x100021454
    NSRect rect=self.contentRect; self.shapeLayer2.hidden=rect.size.height<=20 || rect.size.width<=20;
    CGMutablePathRef path=CGPathCreateMutable(); double x=rect.origin.x,y=rect.origin.y,maxX=x+rect.size.width,maxY=y+rect.size.height;
    CGPathMoveToPoint(path,NULL,x+15,y-2); CGPathAddLineToPoint(path,NULL,x-2,y-2); CGPathAddLineToPoint(path,NULL,x-2,y+15);
    CGPathMoveToPoint(path,NULL,x+15,maxY+2); CGPathAddLineToPoint(path,NULL,x-2,maxY+2); CGPathAddLineToPoint(path,NULL,x-2,maxY-15);
    CGPathMoveToPoint(path,NULL,maxX-15,maxY+2); CGPathAddLineToPoint(path,NULL,maxX+2,maxY+2); CGPathAddLineToPoint(path,NULL,maxX+2,maxY-15);
    CGPathMoveToPoint(path,NULL,maxX-15,y-2); CGPathAddLineToPoint(path,NULL,maxX+2,y-2); CGPathAddLineToPoint(path,NULL,maxX+2,y+15);
    self.shapeLayer2.path=path; if(path) CGPathRelease(path);
}
- (void)reFreshShapeLayer3:(CGPoint)point { // 0x1000216ac
    if(![NSUserDefaults.standardUserDefaults boolForKey:@"displayCoordinateLine"]) return;
    CGMutablePathRef path=CGPathCreateMutable(); int position=self.dragMode==1?self.cropBorderViewForRecordScreen.numberOfReSize:0;
    if(self.dragMode!=1 || (position!=4 && position!=8)) { CGPathMoveToPoint(path,NULL,point.x-10000,(int)point.y); CGPathAddLineToPoint(path,NULL,point.x+10000,(int)point.y); }
    if(self.dragMode!=1 || (position!=2 && position!=6)) { CGPathMoveToPoint(path,NULL,(int)point.x,point.y-10000); CGPathAddLineToPoint(path,NULL,(int)point.x,point.y+10000); }
    self.shapeLayer3.path=path; if(path) CGPathRelease(path);
}
