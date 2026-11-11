static CGRect IShotMXNormalizeMosaicRect(CGRect rect) {
    float width=(float)fabs(rect.size.width),height=(float)fabs(rect.size.height);
    float x=(float)((rect.origin.x+rect.size.width*.5)-(double)(width*.5f));
    float y=(float)((rect.origin.y+rect.size.height*.5)-(double)(height*.5f));
    return CGRectMake(x,y,width,height);
}
static void IShotMXDrawDashedRect(CGRect rect) {
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    CGFloat dash[4]={5,5,5,5};
    CGContextSetRGBStrokeColor(context,.5,.5,.5,1); CGContextSetLineDash(context,0,dash,4);
    CGContextSetLineWidth(context,2); CGContextAddRect(context,rect); CGContextDrawPath(context,kCGPathStroke);
}
