#import "SGVideoControlsViewController.h"
#import "SGVideoControlsDependencies.h"
#import "SGCaptureSession.h"
#import "CaptureAudioFunctions.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>
#import <IOKit/hidsystem/IOHIDLib.h>
#import <unistd.h>
extern SGCaptureSession *IShotGlobal_1001dddb0;
extern BOOL IShotGlobal_1001dd139,IShotGlobal_1001de210;
extern KeyEventSettingPopoverViewController *IShotGlobal_1001de218;
extern AudioDeviceID IShotGlobal_1001de220;
extern uint64_t IShotFunction_100048c68(void);
static BOOL IShotVideoControls_1001f1bd0;
// 0x10004afb0; status is narrowed to signed 16-bit before testing in the binary.
static AudioDeviceID IShotVideoDefaultDevice(int input) {
    AudioObjectPropertyAddress property={input?0x64496e20:0x644f7574,0x676c6f62,0}; UInt32 size=4; AudioDeviceID device;
    OSStatus status=AudioObjectGetPropertyData(1,&property,0,NULL,&size,&device);
    if((int16_t)status==0) return device;
    int16_t narrowed=(int16_t)status; uint8_t diagnostic[6]; memcpy(diagnostic,&narrowed,2); memcpy(diagnostic+2,&property.mSelector,4);
    printf("input device not found. (%4.4s, %ld)\n",(char *)diagnostic,(long)narrowed); exit(-1);
}
// 0x1000b2ff8
static OSStatus IShotVideoDevicesChanged(AudioObjectID object,UInt32 count,const AudioObjectPropertyAddress *addresses,void *client) { return 0; }
// 0x1000b30c0
static OSStatus IShotVideoVolumeChanged(AudioObjectID object,UInt32 count,const AudioObjectPropertyAddress *addresses,void *client) {
    for(UInt32 i=0;i<count;i++) if(addresses[i].mSelector==0x766f6c6d) { UInt32 size=4; float volume=0; AudioObjectGetPropertyData(object,&addresses[i],0,NULL,&size,&volume); } return 0;
}
@implementation SGVideoControlsViewController
- (void)viewDidLoad { // 0x1000afe80
    self.view.wantsLayer=YES; self.view.layer.masksToBounds=YES; self.view.layer.cornerRadius=20; [super viewDidLoad];
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    if([[defaults objectForKey:@"selectedMicrophoneOfRecordScreen"] isEqualToString:@""]) { [defaults setObject:IShotFunction_10004ad10() forKey:@"selectedMicrophoneOfRecordScreen"]; [defaults synchronize]; }
    NSColor *white=[NSColor.whiteColor colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace];
    CIVector *minimum=[CIVector vectorWithX:white.redComponent Y:white.greenComponent Z:white.blueComponent W:0],*maximum=[CIVector vectorWithX:white.redComponent Y:white.greenComponent Z:white.blueComponent W:1];
    CIFilter *filter=[CIFilter filterWithName:@"CIColorClamp"]; [filter setDefaults]; [filter setValue:minimum forKey:@"inputMinComponents"]; [filter setValue:maximum forKey:@"inputMaxComponents"];
    self.indicator.contentFilters=@[filter]; self.indicator.frame=NSMakeRect(25,15,50,50); self.arrOfLevelBox=[NSMutableArray arrayWithCapacity:60];
    for(int i=0;i<60;i++) {
        int origin=(int)(self.view.frame.size.width*0.5-90+i*3); origin=(int)((double)origin+(i>29?0.5:-0.5));
        NSBox *box=[[NSBox alloc] initWithFrame:NSMakeRect(origin,self.view.frame.size.height-32,2,13)]; box.boxType=4; box.fillColor=NSColor.grayColor; box.borderWidth=0; box.cornerRadius=0;
        [self.arrOfLevelBox addObject:box]; [self.view addSubview:box];
    }
    [NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(recordViewDidShowToolBar) name:@"RecordViewDidShowToolBar" object:nil suspensionBehavior:4]; [self formatOfRecordScreenRefresh];
}
- (void)formatOfRecordScreenRefresh { // 0x1000b040c
    BOOL gif=[[NSUserDefaults.standardUserDefaults objectForKey:@"formatOfRecordScreen"] isEqualToString:@"gif"];
    self.framesGifPopUpButton.hidden=!gif; self.framesPopUpButton.hidden=gif;
    for(NSView *box in self.arrOfLevelBox) box.hidden=gif; self.boxOfAspectRatio.hidden=!gif;
}
- (void)recordViewDidShowToolBar { // 0x1000b0688 and 0x1000b0c10/0x1000b0c20/0x1000b0cd8
    if(!self.view.window.visible) return;
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults; IShotGlobal_1001de210=NO;
    if(!(IShotVideoControls_1001f1bd0&1)) {
        IShotVideoControls_1001f1bd0=YES; IShotGlobal_1001dddb0=[SGCaptureSession new];
        dispatch_after(dispatch_time(0,500000000),dispatch_get_main_queue(),^{ [IShotGlobal_1001dddb0 setAudioDevice]; });
        dispatch_async(dispatch_get_global_queue(0,0),^{ do { [NSThread sleepForTimeInterval:0.1]; dispatch_async(dispatch_get_main_queue(),^{ [self updateMeters]; }); } while(IShotVideoControls_1001f1bd0&1); });
        if(IShotGlobal_1001dd139) { [defaults setBool:NO forKey:@"recordSystemSoundOfRecordScreen"]; self.checkButtonOfSystemSound.state=0; [defaults synchronize]; }
        if(!IShotFunction_10004abbc()) { self.checkButtonOfSystemSound.state=0; [defaults setBool:NO forKey:@"recordSystemSoundOfRecordScreen"]; [defaults synchronize]; }
        else { AudioDeviceID device=IShotFunction_10004c0c8(@"iShotAudioPlugin_UID"); if(device) IShotFunction_10004b044(device); }
        if([defaults boolForKey:@"recordSystemSoundOfRecordScreen"]) { self.checkButtonOfSystemSound.state=1; [self refreshiShotMultiOutputDevice]; [self refreshiShotAggregateDevice]; } else self.checkButtonOfSystemSound.state=0;
        self.checkButtonOfShowMouseClicks.enabled=[defaults boolForKey:@"showCursorOfRecordScreen"];
        [self setMenuForMicroPhoneButton]; [self setMenuForCameraButton]; [self setupListenerForCurrentAudioDevices];
    }
    UInt32 transport=IShotFunction_10004c3f4(IShotFunction_10004c20c([defaults objectForKey:@"selectedMicrophoneOfRecordScreen"]));
    BOOL enabled=transport!=0x76697274 && transport!=0x67727570;
    if(!enabled) { [defaults setBool:NO forKey:@"recordSystemSoundOfRecordScreen"]; [defaults synchronize]; self.checkButtonOfSystemSound.state=0; }
    self.checkButtonOfSystemSound.enabled=enabled;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleNSPopUpButtonWillPopUpNotification:) name:NSPopUpButtonWillPopUpNotification object:self.popupButtonOfMicrophone];
    for(NSString *key in @[@"selectedMicrophoneOfRecordScreen",@"showCursorOfRecordScreen",@"recordSystemSoundOfRecordScreen",@"formatOfRecordScreen"]) [defaults addObserver:self forKeyPath:key options:1 context:NULL];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context { // 0x1000b0ce0
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    if([keyPath isEqualToString:@"selectedMicrophoneOfRecordScreen"] || [keyPath isEqualToString:@"recordSystemSoundOfRecordScreen"]) {
        UInt32 transport=IShotFunction_10004c3f4(IShotFunction_10004c20c([defaults objectForKey:@"selectedMicrophoneOfRecordScreen"])); BOOL enabled=transport!=0x76697274 && transport!=0x67727570;
        if(!enabled) { [defaults setBool:NO forKey:@"recordSystemSoundOfRecordScreen"]; [defaults synchronize]; self.checkButtonOfSystemSound.state=0; } self.checkButtonOfSystemSound.enabled=enabled;
        if([defaults boolForKey:@"recordSystemSoundOfRecordScreen"]) { [self refreshiShotAggregateDevice]; [self refreshiShotMultiOutputDevice]; } else IShotFunction_10004bf98(@[@"iShotAudioAggregateDevice_UID",@"iShotAudioMultiOutputDevice_UID"]);
        dispatch_after(dispatch_time(0,1000000000),dispatch_get_main_queue(),^{ [IShotGlobal_1001dddb0 setAudioDevice]; });
    } else if([keyPath isEqualToString:@"showCursorOfRecordScreen"]) self.checkButtonOfShowMouseClicks.enabled=[change[@"new"] intValue]==1;
    else if([keyPath isEqualToString:@"formatOfRecordScreen"]) [self formatOfRecordScreenRefresh];
}
- (void)checkButtonOfFormatClick:(id)sender {} // 0x1000b100c RET
- (void)handleNSPopUpButtonWillPopUpNotification:(id)sender { [self setMenuForMicroPhoneButton]; } // 0x1000b1760 tail branch to selector stub 0x100160980
- (void)checkButtonOfCameraClick:(NSPopUpButton *)sender { // 0x1000b1010
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    if([sender.title isEqualToString:[NSBundle.mainBundle localizedStringForKey:@"None" value:@"" table:nil]]) { [defaults setObject:@"None" forKey:@"selectedCameraOfRecordScreen"]; [NSNotificationCenter.defaultCenter postNotificationName:@"RecordScreenWindowControllerCloseCamera" object:nil]; }
    else { [defaults setObject:sender.menu.highlightedItem.identifier forKey:@"selectedCameraOfRecordScreen"]; [NSNotificationCenter.defaultCenter postNotificationName:@"RecordScreenWindowControllerOpenCamera" object:nil]; } [defaults synchronize];
}
- (void)checkButtonOfInputMonitoringClick:(NSButton *)sender { // 0x1000b11d4
    if(sender.state==1) if(@available(macOS 10.15,*)) if(IOHIDCheckAccess(kIOHIDRequestTypeListenEvent)!=0) {
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"displayKeyboardEventWhenRecording"]; [NSUserDefaults.standardUserDefaults synchronize]; [NSNotificationCenter.defaultCenter postNotificationName:@"RecordScreenWindowControllerDidCancel" object:nil]; IShotFunction_100048c68();
    }
}
- (void)checkButtonOfSystemSoundClick:(id)sender { // 0x1000b12a8 / 0x1000b1478
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    if(self.checkButtonOfSystemSound.state==1) {
        if(!IShotFunction_10004abbc()) dispatch_async(dispatch_get_main_queue(),^{
            self.checkButtonOfSystemSound.state=0; NSAlert *alert=[[NSAlert alloc] init]; self.view.window.level=0; alert.window.level=1; alert.messageText=@"";
            alert.informativeText=[NSBundle.mainBundle localizedStringForKey:@"Need to install iShot audio driver to record system sound." value:@"" table:nil];
            [alert addButtonWithTitle:[NSBundle.mainBundle localizedStringForKey:@"Install" value:@"" table:nil]]; [alert addButtonWithTitle:[NSBundle.mainBundle localizedStringForKey:@"Cancel" value:@"" table:nil]];
            if([alert runModal]==1000) { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot_screenrecording.html"]]; [self.view.window close]; [NSNotificationCenter.defaultCenter postNotificationName:@"RecordScreenWindowControllerDidCancel" object:nil]; }
            self.view.window.level=1020;
        }); else [defaults setBool:YES forKey:@"recordSystemSoundOfRecordScreen"];
    } else [defaults setBool:NO forKey:@"recordSystemSoundOfRecordScreen"];
    [defaults synchronize];
}
- (void)setMenuForMicroPhoneButton { // 0x1000b1764
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults; NSString *selected=[defaults objectForKey:@"selectedMicrophoneOfRecordScreen"];
    NSMenu *menu=[[NSMenu alloc] init]; NSMenuItem *none=[NSMenuItem new]; none.title=[NSBundle.mainBundle localizedStringForKey:@"None" value:@"" table:nil]; [menu addItem:none]; BOOL found=NO;
    for(AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]) {
        if(IShotGlobal_1001dd139) { UInt32 transport=IShotFunction_10004c3f4(IShotFunction_10004c0c8(device.uniqueID)); if(transport==0x67727570 || transport==0x76697274) continue; }
        NSMenuItem *item=[NSMenuItem new]; NSString *uid=device.uniqueID;
        if(![uid isEqualToString:@"iShotAudioAggregateDevice_UID"] && ![uid isEqualToString:@"iShotAudioPlugin_UID"]) { item.title=device.localizedName; [menu addItem:item]; found|=[selected isEqualToString:device.localizedName]; }
    }
    self.popupButtonOfMicrophone.menu=menu;
    if(found) self.popupButtonOfMicrophone.title=selected;
    else { self.popupButtonOfMicrophone.title=[NSBundle.mainBundle localizedStringForKey:@"None" value:@"" table:nil]; [defaults setObject:[NSBundle.mainBundle localizedStringForKey:@"None" value:@"" table:nil] forKey:@"selectedMicrophoneOfRecordScreen"]; [defaults synchronize]; }
}
- (void)setMenuForCameraButton { // 0x1000b1be0; enumeration stops at the selected camera in the binary.
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults; NSString *selected=[defaults objectForKey:@"selectedCameraOfRecordScreen"];
    NSMenu *menu=[[NSMenu alloc] init]; NSMenuItem *none=[NSMenuItem new]; none.title=[NSBundle.mainBundle localizedStringForKey:@"None" value:@"" table:nil]; [menu addItem:none]; NSString *title=@"";
    for(AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) { NSMenuItem *item=[NSMenuItem new]; item.title=device.localizedName; item.identifier=device.uniqueID; [menu addItem:item]; if([selected isEqualToString:item.identifier]) { title=device.localizedName; break; } }
    self.popupButtonOfCamera.menu=menu;
    if(![title isEqualToString:@""]) self.popupButtonOfCamera.title=title;
    else { self.popupButtonOfCamera.title=[NSBundle.mainBundle localizedStringForKey:@"None" value:@"" table:nil]; [defaults setObject:@"None" forKey:@"selectedCameraOfRecordScreen"]; [defaults synchronize]; }
}
- (void)settingKeyEventButtonClick:(NSView *)sender { // 0x1000b1fc8
    if(!IShotGlobal_1001de218) IShotGlobal_1001de218=[[KeyEventSettingPopoverViewController alloc] initFromXib];
    [[IShotGlobal_1001de218 popover] showRelativeToRect:sender.bounds ofView:sender preferredEdge:2];
}
- (void)beginRecording:(id)sender { // 0x1000b2050
    NSRect frame=self.view.accessibilityFrame;
    self.indicatorView.frame=NSMakeRect(frame.origin.x+frame.size.width*0.5-50,frame.origin.y+frame.size.height*0.5-40,100,80);
    self.indicatorView.wantsLayer=YES; self.indicatorView.layer.masksToBounds=YES; self.indicatorView.layer.cornerRadius=10;
    self.indicatorView.layer.backgroundColor=[NSColor colorWithDeviceWhite:(double)0.05f alpha:0.5].CGColor; self.indicatorView.hidden=YES;
    [self.view.window.contentView addSubview:self.indicatorView]; [self showCircleDownCounter]; [self.view removeFromSuperview];
    [NSUserDefaults.standardUserDefaults setObject:[NSBundle.mainBundle localizedStringForKey:@"Calculating" value:@"" table:nil] forKey:@"gifLeftTime"]; [NSUserDefaults.standardUserDefaults setObject:@"0" forKey:@"gifProgressRate"];
}
- (void)refreshiShotMultiOutputDevice { // 0x1000b2390 / 0x1000b25e4
    NSString *uid=IShotFunction_10004b4c4(0); if([uid isEqualToString:@"iShotAudioMultiOutputDevice_UID"]) return;
    IShotGlobal_1001de220=IShotFunction_10004c0c8(uid); NSArray *devices;
    if(!uid || [uid isEqualToString:@"iShotAudioPlugin_UID"]) devices=@[@{@"uid":@"iShotAudioPlugin_UID"}];
    else { self.selectedSpeakerObjectID=IShotVideoDefaultDevice(0); devices=@[@{@"uid":uid},@{@"uid":@"iShotAudioPlugin_UID"}]; }
    IShotFunction_10004bf98(@[@"iShotAudioMultiOutputDevice_UID"]);
    dispatch_async(dispatch_get_main_queue(),^{ AudioDeviceID device=IShotFunction_10004ba34(devices); usleep(10000); IShotFunction_10004b094(device,0); });
}
- (void)refreshiShotAggregateDevice { // 0x1000b2618 / 0x1000b29a0
    NSString *selected=[NSUserDefaults.standardUserDefaults objectForKey:@"selectedMicrophoneOfRecordScreen"];
    if([selected isEqualToString:[NSBundle.mainBundle localizedStringForKey:@"None" value:@"" table:nil]]) { IShotFunction_10004bf98(@[@"iShotAudioAggregateDevice_UID"]); return; }
    for(AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]) {
        NSString *uid=device.uniqueID;
        if([device.localizedName isEqualToString:selected] && ![uid isEqualToString:@"iShotAudioAggregateDevice_UID"]) {
            NSArray *devices=@[@{@"uid":uid},@{@"uid":@"iShotAudioPlugin_UID"}]; IShotFunction_10004bf98(@[@"iShotAudioAggregateDevice_UID"]);
            dispatch_async(dispatch_get_main_queue(),^{ IShotFunction_10004bdcc(devices); }); return;
        }
    }
}
- (void)updateMeters { // 0x1000b29a8
    if(!self.view.window.visible) { IShotVideoControls_1001f1bd0=NO; return; }
    int level=(int)((double)[IShotGlobal_1001dddb0 updateAudioLevels]/2.8+27); if(level>29) level=30; if(level<0) level=0;
    for(NSUInteger i=0;i<self.arrOfLevelBox.count;i++) [(NSBox *)self.arrOfLevelBox[i] setFillColor:(int)fabs((double)(int)i-29.5)<level?NSColor.whiteColor:NSColor.grayColor];
}
- (void)showCircleDownCounter { // 0x1000b2b50
    IShotGlobal_1001de210=YES; NSRect frame=self.view.accessibilityFrame;
    double dimension=frame.size.width; if(frame.size.height<=frame.size.width) dimension=frame.size.height;
    double size=(double)(int)(dimension*0.5); if(dimension>=200) size=200;
    NSView *view=[[NSView alloc] initWithFrame:frame]; view.layer.backgroundColor=NSColor.clearColor.CGColor; [self.view.window.contentView addSubview:view];
    int delay=[[NSUserDefaults.standardUserDefaults objectForKey:@"startDelayTimesOfRecordScreen"] intValue];
    if(delay<1) { IShotGlobal_1001de210=NO; [self.view removeFromSuperview]; [NSNotificationCenter.defaultCenter postNotificationName:@"SGVideoControllerBeginRecordingNotification" object:nil]; }
    else {
        id circle=[CircleDownCounter showCircleDownWithSeconds:(float)(delay+1) onView:view withSize:NSMakeSize(size,size) andType:0];
        [circle setDelegate:self]; [circle setNumberColor:NSColor.whiteColor]; [circle setNumberFont:[NSFont fontWithName:@"Courier-Bold" size:60]]; [circle setCircleColor:NSColor.whiteColor]; [circle setCircleBorderWidth:10];
    }
}
- (void)counterDownFinished:(NSView *)circle { // 0x1000b2e40 / 0x1000b2ec8 / 0x1000b2f50
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) { [circle.animator setAlphaValue:0]; [circle.animator removeFromSuperview]; context.duration=0; } completionHandler:^{ IShotGlobal_1001de210=NO; [NSNotificationCenter.defaultCenter postNotificationName:@"SGVideoControllerBeginRecordingNotification" object:nil]; }];
}
- (void)setupListenerForCurrentAudioDevices { // 0x1000b2f9c
    AudioObjectPropertyAddress property={0x64657623,0x676c6f62,0};
    OSStatus status=AudioObjectAddPropertyListener(1,&property,IShotVideoDevicesChanged,(__bridge_retained void *)self);
    if(status) NSLog(@"Error: could not set up listener for audio devices changing");
}
- (void)setupListenerVolumeWillChangeWithDevice:(unsigned int)device { // 0x1000b3000
    AudioObjectPropertyAddress property={0x766f6c6d,0x6f757470,0};
    if(!AudioObjectHasProperty(device,&property)) { property.mElement=1; OSStatus status=AudioObjectAddPropertyListener(device,&property,IShotVideoVolumeChanged,(__bridge_retained void *)self); NSLog(@"%d",status); property.mElement=2; }
    OSStatus status=AudioObjectAddPropertyListener(device,&property,IShotVideoVolumeChanged,(__bridge_retained void *)self); NSLog(@"%d",status);
}
@end
