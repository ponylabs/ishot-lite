#pragma once
#import "CircleCounterView.h"
@interface CircleDownCounter : NSObject <CircleCounterViewDelegate>
+ (CircleCounterView *)showCircleDownWithSeconds:(float)seconds onView:(NSView *)view;
+ (CircleCounterView *)showCircleDownWithSeconds:(float)seconds onView:(NSView *)view withSize:(CGSize)size;
+ (CircleCounterView *)showCircleDownWithSeconds:(float)seconds onView:(NSView *)view withSize:(CGSize)size andType:(int)type;
+ (void)removeCircleViewFromView:(NSView *)view;
+ (CGRect)frameOfCircleViewOfSize:(CGSize)size inView:(NSView *)view;
+ (CircleCounterView *)circleViewInView:(NSView *)view;
+ (instancetype)circleDownCounter;
@end
