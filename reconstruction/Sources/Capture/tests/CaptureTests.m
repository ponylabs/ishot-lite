// Bounded behavior tests. All stand-in business classes exist only in this test executable.
#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <objc/runtime.h>
#import "../MenuView.h"
#import "../MXRecordScreenManager.h"
#import "../RecordAudioController.h"
#import "../CaptureDependencies.h"
#import "../../MainApplication/AppDelegate.h"
#include <assert.h>
BOOL IShotGlobal_1001de1a8, IShotGlobal_1001ddde0, IShotGlobal_1001dd139;
id IShotGlobal_1001dddb0;
int32_t IShotGlobal_1001ddf78;
BOOL IShotGlobal_1001de2a1;
NSCursor *IShotGlobal_1001dddf8;
NSWindowController *IShotGlobal_1001ddd68;
AudioDeviceID IShotGlobal_1001de220;
static int stopCalls, annotateCalls, pauseNotices;
@implementation AppDelegate
+ (AppDelegate *)appDelegate { static AppDelegate *value; if (!value) value = [AppDelegate new]; return value; }
- (void)stopRecorder:(id)sender { stopCalls++; }
- (void)annotatedWhenRecordScreenClick:(id)sender { annotateCalls++; }
@end
@implementation MXRecordScreenWindowController
@end
@implementation LinearPCMAudioCapture
@synthesize recording;
@end
@implementation AACAudioCapture
@end
@interface TestCaptureSession : NSObject
@property CMTime time;
- (CMTime)lastVideo;
@end
@implementation TestCaptureSession
- (CMTime)lastVideo { return self.time; }
@end
@interface TestWindowController : NSObject
@property int cleanupCalls, delegateCalls, removeCalls;
@property(nonatomic,strong) id delegate;
- (void)cleanup;
- (void)removeEventMonitor;
@end
@implementation TestWindowController
- (void)setDelegate:(id)value { _delegate = value; self.delegateCalls++; }
- (void)cleanup { self.cleanupCalls++; }
- (void)removeEventMonitor { self.removeCalls++; }
@end
@interface TestAudio : NSObject
@property int pauseCalls, stopCalls;
- (void)pauseRecord;
- (void)stopRecord;
- (BOOL)isMP3;
@end
@implementation TestAudio
- (void)pauseRecord { self.pauseCalls++; }
- (void)stopRecord { self.stopCalls++; }
- (BOOL)isMP3 { return NO; }
@end
@interface TestMenuView : MenuView @end
@implementation TestMenuView
- (void)installGlobalMouseMonitor {}
- (void)uninstallGlobalMouseMonitor {}
@end
int main(void) { @autoreleasepool {
    [NSApplication sharedApplication];
    MenuView *menu = [[TestMenuView alloc] initWithFrame:NSMakeRect(0, 0, 128, 22)];
    [menu endRecord]; // Stops its asynchronous timer before any run-loop pumping.
    assert(NSEqualRects(menu.annotateButton.frame, NSMakeRect(3, 1, 20, 20)));
    assert(NSEqualRects(menu.stopButton.frame, NSMakeRect(28, 1, 20, 20)));
    assert(NSEqualRects(menu.durationButton.frame, NSMakeRect(53, 2, 62, 20)));
    assert(NSEqualRects(menu.pauseButton.frame, NSMakeRect(108, 1, 20, 20)));
    assert(menu.durationButton.action == NULL);
    id token = [[NSNotificationCenter defaultCenter] addObserverForName:@"SGVideoControllerPauseAndResumeNotification" object:nil queue:nil usingBlock:^(NSNotification *n) { pauseNotices++; }];
    [menu pauseButtonClick:nil]; assert(menu.pauseButton.state == 0);
    [menu pauseButtonClick:nil]; assert(menu.pauseButton.state == 1 && pauseNotices == 2);
    [menu annotateButtonClick:nil]; [menu stopButtonClick:nil];
    assert(annotateCalls == 1 && stopCalls == 1);
    TestCaptureSession *session = [TestCaptureSession new];
    IShotGlobal_1001dddb0 = session;
    session.time = CMTimeMake(100, 1);
    IShotGlobal_1001ddf78 = 0;
    [menu timerDurationTimeOut:nil];
    assert(IShotGlobal_1001ddf78 == 1 && [menu.durationButton.title isEqualToString:@"00:00:01"]);
    [menu timerDurationTimeOut:nil]; assert(IShotGlobal_1001ddf78 == 1);
    session.time = CMTimeMake(105, 1); [menu timerDurationTimeOut:nil]; assert(IShotGlobal_1001ddf78 == 2);
    IShotGlobal_1001ddf78 = 3600; [menu timerDurationTimeOut:nil]; assert([menu.durationButton.title isEqualToString:@"01:00:00"]);
    [[NSNotificationCenter defaultCenter] removeObserver:token];
    // Skip init's asynchronous AVCaptureDevice enumeration; exercise state transitions only.
    MXRecordScreenManager *manager = class_createInstance([MXRecordScreenManager class], 0);
    TestWindowController *first = [TestWindowController new], *second = [TestWindowController new];
    manager.recordWindowControllerArray = [NSMutableArray arrayWithObjects:first, second, nil];
    [manager recordScreenWindowControllerDidSelectRegion:first];
    assert(first.cleanupCalls == 0 && second.cleanupCalls == 1 && manager.recordWindowControllerArray.count == 1);
    [manager recordScreenWindowControllerRemoveEventMonitor:nil]; assert(first.removeCalls == 1);
    manager.isWorking = YES; IShotGlobal_1001de1a8 = YES; IShotGlobal_1001ddde0 = YES;
    [manager reset];
    assert(!manager.isWorking && !IShotGlobal_1001de1a8 && !IShotGlobal_1001ddde0);
    assert(first.cleanupCalls == 1 && first.delegateCalls == 1 && manager.recordWindowControllerArray.count == 0);
    RecordAudioController *audio = [[RecordAudioController alloc] initWithWindow:nil];
    TestAudio *backend = [TestAudio new];
    audio.isAudioFormatLinearPCM = YES; audio.linearPCMAudioCapture = (id)backend;
    audio.pauseButton = [NSButton new]; audio.startButton = [NSButton new]; audio.stopButton = [NSButton new];
    audio.popupButtonOfMicrophone = [NSPopUpButton new]; audio.checkButtonOfSystemSound = [NSButton new]; audio.microPhoneImageView = [NSImageView new];
    [audio pauseBtnClick:nil]; [audio pauseBtnClick:nil]; assert(backend.pauseCalls == 2);
    audio.isRecording = YES; [audio stopBtnClick:nil];
    assert(!audio.isRecording && backend.stopCalls == 1 && audio.startButton.enabled && !audio.pauseButton.enabled && !audio.stopButton.enabled);
    assert(audio.popupButtonOfMicrophone.enabled && audio.checkButtonOfSystemSound.enabled && audio.microPhoneImageView.enabled);
    puts("CaptureTests: menu geometry, pause notifications, duration counter, controller cleanup, audio state transitions passed; no capture or audio-device mutations executed");
} return 0; }
