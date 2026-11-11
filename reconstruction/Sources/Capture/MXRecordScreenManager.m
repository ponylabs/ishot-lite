#import "MXRecordScreenManager.h"
#import "CaptureDependencies.h"
#import "CaptureAudioFunctions.h"
#import <AVFoundation/AVFoundation.h>
#import <unistd.h>
extern BOOL IShotGlobal_1001de1a8, IShotGlobal_1001ddde0, IShotGlobal_1001de2a1;
extern NSCursor *IShotGlobal_1001dddf8;
extern NSWindowController *IShotGlobal_1001ddd68;
extern AudioDeviceID IShotGlobal_1001de220;
@implementation MXRecordScreenManager
// 0x1000617f4, block 0x100061834
+ (instancetype)sharedInstance {
    static MXRecordScreenManager *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [[MXRecordScreenManager alloc] init]; });
    return instance;
}
// 0x100061864, global block 0x100061928
- (instancetype)init {
    if ((self = [super init])) {
        self.recordWindowControllerArray = [NSMutableArray array];
        self.isWorking = NO;
        IShotGlobal_1001de1a8 = NO;
        IShotGlobal_1001ddde0 = NO;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
            [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        });
    }
    return self;
}
// 0x10006197c; block 0x100061c98 deliberately reads working before the caller sets it.
- (void)readyToRecordScreen {
    if (IShotGlobal_1001de2a1 || self.isWorking) return;
    [NSCursor hide];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (self.isWorking) {
            if (IShotGlobal_1001dddf8) [IShotGlobal_1001dddf8 set];
            usleep(1000);
        }
    });
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"keyboardInfoArr"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"totalTimesOfRecordScreen"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.isWorking = YES;
    IShotGlobal_1001de1a8 = YES;
    [self clearRecordWindowControllerArray];
    self.arrayRect = [NSMutableArray array];
    IShotGlobal_1001ddde0 = NO;
    NSArray *windows = CFBridgingRelease(CGWindowListCopyWindowInfo(1, 0));
    for (NSUInteger i = 0; i < windows.count; i++) [self.arrayRect addObject:windows[i]];
    for (NSScreen *screen in [NSScreen screens]) {
        MXRecordScreenWindowController *controller = [[MXRecordScreenWindowController alloc] initWithDelegate:self];
        [controller startRecorderScreen:screen];
        [self.recordWindowControllerArray addObject:controller];
    }
}
// 0x100061ce8
- (void)changeKeyWindowWithScreen:(NSScreen *)screen {
    for (MXRecordScreenWindowController *controller in self.recordWindowControllerArray) {
        if ([[controller screen] isEqual:screen]) [[controller window] makeKeyAndOrderFront:nil];
    }
}
// 0x100061e50
- (void)reset {
    self.isWorking = NO;
    IShotGlobal_1001de1a8 = NO;
    IShotGlobal_1001ddde0 = NO;
    [self clearRecordWindowControllerArray];
}
// 0x100061e90
- (void)recordScreenWindowController:(id)controller finishRecordWithFileName:(id)name saveToLocal:(BOOL)save {
    [self clearRecordWindowControllerArray];
    self.isWorking = NO;
    IShotGlobal_1001de1a8 = NO;
    IShotGlobal_1001ddde0 = NO;
}
// 0x100061ed4, block 0x100061f94
- (void)recordScreenWindowControllerDidSelectRegion:(id)controller {
    NSMutableArray *copy = [self.recordWindowControllerArray mutableCopy];
    [copy enumerateObjectsUsingBlock:^(MXRecordScreenWindowController *item, NSUInteger index, BOOL *stop) {
        if (![item isEqual:controller]) {
            [item cleanup];
            [self.recordWindowControllerArray removeObject:item];
        }
    }];
    [copy removeAllObjects];
}
// 0x100061ff8, assembly thunk 0x100062030 -> removeEventMonitor
- (void)recordScreenWindowControllerRemoveEventMonitor:(id)controller {
    [self.recordWindowControllerArray enumerateObjectsUsingBlock:^(MXRecordScreenWindowController *item, NSUInteger index, BOOL *stop) {
        [item removeEventMonitor];
    }];
}
// 0x100062038, blocks 0x100062174 and 0x100062200
- (void)recordScreenWindowControllerDidCancel:(id)controller {
    if (IShotGlobal_1001ddd68) {
        [[[IShotGlobal_1001ddd68 window] contentView] removeFromSuperview];
        [[IShotGlobal_1001ddd68 window] close];
        IShotGlobal_1001ddd68 = nil;
    }
    if (IShotGlobal_1001de220) IShotFunction_10004b094(IShotGlobal_1001de220, 0);
    dispatch_async(dispatch_get_main_queue(), ^{
        IShotFunction_10004bf98(@[@"iShotAudioAggregateDevice_UID", @"iShotAudioMultiOutputDevice_UID"]);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100000000), dispatch_get_main_queue(), ^{
        [self clearRecordWindowControllerArray];
        self.isWorking = NO;
        IShotGlobal_1001de1a8 = NO;
        IShotGlobal_1001ddde0 = NO;
    });
}
// 0x100062248, block 0x1000622e4
- (void)clearRecordWindowControllerArray {
    if (self.recordWindowControllerArray.count) {
        [self.recordWindowControllerArray enumerateObjectsUsingBlock:^(MXRecordScreenWindowController *item, NSUInteger index, BOOL *stop) {
            [item setDelegate:nil];
            [item cleanup];
        }];
        [self.recordWindowControllerArray removeAllObjects];
    }
}
@end
