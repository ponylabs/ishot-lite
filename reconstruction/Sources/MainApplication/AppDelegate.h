#import <AppKit/AppKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property(nonatomic, strong) NSStatusItem *statusItem;
@property(nonatomic, strong) NSView *menuBarView;
@property(nonatomic, strong) NSMenu *statusItemMenu;
@property(nonatomic, strong) NSWindow *buyWindowSparkle;
@property(nonatomic, strong) NSWindow *buyWindowAppStore;
+ (AppDelegate *)appDelegate; // 0x1000a7194
- (void)applicationWillFinishLaunching:(id)sender; // 0x1000a71e0
- (void)applicationDidFinishLaunching:(id)sender; // 0x1000a760c
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context; // 0x1000a7f38
- (void)receiveSleepNotification:(id)sender; // 0x1000a80b0
- (void)handleInputSourceChange:(id)sender; // 0x1000a8210
- (void)applicationDidStart; // 0x1000a8214
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application; // 0x1000a8370
- (BOOL)applicationShouldHandleReopen:(NSApplication *)application hasVisibleWindows:(BOOL)visible; // 0x1000a856c
- (void)shortcutRecorderWillBegin; // 0x1000a8638
- (void)startCGEventListen; // 0x1000a863c
- (void)appDidActivate:(id)sender; // 0x1000a89e4
- (void)applicationWillTerminate:(id)sender; // 0x1000a8aec
- (void)startRecordScreen; // 0x1000a8af8
- (void)stopRecorder:(id)sender; // 0x1000a8d70
- (void)selectTheLastSavedFile; // 0x1000a8e34
- (void)regionalScreenshots:(id)sender; // 0x1000a902c
- (void)recordScreen:(id)sender; // 0x1000a9568
- (void)annotatedWhenRecordScreenClick:(id)sender; // 0x1000a99cc
- (void)telliShotToDo:(id)sender; // 0x1000a9aec
- (void)mapFromPaste:(id)sender; // 0x1000a9cf8
- (void)mapFromComBetter365Pasteboard:(id)sender; // 0x1000aa174
- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls; // 0x1000aa5f4
- (void)mapImageToScreen:(NSImage *)image isAddToPinLibrary:(BOOL)add; // 0x1000aa75c
- (void)savePinImageToTempDirectory:(id)sender; // 0x1000aa9e4
- (void)createPreviewImageOfPinLibrary; // 0x1000aabe0
- (void)delayScreenShot:(id)sender; // 0x1000aafe4
- (void)screenshotWindowUnderCursor:(id)sender; // 0x1000ab164
- (void)screenshotPreviousArea:(id)sender; // 0x1000ab2d0
- (void)screenShotWithShell; // 0x1000ab69c
- (void)screenShotToTranslate; // 0x1000ab75c
- (void)screenShotToOCR; // 0x1000ab788
- (void)openPinLibraryWindow; // 0x1000ab868
- (void)startRecordAudio; // 0x1000ab92c
- (void)saveFullImageToFile; // 0x1000abcc8
- (void)openPreferencesWindow; // 0x1000abe84
- (void)registerAllHotKey; // 0x1000abf98
- (void)hotKeyAction:(id)sender; // 0x1000ac248
- (void)hotKeyActionWithIdentifier:(id)sender; // 0x1000ac288
- (void)buttonPressed:(id)sender; // 0x1000ac55c
- (void)saveImageOfNotSpecified:(id)sender; // 0x1000ac670
- (void)saveImageToFile:(id)sender; // 0x1000ace2c
- (NSString *)getSavePathWithOpenPanel; // 0x1000ad308
- (void)saveScreenWithShell:(id)sender; // 0x1000ad4b8
- (void)saveRecordAudioFileFromTempFile:(id)sender; // 0x1000ad59c
- (BOOL)saveImage:(NSImage *)image toFilePath:(NSString *)path withType:(NSUInteger)type; // 0x1000ade38
- (void)hiddenOrShowAllPinWindow; // 0x1000adfe0
- (void)ffmpegTranscodeFrom:(NSString *)source toFile:(NSString *)destination withType:(NSString *)type; // 0x1000ae1cc
- (BOOL)isPureInt:(NSString *)text; // 0x1000ae4e4
@end
