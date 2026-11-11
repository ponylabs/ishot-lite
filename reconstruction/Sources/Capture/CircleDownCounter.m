#import "CircleDownCounter.h"
extern CircleDownCounter *IShotGlobal_1001f1be8;
#pragma clang fp contract(off)
@implementation CircleDownCounter
+ (CircleCounterView *)showCircleDownWithSeconds:(float)seconds onView:(NSView *)view {
    return [self showCircleDownWithSeconds:seconds onView:view withSize:CGSizeMake(44,44) andType:0];
}
+ (CircleCounterView *)showCircleDownWithSeconds:(float)seconds onView:(NSView *)view withSize:(CGSize)size {
    return [self showCircleDownWithSeconds:seconds onView:view withSize:size andType:0];
}
+ (CircleCounterView *)showCircleDownWithSeconds:(float)seconds onView:(NSView *)view withSize:(CGSize)size andType:(int)type {
    [self removeCircleViewFromView:view];
    CircleCounterView *counter=[[CircleCounterView alloc] initWithFrame:[self frameOfCircleViewOfSize:size inView:view]];
    [view addSubview:counter]; counter.delegate=[self circleDownCounter];
    switch(type) {
        case 2: counter.circleIncre=YES;
        case 0: [counter startWithSeconds:seconds]; break;
        case 3: counter.circleIncre=YES;
        case 1: counter.numberFont=[NSFont fontWithName:@"Courier-Bold" size:15]; [counter startWithSeconds:seconds andInterval:.1f andTimeFormat:@"%.1f"]; break;
    }
    return counter;
}
+ (void)removeCircleViewFromView:(NSView *)view { [[self circleViewInView:view] removeFromSuperview]; }
+ (CGRect)frameOfCircleViewOfSize:(CGSize)size inView:(NSView *)view {
    NSRect bounds=view.bounds;
    return CGRectInset(bounds,(CGRectGetWidth(view.bounds)-size.width)*.5,(CGRectGetHeight(view.bounds)-size.height)*.5);
}
+ (CircleCounterView *)circleViewInView:(NSView *)view {
    for(NSView *child in view.subviews) if([child isKindOfClass:[CircleCounterView class]]) return (CircleCounterView *)child;
    return nil;
}
+ (instancetype)circleDownCounter {
    if(!IShotGlobal_1001f1be8) IShotGlobal_1001f1be8=[[CircleDownCounter alloc] init];
    return IShotGlobal_1001f1be8;
}
- (void)counterDownFinished:(CircleCounterView *)counter { [counter removeFromSuperview]; }
@end
