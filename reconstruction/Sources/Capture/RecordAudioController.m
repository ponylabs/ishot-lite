#import "RecordAudioController.h"
#import "CaptureDependencies.h"
#import "CaptureAudioFunctions.h"
#import "../MainApplication/AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <unistd.h>
#import <math.h>
extern BOOL IShotGlobal_1001dd139;
static NSMutableArray<NSBox *> *IShotMeterBoxes_1001f1890;
static int32_t IShotMeterTicks_1001f1898;
static BOOL IShotAudioPaused_1001f189c;
static AudioDeviceID IShotAudioPreviousOutput_1001f18a0;
static BOOL IShotAudioWindowClosed_1001f18a4;
@implementation RecordAudioController
// 0x100006380
- (instancetype)initFromXib {
    if ((self = [super init])) {
        [[NSBundle mainBundle] loadNibNamed:@"RecordAudio" owner:self topLevelObjects:NULL];
        [self setMenuForMicroPhoneButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNSPopUpButtonWillPopUpNotification:) name:NSPopUpButtonWillPopUpNotification object:self.popupButtonOfMicrophone];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedMicrophoneForRecordAudio"] isEqualToString:@""]) {
            NSString *name = IShotFunction_10004ad10();
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"selectedMicrophoneForRecordAudio"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"recordSystemAudioForRecordAudio" options:1 context:NULL];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"selectedMicrophoneForRecordAudio" options:1 context:NULL];
    }
    return self;
}
// 0x10000659c; delayed block 0x1000068d8
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![keyPath isEqualToString:@"selectedMicrophoneForRecordAudio"] && ![keyPath isEqualToString:@"recordSystemAudioForRecordAudio"]) return;
    NSString *microphone = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedMicrophoneForRecordAudio"];
    UInt32 transport = IShotFunction_10004c3f4(IShotFunction_10004c20c(microphone));
    BOOL allowed = transport != 0x76697274 && transport != 0x67727570;
    if (!allowed) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"recordSystemAudioForRecordAudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.checkButtonOfSystemSound.state = 0;
    }
    self.checkButtonOfSystemSound.enabled = allowed;
    BOOL system = [[NSUserDefaults standardUserDefaults] boolForKey:@"recordSystemAudioForRecordAudio"];
    if (!system) IShotFunction_10004bf98(@[@"iShotAudioAggregateDevice_UID", @"iShotAudioMultiOutputDevice_UID"]);
    else { [self refreshiShotAggregateDevice]; [self refreshiShotMultiOutputDevice]; }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500000000), dispatch_get_main_queue(), ^{
        if (self.isAudioFormatLinearPCM) [self.linearPCMAudioCapture configureCaptureSession];
        else [self.audioCaptureOfAAC configureCaptureSession];
    });
    self.startButton.enabled = system || ![microphone isEqualToString:[[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil]];
}
// 0x100006930
- (void)awakeFromNib {
    self.window.level = 1;
    self.window.movableByWindowBackground = YES;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedMicrophoneForRecordAudio"] isEqualToString:@""]) {
        NSString *name = IShotFunction_10004ad10();
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"selectedMicrophoneForRecordAudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.isAudioFormatLinearPCM = ![[[NSUserDefaults standardUserDefaults] stringForKey:@"formatOfRecording"] isEqualToString:@"m4a"];
    if (self.isAudioFormatLinearPCM) {
        if (!self.linearPCMAudioCapture) self.linearPCMAudioCapture = [[LinearPCMAudioCapture alloc] init];
    } else if (!self.audioCaptureOfAAC) self.audioCaptureOfAAC = [AACAudioCapture sharedAudioCapture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:self.window];
    IShotMeterBoxes_1001f1890 = [NSMutableArray arrayWithCapacity:50];
    for (int i = 0; i < 50; i++) {
        double x = (double)(int)((i > 24 ? 0.5 : -0.5) + (double)(int)(self.window.frame.size.width * 0.5 - 75.0 + i * 3));
        NSBox *box = [[NSBox alloc] initWithFrame:NSMakeRect(x, self.window.frame.size.height - 35, 2, 12)];
        box.boxType = 4;
        box.fillColor = [NSColor grayColor];
        box.borderWidth = 0;
        box.cornerRadius = 0;
        [IShotMeterBoxes_1001f1890 addObject:box];
        [self.window.contentView addSubview:box];
    }
    self.pauseButton.image = [NSImage imageNamed:@"Recordingpauseoff"];
    self.startButton.image = [NSImage imageNamed:@"Recordingstart"];
    self.stopButton.image = [NSImage imageNamed:@"Recordingstopoff"];
    self.pauseButton.enabled = NO;
    self.stopButton.enabled = NO;
    if (IShotGlobal_1001dd139) {
        self.checkButtonOfSystemSound.state = 0;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"recordSystemAudioForRecordAudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (!IShotFunction_10004abbc()) {
        self.checkButtonOfSystemSound.state = 0;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"recordSystemAudioForRecordAudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        AudioDeviceID device = IShotFunction_10004c0c8(@"iShotAudioPlugin_UID");
        if (device) IShotFunction_10004b044(device);
    }
}
// 0x100006fa8; block 0x100007168
- (IBAction)checkButtonOfSystemSoundClick:(id)sender {
    if (self.checkButtonOfSystemSound.state == 1) {
        if (!IShotFunction_10004abbc()) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.checkButtonOfSystemSound.state = 0;
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"";
                alert.informativeText = [[NSBundle mainBundle] localizedStringForKey:@"Need to install iShot audio driver to record system sound." value:@"" table:nil];
                [alert addButtonWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"Install" value:@"" table:nil]];
                [alert addButtonWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"Cancel" value:@"" table:nil]];
                if ([alert runModal] == 1000) {
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot_screenrecording.html"]];
                    [self.window close];
                }
            });
        } else [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"recordSystemAudioForRecordAudio"];
    } else [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"recordSystemAudioForRecordAudio"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)handleNSPopUpButtonWillPopUpNotification:(id)sender { [self setMenuForMicroPhoneButton]; } // 0x100007368 assembly tail call
// 0x10000736c
- (void)setMenuForMicroPhoneButton {
    NSString *selected = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedMicrophoneForRecordAudio"];
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    NSMenu *menu = [[NSMenu alloc] init];
    NSMenuItem *none = [NSMenuItem new];
    none.title = [[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil];
    [menu addItem:none];
    BOOL found = NO;
    for (AVCaptureDevice *device in devices) {
        if (IShotGlobal_1001dd139) {
            UInt32 transport = IShotFunction_10004c3f4(IShotFunction_10004c0c8(device.uniqueID));
            if (transport == 0x67727570 || transport == 0x76697274) continue;
        }
        NSMenuItem *item = [NSMenuItem new];
        NSString *uid = device.uniqueID;
        if (![uid isEqualToString:@"iShotAudioAggregateDevice_UID"] && ![uid isEqualToString:@"iShotAudioPlugin_UID"]) {
            NSString *name = device.localizedName;
            item.title = name;
            [menu addItem:item];
            found |= [selected isEqualToString:name];
        }
    }
    self.popupButtonOfMicrophone.menu = menu;
    if (!found) {
        self.popupButtonOfMicrophone.title = [[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil];
        [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil] forKey:@"selectedMicrophoneForRecordAudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else self.popupButtonOfMicrophone.title = selected;
}
- (void)windowDidLoad { [super windowDidLoad]; } // 0x1000077e8
// 0x10000781c, block 0x1000078ac
- (IBAction)startBtnClick:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500000000), dispatch_get_main_queue(), ^{
        self.isAudioFormatLinearPCM = ![[[NSUserDefaults standardUserDefaults] stringForKey:@"formatOfRecording"] isEqualToString:@"m4a"];
        if (self.isAudioFormatLinearPCM) {
            if (!self.linearPCMAudioCapture) self.linearPCMAudioCapture = [[LinearPCMAudioCapture alloc] init];
        } else if (!self.audioCaptureOfAAC) self.audioCaptureOfAAC = [AACAudioCapture sharedAudioCapture];
        self.isRecording = YES;
        [self.window standardWindowButton:0].enabled = NO;
        self.pauseButton.image = [NSImage imageNamed:@"Recordingpause"];
        self.startButton.image = [NSImage imageNamed:@"Recordingstartoff"];
        self.stopButton.image = [NSImage imageNamed:@"Recordingstop"];
        self.pauseButton.enabled = YES;
        self.startButton.enabled = NO;
        self.stopButton.enabled = YES;
        self.popupButtonOfMicrophone.enabled = NO;
        self.checkButtonOfSystemSound.enabled = NO;
        self.microPhoneImageView.enabled = NO;
        IShotMeterTicks_1001f1898 = 0;
        if (self.isAudioFormatLinearPCM) [self.linearPCMAudioCapture startRecord]; else [self.audioCaptureOfAAC startRecord];
    });
}
// 0x100007c10
- (IBAction)pauseBtnClick:(id)sender {
    NSString *imageName = IShotAudioPaused_1001f189c ? @"Recordingpause" : @"Recordingpausing";
    IShotAudioPaused_1001f189c ^= 1;
    self.pauseButton.image = [NSImage imageNamed:imageName];
    if (self.isAudioFormatLinearPCM) [self.linearPCMAudioCapture pauseRecord]; else [self.audioCaptureOfAAC pauseRecord];
}
// 0x100007cf0
- (IBAction)stopBtnClick:(id)sender {
    self.isRecording = NO;
    self.pauseButton.image = [NSImage imageNamed:@"Recordingpauseoff"];
    self.startButton.image = [NSImage imageNamed:@"Recordingstart"];
    self.stopButton.image = [NSImage imageNamed:@"Recordingstopoff"];
    self.pauseButton.enabled = NO;
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
    self.popupButtonOfMicrophone.enabled = YES;
    self.checkButtonOfSystemSound.enabled = YES;
    self.microPhoneImageView.enabled = YES;
    if (self.isAudioFormatLinearPCM) {
        [self.linearPCMAudioCapture stopRecord];
        if ([self.linearPCMAudioCapture isMP3]) {
            [self.window close];
            [[AppDelegate appDelegate] ffmpegTranscodeFrom:[self.linearPCMAudioCapture temporaryPath] toFile:[self.linearPCMAudioCapture mp3Path] withType:@"MP3"];
        }
    } else [self.audioCaptureOfAAC stopRecord];
}
// 0x100008018, block 0x100008254
- (void)refreshiShotMultiOutputDevice {
    NSString *uid = IShotFunction_10004b4c4(0);
    if ([uid isEqualToString:@"iShotAudioMultiOutputDevice_UID"]) return;
    IShotAudioPreviousOutput_1001f18a0 = IShotFunction_10004c0c8(uid);
    NSArray *devices;
    if (!uid || [uid isEqualToString:@"iShotAudioPlugin_UID"]) devices = @[@{@"uid":@"iShotAudioPlugin_UID"}];
    else devices = @[@{@"uid":uid}, @{@"uid":@"iShotAudioPlugin_UID"}];
    IShotFunction_10004bf98(@[@"iShotAudioMultiOutputDevice_UID"]);
    dispatch_async(dispatch_get_main_queue(), ^{
        AudioDeviceID device = IShotFunction_10004ba34(devices);
        usleep(10000);
        IShotFunction_10004b094(device, 0);
    });
}
// 0x100008288, block 0x100008610
- (void)refreshiShotAggregateDevice {
    NSString *selected = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedMicrophoneForRecordAudio"];
    if ([selected isEqualToString:[[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil]]) {
        IShotFunction_10004bf98(@[@"iShotAudioAggregateDevice_UID"]);
        return;
    }
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]) {
        NSString *uid = device.uniqueID;
        if ([device.localizedName isEqualToString:selected] && ![uid isEqualToString:@"iShotAudioAggregateDevice_UID"]) {
            NSArray *devices = @[@{@"uid":uid}, @{@"uid":@"iShotAudioPlugin_UID"}];
            IShotFunction_10004bf98(@[@"iShotAudioAggregateDevice_UID"]);
            dispatch_async(dispatch_get_main_queue(), ^{ IShotFunction_10004bdcc(devices); });
            return;
        }
    }
}
// 0x100008618. Float -> double before division; original truncation then clamp [0,25].
- (void)updateMeters {
    float level = self.isAudioFormatLinearPCM ? [self.linearPCMAudioCapture updateAudioLevels] : [self.audioCaptureOfAAC updateAudioLevels];
    int count = (int)((double)level / 2.8 + 25.0);
    if (count > 24) count = 25;
    for (NSUInteger i = 0; i < IShotMeterBoxes_1001f1890.count; i++) {
        NSBox *box = IShotMeterBoxes_1001f1890[i];
        box.fillColor = (int)fabs((double)(int)i - 24.5) < (count < 0 ? 0 : count) ? [NSColor whiteColor] : [NSColor grayColor];
    }
    IShotMeterTicks_1001f1898++;
    if (IShotMeterTicks_1001f1898 == 10) {
        IShotMeterTicks_1001f1898 = 0;
        NSString *time = self.isAudioFormatLinearPCM ? [self.linearPCMAudioCapture getRecordTime] : [self.audioCaptureOfAAC getRecordTime];
        self.textFieldOfRecordeTime.stringValue = time;
    }
}
// 0x100008810, global block 0x100008ae8
- (void)windowWillClose:(id)sender {
    IShotAudioWindowClosed_1001f18a4 = YES;
    if (IShotAudioPreviousOutput_1001f18a0) IShotFunction_10004b094(IShotAudioPreviousOutput_1001f18a0, 0);
    dispatch_async(dispatch_get_main_queue(), ^{ IShotFunction_10004bf98(@[@"iShotAudioAggregateDevice_UID", @"iShotAudioMultiOutputDevice_UID"]); });
    self.pauseButton.image = [NSImage imageNamed:@"Recordingpauseoff"];
    self.startButton.image = [NSImage imageNamed:@"Recordingstart"];
    self.stopButton.image = [NSImage imageNamed:@"Recordingstopoff"];
    self.pauseButton.enabled = NO;
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
    self.popupButtonOfMicrophone.enabled = YES;
    self.checkButtonOfSystemSound.enabled = YES;
    self.microPhoneImageView.enabled = YES;
    if (self.isAudioFormatLinearPCM) [self.linearPCMAudioCapture cancelRecord]; else [self.audioCaptureOfAAC cancelRecord];
    self.textFieldOfRecordeTime.stringValue = @"00:00:00";
    if (self.isAudioFormatLinearPCM) [self.linearPCMAudioCapture cancelCaptureSession]; else [self.audioCaptureOfAAC cancelCaptureSession];
}
// 0x100008b74, blocks 0x100009060/0x10000911c/0x100009124
- (void)actionWhenWindowOpened {
    IShotAudioWindowClosed_1001f18a4 = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        do {
            [NSThread sleepForTimeInterval:0.1];
            dispatch_async(dispatch_get_main_queue(), ^{ [self updateMeters]; });
        } while (IShotAudioWindowClosed_1001f18a4 != YES);
    });
    NSString *selected = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedMicrophoneForRecordAudio"];
    BOOL found = NO;
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio])
        if ([selected isEqualToString:device.localizedName]) { found = YES; break; }
    if (!found) {
        selected = [[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil];
        [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil] forKey:@"selectedMicrophoneForRecordAudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.startButton.enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"recordSystemAudioForRecordAudio"] || ![selected isEqualToString:[[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"recordSystemAudioForRecordAudio"]) {
        self.checkButtonOfSystemSound.state = 1;
        [self refreshiShotAggregateDevice]; [self refreshiShotMultiOutputDevice];
    } else self.checkButtonOfSystemSound.state = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500000000), dispatch_get_main_queue(), ^{
        if (self.isAudioFormatLinearPCM) [self.linearPCMAudioCapture configureCaptureSession]; else [self.audioCaptureOfAAC configureCaptureSession];
    });
    self.popupButtonOfMicrophone.enabled = YES;
    self.checkButtonOfSystemSound.enabled = YES;
    self.microPhoneImageView.enabled = YES;
}
@end
