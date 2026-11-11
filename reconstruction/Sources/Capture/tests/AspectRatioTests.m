#import <Cocoa/Cocoa.h>
#include <assert.h>
extern CGRect IShotFunction_10004d14c(CGPoint,CGPoint,CGRect,double);
int main(void) {
    CGRect area=CGRectMake(3,7,90,60); CGPoint begin=CGPointMake(100,100);
    assert(CGRectEqualToRect(IShotFunction_10004d14c(begin,CGPointMake(110,110),area,2),CGRectMake(100,100,30,60)));
    assert(CGRectEqualToRect(IShotFunction_10004d14c(begin,CGPointMake(90,90),area,2),CGRectMake(70,40,30,60)));
    assert(CGRectEqualToRect(IShotFunction_10004d14c(begin,CGPointMake(110,90),area,2),CGRectMake(100,40,30,60)));
    assert(CGRectEqualToRect(IShotFunction_10004d14c(begin,CGPointMake(90,110),area,2),CGRectMake(70,100,30,60)));
    assert(CGRectEqualToRect(IShotFunction_10004d14c(begin,CGPointMake(100,110),area,2),CGRectZero));
    assert(CGRectEqualToRect(IShotFunction_10004d14c(begin,CGPointMake(110,110),area,0.5),CGRectMake(100,100,90,45)));
    NSLog(@"AspectRatioTests passed");
}
