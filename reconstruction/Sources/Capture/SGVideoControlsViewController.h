#pragma once
#import <Cocoa/Cocoa.h>
@class LCAuthGuideKit;
@interface SGVideoControlsViewController : NSViewController
- (void)viewDidLoad; // 0x1000afe80
- (void)formatOfRecordScreenRefresh; // 0x1000b040c
- (void)recordViewDidShowToolBar; // 0x1000b0688
- (void)observeValueForKeyPath:(id)arg0 ofObject:(id)arg1 change:(id)arg2 context:(void *)arg3; // 0x1000b0ce0
- (void)checkButtonOfFormatClick:(id)arg0; // 0x1000b100c
- (void)checkButtonOfCameraClick:(id)arg0; // 0x1000b1010
- (void)checkButtonOfInputMonitoringClick:(id)arg0; // 0x1000b11d4
- (void)checkButtonOfSystemSoundClick:(id)arg0; // 0x1000b12a8
- (void)handleNSPopUpButtonWillPopUpNotification:(id)arg0; // 0x1000b1760
- (void)setMenuForMicroPhoneButton; // 0x1000b1764
- (void)setMenuForCameraButton; // 0x1000b1be0
- (void)settingKeyEventButtonClick:(id)arg0; // 0x1000b1fc8
- (void)beginRecording:(id)arg0; // 0x1000b2050
- (void)refreshiShotMultiOutputDevice; // 0x1000b2390
- (void)refreshiShotAggregateDevice; // 0x1000b2618
- (void)updateMeters; // 0x1000b29a8
- (void)showCircleDownCounter; // 0x1000b2b50
- (void)counterDownFinished:(id)arg0; // 0x1000b2e40
- (void)setupListenerForCurrentAudioDevices; // 0x1000b2f9c
- (void)setupListenerVolumeWillChangeWithDevice:(unsigned int)arg0; // 0x1000b3000
@property (atomic, strong) NSString * selectedMicID;
@property (nonatomic, strong) NSMutableArray * arrOfLevelBox;
@property (atomic, assign) uint32_t selectedSpeakerObjectID;
@property (nonatomic, strong) NSButton * checkButtonOfSystemSound;
@property (nonatomic, strong) NSPopUpButton * popupButtonOfMicrophone;
@property (nonatomic, strong) NSPopUpButton * popupButtonOfCamera;
@property (nonatomic, strong) NSTextField * textFieldOfCountTime;
@property (nonatomic, strong) NSButton * checkButtonOfShowMouseClicks;
@property (nonatomic, strong) LCAuthGuideKit * authKit;
@property (atomic, weak) NSVisualEffectView * visual;
@property (atomic, weak) NSButton * recordButton;
@property (atomic, weak) NSMenuItem * showMouseClick;
@property (atomic, weak) NSPopUpButton * qualityPopUpButton;
@property (atomic, weak) NSPopUpButton * framesPopUpButton;
@property (atomic, weak) NSPopUpButton * framesGifPopUpButton;
@property (atomic, weak) NSProgressIndicator * indicator;
@property (atomic, strong) NSView * indicatorView;
@property (atomic, weak) NSBox * boxOfAspectRatio;
@property (atomic, weak) NSTextView * totalTimes;
@property (nonatomic, strong) NSTask * ffmpegTask;
@end
