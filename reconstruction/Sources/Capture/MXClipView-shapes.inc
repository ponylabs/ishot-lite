- (void)reFreshShapeLayer1 { // 0x100033b98
    if (!self.shapeLayer1) {
        self.shapeLayer1=[CAShapeLayer layer]; self.shapeLayer1.fillRule=kCAFillRuleEvenOdd;
        self.shapeLayer1.lineWidth=1;
        self.shapeLayer1.strokeColor=[NSColor colorWithDeviceRed:0x1.5959595959596p-3 green:0x1.5757575757575p-1 blue:1 alpha:1].CGColor;
        self.shapeLayer1.fillColor=[NSColor.blackColor colorWithAlphaComponent:.5].CGColor;
        [self.layer addSublayer:self.shapeLayer1];
    }
    CGMutablePathRef path=CGPathCreateMutable();
    if (!(self.contentRect.size.width<=0)) {
        NSScreen *screen=[NSScreen currentScreenForMouseLocation];
        if (IShotGlobal_1001dde80) screen=IShotGlobal_1001dde80;
        int x=(int)self.contentRect.origin.x,right=(int)IShotMXEndX(self.contentRect);
        int y=(int)self.contentRect.origin.y,top=(int)IShotMXEndY(self.contentRect);
        if (screen.frame.size.width<(double)right) right=(int)screen.frame.size.width;
        if (x<0) x=0; if (y<0) y=0;
        if (screen.frame.size.height<(double)top) top=(int)screen.frame.size.height;
        CGRect rect=CGRectMake(x,y,(int)((uint32_t)right-(uint32_t)x),(int)((uint32_t)top-(uint32_t)y));
        if (IShotGlobal_1001de183) CGPathAddRect(path,NULL,rect);
        else {
            NSBezierPath *bezier=[NSBezierPath bezierPathWithRoundedRect:rect xRadius:_radiusOfFrame yRadius:_radiusOfFrame];
            NSInteger count=bezier.elementCount;
            for (NSInteger i=0;i<count;i++) {
                NSPoint points[3];
                switch ([bezier elementAtIndex:i associatedPoints:points]) {
                    case NSMoveToBezierPathElement: CGPathMoveToPoint(path,NULL,points[0].x,points[0].y); break;
                    case NSLineToBezierPathElement: CGPathAddLineToPoint(path,NULL,points[0].x,points[0].y); break;
                    case NSCurveToBezierPathElement: CGPathAddCurveToPoint(path,NULL,points[0].x,points[0].y,points[1].x,points[1].y,points[2].x,points[2].y); break;
                    case NSClosePathBezierPathElement: CGPathCloseSubpath(path); break;
                    default: break;
                }
            }
        }
    }
    double width=self.window.frame.size.width+4,height=self.window.frame.size.height+4;
    CGPathAddRect(path,NULL,CGRectMake(-2,-2,width,height)); self.shapeLayer1.path=path; CGPathRelease(path);
}
- (void)reFreshShapeLayer2 { // 0x100034108
    if (!self.shapeLayer2) {
        self.shapeLayer2=[CAShapeLayer layer]; self.shapeLayer2.lineWidth=3;
        self.shapeLayer2.strokeColor=[NSColor colorWithDeviceRed:0x1.5959595959596p-3 green:0x1.5757575757575p-1 blue:1 alpha:1].CGColor;
        self.shapeLayer2.fillColor=NSColor.clearColor.CGColor; [self.layer addSublayer:self.shapeLayer2];
    }
    self.shapeLayer2.hidden=self.contentRect.size.height<=20 || self.contentRect.size.width<=20;
    CGMutablePathRef path=CGPathCreateMutable();
    double x=self.contentRect.origin.x,y=self.contentRect.origin.y;
    double right=self.contentRect.origin.x+self.contentRect.size.width,top=self.contentRect.origin.y+self.contentRect.size.height;
    CGPathMoveToPoint(path,NULL,x+15,y-2); CGPathAddLineToPoint(path,NULL,x-2,y-2); CGPathAddLineToPoint(path,NULL,x-2,y+15);
    CGPathMoveToPoint(path,NULL,x+15,top+2); CGPathAddLineToPoint(path,NULL,x-2,top+2); CGPathAddLineToPoint(path,NULL,x-2,top-15);
    CGPathMoveToPoint(path,NULL,right-15,top+2); CGPathAddLineToPoint(path,NULL,right+2,top+2); CGPathAddLineToPoint(path,NULL,right+2,top-15);
    CGPathMoveToPoint(path,NULL,right-15,y-2); CGPathAddLineToPoint(path,NULL,right+2,y-2); CGPathAddLineToPoint(path,NULL,right+2,y+15);
    self.shapeLayer2.path=path; CGPathRelease(path);
}
- (void)reFreshShapeLayer3:(CGPoint)point { // 0x1000344b4
    if (![NSUserDefaults.standardUserDefaults boolForKey:@"displayCoordinateLine"]) return;
    if (!self.shapeLayer3) {
        self.shapeLayer3=[CAShapeLayer layer]; self.shapeLayer3.lineWidth=1;
        self.shapeLayer3.strokeColor=[NSColor colorWithDeviceRed:0x1.5959595959596p-3 green:0x1.5757575757575p-1 blue:1 alpha:1].CGColor;
        self.shapeLayer3.fillColor=NSColor.clearColor.CGColor; [self.layer addSublayer:self.shapeLayer3];
    }
    CGMutablePathRef path=CGPathCreateMutable();
    int resize=0; if (self.dragMode==1) resize=[self.cropBorderView numberOfReSize];
    if (self.dragMode!=1 || (resize!=4 && resize!=8)) {
        CGPathMoveToPoint(path,NULL,point.x-10000,(int)point.y);
        CGPathAddLineToPoint(path,NULL,point.x+10000,(int)point.y);
    }
    if (self.dragMode!=1 || (resize & ~4U)!=2) {
        CGPathMoveToPoint(path,NULL,(int)point.x,point.y-10000);
        CGPathAddLineToPoint(path,NULL,(int)point.x,point.y+10000);
    }
    self.shapeLayer3.path=path; CGPathRelease(path);
}
