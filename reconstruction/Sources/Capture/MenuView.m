#import "MenuView.h"
#import "../MainApplication/AppDelegate.h"
#import <CoreMedia/CoreMedia.h>
// The metadata of SGCaptureSession::lastVideo (0x1000bcc24) encodes CMTime.
@interface SGCaptureSession : NSObject
- (CMTime)lastVideo;
@end
extern SGCaptureSession *IShotGlobal_1001dddb0;
extern int32_t IShotGlobal_1001ddf78;
static BOOL IShotMenuStopped_1001f1928;
static NSInteger IShotMenuMinutes_1001f1930;
static int32_t IShotMenuLastSecond_1001f1938;
@implementation MenuView
// 0x1000455bc. Frames and enum constants are literal machine-code operands.
- (instancetype)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.annotateButton = [[NSButton alloc] initWithFrame:NSMakeRect(3, 1, 20, 20)];
        NSImage *image = [NSImage imageNamed:@"annotate"];
        image.size = NSMakeSize(20, 20);
        image.template = YES;
        [self.annotateButton setButtonType:5];
        self.annotateButton.image = image;
        self.annotateButton.imagePosition = 1;
        self.annotateButton.bordered = NO;
        self.annotateButton.toolTip = [[NSBundle mainBundle] localizedStringForKey:@"Annotate" value:@"" table:nil];
        self.annotateButton.target = self;
        self.annotateButton.action = @selector(annotateButtonClick:);
        [self addSubview:self.annotateButton];
        self.stopButton = [[NSButton alloc] initWithFrame:NSMakeRect(28, 1, 20, 20)];
        image = [NSImage imageNamed:@"Recordingstop"];
        image.size = NSMakeSize(20, 20);
        [self.stopButton setButtonType:5];
        self.stopButton.image = image;
        self.stopButton.imagePosition = 1;
        self.stopButton.bordered = NO;
        self.stopButton.toolTip = [[NSBundle mainBundle] localizedStringForKey:@"Stop" value:@"" table:nil];
        self.stopButton.target = self;
        self.stopButton.action = @selector(stopButtonClick:);
        [self addSubview:self.stopButton];
        self.durationButton = [[NSButton alloc] initWithFrame:NSMakeRect(53, 2, 62, 20)];
        self.durationButton.title = @"00:00:00";
        self.durationButton.alignment = 0;
        self.durationButton.bordered = NO;
        self.durationButton.target = self;
        [self addSubview:self.durationButton];
        image = [NSImage imageNamed:@"Recordingpause"];
        image.size = NSMakeSize(20, 20);
        self.pauseButton = [[NSButton alloc] initWithFrame:NSMakeRect(108, 1, 20, 20)];
        [self.pauseButton setButtonType:2];
        self.pauseButton.image = image;
        self.pauseButton.bordered = NO;
        self.pauseButton.state = 1;
        self.pauseButton.bezelStyle = 1;
        self.pauseButton.toolTip = [[NSBundle mainBundle] localizedStringForKey:@"Pause" value:@"" table:nil];
        self.pauseButton.target = self;
        self.pauseButton.action = @selector(pauseButtonClick:);
        [self addSubview:self.pauseButton];
        IShotMenuStopped_1001f1928 = NO;
        // Blocks 0x100045da0 and 0x100045e74, including the original strong self capture.
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:0.5];
            while (!IShotMenuStopped_1001f1928) {
                dispatch_async(dispatch_get_main_queue(), ^{ [self timerDurationTimeOut:nil]; });
                [NSThread sleepForTimeInterval:0.5];
            }
        });
        IShotMenuMinutes_1001f1930 = [[NSUserDefaults standardUserDefaults] integerForKey:@"totalTimesOfRecordScreen"];
        if (@available(macOS 27.0, *)) [self installGlobalMouseMonitor];
    }
    return self;
}
// 0x100045e80
- (void)dealloc { [self uninstallGlobalMouseMonitor]; }
// 0x100045ec4, blocks 0x100045fc4 and 0x100046210.
- (void)installGlobalMouseMonitor {
    if (!self.mouseDownMonitor) {
        self.mouseDownMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:2 handler:^(NSEvent *event) {
            NSPoint point = [NSEvent mouseLocation];
            NSWindow *window = self.window;
            if (window) {
                point = [self convertPoint:[window convertPointFromScreen:point] fromView:nil];
                if (NSPointInRect(point, self.annotateButton.frame)) {
                    [self annotateButtonClick:self.annotateButton];
                    [self.annotateButton highlight:YES];
                } else if (NSPointInRect(point, self.stopButton.frame)) {
                    [self stopButtonClick:self.stopButton];
                    [self.stopButton highlight:YES];
                } else if (NSPointInRect(point, self.pauseButton.frame)) {
                    [self pauseButtonClick:self.pauseButton];
                    [self.pauseButton highlight:YES];
                }
            }
        }];
        self.mouseUpMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:4 handler:^(NSEvent *event) {
            [self.annotateButton highlight:NO];
            [self.stopButton highlight:NO];
            [self.pauseButton highlight:NO];
        }];
    }
}
// 0x100046294
- (void)uninstallGlobalMouseMonitor {
    if (self.mouseDownMonitor) { [NSEvent removeMonitor:self.mouseDownMonitor]; self.mouseDownMonitor = nil; }
    if (self.mouseUpMonitor) { [NSEvent removeMonitor:self.mouseUpMonitor]; self.mouseUpMonitor = nil; }
}
// 0x10004636c
- (void)stopButtonClick:(id)sender {
    if (@available(macOS 27.0, *)) [self uninstallGlobalMouseMonitor];
    [[AppDelegate appDelegate] stopRecorder:nil];
}
// 0x1000463cc
- (void)annotateButtonClick:(id)sender { [[AppDelegate appDelegate] annotatedWhenRecordScreenClick:nil]; }
// 0x100046408: frame origin, followed by x + 0.0 and y - 7.0.
- (void)durationButtonClick:(id)sender {
    NSRect frame = self.durationButton.frame;
    [[[AppDelegate appDelegate] statusItemMenu] popUpMenuPositioningItem:nil atLocation:NSMakePoint(frame.origin.x + 0.0, frame.origin.y - 7.0) inView:self];
}
// 0x1000464b0
- (void)endRecord {
    [self.window resetCursorRects];
    [self.durationButton setStringValue:@"00:00:00"];
    NSImage *image = [NSImage imageNamed:@"Recordingpause"];
    image.size = NSMakeSize(20, 20);
    self.pauseButton.image = image;
    IShotMenuStopped_1001f1928 = YES;
}
// 0x100046570
- (void)pauseButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SGVideoControllerPauseAndResumeNotification" object:nil];
    NSString *imageName;
    if ([self.pauseButton.toolTip isEqualToString:[[NSBundle mainBundle] localizedStringForKey:@"Pause" value:@"" table:nil]]) {
        self.pauseButton.state = 0;
        self.pauseButton.toolTip = [[NSBundle mainBundle] localizedStringForKey:@"Continue" value:@"" table:nil];
        imageName = @"Recordingpausing";
    } else {
        self.pauseButton.state = 1;
        self.pauseButton.toolTip = [[NSBundle mainBundle] localizedStringForKey:@"Pause" value:@"" table:nil];
        imageName = @"Recordingpause";
    }
    NSImage *image = [NSImage imageNamed:imageName];
    image.size = NSMakeSize(20, 20);
    self.pauseButton.image = image;
}
// 0x1000467dc. The counter increments once on any changed video second, not by its delta.
- (void)timerDurationTimeOut:(id)sender {
    CMTime time = IShotGlobal_1001dddb0 ? [IShotGlobal_1001dddb0 lastVideo] : (CMTime){0};
    int32_t second = (int32_t)CMTimeGetSeconds(time);
    if (IShotMenuLastSecond_1001f1938 != second) IShotGlobal_1001ddf78++;
    IShotMenuLastSecond_1001f1938 = second;
    if (IShotMenuMinutes_1001f1930 > 0 && IShotMenuMinutes_1001f1930 * 60 < (NSInteger)IShotGlobal_1001ddf78)
        [self stopButtonClick:self];
    int32_t count = IShotGlobal_1001ddf78;
    NSString *formatted = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)((count / 3600) % 60), (unsigned long)((count / 60) % 60), (unsigned long)(count % 60)];
    self.durationButton.title = [NSString stringWithFormat:@"%@", formatted];
}
// These five empty methods are verified RET-only in the original binary.
- (void)drawRect:(NSRect)rect {} // 0x10004699c
- (void)keyDown:(NSEvent *)event {} // 0x1000469a0
- (void)mouseMoved:(NSEvent *)event {} // 0x1000469a4
- (void)mouseUp:(NSEvent *)event {} // 0x1000469e0
- (void)mouseExited:(NSEvent *)event { NSLog(@"退出"); } // 0x1000469a8
- (void)mouseEntered:(NSEvent *)event { NSLog(@"进入"); } // 0x1000469c4
@end
