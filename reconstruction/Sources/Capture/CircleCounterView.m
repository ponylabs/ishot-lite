#import "CircleCounterView.h"
#import <QuartzCore/QuartzCore.h>
#pragma clang fp contract(off)
@implementation CircleCounterView
@synthesize timeFormatString=mTimeFormatString, delegate=_delegate, circleIncre=mCircleIncre;
@synthesize numberColor=mNumberColor, numberFont=mNumberFont, circleColor=mCircleColor;
@synthesize circleBorderWidth=mCircleBorderWidth, circleTimeInterval=mCircleTimeInterval;
- (void)awakeFromNib { [super awakeFromNib]; [self setup]; }
- (instancetype)initWithFrame:(NSRect)frame { self=[super initWithFrame:frame]; if(self) [self setup]; return self; }
- (void)dealloc { self.numberFont=nil; self.numberColor=nil; self.circleColor=nil; self.circleBorderWidth=0; self.timeFormatString=nil; }
- (void)setup {
    mIsRunning=NO;
    self.numberColor=[NSColor blackColor]; self.numberFont=[NSFont fontWithName:@"Courier-Bold" size:20];
    self.circleColor=[NSColor blackColor]; self.circleBorderWidth=6;
    self.timeFormatString=@"%.0f"; self.circleIncre=NO; self.circleTimeInterval=1.f;
    mTimeInSeconds=20.f; mTimeInterval=1.f; mCircleSegs=0;
    self.wantsLayer=YES;
    self.layer.backgroundColor=[NSColor colorWithWhite:(double).1f alpha:.5].CGColor;
    self.layer.cornerRadius=10;
}
- (void)startWithSeconds:(float)seconds andInterval:(float)interval andTimeFormat:(NSString *)format {
    self.timeFormatString=format; [self startWithSeconds:seconds andInterval:interval];
}
- (void)startWithSeconds:(float)seconds andInterval:(float)interval {
    mTimeInterval=interval<=seconds ? interval : seconds/10.f; [self startWithSeconds:seconds];
}
- (void)startWithSeconds:(float)seconds {
    if(seconds>0.f) { mTimeInSeconds=seconds; mIsRunning=YES; mCircleSegs=0; [self update:nil]; [self updateTime:nil]; }
}
- (void)stop { mIsRunning=NO; }
- (void)update:(id)sender {
    if(mIsRunning) {
        mCircleSegs=(int32_t)((uint32_t)mCircleSegs+1)%30;
        if((double)fabsf(mTimeInSeconds)<.0001) {
            mCircleSegs=29; mTimeInSeconds=0;
            if(self.superview) [self.delegate counterDownFinished:self];
        } else [NSTimer scheduledTimerWithTimeInterval:(double)(self.circleTimeInterval/30.f) target:self selector:@selector(update:) userInfo:nil repeats:NO];
        self.needsDisplay=YES;
    }
}
- (void)updateTime:(id)sender {
    if(mIsRunning) {
        mTimeInSeconds-=mTimeInterval;
        if((double)fabsf(mTimeInSeconds)<.0001) {
            mCircleSegs=29; mTimeInSeconds=0; self.needsDisplay=YES;
            if(self.superview) [self.delegate counterDownFinished:self];
        } else [NSTimer scheduledTimerWithTimeInterval:(double)mTimeInterval target:self selector:@selector(updateTime:) userInfo:nil repeats:NO];
    }
}
- (void)drawRect:(NSRect)rect {
    CGContextRef context=[[NSGraphicsContext currentContext] graphicsPort];
    float radius=(float)(CGRectGetWidth(rect)*.5-self.circleBorderWidth*.5-45.);
    CGContextSetLineWidth(context,self.circleBorderWidth); CGContextBeginPath(context);
    BOOL incre=self.circleIncre;
    double x=CGRectGetMidX(rect), y=CGRectGetMidY(rect);
    double angle=(double)((float)(int32_t)((uint32_t)mCircleSegs+1)/30.f)*3.141592653589793;
    angle=angle+angle-1.5707963705062866;
    CGContextAddArc(context,x,y,radius,incre ? -1.5707963705062866:angle,incre ? angle:4.7123889366733,0);
    CGContextSetStrokeColorWithColor(context,self.circleColor.CGColor); CGContextStrokePath(context); CGContextSetLineWidth(context,1);
    [self.numberColor set];
    NSString *text=[NSString stringWithFormat:self.timeFormatString,(double)mTimeInSeconds];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue Bold" size:45],NSFontAttributeName,self.numberColor,NSForegroundColorAttributeName,nil];
    NSSize size=[text sizeWithAttributes:attributes];
    NSRect textRect=NSInsetRect(rect,(CGRectGetWidth(rect)-size.width)*.5,(CGRectGetHeight(rect)-size.height)*.5);
    [text drawInRect:textRect withAttributes:attributes];
}
@end
