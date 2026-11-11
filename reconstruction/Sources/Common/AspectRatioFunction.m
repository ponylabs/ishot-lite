#import <Cocoa/Cocoa.h>
// 0x10004d14c. CGPoint+CGPoint+CGRect occupy d0..d7; ratio is stack arg.
// Returns CGRect in d0..d3. Intermediate dimensions are deliberately float.
CGRect IShotFunction_10004d14c(CGPoint begin,CGPoint end,CGRect rectangle,double ratio) {
    float width=(float)rectangle.size.width,limit=(float)rectangle.size.height;
    float height=(float)((double)width*ratio);
    if(height>=limit) { width=(float)((double)limit/ratio); height=limit; }
    if(end.x<begin.x && end.y<begin.y) return CGRectMake(begin.x-width,begin.y-height,width,height);
    if(end.x>begin.x && end.y>begin.y) return CGRectMake(begin.x,begin.y,width,height);
    if(end.x>begin.x && end.y<begin.y) return CGRectMake(begin.x,begin.y-height,width,height);
    if(end.x<begin.x && end.y>begin.y) return CGRectMake(begin.x-width,begin.y,width,height);
    return CGRectZero;
}
