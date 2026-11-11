#import <Cocoa/Cocoa.h>
#import "../Sources/Common/Utility.h"
#include <assert.h>
#include <math.h>
extern CGPoint IShotFunction_10004cdb8(CGPoint,CGPoint,CGPoint,CGPoint,double);
extern BOOL IShotFunction_10004ce78(CGPoint,CGPoint,CGPoint,CGPoint);
extern uint32_t IShotFunction_100048db8(NSString *);
int main(void) { @autoreleasepool {
    CGPoint p=IShotFunction_10004cdb8(CGPointMake(0,0),CGPointMake(0,4),CGPointMake(4,4),CGPointMake(4,0),.5);
    assert(p.x==2 && p.y==3);
    assert(IShotFunction_10004ce78(CGPointMake(1,1),CGPointMake(0,0),CGPointMake(4,0),CGPointMake(0,4)));
    assert(!IShotFunction_10004ce78(CGPointMake(4,4),CGPointMake(0,0),CGPointMake(4,0),CGPointMake(0,4)));
    assert(IShotFunction_100048db8(@"a")==0);
    assert(IShotFunction_100048db8(@"s")==1);
    assert(IShotFunction_100048db8(@"DELETE")==51);
    assert([[Utility digestString:@"abc"] isEqualToString:@"900150983CD24FB0D6963F7D28E17F72"]);
    puts("PASS common curve geometry, keycode comparisons, MD5");
} return 0; }
