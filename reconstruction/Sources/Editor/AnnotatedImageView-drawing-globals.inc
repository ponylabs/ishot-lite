// Drawing-only support, recovered from the procedures listed in drawing-source-evidence.json.
extern NSMutableDictionary *IShotGlobal_1001de058;
#pragma STDC FP_CONTRACT OFF
// 0x10004cc38: ninth double is passed on the stack after four CGPoint values.
static void IShotFunction_10004cc38(CGPoint start, CGPoint end, CGPoint control1, CGPoint control2, double width) {
    NSBezierPath *curve=NSBezierPath.bezierPath;
    [curve moveToPoint:start]; [curve curveToPoint:end controlPoint1:control1 controlPoint2:control2]; curve.lineWidth=width; [curve stroke];
    NSBezierPath *arrow=NSBezierPath.bezierPath;
    double size=width+3.0,dx=end.x-control2.x,dy=end.y-control2.y;
    double length=hypot(dx,dy),alongX=size*(dx/length),alongY=size*(dy/length);
    double tipX=end.x+(alongX+alongX),tipY=end.y+(alongY+alongY);
    double norm=sqrt(dy*dy+dx*dx),acrossX=size*(-dy/norm),acrossY=size*(dx/norm);
    [arrow moveToPoint:NSMakePoint(end.x+acrossX,end.y+acrossY)];
    [arrow lineToPoint:NSMakePoint(end.x-acrossX,end.y-acrossY)];
    [arrow lineToPoint:NSMakePoint(tipX,tipY)]; [arrow fill];
}
// Common instruction sequences factored without changing their float-to-double boundaries.
typedef struct { float x1,y1,x2,y2; } IShotDrawingCoordinates;
static IShotDrawingCoordinates IShotDrawingGetCoordinates(NSView *view, NSDictionary *stroke) {
    IShotDrawingCoordinates p;
    p.x1=(float)((double)[stroke[@"X1"] floatValue]-view.frame.origin.x);
    p.y1=(float)((double)[stroke[@"Y1"] floatValue]-view.frame.origin.y);
    p.x2=(float)((double)[stroke[@"X2"] floatValue]-view.frame.origin.x);
    p.y2=(float)((double)[stroke[@"Y2"] floatValue]-view.frame.origin.y);
    return p;
}
static NSColor *IShotDrawingColor(NSColor *color, NSDictionary *stroke) {
    float alpha=stroke[@"colorAlpha"]?[stroke[@"colorAlpha"] floatValue]:1.f;
    return [color colorWithAlphaComponent:(double)(alpha==0.f?.01f:alpha)];
}
static void IShotDrawingHandle(CGContextRef context, CGColorRef color, CGRect rect) {
    CGContextSetFillColorWithColor(context,color); CGContextFillEllipseInRect(context,rect);
    CGContextSetRGBFillColor(context,1,1,1,.95); CGContextFillEllipseInRect(context,CGRectInset(rect,1,1));
}
// Shared straight-arrow polygon sequence at 0x100067a8c and 0x100069824.
static void IShotDrawingStraightArrow(AnnotatedImageView *view, CGPoint start, CGPoint end, int width, NSColor *color) {
    CGContextRef context=NSGraphicsContext.currentContext.graphicsPort;
    CGColorRef fill=color.CGColor; CGContextSetStrokeColorWithColor(context,color.CGColor); CGContextSetLineWidth(context,1);
    [NSBezierPath setDefaultLineCapStyle:0]; [NSBezierPath setDefaultLineJoinStyle:1]; CGContextSetFillColorWithColor(context,fill);
    double angle=[view angleBetweenPoint:end and:start]; CGContextSaveGState(context); CGContextTranslateCTM(context,start.x,start.y); CGContextRotateCTM(context,angle);
    double distance=[view distanceBetweenPoint:start and:end],scale=distance==0?1.0/30.0:distance/30.0;
    NSBezierPath *path=NSBezierPath.bezierPath;
    int32_t expanded=(int32_t)((uint32_t)width*3U+2U); double head=expanded/scale;
    [path moveToPoint:NSMakePoint(0,.05)]; double neck=30.0-head;
    [path lineToPoint:NSMakePoint(neck,head*.4)]; double shoulder=head*-1.1+30.0;
    [path lineToPoint:NSMakePoint(shoulder,head*.8)]; [path lineToPoint:NSMakePoint(30,0)];
    [path lineToPoint:NSMakePoint(shoulder,head*-.8)]; [path lineToPoint:NSMakePoint(neck,head*-.4)];
    [path lineToPoint:NSMakePoint(0,-.05)]; [path closePath];
    NSAffineTransform *transform=NSAffineTransform.transform; [transform scaleBy:scale]; [path transformUsingAffineTransform:transform]; [path fill];
    // Original reverses CTM manually and leaves its saved GState on the stack.
    CGContextRotateCTM(context,-angle); CGContextTranslateCTM(context,-start.x,-start.y);
}
