#import <Cocoa/Cocoa.h>
#pragma clang fp contract(off)
// 0x10004cdb8: four CGPoint arguments occupy d0-d7; t is the stack double.
CGPoint IShotFunction_10004cdb8(CGPoint a,CGPoint b,CGPoint c,CGPoint d,double t) {
    double u=1.0-t,t2=t*t,u2=u*u,u3=u*u2,t3=t2*t;
    double bWeight=(u2*3.0)*t,cWeight=t2*(u*3.0);
    return CGPointMake(d.x*t3+(c.x*cWeight+(a.x*u3+b.x*bWeight)),
                       d.y*t3+(c.y*cWeight+(a.y*u3+b.y*bWeight)));
}
// 0x10004ce78: ordered comparisons, including the original NaN behavior.
BOOL IShotFunction_10004ce78(CGPoint p,CGPoint a,CGPoint b,CGPoint c) {
    double first=(p.x-c.x)*(a.y-c.y)-(a.x-c.x)*(p.y-c.y);
    double second=(p.x-a.x)*(b.y-a.y)-(p.y-a.y)*(b.x-a.x);
    double third=(p.x-b.x)*(c.y-b.y)-(p.y-b.y)*(c.x-b.x);
    BOOL negative=first<0 || second<0 || third<0;
    BOOL positive=first>0 || second>0 || third>0;
    return !(negative && positive);
}
