#import "../CircleDownCounter.h"
#import "../KeyEventSettingPopoverViewController.h"
CircleDownCounter *IShotGlobal_1001f1be8;
@interface CounterDelegate : NSObject<CircleCounterViewDelegate>
@property int finished;
@end
@implementation CounterDelegate
- (void)counterDownFinished:(CircleCounterView *)v { self.finished++; }
@end
int main(void) { @autoreleasepool {
    [NSApplication sharedApplication];
    NSView *parent=[[NSView alloc] initWithFrame:NSMakeRect(0,0,300,200)];
    NSCAssert(NSEqualRects([CircleDownCounter frameOfCircleViewOfSize:NSMakeSize(44,44) inView:parent],NSMakeRect(128,78,44,44)),@"center");
    CircleCounterView *v=[CircleDownCounter showCircleDownWithSeconds:0 onView:parent withSize:NSMakeSize(160,160) andType:3];
    NSCAssert(v.circleIncre && [v.timeFormatString isEqual:@"%.1f"],@"mode3");
    NSCAssert([CircleDownCounter circleViewInView:parent]==v,@"lookup");
    CounterDelegate *delegate=[CounterDelegate new];v.delegate=delegate;
    [v startWithSeconds:1 andInterval:1];
    NSCAssert(delegate.finished==1 && [[v valueForKey:@"mTimeInSeconds"] floatValue]==0,@"immediate tick completes");
    [v stop]; [v update:nil]; [v updateTime:nil]; NSCAssert(delegate.finished==1,@"stop");
    NSBitmapImageRep *bitmap=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:160 pixelsHigh:160 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    [NSGraphicsContext saveGraphicsState]; [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:bitmap]];
    [v drawRect:NSMakeRect(0,0,160,160)]; [NSGraphicsContext restoreGraphicsState];
    BOOL any=NO;for(NSUInteger i=0;i<(NSUInteger)(bitmap.bytesPerRow*160);i++) if(bitmap.bitmapData[i]) {any=YES;break;}
    NSCAssert(any,@"rendered countdown"); [CircleDownCounter removeCircleViewFromView:parent]; NSCAssert(v.superview==nil,@"remove");
    KeyEventSettingPopoverViewController *settings=[KeyEventSettingPopoverViewController new];
    NSUserDefaults *d=NSUserDefaults.standardUserDefaults;
    NSArray *keys=@[@"sizeOfKeyEvent",@"delayOfKeyEvent",@"maxKeysOfKeyEvent",@"appearanceLightOfKeyEvent",@"appearanceDarkOfKeyEvent",@"appearanceAutoOfKeyEvent"];
    NSMutableDictionary *old=[NSMutableDictionary new];for(NSString *key in keys) if([d objectForKey:key]) old[key]=[d objectForKey:key];
    [settings adjustSize:@24.9f];NSCAssert([d floatForKey:keys[0]]==20.f,@"round size");
    [settings adjustDelayTime:@1.26f];NSCAssert([d floatForKey:keys[1]]==1.3f,@"round delay");
    [settings adjustMaxKeys:@3.6f];NSCAssert([d floatForKey:keys[2]]==4.f,@"round keys");
    NSButton *button=[NSButton new];button.tag=2;[settings radioButtonSelected:button];
    NSCAssert(![d boolForKey:keys[3]] && ![d boolForKey:keys[4]] && [d boolForKey:keys[5]],@"auto appearance");
    for(NSString *key in keys) if(old[key]) [d setObject:old[key] forKey:key];else[d removeObjectForKey:key];
    NSLog(@"PASS countdown geometry/types/immediate completion/stop/render and key settings");
} return 0; }
