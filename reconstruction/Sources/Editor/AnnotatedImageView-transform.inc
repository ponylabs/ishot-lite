- (void)moveSquare:(NSDictionary *)stroke { // 0x10006b608
    NSColor *color=stroke[@"color"];
    float alpha=stroke[@"colorAlpha"] ? [stroke[@"colorAlpha"] floatValue] : 1.0f;
    if (alpha==0.0f) alpha=0.01f;
    [[color colorWithAlphaComponent:alpha] set];
    float x1=(float)([stroke[@"X1"] floatValue]-self.frame.origin.x), y1=(float)([stroke[@"Y1"] floatValue]-self.frame.origin.y);
    float x2=(float)([stroke[@"X2"] floatValue]-self.frame.origin.x), y2=(float)([stroke[@"Y2"] floatValue]-self.frame.origin.y);
    float dx=0,dy=0;
    if (stroke[@"moveToX"]) { dx=[stroke[@"moveToX"] floatValue]-[stroke[@"moveX"] floatValue]; dy=[stroke[@"moveToY"] floatValue]-[stroke[@"moveY"] floatValue]; }
    CGRect r=CGRectMake((float)(dx+x1),(float)(dy+y1),(float)(x2-x1),(float)(y2-y1));
    int width=[stroke[@"size"] intValue];
    double radius=[stroke[@"enableRoundOfSquare"] intValue] ? 8.0 : 0.0;
    NSBezierPath *path=[self makeBubble:NSBezierPath.bezierPath withBubbleRect:r cornerRight:radius cornerLeft:radius];
    if ([stroke[@"filledOfSquare"] boolValue]) [path fill];
    else {
        path.lineWidth=width; [path stroke];
        [[NSColor.clearColor colorWithAlphaComponent:0.002] set]; path.lineWidth=7; [path stroke];
    }
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    if (context) {
        NSArray *handles=[self _calculateAllNeededHandleSquareRects:r];
        for (NSUInteger i=1;i<handles.count;++i) {
            CGRect handle=[handles[i] CGRectValue];
            CGContextSetFillColorWithColor(context,color.CGColor); CGContextFillEllipseInRect(context,handle);
            CGContextSetRGBFillColor(context,1,1,1,0.95); CGContextFillEllipseInRect(context,CGRectInset(handle,1,1));
        }
    }
}
- (void)moveEllipse:(NSDictionary *)stroke { // 0x10006bb98
    NSColor *color=stroke[@"color"];
    float alpha=stroke[@"colorAlpha"] ? [stroke[@"colorAlpha"] floatValue] : 1.0f;
    if (alpha==0.0f) alpha=0.01f;
    [[color colorWithAlphaComponent:alpha] set];
    float x1=(float)([stroke[@"X1"] floatValue]-self.frame.origin.x), y1=(float)([stroke[@"Y1"] floatValue]-self.frame.origin.y);
    float x2=(float)([stroke[@"X2"] floatValue]-self.frame.origin.x), y2=(float)([stroke[@"Y2"] floatValue]-self.frame.origin.y);
    float dx=0,dy=0;
    if (stroke[@"moveToX"]) { dx=[stroke[@"moveToX"] floatValue]-[stroke[@"moveX"] floatValue]; dy=[stroke[@"moveToY"] floatValue]-[stroke[@"moveY"] floatValue]; }
    CGRect r=CGRectMake((float)(dx+x1),(float)(dy+y1),(float)(x2-x1),(float)(y2-y1));
    int width=[stroke[@"size"] intValue];
    NSBezierPath *path=[NSBezierPath bezierPathWithOvalInRect:r];
    if ([stroke[@"filledOfEllipse"] boolValue]) [path fill];
    else {
        path.lineWidth=width; [path stroke];
        [[NSColor.clearColor colorWithAlphaComponent:0.002] set]; path.lineWidth=7; [path stroke];
    }
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    if (context) {
        NSArray *handles=[self _calculateAllNeededHandleSquareRects:r];
        for (NSUInteger i=1;i<handles.count;++i) {
            CGRect handle=[handles[i] CGRectValue];
            CGContextSetFillColorWithColor(context,color.CGColor); CGContextFillEllipseInRect(context,handle);
            CGContextSetRGBFillColor(context,1,1,1,0.95); CGContextFillEllipseInRect(context,CGRectInset(handle,1,1));
        }
    }
}
- (void)resizeSquare { // 0x10006d274
    NSDictionary *stroke=IShotGlobal_1001de058;
    NSColor *color=stroke[@"color"];
    float alpha=stroke[@"colorAlpha"] ? [stroke[@"colorAlpha"] floatValue] : 1.0f;
    [[color colorWithAlphaComponent:alpha] set];
    CGRect r=[self getNewRectOfResizeAllStroke]; r.origin.x-=self.frame.origin.x; r.origin.y-=self.frame.origin.y;
    int width=[stroke[@"size"] intValue];
    double radius=[stroke[@"enableRoundOfSquare"] intValue] ? 8.0 : 0.0;
    NSBezierPath *path=[self makeBubble:NSBezierPath.bezierPath withBubbleRect:r cornerRight:radius cornerLeft:radius];
    if ([stroke[@"filledOfSquare"] boolValue]) [path fill];
    else {
        path.lineWidth=width; [path stroke];
        [[NSColor.clearColor colorWithAlphaComponent:0.002] set]; path.lineWidth=7; [path stroke];
    }
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    if (context) {
        NSArray *handles=[self _calculateAllNeededHandleSquareRects:r];
        for (NSUInteger i=1;i<handles.count;++i) {
            CGRect handle=[handles[i] CGRectValue];
            CGContextSetFillColorWithColor(context,color.CGColor); CGContextFillEllipseInRect(context,handle);
            CGContextSetRGBFillColor(context,1,1,1,0.95); CGContextFillEllipseInRect(context,CGRectInset(handle,1,1));
        }
    }
}
- (void)resizeEllipse { // 0x10006d618
    NSDictionary *stroke=IShotGlobal_1001de058;
    NSColor *color=stroke[@"color"];
    float alpha=stroke[@"colorAlpha"] ? [stroke[@"colorAlpha"] floatValue] : 1.0f;
    [[color colorWithAlphaComponent:alpha] set];
    CGRect r=[self getNewRectOfResizeAllStroke]; r.origin.x-=self.frame.origin.x; r.origin.y-=self.frame.origin.y;
    int width=[stroke[@"size"] intValue];
    NSBezierPath *path=[NSBezierPath bezierPathWithOvalInRect:r];
    if ([stroke[@"filledOfEllipse"] boolValue]) [path fill];
    else {
        path.lineWidth=width; [path stroke];
        [[NSColor.clearColor colorWithAlphaComponent:0.002] set]; path.lineWidth=7; [path stroke];
    }
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    if (context) {
        NSArray *handles=[self _calculateAllNeededHandleSquareRects:r];
        for (NSUInteger i=1;i<handles.count;++i) {
            CGRect handle=[handles[i] CGRectValue];
            CGContextSetFillColorWithColor(context,color.CGColor); CGContextFillEllipseInRect(context,handle);
            CGContextSetRGBFillColor(context,1,1,1,0.95); CGContextFillEllipseInRect(context,CGRectInset(handle,1,1));
        }
    }
}
- (void)movePencilPen:(NSDictionary *)stroke { // 0x10006cb80
    NSColor *color=stroke[@"color"]; CGColorRef cgColor=color.CGColor;
    int width=[stroke[@"size"] intValue];
    float alpha=stroke[@"colorAlpha"] ? [stroke[@"colorAlpha"] floatValue] : 1.0f;
    if (alpha==0.0f) alpha=0.01f;
    [[color colorWithAlphaComponent:alpha] set];
    double dx=0,dy=0;
    if (stroke[@"moveToX"]) { dx=(float)([stroke[@"moveToX"] floatValue]-[stroke[@"moveX"] floatValue]);dy=(float)([stroke[@"moveToY"] floatValue]-[stroke[@"moveY"] floatValue]); }
    NSArray *points=stroke[@"allPoints"];
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    if (context) {
        CGPoint first=CGPointZero,last=CGPointZero;
        if (![stroke[@"indexOfPencilMosaic"] intValue]) {
            CGContextSaveGState(context); CGContextSetFillColorWithColor(context,cgColor); CGContextSetLineWidth(context,width);
            CGContextSetLineJoin(context,kCGLineJoinRound); CGContextSetLineCap(context,kCGLineCapRound); CGContextBeginPath(context);
            for (NSUInteger i=0;i<points.count;++i) {
                CGPoint q=[points[i] CGPointValue]; q.x-=self.frame.origin.x; q.y-=self.frame.origin.y;
                if (i==0) { CGContextMoveToPoint(context,dx+q.x,dy+q.y);first=q; }
                else CGContextAddLineToPoint(context,dx+q.x,dy+q.y);
                last=q;
            }
            CGContextDrawPath(context,kCGPathStroke); CGContextRestoreGState(context);
        } else {
            first=[points[0] CGPointValue]; first.x-=self.frame.origin.x; first.y-=self.frame.origin.y;
            last=[points.lastObject CGPointValue]; last.x-=self.frame.origin.x; last.y-=self.frame.origin.y;
            NSImage *image=stroke[@"imageOfMosaic"];
            [image drawInRect:CGRectMake(-self.frame.origin.x,-self.frame.origin.y,image.size.width,image.size.height)];
        }
        CGRect handles[]={CGRectMake(dx+first.x-5,dy+first.y-5,10,10),CGRectMake(dx+last.x-5,dy+last.y-5,10,10)};
        for (int i=0;i<2;++i) {
            CGContextSetFillColorWithColor(context,cgColor);CGContextFillEllipseInRect(context,handles[i]);
            CGContextSetRGBFillColor(context,1,1,1,0.95);CGContextFillEllipseInRect(context,CGRectInset(handles[i],1,1));
        }
    }
    if (width<7) {
        NSBezierPath *path=NSBezierPath.bezierPath;
        [[NSColor.clearColor colorWithAlphaComponent:0.002] set];path.lineWidth=7;
        for (NSUInteger i=0;i<points.count;++i) {
            CGPoint q=[points[i] CGPointValue];q.x-=self.frame.origin.x;q.y-=self.frame.origin.y;
            if (i==0) [path moveToPoint:q];else [path lineToPoint:q];
        }
        [path stroke];
    }
}
- (void)moveLine:(NSDictionary *)stroke { // 0x10006c0c4
    IShotDrawingCoordinates q=IShotDrawingGetCoordinates(self,stroke);
    int width=[stroke[@"size"] intValue]; NSColor *color=IShotDrawingColor(stroke[@"color"],stroke); [color set];
    float dx=0,dy=0;
    if (stroke[@"moveToX"]) { dx=[stroke[@"moveToX"] floatValue]-[stroke[@"moveX"] floatValue];dy=[stroke[@"moveToY"] floatValue]-[stroke[@"moveY"] floatValue]; }
    q.x1+=dx;q.y1+=dy;q.x2+=dx;q.y2+=dy;
    CGPoint a=CGPointMake(q.x1,q.y1),b=CGPointMake(q.x2,q.y2),c1=NSZeroPoint,c2=NSZeroPoint;
    if ([stroke[@"type"] intValue]==3) {
        if ([stroke[@"normalTypeOfArrow"] isEqualToString:@"0"]) IShotDrawingStraightArrow(self,a,b,width,color);
        else {
            c1=NSPointFromString(stroke[@"controlPoint1"]);c2=NSPointFromString(stroke[@"controlPoint2"]);
            c1.x=(c1.x-self.frame.origin.x)+dx;c1.y=(c1.y-self.frame.origin.y)+dy;
            c2.x=(c2.x-self.frame.origin.x)+dx;c2.y=(c2.y-self.frame.origin.y)+dy;
            IShotFunction_10004cc38(a,b,c1,c2,width);
        }
    } else {
        CGContextRef context=NSGraphicsContext.currentContext.CGContext;
        if (context) {
            CGContextSaveGState(context);CGContextSetFillColorWithColor(context,color.CGColor);CGContextSetLineWidth(context,width);
            CGContextSetLineJoin(context,kCGLineJoinRound);CGContextSetLineCap(context,kCGLineCapRound);CGContextBeginPath(context);
            CGContextMoveToPoint(context,a.x,a.y);CGContextAddLineToPoint(context,b.x,b.y);CGContextDrawPath(context,kCGPathStroke);CGContextRestoreGState(context);
        }
        NSBezierPath *path=NSBezierPath.bezierPath;
        [[NSColor.clearColor colorWithAlphaComponent:0.002] set];path.lineWidth=7;[path moveToPoint:a];[path lineToPoint:b];[path stroke];
    }
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    if (context) {
        IShotDrawingHandle(context,color.CGColor,CGRectMake((float)(q.x1-5.0f),(float)(q.y1-5.0f),10,10));
        IShotDrawingHandle(context,color.CGColor,CGRectMake((float)(q.x2-5.0f),(float)(q.y2-5.0f),10,10));
        if ([stroke[@"normalTypeOfArrow"] isEqualToString:@"1"]) {
            IShotDrawingHandle(context,color.CGColor,CGRectMake(c1.x-5,c1.y-5,10,10));
            IShotDrawingHandle(context,color.CGColor,CGRectMake(c2.x-5,c2.y-5,10,10));
        }
    }
}
- (void)resizeLine { // 0x10006d958
    NSDictionary *stroke=IShotGlobal_1001de058;
    IShotDrawingCoordinates q=IShotDrawingGetCoordinates(self,stroke);
    int width=[stroke[@"size"] intValue]; NSColor *color=IShotDrawingColor(stroke[@"color"],stroke); [color set];
    float dx=0,dy=0;
    if (stroke[@"moveToX"]) { dx=[stroke[@"moveToX"] floatValue]-[stroke[@"moveX"] floatValue];dy=[stroke[@"moveToY"] floatValue]-[stroke[@"moveY"] floatValue]; }
    if (IShotGlobal_1001de070==1) {q.x1+=dx;q.y1+=dy;} else if (IShotGlobal_1001de070==2) {q.x2+=dx;q.y2+=dy;}
    CGPoint a=CGPointMake(q.x1,q.y1),b=CGPointMake(q.x2,q.y2),c1=NSZeroPoint,c2=NSZeroPoint;
    if ([stroke[@"type"] intValue]==3) {
        if ([stroke[@"normalTypeOfArrow"] isEqualToString:@"1"]) {
            c1=NSPointFromString(stroke[@"controlPoint1"]);c2=NSPointFromString(stroke[@"controlPoint2"]);
            c1.x-=self.frame.origin.x;c1.y-=self.frame.origin.y;c2.x-=self.frame.origin.x;c2.y-=self.frame.origin.y;
            if (IShotGlobal_1001de070==3) {c1.x+=dx;c1.y+=dy;} else if (IShotGlobal_1001de070==4) {c2.x+=dx;c2.y+=dy;}
        }
        if ([stroke[@"normalTypeOfArrow"] isEqualToString:@"0"]) IShotDrawingStraightArrow(self,a,b,width,color);
        else IShotFunction_10004cc38(a,b,c1,c2,width);
    } else {
        CGContextRef context=NSGraphicsContext.currentContext.CGContext;
        if (context) {
            CGContextSaveGState(context);CGContextSetFillColorWithColor(context,color.CGColor);CGContextSetLineWidth(context,width);
            CGContextSetLineJoin(context,kCGLineJoinRound);CGContextSetLineCap(context,kCGLineCapRound);CGContextBeginPath(context);
            CGContextMoveToPoint(context,a.x,a.y);CGContextAddLineToPoint(context,b.x,b.y);CGContextDrawPath(context,kCGPathStroke);CGContextRestoreGState(context);
        }
        NSBezierPath *path=NSBezierPath.bezierPath;
        [[NSColor.clearColor colorWithAlphaComponent:0.002] set];path.lineWidth=7;[path moveToPoint:a];[path lineToPoint:b];[path stroke];
    }
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    if (context) {
        IShotDrawingHandle(context,color.CGColor,CGRectMake((float)(q.x1-5.0f),(float)(q.y1-5.0f),10,10));
        IShotDrawingHandle(context,color.CGColor,CGRectMake((float)(q.x2-5.0f),(float)(q.y2-5.0f),10,10));
        if ([stroke[@"normalTypeOfArrow"] isEqualToString:@"1"]) {
            IShotDrawingHandle(context,color.CGColor,CGRectMake(c1.x-5,c1.y-5,10,10));
            IShotDrawingHandle(context,color.CGColor,CGRectMake(c2.x-5,c2.y-5,10,10));
        }
    }
}
