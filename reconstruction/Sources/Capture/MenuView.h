#import <Cocoa/Cocoa.h>
@interface MenuView : NSView
@property(nonatomic,strong) NSButton *annotateButton;
@property(nonatomic,strong) NSButton *stopButton;
@property(nonatomic,strong) NSButton *pauseButton;
@property(nonatomic,strong) NSButton *durationButton;
@property(nonatomic,unsafe_unretained) id mouseDownMonitor;
@property(nonatomic,unsafe_unretained) id mouseUpMonitor;
- (void)installGlobalMouseMonitor;
- (void)uninstallGlobalMouseMonitor;
- (void)stopButtonClick:(id)sender;
- (void)annotateButtonClick:(id)sender;
- (void)durationButtonClick:(id)sender;
- (void)endRecord;
- (void)pauseButtonClick:(id)sender;
- (void)timerDurationTimeOut:(id)sender;
@end
