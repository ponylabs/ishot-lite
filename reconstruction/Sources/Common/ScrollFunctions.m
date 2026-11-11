#import <Cocoa/Cocoa.h>
#include <math.h>
// 0x10004d490; REA ev_ca022dd133f68723d4fdc35c3fefb59dbf9a96a530dfc535f8ace1297b593d74.
static float IShotGlobal_1001f1948;
BOOL IShotFunction_10004d490(NSEvent *event) {
    float delta = fabsf((float)event.deltaY);
    BOOL suppress = NO;
    if ((event.phase | event.momentumPhase) == 0) {
        if (delta > IShotGlobal_1001f1948 ||
            [[NSString stringWithFormat:@"%f", (double)delta] isEqualToString:@"0.100006"]) {
            NSString *previous = [NSString stringWithFormat:@"%f", (double)IShotGlobal_1001f1948];
            suppress = !(IShotGlobal_1001f1948 >= 1.0f) && [previous containsString:@"999"];
        } else {
            suppress = YES;
        }
    }
    IShotGlobal_1001f1948 = delta;
    return suppress;
}
