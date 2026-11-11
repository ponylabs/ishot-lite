// 0x100067194
- (void)drawAllSquare:(NSDictionary *)stroke {
    NSColor *color=stroke[@"color"]; [IShotDrawingColor(color,stroke) set];
    IShotDrawingCoordinates p=IShotDrawingGetCoordinates(self,stroke);
    NSRect rect=NSMakeRect(p.x1,p.y1,(float)(p.x2-p.x1),(float)(p.y2-p.y1));
    int width=[stroke[@"size"] intValue];
    double radius=[stroke[@"enableRoundOfSquare"] intValue]?8:0;
    BOOL filled=[stroke[@"filledOfSquare"] boolValue];
    NSBezierPath *path=[self makeBubble:NSBezierPath.bezierPath withBubbleRect:rect cornerRight:radius cornerLeft:radius];
    if(filled) [path fill];
    else { path.lineWidth=width; [path stroke]; [[NSColor.clearColor colorWithAlphaComponent:.002] set]; path.lineWidth=7; [path stroke]; }
}
// 0x100068c34
- (void)drawSquareOfCurrentStroke:(NSDictionary *)stroke {
    NSColor *color=stroke[@"color"]; [IShotDrawingColor(color,stroke) set];
    if(!stroke[@"X2"]) return;
    IShotDrawingCoordinates p=IShotDrawingGetCoordinates(self,stroke);
    float minX=p.x1,maxX=p.x2,minY=p.y1,maxY=p.y2;
    if(p.x1>p.x2){minX=p.x2;maxX=p.x1;} if(p.y1>p.y2){minY=p.y2;maxY=p.y1;}
    NSRect rect=NSMakeRect(minX,minY,(float)(maxX-minX),(float)(maxY-minY));
    int width=[stroke[@"size"] intValue];
    double radius=[stroke[@"enableRoundOfSquare"] intValue]?8:0;
    BOOL filled=[stroke[@"filledOfSquare"] boolValue];
    NSBezierPath *path=[self makeBubble:NSBezierPath.bezierPath withBubbleRect:rect cornerRight:radius cornerLeft:radius];
    if(filled) [path fill];
    else { path.lineWidth=width; [path stroke]; [[NSColor.clearColor colorWithAlphaComponent:.002] set]; path.lineWidth=7; [path stroke]; }
    CGContextRef context=NSGraphicsContext.currentContext.graphicsPort;
    if(context){ NSArray *handles=[self _calculateAllNeededHandleSquareRects:rect];
        for(NSUInteger i=1;i<handles.count;i++) IShotDrawingHandle(context,color.CGColor,[handles[i] CGRectValue]);
    }
}
// 0x100067504
- (void)drawAllEllipse:(NSDictionary *)stroke {
    NSColor *color=stroke[@"color"]; [IShotDrawingColor(color,stroke) set];
    IShotDrawingCoordinates p=IShotDrawingGetCoordinates(self,stroke);
    NSRect rect=NSMakeRect(p.x1,p.y1,(float)(p.x2-p.x1),(float)(p.y2-p.y1));
    int width=[stroke[@"size"] intValue];
    BOOL filled=[stroke[@"filledOfEllipse"] boolValue];
    NSBezierPath *path=[NSBezierPath bezierPathWithOvalInRect:rect];
    if(filled) [path fill];
    else { path.lineWidth=width; [path stroke]; [[NSColor.clearColor colorWithAlphaComponent:.002] set]; path.lineWidth=7; [path stroke]; }
}
// 0x100069110
- (void)drawEllipseOfCurrentStroke:(NSDictionary *)stroke {
    NSColor *color=stroke[@"color"]; [IShotDrawingColor(color,stroke) set];
    if(!stroke[@"X2"]) return;
    IShotDrawingCoordinates p=IShotDrawingGetCoordinates(self,stroke);
    NSRect rect=NSMakeRect(p.x1,p.y1,(float)(p.x2-p.x1),(float)(p.y2-p.y1));
    int width=[stroke[@"size"] intValue];
    BOOL filled=[stroke[@"filledOfEllipse"] boolValue];
    NSBezierPath *path=[NSBezierPath bezierPathWithOvalInRect:rect];
    if(filled) [path fill];
    else { path.lineWidth=width; [path stroke]; [[NSColor.clearColor colorWithAlphaComponent:.002] set]; path.lineWidth=7; [path stroke]; }
    CGContextRef context=NSGraphicsContext.currentContext.graphicsPort;
    if(context){ NSArray *handles=[self _calculateAllNeededHandleSquareRects:rect];
        for(NSUInteger i=1;i<handles.count;i++) IShotDrawingHandle(context,color.CGColor,[handles[i] CGRectValue]);
    }
}
// 0x100067f1c
- (void)drawAllPencilPen:(NSDictionary *)stroke {
    NSColor *color=stroke[@"color"]; int width=[stroke[@"size"] intValue];
    [IShotDrawingColor(color,stroke) set]; NSArray *points=stroke[@"allPoints"];
    CGContextRef context=NSGraphicsContext.currentContext.graphicsPort;
    if(context){
        CGContextSaveGState(context); CGColorRef cgColor=color.CGColor;
        CGContextSetFillColorWithColor(context,cgColor); CGContextSetLineWidth(context,width); CGContextSetLineJoin(context,1); CGContextSetLineCap(context,1); CGContextBeginPath(context);
        for(NSUInteger i=0;i<points.count;i++) {
            CGPoint point=[points[i] CGPointValue]; point.x-=self.frame.origin.x; point.y-=self.frame.origin.y;
            if(i==0) CGContextMoveToPoint(context,point.x,point.y); else CGContextAddLineToPoint(context,point.x,point.y);
        }
        CGContextDrawPath(context,2); CGContextRestoreGState(context);
    }
    if(width<7) {
        NSBezierPath *path=NSBezierPath.bezierPath; [[NSColor.clearColor colorWithAlphaComponent:.002] set]; path.lineWidth=7;
        for(NSUInteger i=0;i<points.count;i++) {
            CGPoint point=[points[i] CGPointValue]; point.x-=self.frame.origin.x; point.y-=self.frame.origin.y;
            if(i==0) [path moveToPoint:point]; else [path lineToPoint:point];
        } [path stroke];
    }
}
// 0x100069f74
- (void)drawPencilPenOfCurrentStroke:(NSDictionary *)stroke {
    NSColor *color=stroke[@"color"]; int width=[stroke[@"size"] intValue];
    [IShotDrawingColor(color,stroke) set]; NSArray *points=stroke[@"allPoints"];
    CGContextRef context=NSGraphicsContext.currentContext.graphicsPort;
    if(context){
        CGPoint first=CGPointZero,last=CGPointZero;
        CGContextSaveGState(context); CGColorRef cgColor=color.CGColor;
        CGContextSetFillColorWithColor(context,cgColor); CGContextSetLineWidth(context,width); CGContextSetLineJoin(context,1); CGContextSetLineCap(context,1); CGContextBeginPath(context);
        for(NSUInteger i=0;i<points.count;i++) {
            CGPoint point=[points[i] CGPointValue]; point.x-=self.frame.origin.x; point.y-=self.frame.origin.y;
            last=point; if(i==0){ CGContextMoveToPoint(context,point.x,point.y); first=point; } else CGContextAddLineToPoint(context,point.x,point.y);
        }
        CGContextDrawPath(context,2); CGContextRestoreGState(context);
        IShotDrawingHandle(context,cgColor,CGRectMake(first.x-5,first.y-5,10,10));
        IShotDrawingHandle(context,cgColor,CGRectMake(last.x-5,last.y-5,10,10));
    }
    if(width<7) {
        NSBezierPath *path=NSBezierPath.bezierPath; [[NSColor.clearColor colorWithAlphaComponent:.002] set]; path.lineWidth=7;
        for(NSUInteger i=0;i<points.count;i++) {
            CGPoint point=[points[i] CGPointValue]; point.x-=self.frame.origin.x; point.y-=self.frame.origin.y;
            if(i==0) [path moveToPoint:point]; else [path lineToPoint:point];
        } [path stroke];
    }
}
// 0x100068274: pointSize is narrowed to float before /15 and +2.
- (void)drawAllText:(NSDictionary *)stroke withAlpha:(float)alpha {
    NSScrollView *scroll=stroke[@"scrollView"]; if(scroll.hidden) return;
    NSTextView *text=stroke[@"textView"]; float size=(float)text.font.pointSize; NSColor *color=stroke[@"color"];
    double pad=(int)(size/15.f+2.f);
    double x=(scroll.frame.origin.x-self.frame.origin.x)-pad-3.0;
    double y=scroll.frame.origin.y-self.frame.origin.y-3.0;
    double width=pad*.9+scroll.frame.size.width+8.0, height=scroll.frame.size.height+8.0;
    NSRect rect=NSMakeRect(x,y,width,height);
    if([stroke isEqual:IShotGlobal_1001de058]) { [[color colorWithAlphaComponent:(double)alpha] set]; NSBezierPath *path=[NSBezierPath bezierPathWithRect:rect]; path.lineWidth=1; [path stroke]; }
    [[NSColor.redColor colorWithAlphaComponent:.002] set]; NSBezierPath *path=[NSBezierPath bezierPathWithRect:NSInsetRect(rect,2,2)]; path.lineWidth=8; [path stroke];
}
// 0x100068608; geometry and varargs separately confirmed by REA assembly.
- (void)drawAllNote:(NSDictionary *)stroke withAlpha:(float)alpha {
    NSScrollView *scroll=stroke[@"scrollView"]; if(scroll.hidden) return;
    NSTextView *text=stroke[@"textView"]; float size=(float)text.font.pointSize; NSColor *color=stroke[@"color"];
    double pad=(int)(size/15.f+2.f);
    double x=(scroll.frame.origin.x-self.frame.origin.x)-pad-3.0;
    double y=scroll.frame.origin.y-self.frame.origin.y-3.0;
    double width=pad*.9+scroll.frame.size.width+8.0,height=scroll.frame.size.height+8.0;
    NSRect rect=NSMakeRect(x,y,width,height);
    BOOL hasText=![[text.string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] isEqualToString:@""];
    if([stroke isEqual:IShotGlobal_1001de058] || hasText) {
        [[color colorWithAlphaComponent:(double)alpha] set]; NSBezierPath *path=[NSBezierPath bezierPathWithRect:rect]; path.lineWidth=1; [path stroke];
        [[NSColor.clearColor colorWithAlphaComponent:.002] set];
        // Original discards the expanded path and strokes the existing path again.
        [NSBezierPath bezierPathWithRect:NSInsetRect(rect,-4,-4)]; path.lineWidth=8; [path stroke];
    }
    [color set]; CGPoint center=[stroke[@"cyclePoint"] pointValue]; center.x-=self.frame.origin.x; center.y-=self.frame.origin.y;
    NSBezierPath *circle=NSBezierPath.bezierPath; double numberSize=(double)(size/5.f+11.f);
    [circle appendBezierPathWithArcWithCenter:center radius:numberSize*.8 startAngle:0 endAngle:360 clockwise:NO]; circle.lineWidth=1; [circle fill];
    if(([stroke isEqual:IShotGlobal_1001de058] | hasText)==1) {
        [[color colorWithAlphaComponent:(double)alpha] set]; CGPoint target=[self getPointFrom:center to:rect];
        NSBezierPath *path=NSBezierPath.bezierPath; [path moveToPoint:center]; [path lineToPoint:target]; path.lineWidth=1; [path stroke];
    }
    NSString *serial=[NSString stringWithFormat:@"%@",stroke[@"serialNumber"]];
    NSSize measured=[serial sizeWithAttributes:@{NSFontAttributeName:[NSFont systemFontOfSize:numberSize]}];
    NSMutableDictionary *attributes=NSMutableDictionary.dictionary; attributes[NSFontAttributeName]=[NSFont systemFontOfSize:numberSize]; attributes[NSForegroundColorAttributeName]=NSColor.whiteColor;
    [serial drawAtPoint:NSMakePoint(center.x-measured.width*.5,(center.y-measured.height*.5)+1) withAttributes:attributes];
}
// 0x10006a3e8: unlike drawAllText, size/15 uses signed integer division.
- (void)drawTextOfCurrentStroke:(NSDictionary *)stroke {
    NSColor *color=stroke[@"color"]; int size=[stroke[@"size"] intValue]; NSScrollView *scroll=stroke[@"scrollView"];
    double pad=size/15+2;
    double x=((scroll.frame.origin.x-self.frame.origin.x)-6.0)-pad;
    double y=((scroll.frame.origin.y-self.frame.origin.y)-6.0)-3.0;
    double width=scroll.frame.size.width+3.0-pad,height=scroll.frame.size.height+8.0;
    NSRect rect=NSMakeRect(x,y,width,height);
    [[color colorWithAlphaComponent:1] set]; NSBezierPath *path=[NSBezierPath bezierPathWithRect:rect]; path.lineWidth=1; [path stroke];
    [[NSColor.clearColor colorWithAlphaComponent:.002] set]; [NSBezierPath bezierPathWithRect:NSInsetRect(rect,-4,-4)]; path.lineWidth=8; [path stroke];
}
// 0x100067810
- (void)drawAllLine:(NSDictionary *)stroke {
    NSColor *color=stroke[@"color"];
    color=IShotDrawingColor(color,stroke); [color set];
    IShotDrawingCoordinates p=IShotDrawingGetCoordinates(self,stroke); int width=[stroke[@"size"] intValue];
    int type=[stroke[@"type"] intValue];
    CGPoint start=CGPointMake(p.x1,p.y1),end=CGPointMake(p.x2,p.y2);
    CGPoint control1=NSZeroPoint,control2=NSZeroPoint;
    if(type==3) {
        if([stroke[@"normalTypeOfArrow"] isEqualToString:@"0"]) IShotDrawingStraightArrow(self,start,end,width,color);
        else {
            control1=NSPointFromString(stroke[@"controlPoint1"]); control2=NSPointFromString(stroke[@"controlPoint2"]);
            control1.x-=self.frame.origin.x; control1.y-=self.frame.origin.y;
            control2.x-=self.frame.origin.x; control2.y-=self.frame.origin.y;
            IShotFunction_10004cc38(start,end,control1,control2,(double)width);
        }
    } else {
        CGContextRef context=NSGraphicsContext.currentContext.graphicsPort;
        if(context) {
            CGContextSaveGState(context); CGContextSetFillColorWithColor(context,color.CGColor); CGContextSetLineWidth(context,width);
            CGContextSetLineJoin(context,1); CGContextSetLineCap(context,1); CGContextBeginPath(context);
            CGContextMoveToPoint(context,start.x,start.y); CGContextAddLineToPoint(context,end.x,end.y); CGContextDrawPath(context,2); CGContextRestoreGState(context);
        }
        NSBezierPath *path=NSBezierPath.bezierPath; [[NSColor.clearColor colorWithAlphaComponent:.002] set]; path.lineWidth=7;
        [path moveToPoint:start]; [path lineToPoint:end]; [path stroke];
    }
}
// 0x100069570
- (void)drawLineOfCurrentStroke:(NSDictionary *)stroke {
    NSColor *color=stroke[@"color"];
    if(!stroke[@"X2"]) return;
    IShotDrawingCoordinates p=IShotDrawingGetCoordinates(self,stroke); int width=[stroke[@"size"] intValue];
    color=IShotDrawingColor(color,stroke); [color set];
    int type=[stroke[@"type"] intValue];
    CGPoint start=CGPointMake(p.x1,p.y1),end=CGPointMake(p.x2,p.y2);
    CGPoint control1=NSZeroPoint,control2=NSZeroPoint;
    if(type==3) {
        if([stroke[@"normalTypeOfArrow"] isEqualToString:@"0"]) IShotDrawingStraightArrow(self,start,end,width,color);
        else {
            control1=NSPointFromString(stroke[@"controlPoint1"]); control2=NSPointFromString(stroke[@"controlPoint2"]);
            control1.x-=self.frame.origin.x; control1.y-=self.frame.origin.y;
            control2.x-=self.frame.origin.x; control2.y-=self.frame.origin.y;
            IShotFunction_10004cc38(start,end,control1,control2,(double)width);
        }
    } else {
        CGContextRef context=NSGraphicsContext.currentContext.graphicsPort;
        if(context) {
            CGContextSaveGState(context); CGContextSetFillColorWithColor(context,color.CGColor); CGContextSetLineWidth(context,width);
            CGContextSetLineJoin(context,1); CGContextSetLineCap(context,1); CGContextBeginPath(context);
            CGContextMoveToPoint(context,start.x,start.y); CGContextAddLineToPoint(context,end.x,end.y); CGContextDrawPath(context,2); CGContextRestoreGState(context);
        }
        NSBezierPath *path=NSBezierPath.bezierPath; [[NSColor.clearColor colorWithAlphaComponent:.002] set]; path.lineWidth=7;
        [path moveToPoint:start]; [path lineToPoint:end]; [path stroke];
    }
    CGContextRef context=NSGraphicsContext.currentContext.graphicsPort;
    if(context) {
        CGColorRef handleColor=color.CGColor;
        IShotDrawingHandle(context,handleColor,CGRectMake((float)(p.x1-5.f),(float)(p.y1-5.f),10,10));
        IShotDrawingHandle(context,handleColor,CGRectMake((float)(p.x2-5.f),(float)(p.y2-5.f),10,10));
        if([stroke[@"normalTypeOfArrow"] isEqualToString:@"1"]) {
            IShotDrawingHandle(context,color.CGColor,CGRectMake(control1.x-5,control1.y-5,10,10));
            IShotDrawingHandle(context,color.CGColor,CGRectMake(control2.x-5,control2.y-5,10,10));
        }
    }
}
