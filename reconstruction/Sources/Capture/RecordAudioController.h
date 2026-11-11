#import <Cocoa/Cocoa.h>
@class LinearPCMAudioCapture, AACAudioCapture;
@interface RecordAudioController : NSWindowController
@property(nonatomic) BOOL isRecording;
@property(nonatomic) BOOL isAudioFormatLinearPCM;
@property(nonatomic,strong) LinearPCMAudioCapture *linearPCMAudioCapture;
@property(nonatomic,strong) AACAudioCapture *audioCaptureOfAAC;
@property(nonatomic,strong) IBOutlet NSPopUpButton *popupButtonOfMicrophone;
@property(nonatomic,strong) IBOutlet NSTextField *textFieldOfRecordeTime;
@property(nonatomic,strong) IBOutlet NSButton *pauseButton, *startButton, *stopButton, *checkButtonOfSystemSound;
@property(nonatomic,strong) IBOutlet NSImageView *microPhoneImageView;
- (instancetype)initFromXib;
- (IBAction)checkButtonOfSystemSoundClick:(id)sender;
- (void)handleNSPopUpButtonWillPopUpNotification:(id)sender;
- (void)setMenuForMicroPhoneButton;
- (IBAction)startBtnClick:(id)sender;
- (IBAction)pauseBtnClick:(id)sender;
- (IBAction)stopBtnClick:(id)sender;
- (void)refreshiShotMultiOutputDevice;
- (void)refreshiShotAggregateDevice;
- (void)updateMeters;
- (void)windowWillClose:(id)sender;
- (void)actionWhenWindowOpened;
@end
