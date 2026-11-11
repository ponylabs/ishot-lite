#import "AppDelegate.h"
#import "RecoveredDependencies.h"
#import "../Startup/MainEntry.h"
#import "../PTHotKey/PTHotKey.h"
#import <ApplicationServices/ApplicationServices.h>
#import <CoreServices/CoreServices.h>
#import <dispatch/dispatch.h>

// Shared data retain their original address identity across recovered modules.
extern NSUserDefaults *IShotGlobal_1001de128;
extern NSArray *IShotGlobal_1001de130;
extern NSMutableArray *IShotGlobal_1001de138, *IShotGlobal_1001de140, *IShotGlobal_1001de148;
extern BOOL IShotGlobal_1001de150, IShotGlobal_1001de168;
extern NSMutableDictionary *IShotGlobal_1001de158;
extern AnnotatedImageController *IShotGlobal_1001de160;
extern MenuView *IShotGlobal_1001de170;
extern NSDictionary *IShotGlobal_1001de178;
extern BOOL IShotGlobal_1001de180, IShotGlobal_1001de181, IShotGlobal_1001de182, IShotGlobal_1001de183, IShotGlobal_1001de184;
extern PinLibraryController *IShotGlobal_1001de188;
extern ScreenshotWithShellController *IShotGlobal_1001de190;
extern RecordAudioController *IShotGlobal_1001de198;
extern AppPrefsWindowController *IShotGlobal_1001de1a0;
extern BOOL IShotGlobal_1001de1a8;
extern FFmpegCommandToolController *IShotGlobal_1001de1b0;
extern NSScreen *IShotGlobal_1001dde80;
extern NSMutableArray *IShotGlobal_1001ddcd0;
extern NSScreen *IShotGlobal_1001ddd60;
extern double IShotGlobal_1001ddd18, IShotGlobal_1001ddd20, IShotGlobal_1001ddd28, IShotGlobal_1001ddd30;
extern BOOL IShotGlobal_1001ddde0;
extern double IShotGlobal_1001f1b80;
extern CFMachPortRef IShotGlobal_1001f1b88;
extern CFRunLoopSourceRef IShotGlobal_1001f1b90;
extern NSSavePanel *IShotGlobal_1001f1b98;
extern BOOL IShotGlobal_1001f1ba0;
extern void IShotFunction_100048840(NSString *name);
extern void IShotFunction_100047ffc(NSString *name);
extern void IShotFunction_100047f3c(void);
#import "../Camera/RecoveredCursors.h"
extern void IShotFunction_100049a04(void);
extern int IShotFunction_1000489a8(void);

static NSString *localized(NSString *key) {
    return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:nil];
}
static void IShotFunction_1000a7aa4(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info);
static CGEventRef IShotFunction_1000a86e8(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *context);

@implementation AppDelegate
+ (AppDelegate *)appDelegate { return (AppDelegate *)NSApplication.sharedApplication.delegate; } // 0x1000a7194
- (void)applicationWillFinishLaunching:(NSNotification *)notification { // 0x1000a71e0
    IShotGlobal_1001f1b80 = NSDate.date.timeIntervalSince1970 * 1000;
    IShotFunction_100048840(@"TelliShotToQuit");
    IShotGlobal_1001de128 = [[NSUserDefaults alloc] initWithSuiteName:@"4K6FWZU8C4.group.cn.better365"];
    if ([IShotGlobal_1001de128 boolForKey:@"StartiShotByiShotHelper"]) {
        [IShotGlobal_1001de128 removeObjectForKey:@"StartiShotByiShotHelper"];
        [IShotGlobal_1001de128 synchronize];
    }
    NSString *path = [NSBundle.mainBundle pathForResource:@"DefaultPreferences" ofType:@"plist"];
    NSMutableDictionary *preferences = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    [preferences removeObjectForKey:@"dicOfShortCutKeyOver15"];
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    [defaults registerDefaults:preferences];
    if([defaults integerForKey:@"doubleLeftButtonAction"]==2) [defaults setInteger:0 forKey:@"doubleLeftButtonAction"]; // Removed OCR action.
    NSDictionary *defaultShortcuts = preferences[@"dicOfShortCutKey"];
    NSMutableDictionary *shortcuts = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"dicOfShortCutKey"]];
    if (![defaults boolForKey:@"quickScreenshotsRecorderHaveSetted"]) {
        [shortcuts setObject:defaultShortcuts[@"quickScreenshotsRecorder"] forKey:@"quickScreenshotsRecorder"];
        [defaults setBool:YES forKey:@"quickScreenshotsRecorderHaveSetted"];
        [defaults setObject:shortcuts forKey:@"dicOfShortCutKey"];
        [defaults synchronize];
    }
    if (![defaults boolForKey:@"presetAreaSizeScreenshotsRecorderHaveSetted"]) {
        [shortcuts setObject:defaultShortcuts[@"presetAreaSizeScreenshotsRecorder"] forKey:@"presetAreaSizeScreenshotsRecorder"];
        [defaults setBool:YES forKey:@"presetAreaSizeScreenshotsRecorderHaveSetted"];
        [defaults setObject:shortcuts forKey:@"dicOfShortCutKey"];
        [defaults synchronize];
    }
    IShotGlobal_1001de130 = @[@"squareShortcut", @"ellipseShortcut", @"lineShortcut", @"arrowShortcut", @"pencilShortcut", @"mosaicShortcut", @"textShortcut", @"noteShortcut", @"highlightShortcut", @"mapShortcut", @"clearShortcut", @"zoomShortcut", @"scrollScreenshotShortcut", @"saveShortcut", @"copyToPasteShortcut"];
}
- (void)applicationDidFinishLaunching:(NSNotification *)notification { // 0x1000a760c
    IShotGlobal_1001de138 = [NSMutableArray new];
    IShotGlobal_1001de140 = [NSMutableArray new];
    IShotGlobal_1001de148 = [NSMutableArray array];
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    if (![defaults boolForKey:@"IsRestart"]) IShotFunction_100047f3c();
    else { [defaults removeObjectForKey:@"IsRestart"]; [defaults synchronize]; }
    if ([NSBundle.mainBundle.bundlePath containsString:@"/Library/Developer/Xcode/DerivedData/"]) IShotGlobal_1001de150 = YES;
    [self applicationDidStart];
    IShotGlobal_1001de158 = [NSMutableDictionary new];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100000000), dispatch_get_main_queue(), ^{ // 0x1000a793c
        CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), NULL, IShotFunction_1000a7aa4, CFSTR("PinFromPasteboardByiRightMouse"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), NULL, IShotFunction_1000a7aa4, CFSTR("ScreenShotsByBetter365Group"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        [NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(telliShotToDo:) name:nil object:@"cn.better365.group" suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];
        [NSWorkspace.sharedWorkspace.notificationCenter addObserver:self selector:@selector(appDidActivate:) name:NSWorkspaceDidActivateApplicationNotification object:nil];
        [NSWorkspace.sharedWorkspace.notificationCenter addObserver:self selector:@selector(receiveSleepNotification:) name:NSWorkspaceWillSleepNotification object:nil];
        // Lite: automatic App Store rating prompts removed.
    });
    if ([defaults boolForKey:@"needOpenPreferencesWindow"]) {
        [defaults removeObjectForKey:@"needOpenPreferencesWindow"];
        [self openPreferencesWindow];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{ [self createPreviewImageOfPinLibrary]; }); // 0x1000a7f30
    [defaults addObserver:self forKeyPath:@"pathofSaveScreenShotsPhoto" options:NSKeyValueObservingOptionNew context:NULL];
    [defaults addObserver:self forKeyPath:@"pathofSaveVideo" options:NSKeyValueObservingOptionNew context:NULL];
    [defaults addObserver:self forKeyPath:@"pathofSaveAudio" options:NSKeyValueObservingOptionNew context:NULL];
    if (@available(macOS 16.0, *)) {
        [IShotGlobal_1001de160 openWindow];
        [IShotGlobal_1001de160 closeWindow];
        IShotGlobal_1001de168 = YES;
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context { // 0x1000a7f38
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSString *path = [defaults objectForKey:@"pathofSaveScreenShotsPhoto"];
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) [defaults setObject:path forKey:@"oldPathofSaveScreenShotsPhoto"];
    path = [defaults objectForKey:@"pathofSaveVideo"];
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) [defaults setObject:path forKey:@"oldPathofSaveVideo"];
    path = [defaults objectForKey:@"pathofSaveAudio"];
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) [defaults setObject:path forKey:@"oldPathofSaveAudio"];
    [defaults synchronize];
}
- (void)receiveSleepNotification:(NSNotification *)notification { // 0x1000a80b0
    if (!IShotGlobal_1001de150) {
        for (NSWindow *window in NSApp.windows) if (window.visible) return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100000000), dispatch_get_main_queue(), ^{ IShotFunction_100049a04(); }); // 0x1000a820c thunk
    }
}
- (void)handleInputSourceChange:(id)sender {} // 0x1000a8210 RET only
- (void)applicationDidStart { // 0x1000a8214
    IShotGlobal_1001de160 = [[AnnotatedImageController alloc] initWithWindowNibName:@"AnnotatedImage"];
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    if (@available(macOS 15.0, *)) {
        if (@available(macOS 15.3, *)) {} else if ([Global haveOnlyOptionAsFlag]) {
            if (!AXIsProcessTrusted()) [Global checkAllHotKeyForMacosSequoia];
            else [self startCGEventListen];
        }
    }
    [self registerAllHotKey];
    if (![defaults boolForKey:@"needFilletOfnotSingleWindow"]) {
        [defaults setInteger:0 forKey:@"sizeOfImageFillet"];
        [defaults setBool:YES forKey:@"needFilletOfnotSingleWindow"];
        [defaults synchronize];
    }
    if (![defaults boolForKey:@"addCornerRadiusForPin"]) {
        [defaults setInteger:0 forKey:@"sizeOfPinFillet"];
        [defaults setBool:YES forKey:@"addCornerRadiusForPin"];
        [defaults synchronize];
    }
    IShotInitializeCursors_100049f5c();
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application { // 0x1000a8370
    BOOL allClosed = YES;
    for (NSWindow *window in NSApp.windows) if (window.visible) { allClosed = NO; break; }
    if (allClosed) [Global activateAppWithIdentifier:IShotGlobal_1001ddfe0];
    if (IShotGlobal_1001de168) {
        if (allClosed) IShotGlobal_1001de168 = NO;
        return NO;
    }
    if (IShotGlobal_1001de150) NSLog(@"allWindowClose:%d", allClosed);
    if (allClosed && !IShotGlobal_1001de150) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"4K6FWZU8C4.group.cn.better365"];
        [defaults synchronize];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{ [Global restart]; }); // 0x1000a8560
    }
    return NO;
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)application hasVisibleWindows:(BOOL)visible { // 0x1000a856c
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"4K6FWZU8C4.group.cn.better365"];
    if ([defaults boolForKey:@"StartiShotByiShotHelper"]) {
        [defaults removeObjectForKey:@"StartiShotByiShotHelper"];
        [defaults synchronize];
    } else if (NSDate.date.timeIntervalSince1970 * 1000 - IShotGlobal_1001f1b80 >= 1000) [self openPreferencesWindow];
    return YES;
}
- (void)shortcutRecorderWillBegin {} // 0x1000a8638 RET only
- (void)startCGEventListen { // 0x1000a863c
    if (IShotGlobal_1001f1b88) { CGEventTapEnable(IShotGlobal_1001f1b88, true); return; }
    IShotGlobal_1001f1b88 = CGEventTapCreate(1, 0, 0, 0x1c00, IShotFunction_1000a86e8, NULL);
    if (IShotGlobal_1001f1b88) {
        IShotGlobal_1001f1b90 = CFMachPortCreateRunLoopSource(NULL, IShotGlobal_1001f1b88, 0);
        CFRelease(IShotGlobal_1001f1b88);
        if (IShotGlobal_1001f1b90) {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), IShotGlobal_1001f1b90, kCFRunLoopCommonModes);
            CFRelease(IShotGlobal_1001f1b90);
        }
    }
}
- (void)appDidActivate:(NSNotification *)notification { // 0x1000a89e4
    NSRunningApplication *application = notification.userInfo[@"NSWorkspaceApplicationKey"];
    if (![[MXClipScreenManager sharedInstance] isWorking] && ![application.bundleIdentifier isEqualToString:@"cn.better365.ishot"] && ![application.bundleIdentifier isEqualToString:@"cn.better365.iShotPro"])
        IShotGlobal_1001ddfe0 = application.bundleIdentifier;
}
- (void)applicationWillTerminate:(NSNotification *)notification { IShotFunction_100047ffc(@"TelliShotHelperToQuit"); } // 0x1000a8aec
- (void)startRecordScreen { // 0x1000a8af8
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    [defaults registerDefaults:@{@"NSStatusItem Preferred Position Item-0":@301}];
    [defaults setInteger:301 forKey:@"NSStatusItem Preferred Position Item-0"];
    self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:133];
    self.statusItem = self.statusItem;
    IShotGlobal_1001de170 = [MenuView alloc];
    self.menuBarView = [IShotGlobal_1001de170 initWithFrame:NSMakeRect(0, 0, 133, NSStatusBar.systemStatusBar.thickness)];
    self.statusItem.view = self.menuBarView;
    [defaults removeObjectForKey:@"NSStatusItem Preferred Position Item-0"];
}
- (void)stopRecorder:(id)sender { // 0x1000a8d70
    [IShotGlobal_1001de170 endRecord];
    [NSNotificationCenter.defaultCenter postNotificationName:@"SGVideoControllerEndCaptureNotification" object:nil];
    if (self.statusItem) [NSStatusBar.systemStatusBar removeStatusItem:self.statusItem];
}
- (void)selectTheLastSavedFile { // 0x1000a8e34
    NSString *path = [NSUserDefaults.standardUserDefaults stringForKey:@"LastSavedFile"];
    NSURL *directory = [NSURL fileURLWithPath:path.stringByDeletingLastPathComponent];
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) [NSWorkspace.sharedWorkspace selectFile:path inFileViewerRootedAtPath:directory.path];
    else [[AppSandboxFileAccess fileAccessWithMessage:@""] accessFilePath:directory.path persistPermission:YES withBlock:^{ // 0x1000a8fec
        [NSWorkspace.sharedWorkspace openURL:directory];
        return (id)nil;
    }];
}
- (void)regionalScreenshots:(id)sender { // 0x1000a902c
    IShotGlobal_1001dde80 = nil;
    if (![LCAuthGuideKit getScreenCaptureIsEnabled]) {
        if (@available(macOS 10.15, *)) {
            LCPermissionModel *model = [[LCPermissionModel alloc] initWithAuthType:3 desc:@""];
            [[LCAuthGuideKit shared] setAllAuthPassedHandler:^{ NSLog(@"----所有授权全部完成-----"); }]; // 0x1000a9378; CFString 0x1001b8420
            [[LCAuthGuideKit shared] setShouldTerminateOnClose:YES];
            [[LCAuthGuideKit shared] showPermissionAuth:@[model]];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{ // 0x1000a9394
                [NSApp activateIgnoringOtherApps:YES];
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = localized(@"Screenshot needs to obtain the permission of <Screen Recording>. Please <tick> or <retick> the option of iShot in <Screen Recording>.");
                [alert addButtonWithTitle:localized(@"OK")];
                [alert addButtonWithTitle:localized(@"Watch Help Video")];
                if ([alert runModal] == 1000) [Global popupRequestScreenCaptureAccess];
                else [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/h-nd-169.html"]];
            });
        }
        return;
    }
    if (![[MXClipScreenManager sharedInstance] isWorking]) {
        if (![NSUserDefaults.standardUserDefaults boolForKey:@"enableCaptureCursor"]) IShotGlobal_1001de178 = nil;
        else {
            NSPoint location = NSEvent.mouseLocation;
            NSCursor *cursor = NSCursor.currentSystemCursor;
            IShotGlobal_1001de178 = @{@"CursorPos":NSStringFromPoint(location), @"CursorImage":cursor.image, @"HotSpot":NSStringFromPoint(cursor.hotSpot)};
        }
    }
    [[MXClipScreenManager sharedInstance] startCaptureFromPinAnnotate:NO];
}
- (void)recordScreen:(id)sender { // 0x1000a9568
    IShotGlobal_1001ddd60 = nil;
    if ([[MXRecordScreenManager sharedInstance] isWorking]) { [self stopRecorder:self]; return; }
    BOOL capture = [LCAuthGuideKit getScreenCaptureIsEnabled];
    int microphone = IShotFunction_1000489a8();
    if (!capture) {
        if (@available(macOS 10.15, *)) {
            LCPermissionModel *model = [[LCPermissionModel alloc] initWithAuthType:3 desc:@""];
            [[LCAuthGuideKit shared] setAllAuthPassedHandler:^{ NSLog(@"----所有授权全部完成-----"); }]; // 0x1000a99b0; CFString 0x1001b8420
            [[LCAuthGuideKit shared] setShouldTerminateOnClose:YES];
            [[LCAuthGuideKit shared] showPermissionAuth:@[model]];
        } else {
            [NSApp activateIgnoringOtherApps:YES];
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = localized(@"Recorder Screen needs to obtain the permission of <Screen Recording>. Please <tick> or <retick> the option of iShot in <Screen Recording>.");
            [alert addButtonWithTitle:localized(@"OK")];
            [alert runModal];
            [Global popupRequestScreenCaptureAccess];
        }
    } else if (microphone == -1) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = localized(@"Recorder Screen needs to obtain the permission of <Microphone>. Please <tick> or <retick> the option of iShot in <Microphone>.");
        [alert addButtonWithTitle:localized(@"OK")];
        [alert runModal];
        [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone"]];
    } else if (microphone == 1) [[MXRecordScreenManager sharedInstance] readyToRecordScreen];
}
- (void)annotatedWhenRecordScreenClick:(id)sender { // 0x1000a99cc
    IShotGlobal_1001de180 = YES;
    [[MXClipScreenManager sharedInstance] startCaptureFromPinAnnotate:YES];
    NSScreen *screen = [NSScreen currentScreenForMouseLocation];
    IShotGlobal_1001dde80 = screen;
    NSRect rect = [(NSWindow *)[(id)self window] frame];
    IShotGlobal_1001ddd18 = rect.origin.x;
    IShotGlobal_1001ddd20 = rect.origin.y;
    IShotGlobal_1001ddd28 = rect.size.width;
    IShotGlobal_1001ddd30 = rect.size.height;
    IShotGlobal_1001ddd18 -= screen.frame.origin.x;
    IShotGlobal_1001ddd20 -= screen.frame.origin.y;
    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"startAnnotation" object:nil userInfo:nil];
}
- (void)telliShotToDo:(NSNotification *)notification { // 0x1000a9aec
    NSString *name = notification.name;
    if ([name isEqualToString:@"TelliShotToScreenShots"]) {
        IShotGlobal_1001de181 = NO; IShotGlobal_1001de182 = NO; IShotGlobal_1001de183 = NO; IShotGlobal_1001de184 = NO;
        [self regionalScreenshots:nil];
    } else if ([name isEqualToString:@"TelliShotToMapFromPaste"]) [self mapFromPaste:nil];
    else if ([name isEqualToString:@"TelliShotToMapFromComBetter365Pasteboard"]) [self mapFromComBetter365Pasteboard:nil];
    else if ([name isEqualToString:@"TelliShotToDelayScreenShot"]) [self delayScreenShot:nil];
    else if ([name isEqualToString:@"TelliShotToRecordScreen"]) [self recordScreen:nil];
    else if ([name isEqualToString:@"TelliShotToOpenPreferencesWindow"]) [self openPreferencesWindow];
    else if ([name isEqualToString:@"TelliShotToSelectTheLastSavedFile"]) [self selectTheLastSavedFile];
    else if ([name isEqualToString:@"TelliShotToStartRecordAudio"]) [self startRecordAudio];
    else if ([name isEqualToString:@"TelliShotToOpenPinLibraryWindow"]) [self openPinLibraryWindow];
    else if ([name isEqualToString:@"TelliShotToScreenShotWithShell"]) [self screenShotWithShell];
    else if ([name isEqualToString:@"TelliShotToScreenShotToTranslate"]) [self screenShotToTranslate];
    else if ([name isEqualToString:@"TelliShotToScreenShotToOCR"]) [self screenShotToOCR];
    else if ([name isEqualToString:@"TelliShotToQuit"]) [NSApp terminate:nil];
}
- (void)mapFromPaste:(id)sender { // 0x1000a9cf8
    NSPasteboard *pasteboard = NSPasteboard.generalPasteboard;
    if (pasteboard.pasteboardItems.count == 0) return;
    NSArray *types = pasteboard.types;
    if ([types containsObject:NSFilenamesPboardType]) types = @[NSFilenamesPboardType];
    NSFileManager *manager = NSFileManager.defaultManager;
    NSImage *image = nil;
    for (NSString *type in types) {
        if ([type isEqualToString:NSFilenamesPboardType]) {
            for (NSString *path in [pasteboard propertyListForType:NSFilenamesPboardType]) {
                BOOL directory = NO;
                if ([manager fileExistsAtPath:path isDirectory:&directory] && !directory) {
                    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)path.pathExtension, NULL);
                    if (UTTypeConformsTo(uti, kUTTypeImage)) image = [[NSImage alloc] initWithContentsOfFile:path];
                    CFRelease(uti);
                }
            }
        } else if ([type isEqualToString:NSTIFFPboardType] && [NSImage canInitWithPasteboard:pasteboard] && ![types containsObject:@"com.adobe.pdf"]) image = [[NSImage alloc] initWithPasteboard:pasteboard];
    }
    if (!image) image = [Global convertClipboardDataToImage:sender == nil withPasteboard:pasteboard];
    if (image) [self mapImageToScreen:image isAddToPinLibrary:YES];
    else IShotFunction_100047ffc([@"TelliShotHelperToUserNotification:" stringByAppendingString:localized(@"⚠️ There are no pictures in the clipboard to use for pin.")]);
}
- (void)mapFromComBetter365Pasteboard:(id)sender { // 0x1000aa174
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:@"com.better365.pasteboard"];
    if (pasteboard.pasteboardItems.count == 0) return;
    NSArray *types = pasteboard.types;
    if ([types containsObject:NSFilenamesPboardType]) types = @[NSFilenamesPboardType];
    NSFileManager *manager = NSFileManager.defaultManager;
    NSImage *image = nil;
    for (NSString *type in types) {
        if ([type isEqualToString:NSFilenamesPboardType]) {
            for (NSString *path in [pasteboard propertyListForType:NSFilenamesPboardType]) {
                BOOL directory = NO;
                if ([manager fileExistsAtPath:path isDirectory:&directory] && !directory) {
                    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)path.pathExtension, NULL);
                    if (UTTypeConformsTo(uti, kUTTypeImage)) image = [[NSImage alloc] initWithContentsOfFile:path];
                    CFRelease(uti);
                }
            }
        } else if ([type isEqualToString:NSTIFFPboardType] && [NSImage canInitWithPasteboard:pasteboard] && ![types containsObject:@"com.adobe.pdf"]) image = [[NSImage alloc] initWithPasteboard:pasteboard];
    }
    if (!image) image = [Global convertClipboardDataToImage:NO withPasteboard:pasteboard];
    if (image) [self mapImageToScreen:image isAddToPinLibrary:YES];
    else IShotFunction_100047ffc([@"TelliShotHelperToUserNotification:" stringByAppendingString:localized(@"⚠️ There are no pictures in the clipboard to use for pin.")]);
}
- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls { // 0x1000aa5f4
    for (NSURL *url in urls) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:url.path];
        NSImage *image = [[NSImage alloc] initWithData:data];
        if (image) [self mapImageToScreen:image isAddToPinLibrary:YES];
    }
}
- (void)mapImageToScreen:(NSImage *)image isAddToPinLibrary:(BOOL)add { // 0x1000aa75c
    if (image) {
        NSScreen *screen = [NSScreen currentScreenForMouseLocation];
        NSSize size = image.size;
        CGFloat x = screen.frame.origin.x + 20;
        CGFloat top = screen.frame.origin.y + screen.frame.size.height - 20;
        for (NSWindowController *controller in IShotGlobal_1001ddcd0) {
            CGFloat existingX = controller.window.frame.origin.x;
            NSRect rect = controller.window.frame;
            if (x == existingX && top == rect.origin.y + rect.size.height) { x += 20; top -= 20; }
        }
        [Global pinToScreenWithImage:image rect:NSMakeRect(x, top - size.height - 12, size.width + 12, size.height + 12)];
        if (add) [self savePinImageToTempDirectory:image];
    }
}
- (void)savePinImageToTempDirectory:(NSImage *)image { // 0x1000aa9e4
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/PinLibrary"];
    NSFileManager *manager = NSFileManager.defaultManager;
    if (![manager fileExistsAtPath:directory]) [manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [NSString stringWithFormat:@"%@/%@.png", directory, [NSImage md5WithImage:image]];
    if (![manager fileExistsAtPath:path]) {
        [self saveImage:image toFilePath:path withType:4];
        if (IShotGlobal_1001de188) dispatch_async(dispatch_get_main_queue(), ^{ [IShotGlobal_1001de188 refreshCollectionView]; }); // 0x1000aabcc
        dispatch_async(dispatch_get_global_queue(0, 0), ^{ [self createPreviewImageOfPinLibrary]; }); // 0x1000aabd8
    }
}
- (void)delayScreenShot:(id)sender { // 0x1000aafe4
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSInteger delay = [[defaults stringForKey:@"timeOfDelayScreenshots"] integerValue];
    if (![defaults boolForKey:@"playSoundWhenDelayScreenShots"]) [self performSelector:@selector(saveFullImageToFile) withObject:nil afterDelay:delay];
    else dispatch_async(dispatch_get_global_queue(0, 0), ^{ // 0x1000ab0e0
        for (NSInteger i = delay; i != 0; i--) system([NSString stringWithFormat:@"say %lu", (unsigned long)i].UTF8String);
        [self saveFullImageToFile];
    });
}
- (void)screenshotWindowUnderCursor:(id)sender { // 0x1000ab164
    IShotGlobal_1001dde80 = [NSScreen currentScreenForMouseLocation];
    NSImage *image = [NSImage getImageWindowUnderMouse];
    int shadow = [[NSUserDefaults.standardUserDefaults stringForKey:@"sizeOfShadow"] intValue];
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"needShadowOfnotSingleWindow"] && shadow > 0) image = [NSImage addShadow:image withSize:(float)shadow];
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"alsoSaveToPaste"]) [NSImage saveImageToPaste:image];
    [self saveImageToFile:image];
}
- (void)screenShotWithShell { // 0x1000ab69c
    if (!IShotGlobal_1001de190) IShotGlobal_1001de190 = [[ScreenshotWithShellController alloc] initFromXib];
    else {
        if (IShotGlobal_1001de190.window.visible) { [IShotGlobal_1001de190.window close]; return; }
        [IShotGlobal_1001de190.window makeKeyAndOrderFront:self];
    }
    [NSApp activateIgnoringOtherApps:YES];
}
- (void)screenShotToTranslate { /* Removed in Lite: ignore legacy feature notifications. */ }
- (void)screenShotToOCR { /* Removed in Lite: ignore legacy feature notifications. */ }
- (void)openPinLibraryWindow { // 0x1000ab868
    if (!IShotGlobal_1001de188) IShotGlobal_1001de188 = [[PinLibraryController alloc] init];
    if (IShotGlobal_1001de188.window.visible) { [IShotGlobal_1001de188.window close]; return; }
    [IShotGlobal_1001de188.window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}
- (void)startRecordAudio { // 0x1000ab92c
    int permission = IShotFunction_1000489a8();
    if (permission == -1) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = localized(@"Recording needs to obtain the permission of <Microphone>. Please <tick> or <retick> the option of iShot in <Microphone>.");
        [alert addButtonWithTitle:localized(@"Agree")];
        [alert addButtonWithTitle:localized(@"Refuse")];
        if ([alert runModal] == 1000) [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone"]];
        return;
    }
    if (permission == 1) {
        if (!IShotGlobal_1001de198) {
            IShotGlobal_1001de198 = [[RecordAudioController alloc] initFromXib];
            [IShotGlobal_1001de198.window standardWindowButton:NSWindowCloseButton].enabled = YES;
            [IShotGlobal_1001de198.window makeKeyAndOrderFront:self];
            dispatch_async(dispatch_get_main_queue(), ^{ [IShotGlobal_1001de198 actionWhenWindowOpened]; }); // 0x1000abcb0
        } else {
            if ([IShotGlobal_1001de198 isRecording]) { [IShotGlobal_1001de198 stopBtnClick:self]; return; }
            [IShotGlobal_1001de198.window standardWindowButton:NSWindowCloseButton].enabled = YES;
            if (!IShotGlobal_1001de198.window.visible) dispatch_async(dispatch_get_main_queue(), ^{ [IShotGlobal_1001de198 actionWhenWindowOpened]; }); // 0x1000abcbc
            [IShotGlobal_1001de198.window makeKeyAndOrderFront:self];
        }
        [NSApp activateIgnoringOtherApps:YES];
    }
}
- (void)openPreferencesWindow { // 0x1000abe84
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 50000000), dispatch_get_main_queue(), ^{ // 0x1000abf14
        if (!IShotGlobal_1001de1a0) IShotGlobal_1001de1a0 = [[AppPrefsWindowController alloc] initWithWindowNibName:@"Preferences"];
        [IShotGlobal_1001de1a0.window makeKeyAndOrderFront:self];
        [NSApp activateIgnoringOtherApps:YES];
    });
}
- (void)registerAllHotKey { // 0x1000abf98
    extern NSString *IShotFunction_10004ab58(id dictionary);
    NSMutableDictionary *shortcuts = [[NSUserDefaults.standardUserDefaults objectForKey:@"dicOfShortCutKey"] mutableCopy];
    [shortcuts removeObjectsForKeys:@[@"OCRRecorder",@"translateRecorder"]];
    NSString *message = [@"TelliShotHelperToRegisterAllHotKey:" stringByAppendingString:IShotFunction_10004ab58(shortcuts)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2000000000), dispatch_get_main_queue(), ^{ IShotFunction_100047ffc(message); }); // 0x1000ac240
    PTHotKeyCenter *center = [PTHotKeyCenter sharedCenter];
    for (NSString *identifier in shortcuts) {
        id combo = shortcuts[identifier];
        PTHotKey *previous = [center hotKeyWithIdentifier:identifier];
        if (previous) [center unregisterHotKey:previous];
        PTHotKey *hotkey = [PTHotKey hotKeyWithIdentifier:identifier keyCombo:combo target:self action:@selector(hotKeyAction:)];
        [center registerHotKey:hotkey];
    }
}
- (void)hotKeyAction:(PTHotKey *)hotkey { [self hotKeyActionWithIdentifier:hotkey.identifier]; } // 0x1000ac248
- (void)hotKeyActionWithIdentifier:(NSString *)identifier { // 0x1000ac288
    if ([identifier isEqualToString:@"regionalScreenshotsRecorder"] || [identifier isEqualToString:@"quickScreenshotsRecorder"] || [identifier isEqualToString:@"presetAreaSizeScreenshotsRecorder"]) {
        IShotGlobal_1001de181 = ![identifier isEqualToString:@"regionalScreenshotsRecorder"];
        IShotGlobal_1001de182 = [identifier isEqualToString:@"presetAreaSizeScreenshotsRecorder"];
        IShotGlobal_1001de183 = NO; IShotGlobal_1001de184 = NO;
        [self regionalScreenshots:self];
    } else if ([identifier isEqualToString:@"delayScreenshotsRecorder"]) [self delayScreenShot:self];
    else if ([identifier isEqualToString:@"screenshotWindowUnderCursorRecorder"]) [self screenshotWindowUnderCursor:self];
    else if ([identifier isEqualToString:@"screenshotPreviousAreaRecorder"]) [self screenshotPreviousArea:self];
    else if ([identifier isEqualToString:@"mapFromPasteRecorder"]) [self mapFromPaste:self];
    else if ([identifier isEqualToString:@"recordScreenRecorder"]) {
        if (IShotGlobal_1001de1a8) [self stopRecorder:self]; else [self recordScreen:self];
    } else if ([identifier isEqualToString:@"pauseScreenRecorder"]) {
        if (IShotGlobal_1001ddde0) [IShotGlobal_1001de170 pauseButtonClick:self];
    } else if ([identifier isEqualToString:@"annotateOfScreenRecorder"]) {
        if (IShotGlobal_1001ddde0) {
            if (IShotGlobal_1001de180) [IShotGlobal_1001de160 cancelButtonClick:self];
            else [self annotatedWhenRecordScreenClick:self];
        }
    } else if ([identifier isEqualToString:@"screenshotWithShellRecorder"]) [self screenShotWithShell];
    else if ([identifier isEqualToString:@"recordingRecorder"]) [self startRecordAudio];
    else if ([identifier isEqualToString:@"OCRRecorder"]) [self screenShotToOCR];
    else if ([identifier isEqualToString:@"translateRecorder"]) [self screenShotToTranslate];
    else if ([identifier isEqualToString:@"openPinLibraryWindowRecorder"]) [self openPinLibraryWindow];
    else if ([identifier isEqualToString:@"hiddenAndShowAllPinWindowRecorder"]) [self hiddenOrShowAllPinWindow];
}
- (void)createPreviewImageOfPinLibrary { // 0x1000aabe0
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/PinLibrary"];
    NSFileManager *manager = NSFileManager.defaultManager;
    if (![manager fileExistsAtPath:directory]) {
        [manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSError *error = nil;
        NSArray *files = [manager contentsOfDirectoryAtPath:directory error:&error];
        NSString *previewDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/PreviewImageOfPinLibrary"];
        if (![manager fileExistsAtPath:previewDirectory]) [manager createDirectoryAtPath:previewDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        NSArray *previews = [manager contentsOfDirectoryAtPath:previewDirectory error:&error];
        for (NSString *file in files) {
            if (![previews containsObject:file]) {
                NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", directory, file]];
                if (image) {
                    float sx = (float)(320.0 / image.size.width);
                    float sy = (float)(200.0 / image.size.height);
                    float scale = sx < sy ? sx : sy;
                    if (scale < 0.5f) {
                        NSImage *resized = [NSImage resizeImage:image scale:scale];
                        if (resized.size.width < 1 || resized.size.height < 1) resized = image;
                        [self saveImage:resized toFilePath:[NSString stringWithFormat:@"%@/%@", previewDirectory, file] withType:4];
                    }
                }
            }
        }
    }
}
- (void)screenshotPreviousArea:(id)sender { // 0x1000ab2d0
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSRect rect = NSRectFromString([defaults stringForKey:@"preRectOfScreenShots"]);
    if (!NSEqualRects(rect, NSZeroRect)) {
        CGFloat height = NSScreen.deepestScreen.frame.size.height;
        IShotGlobal_1001dde80 = nil;
        NSPoint center = NSMakePoint(rect.origin.x + rect.size.width * 0.5, height - (rect.origin.y + rect.size.height * 0.5));
        for (NSScreen *screen in NSScreen.screens) {
            if (NSPointInRect(center, screen.frame)) { IShotGlobal_1001dde80 = screen; break; }
        }
        if (IShotGlobal_1001dde80) {
            NSImage *image = [NSImage captureCurrentScreenshot:rect];
            if (![defaults boolForKey:@"isClipWindowPreviousScreenShots"]) image = [NSImage addRoundImgae:image withRadius:(float)[[defaults objectForKey:@"sizeOfImageFillet"] intValue]];
            int shadow = [[NSUserDefaults.standardUserDefaults stringForKey:@"sizeOfShadow"] intValue];
            if ([NSUserDefaults.standardUserDefaults boolForKey:@"needShadowOfnotSingleWindow"] && shadow > 0) image = [NSImage addShadow:image withSize:(float)shadow];
            if ([NSUserDefaults.standardUserDefaults boolForKey:@"alsoSaveToPaste"]) [NSImage saveImageToPaste:image];
            [self saveImageToFile:image];
            return;
        }
    }
    NSBeep();
}
- (void)saveFullImageToFile { // 0x1000abcc8
    IShotGlobal_1001dde80 = [NSScreen currentScreenForMouseLocation];
    dispatch_async(dispatch_get_main_queue(), ^{ // 0x1000abd64
        CGFloat height = NSScreen.deepestScreen.frame.size.height;
        CGFloat y = (double)(float)(height - IShotGlobal_1001dde80.frame.size.height - IShotGlobal_1001dde80.frame.origin.y);
        NSRect rect = NSMakeRect(IShotGlobal_1001dde80.frame.origin.x, y, IShotGlobal_1001dde80.frame.size.width, IShotGlobal_1001dde80.frame.size.height);
        NSImage *image = [NSImage captureCurrentScreenshot:rect];
        if ([NSUserDefaults.standardUserDefaults boolForKey:@"alsoSaveToPaste"]) [NSImage saveImageToPaste:image];
        [self saveImageToFile:image];
    });
}
- (void)buttonPressed:(NSPopUpButton *)sender { // 0x1000ac55c
    NSString *format = nil;
    if (sender.indexOfSelectedItem == 0) format = @"png";
    else if (sender.indexOfSelectedItem == 1) format = @"jpg";
    else if (sender.indexOfSelectedItem == 2) format = @"tiff";
    else if (sender.indexOfSelectedItem == 3) format = @"webp";
    else if (sender.indexOfSelectedItem == 4) format = @"heic";
    else if (sender.indexOfSelectedItem == 5) format = @"pdf";
    if (format) IShotGlobal_1001f1b98.allowedFileTypes = @[format];
    [IShotGlobal_1001f1b98 validateVisibleColumns];
}
- (void)saveImageOfNotSpecified:(NSImage *)image { // 0x1000ac670
    extern NSString *IShotFunction_10004a980(NSString *path);
    NSString *frontmost = NSWorkspace.sharedWorkspace.frontmostApplication.bundleIdentifier;
    IShotGlobal_1001f1b98 = NSSavePanel.savePanel;
    IShotGlobal_1001f1b98.contentView.window.level = 1;
    IShotGlobal_1001f1b98.allowsOtherFileTypes = YES;
    IShotGlobal_1001f1b98.title = localized(@"Save Image File");
    NSFont *font = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:0]];
    NSTextView *label = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 60, 22)];
    label.font = font;
    label.editable = NO;
    label.drawsBackground = NO;
    label.horizontallyResizable = YES;
    label.verticallyResizable = YES;
    label.alignment = NSTextAlignmentRight;
    label.textColor = NSColor.secondaryLabelColor;
    label.string = localized(@"Format:");
    NSPopUpButton *formatButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(63, 0, 225, 25) pullsDown:NO];
    [formatButton addItemWithTitle:localized(@"png")];
    [formatButton addItemWithTitle:localized(@"jpg")];
    [formatButton addItemWithTitle:localized(@"tiff")];
    [formatButton addItemWithTitle:localized(@"webp")];
    [formatButton addItemWithTitle:localized(@"heic")];
    [formatButton addItemWithTitle:localized(@"pdf")];
    formatButton.autoenablesItems = YES;
    formatButton.action = @selector(buttonPressed:);
    formatButton.target = self;
    NSView *accessory = [[NSView alloc] initWithFrame:NSMakeRect(-30, 0, formatButton.frame.size.width + 100, 26)];
    [accessory addSubview:label];
    [accessory addSubview:formatButton];
    IShotGlobal_1001f1b98.accessoryView = accessory;
    NSString *format = [NSUserDefaults.standardUserDefaults stringForKey:@"formatOfSavePhoto"];
    [formatButton selectItemWithTitle:format];
    IShotGlobal_1001f1b98.allowedFileTypes = [NSArray arrayWithObjects:format, nil];
    NSString *path = IShotGlobal_1001f1b98.URL.path;
    NSString *name = IShotFunction_10004a980([NSString stringWithFormat:@"%@.%@", path, format]);
    IShotGlobal_1001f1b98.directoryURL = [NSURL fileURLWithPath:path];
    IShotGlobal_1001f1b98.nameFieldStringValue = name.lastPathComponent;
    if ([IShotGlobal_1001f1b98 runModal] == 1) {
        NSUInteger type = 1;
        if (formatButton.indexOfSelectedItem == 0) type = 4;
        else if (formatButton.indexOfSelectedItem == 1) type = 3;
        else if (formatButton.indexOfSelectedItem == 2) type = 0;
        else if (formatButton.indexOfSelectedItem == 3) type = 100000;
        else if (formatButton.indexOfSelectedItem == 4) type = 100001;
        else if (formatButton.indexOfSelectedItem == 5) type = 100002;
        [NSImage saveImage:image toFile:IShotGlobal_1001f1b98.URL.path withType:type];
        IShotGlobal_1001f1b98 = nil;
    }
    [Global activateAppWithIdentifier:frontmost];
}
- (void)saveImageToFile:(NSImage *)image { // 0x1000ace2c
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"playSoundWhenScreenShots"]) IShotFunction_100047ffc(@"TelliShotHelperToPlayScreenShotAudio");
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSString *format = [defaults stringForKey:@"formatOfSavePhoto"] ?: @"jpg";
    NSDate *date = NSDate.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH.mm.ss";
    NSString *stamp = [formatter stringFromDate:date];
    NSString *name = [[localized(@"iShot") stringByAppendingString:@"_"] stringByAppendingString:stamp];
    NSString *directory = [defaults stringForKey:@"pathofSaveScreenShotsPhoto"];
    if ([directory isEqualToString:@"Not Specified"]) { [self saveImageOfNotSpecified:image]; return; }
    if (![NSFileManager.defaultManager fileExistsAtPath:directory]) {
        directory = [self getSavePathWithOpenPanel];
        if ([directory isEqualToString:@""]) return;
        [defaults setObject:directory forKey:@"pathofSaveScreenShotsPhoto"];
        [defaults synchronize];
    }
    NSUInteger type;
    NSString *extension;
    if ([format isEqualToString:@"jpg"]) { type = 3; extension = @"jpg"; }
    else if ([format isEqualToString:@"png"]) { type = 4; extension = @"png"; }
    else if ([format isEqualToString:@"tiff"]) { type = 0; extension = @"tiff"; }
    else if ([format isEqualToString:@"webp"]) { type = 100000; extension = @"webp"; }
    else if ([format isEqualToString:@"heic"]) { type = 100001; extension = @"heic"; }
    else { type = 100002; extension = @"pdf"; }
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@", directory, name, extension];
    [[AppSandboxFileAccess fileAccessWithMessage:@""] accessFilePath:directory persistPermission:YES withBlock:^{ // 0x1000ad2f0
        [NSImage saveImage:image toFile:path withType:type];
    }];
}
- (NSString *)getSavePathWithOpenPanel { // 0x1000ad308
    NSOpenPanel *panel = NSOpenPanel.openPanel;
    panel.canChooseDirectories = YES;
    panel.canCreateDirectories = YES;
    panel.canChooseFiles = NO;
    panel.directoryURL = [NSURL fileURLWithPath:NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0]];
    if ([panel runModal] == 1) {
        NSString *path = panel.URLs.firstObject.path;
        [[AppSandboxFileAccess fileAccessWithMessage:@""] persistPermissionURL:panel.URLs.firstObject];
        return path;
    }
    return @"";
}
- (void)saveScreenWithShell:(NSImage *)image { // 0x1000ad4b8
    NSInteger method = [NSUserDefaults.standardUserDefaults integerForKey:@"saveMethodOfScreenWithShell"];
    if (method == 1) {
        if ([NSUserDefaults.standardUserDefaults boolForKey:@"playSoundWhenScreenShots"]) IShotFunction_100047ffc(@"TelliShotHelperToPlayScreenShotAudio");
        [NSImage saveImageToPaste:image];
    } else {
        if (method != 0) [NSImage saveImageToPaste:image];
        [self saveImageToFile:image];
    }
}
- (void)saveRecordAudioFileFromTempFile:(NSString *)source { // 0x1000ad59c
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSString *directory = [defaults stringForKey:@"pathofSaveAudio"];
    NSFileManager *manager = NSFileManager.defaultManager;
    if ([directory isEqualToString:@"Not Specified"]) {
        [[IShotGlobal_1001de198 window] orderOut:self];
        NSSavePanel *panel = NSSavePanel.savePanel;
        panel.contentView.window.level = -1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100000000), dispatch_get_main_queue(), ^{ panel.contentView.window.level = 1; }); // 0x1000adc64
        panel.nameFieldStringValue = source.lastPathComponent;
        panel.allowsOtherFileTypes = YES;
        panel.extensionHidden = YES;
        panel.canCreateDirectories = YES;
        [panel beginSheetModalForWindow:NSApp.mainWindow completionHandler:^(NSModalResponse result) { // 0x1000adcb4
            if (result == 1) {
                NSString *path = panel.URL.path;
                NSError *error = nil;
                [manager moveItemAtPath:source toPath:path error:&error];
                if (!error) {
                    [NSUserDefaults.standardUserDefaults setObject:path forKey:@"LastSavedFile"];
                    [NSUserDefaults.standardUserDefaults synchronize];
                    IShotFunction_100047ffc([@"TelliShotHelperToUserNotification:" stringByAppendingString:path]);
                } else NSLog(@"%@", error);
            } else [[[IShotGlobal_1001de198 window] standardWindowButton:0] setEnabled:YES];
            [[IShotGlobal_1001de198 window] close];
        }];
        return;
    }
    if (![NSFileManager.defaultManager fileExistsAtPath:directory]) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = localized(@"The save path you set does not exist. Please reset the save path.");
        [alert addButtonWithTitle:localized(@"OK")];
        [alert runModal];
        directory = [self getSavePathWithOpenPanel];
        if ([directory isEqualToString:@""]) { [[IShotGlobal_1001de198 window] close]; return; }
        [defaults setObject:directory forKey:@"pathofSaveAudio"];
        [defaults synchronize];
        if (IShotGlobal_1001de1a0) {
            NSString *title = [NSFileManager.defaultManager displayNameAtPath:directory].lastPathComponent;
            NSPopUpButton *button = [IShotGlobal_1001de1a0 buttonOfSaveAudioPath];
            button.menu.itemArray[0].title = title;
            [button selectItemAtIndex:0];
        }
    }
    // The shipped block at 0x1000ade34 is literally RET (REA assembly verified).
    BOOL access = [[AppSandboxFileAccess fileAccessWithMessage:@""] accessFilePath:directory persistPermission:YES withBlock:^{}];
    if (!access) [NSFileManager.defaultManager removeItemAtPath:source error:NULL];
    else {
        NSString *path = [NSString stringWithFormat:@"%@/%@", directory, source.lastPathComponent];
        NSError *error = nil;
        [manager moveItemAtPath:source toPath:path error:&error];
        if (!error) {
            [NSUserDefaults.standardUserDefaults setObject:path forKey:@"LastSavedFile"];
            [NSUserDefaults.standardUserDefaults synchronize];
            IShotFunction_100047ffc([@"TelliShotHelperToUserNotification:" stringByAppendingString:path]);
        } else NSLog(@"%@", error);
    }
    [[IShotGlobal_1001de198 window] close];
}
- (BOOL)saveImage:(NSImage *)image toFilePath:(NSString *)path withType:(NSUInteger)type { // 0x1000ade38
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:[image CGImageForProposedRect:NULL context:nil hints:nil]];
    rep.size = image.size;
    NSDictionary *properties = nil;
    if (type == 0) properties = @{NSImageCompressionMethod: @1.0f};
    else if (type == 3) properties = @{NSImageCompressionFactor: @0.85f};
    else if (type == 4) properties = @{NSImageCompressionFactor: @1.0f};
    return [[rep representationUsingType:type properties:properties] writeToFile:path atomically:YES];
}
- (void)hiddenOrShowAllPinWindow { // 0x1000adfe0
    NSInteger level = 25;
    for (NSWindowController *controller in IShotGlobal_1001ddcd0) {
        if (controller.window.level == 25) { level = -2147483626; break; }
    }
    for (NSWindowController *controller in IShotGlobal_1001ddcd0) controller.window.level = level;
}
- (void)ffmpegTranscodeFrom:(NSString *)source toFile:(NSString *)destination withType:(NSString *)type { // 0x1000ae1cc
    if (!IShotGlobal_1001de1b0) IShotGlobal_1001de1b0 = [[FFmpegCommandToolController alloc] initFromXib];
    [[IShotGlobal_1001de1b0 windowTitle] setStringValue:[NSString stringWithFormat:@"%@%@", type, localized(@"Transcode")]];
    [[IShotGlobal_1001de1b0 window] makeKeyAndOrderFront:self];
    [[IShotGlobal_1001de1b0 leftTimeTextField] setStringValue:localized(@"Calculating")];
    [[IShotGlobal_1001de1b0 progressIndicator] setIndeterminate:YES];
    [[IShotGlobal_1001de1b0 progressTextField] setStringValue:@"0"];
    dispatch_async(dispatch_get_main_queue(), ^{ // 0x1000ae48c
        [[IShotGlobal_1001de1b0 progressIndicator] startAnimation:self];
        [IShotGlobal_1001de1b0 ffmpegTranscodeFrom:source toFile:destination withType:type];
    });
}
- (BOOL)isPureInt:(NSString *)text { // 0x1000ae4e4
    int value;
    NSScanner *scanner = [NSScanner scannerWithString:text];
    return [scanner scanInt:&value] && scanner.isAtEnd;
}
@end

static void IShotFunction_1000a7aa4(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {
    NSString *notification = (__bridge NSString *)name;
    if ([notification isEqualToString:@"PinFromPasteboardByiRightMouse"]) {
        NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSPasteboardNameDrag];
        if (pasteboard.pasteboardItems.count == 0) return;
        NSArray *types = pasteboard.types;
        if ([types containsObject:NSFilenamesPboardType]) types = @[NSFilenamesPboardType];
        NSFileManager *manager = NSFileManager.defaultManager;
        for (NSString *type in types) {
            if ([type isEqualToString:NSFilenamesPboardType]) {
                for (NSString *path in [pasteboard propertyListForType:NSFilenamesPboardType]) {
                    BOOL directory = NO;
                    if ([manager fileExistsAtPath:path isDirectory:&directory] && !directory) {
                        CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)path.pathExtension, NULL);
                        if (UTTypeConformsTo(uti, kUTTypeImage)) [[AppDelegate appDelegate] mapImageToScreen:[[NSImage alloc] initWithContentsOfFile:path] isAddToPinLibrary:YES];
                        CFRelease(uti);
                    }
                }
            } else if ([type isEqualToString:NSTIFFPboardType] && [NSImage canInitWithPasteboard:pasteboard] && ![types containsObject:@"com.adobe.pdf"]) {
                [[AppDelegate appDelegate] mapImageToScreen:[[NSImage alloc] initWithPasteboard:pasteboard] isAddToPinLibrary:YES];
            }
        }
    } else if ([notification isEqualToString:@"ScreenShotsByBetter365Group"]) {
        IShotGlobal_1001de181 = NO; IShotGlobal_1001de182 = NO; IShotGlobal_1001de183 = NO; IShotGlobal_1001de184 = NO;
        [[AppDelegate appDelegate] regionalScreenshots:nil];
    }
}
static CGEventRef IShotFunction_1000a86e8(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *context) {
    @autoreleasepool {
        if (type == 12) IShotGlobal_1001f1ba0 = (CGEventGetFlags(event) & 0x1e0000) == 0x80000;
        else if (type == 10) {
            if (IShotGlobal_1001f1ba0 == YES) {
                NSEvent *keyEvent = [NSEvent eventWithCGEvent:event];
                NSDictionary *shortcuts = [NSUserDefaults.standardUserDefaults objectForKey:@"dicOfShortCutKey"];
                for (NSString *key in shortcuts) {
                    NSInteger code = [shortcuts[key][@"keyCode"] integerValue];
                    NSInteger flags = [shortcuts[key][@"modifierFlags"] integerValue];
                    if (code == keyEvent.keyCode && flags == 0x80000) { [[AppDelegate appDelegate] hotKeyActionWithIdentifier:key]; return NULL; }
                }
            }
        } else if (type == (CGEventType)-2) {
            NSLog(@"kCGEventTapDisabledByTimeout:%d", AXIsProcessTrusted());
            CGEventTapEnable(IShotGlobal_1001f1b88, AXIsProcessTrusted());
        }
    }
    return event;
}
