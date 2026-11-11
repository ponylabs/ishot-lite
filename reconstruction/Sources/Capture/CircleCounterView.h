#pragma once
#import <Cocoa/Cocoa.h>
@class CircleCounterView;
@protocol CircleCounterViewDelegate <NSObject>
- (void)counterDownFinished:(CircleCounterView *)counter;
@end
@interface CircleCounterView : NSView {
    float mCircleTimeInterval;
    NSColor *mNumberColor;
    NSFont *mNumberFont;
    NSColor *mCircleColor;
    double mCircleBorderWidth;
    float mTimeInSeconds, mTimeInterval;
    NSString *mTimeFormatString;
    BOOL mIsRunning;
    int mCircleSegs;
    BOOL mCircleIncre;
    __unsafe_unretained id<CircleCounterViewDelegate> _delegate;
}
@property(nonatomic,strong) NSString *timeFormatString;
@property(nonatomic,assign) id<CircleCounterViewDelegate> delegate;
@property(nonatomic) BOOL circleIncre;
@property(nonatomic,strong) NSColor *numberColor;
@property(nonatomic,strong) NSFont *numberFont;
@property(nonatomic,strong) NSColor *circleColor;
@property(nonatomic) double circleBorderWidth;
@property(nonatomic) float circleTimeInterval;
- (void)setup;
- (void)startWithSeconds:(float)seconds;
- (void)startWithSeconds:(float)seconds andInterval:(float)interval;
- (void)startWithSeconds:(float)seconds andInterval:(float)interval andTimeFormat:(NSString *)format;
- (void)stop;
- (void)update:(id)sender;
- (void)updateTime:(id)sender;
@end
