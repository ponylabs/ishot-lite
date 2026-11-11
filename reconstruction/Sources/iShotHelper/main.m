#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreServices/CoreServices.h>
#import <dispatch/dispatch.h>

// Semantic transcription of iShotHelper arm64. Address mapping: source-evidence.json.
static NSUserDefaults *groupDefaults;
static AVAudioPlayer *screenshotAudio;
static long installationTime;

static NSString *localized(NSString *key) {
    return [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:nil];
}
static void telliShot(NSString *name) { // 0x100005188
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:name object:@"cn.better365.group" userInfo:nil deliverImmediately:YES];
}
static NSString *shellOutput(NSString *command) { // 0x1000061a8
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/sh";
    task.arguments = @[@"-c", [NSString stringWithFormat:@"%@", command]];
    NSPipe *pipe = [NSPipe pipe];
    task.standardOutput = pipe;
    NSFileHandle *reader = pipe.fileHandleForReading;
    [task launch];
    NSString *output = [[NSString alloc] initWithData:[reader readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    return [output stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}
static id dictionaryFromJSON(NSString *text) { // 0x1000073e0
    if (!text) return nil;
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (error) { NSLog(@"json解析失败：%@", error); return nil; }
    return value;
}
static double receiptInstallationTime(NSString *identifier) { // 0x10000b1ec
    NSString *path = @"/Library/Receipts/InstallHistory.plist";
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        for (NSDictionary *entry in [NSArray arrayWithContentsOfFile:path]) {
            if ([[entry[@"packageIdentifiers"] componentsJoinedByString:@" "] isEqualToString:identifier]
                && [entry[@"displayVersion"] hasPrefix:@"2."] && [entry objectForKey:@"date"]) {
                return [[entry objectForKey:@"date"] timeIntervalSince1970];
            }
        }
    }
    return 0;
}
static void collectProInstallationTime(NSString *identifier, BOOL outsideStore) { // 0x10000ae88
    if (!outsideStore) {
        installationTime = (long)receiptInstallationTime(identifier);
        if (!installationTime) (void)[[NSDate date] timeIntervalSince1970];
        return;
    }
    NSString *output = shellOutput(@"system_profiler SPInstallHistoryDataType | grep -E 'iShot Pro' -A 4");
    if (![output isEqualToString:@""]) {
        output = [output stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        output = [output stringByReplacingOccurrencesOfString:@"      Source: 3rd Party      Install Date: " withString:@"="];
        for (NSString *part in [output componentsSeparatedByString:@"--"]) {
            if (![part containsString:@"Version: "] && [part containsString:@"="]) {
                NSString *dateText = [[part componentsSeparatedByString:@"="][1] stringByReplacingOccurrencesOfString:@"," withString:@""];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.timeStyle = NSDateFormatterShortStyle;
                formatter.dateStyle = NSDateFormatterShortStyle;
                NSDate *date = [formatter dateFromString:dateText];
                if (!date) break;
                installationTime = (long)[date timeIntervalSince1970];
                if (installationTime > 0) {
                    [groupDefaults setInteger:installationTime forKey:@"NotAppStoreiShotProInstallTime"];
                    [groupDefaults synchronize];
                }
                return;
            }
        }
    }
    installationTime = 0;
}
static void watchApplication(NSString *identifier, NSString *path, BOOL outsideStore) { // 0x10000b4a0
    int counter = 0;
    for (;;) {
        [NSThread sleepForTimeInterval:2];
        if ([NSRunningApplication runningApplicationsWithBundleIdentifier:identifier].count == 0) {
            [NSThread sleepForTimeInterval:1];
            BOOL found = NO;
            for (NSRunningApplication *app in NSWorkspace.sharedWorkspace.runningApplications) {
                if ([app.bundleIdentifier isEqualToString:identifier]) { found = YES; break; }
            }
            if (!found) {
                [groupDefaults setBool:YES forKey:@"StartiShotByiShotHelper"];
                [groupDefaults synchronize];
                [NSWorkspace.sharedWorkspace launchApplication:path];
            }
        }
        if (counter < 300) counter++;
        else {
            if (installationTime > 0) {
                if (![path hasSuffix:@"iShot Pro.app"])
                    [groupDefaults setInteger:installationTime forKey:@"AppStoreiShotInstallTime"];
                else if (outsideStore)
                    [groupDefaults setInteger:installationTime forKey:@"NotAppStoreiShotProInstallTime"];
                [groupDefaults synchronize];
            }
            counter = 0;
        }
    }
}

@interface MenuView : NSView
@property(nonatomic, strong) NSImageView *appIconView;
@end
@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>
@property(nonatomic, strong) NSStatusItem *statusItem;
@property(nonatomic, strong) NSView *menuBarView;
@property(nonatomic, strong) NSMenu *statusItemMenu;
@property(strong) IBOutlet NSWindow *window;
+ (AppDelegate *)appDelegate;
- (void)refreshMenuBarIcon;
- (void)refreshStatusItemMenu;
- (void)openMenu;
- (void)userNotificationOfSaveFile:(NSString *)path;
@end
@implementation MenuView
- (instancetype)initWithFrame:(NSRect)frame { // 0x100009fc4
    self = [super initWithFrame:frame];
    if (self) {
        self.appIconView = [[NSImageView alloc] initWithFrame:NSMakeRect(3, 1, 20, 20)];
        NSImage *image = [NSImage imageNamed:@"ishotmenulogo"];
        image.size = NSMakeSize(20, 20);
        image.template = YES;
        self.appIconView.image = image;
        [self addSubview:self.appIconView];
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(telliShotHelperToDo:) name:nil object:@"cn.better365.iShot" suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];
    }
    return self;
}
- (void)telliShotHelperToDo:(NSNotification *)notification { // 0x10000a118
    NSString *name = notification.name;
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    if ([name isEqualToString:@"TelliShotHelperToPlayScreenShotAudio"]) [screenshotAudio play];
    else if ([name isEqualToString:@"TelliShotHelperToQuit"]) [NSApp terminate:nil];
    else if ([name isEqualToString:@"TelliShotHelperToHideMenuBarIcon"]) {
        [defaults setBool:YES forKey:@"hideMenuBarIcon"];
        [defaults synchronize];
        [[AppDelegate appDelegate] refreshMenuBarIcon];
    } else if ([name isEqualToString:@"TelliShotHelperToShowMenuBarIcon"]) {
        [defaults setBool:NO forKey:@"hideMenuBarIcon"];
        [defaults synchronize];
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/usr/bin/open";
        task.arguments = @[@"-n", NSBundle.mainBundle.bundlePath];
        [task launch];
        exit(0);
    } else if ([name isEqualToString:@"TelliShotHelperToAutoStartAtLogin"] || [name isEqualToString:@"TelliShotHelperToNotAutoStartAtLogin"]) {
        [defaults setBool:[name isEqualToString:@"TelliShotHelperToAutoStartAtLogin"] forKey:@"autoStartAtLogin"];
        [defaults synchronize];
    } else if ([name hasPrefix:@"TelliShotHelperToUserNotification:"]) {
        [[AppDelegate appDelegate] userNotificationOfSaveFile:[name substringFromIndex:0x22]];
    } else if ([name hasPrefix:@"TelliShotHelperToRegisterAllHotKey:"]) {
        [defaults setObject:dictionaryFromJSON([name substringFromIndex:0x23]) forKey:@"dicOfShortCutKey"];
        [defaults synchronize];
        [[AppDelegate appDelegate] refreshStatusItemMenu];
    } else if ([name isEqualToString:@"TelliShotHelperToDownloadAgain"]) {
        telliShot(@"TelliShotToQuit");
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = localized(@"An error occurred due to unknown reasons, and it needs to be downloaded again from the App Store.");
        [alert addButtonWithTitle:localized(@"OK")];
        [alert runModal];
        [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"macappstore://itunes.apple.com/app/id1611347086"]];
        dispatch_async(dispatch_get_main_queue(), ^{ [NSApp terminate:self]; });
    }
}
// Empty bodies below are actual RET-only binary methods, not missing implementations.
- (void)drawRect:(NSRect)rect {} // 0x10000a6f0
- (void)keyDown:(NSEvent *)event {} // 0x10000a6f4
- (void)mouseMoved:(NSEvent *)event {} // 0x10000a6f8
- (void)mouseExited:(NSEvent *)event { NSLog(@"退出"); } // 0x10000a6fc
- (void)mouseEntered:(NSEvent *)event { NSLog(@"进入"); } // 0x10000a718
- (void)mouseUp:(NSEvent *)event {} // 0x10000a734
- (void)mouseDown:(NSEvent *)event { // 0x10000a738
    double threshold = 20;
    if (@available(macOS 10.15, *)) threshold = 30;
    if (event.locationInWindow.x < threshold) [[AppDelegate appDelegate] openMenu];
}
- (void)rightMouseDown:(NSEvent *)event {} // 0x10000a7d4
@end

@implementation AppDelegate
+ (AppDelegate *)appDelegate { return (AppDelegate *)NSApplication.sharedApplication.delegate; } // 0x10000a810
- (void)applicationDidFinishLaunching:(NSNotification *)notification { // 0x10000a85c
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"4K6FWZU8C4.group.cn.better365"];
    NSString *path = NSBundle.mainBundle.bundlePath;
    for (int i = 0; i < 4; i++) path = path.stringByDeletingLastPathComponent;
    BOOL pro = [path hasSuffix:@"iShot Pro.app"];
    BOOL outsideStore = NO;
    NSString *identifier = pro ? @"cn.better365.iShotPro" : @"cn.better365.ishot";
    if (pro) {
        outsideStore = [NSFileManager.defaultManager fileExistsAtPath:[NSString stringWithFormat:@"%@/Contents/Resources/BuyNotFromAppStore.nib", path]];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{ collectProInstallationTime(identifier, outsideStore); });
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            installationTime = (long)receiptInstallationTime(identifier);
            if (installationTime > 0) {
                [groupDefaults setInteger:installationTime forKey:@"AppStoreiShotInstallTime"];
                [groupDefaults synchronize];
            }
        });
    }
    if ([NSRunningApplication runningApplicationsWithBundleIdentifier:identifier].count == 0) {
        if (![defaults boolForKey:@"autoStartAtLogin"]) exit(0);
        [NSWorkspace.sharedWorkspace launchApplication:path];
    } else if ([NSRunningApplication runningApplicationsWithBundleIdentifier:@"cn.better365.iShotHelper"].count > 1) exit(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{ watchApplication(identifier, path, outsideStore); });
    if (![defaults objectForKey:@"installTime"]) {
        [defaults setObject:[NSString stringWithFormat:@"%.f", NSDate.date.timeIntervalSince1970] forKey:@"installTime"];
        [defaults synchronize];
    }
    self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:28];
    self.menuBarView = [[MenuView alloc] initWithFrame:NSMakeRect(0, 0, 28, NSStatusBar.systemStatusBar.thickness)];
    self.statusItem.view = self.menuBarView;
    [self refreshMenuBarIcon];
    [self refreshStatusItemMenu];
    NSString *audioPath = [NSBundle.mainBundle pathForResource:@"screenshot" ofType:@"aif"];
    if (audioPath.length) {
        screenshotAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:nil];
        screenshotAudio.volume = 1;
        [screenshotAudio prepareToPlay];
    }
    if (![defaults objectForKey:@"CPUThreads"]) {
        [groupDefaults setObject:shellOutput(@"sysctl -n machdep.cpu.thread_count") forKey:@"CPUThreads"];
        [groupDefaults synchronize];
    }
    [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
}
- (void)applicationWillTerminate:(NSNotification *)notification {} // 0x10000ca54, RET only
- (void)refreshMenuBarIcon { // 0x10000ca58
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    if (![defaults boolForKey:@"hideMenuBarIcon"]) self.statusItem.visible = YES;
    else {
        NSInteger position = [defaults integerForKey:@"NSStatusItem Preferred Position Item-0"];
        self.statusItem.visible = NO;
        [defaults setInteger:position forKey:@"NSStatusItem Preferred Position Item-0"];
        [defaults removeObjectForKey:@"item0"];
        [defaults synchronize];
    }
}
- (NSAppearance *)getSystemInterfaceAppearance { // 0x10000d624
    if (@available(macOS 10.14, *)) {
        if ([[NSUserDefaults.standardUserDefaults stringForKey:@"AppleInterfaceStyle"] isEqualToString:@"Dark"])
            return [NSAppearance appearanceNamed:NSAppearanceNameDarkAqua];
    }
    return [NSAppearance appearanceNamed:NSAppearanceNameAqua];
}
- (void)openMenu { // 0x10000cb98
    CGFloat x = self.statusItem.view.window.frame.size.height * -0.5 + 5;
    self.statusItemMenu.appearance = [self getSystemInterfaceAppearance];
    [self.statusItemMenu popUpMenuPositioningItem:nil atLocation:NSMakePoint(x, 0) inView:self.statusItem.view];
}
- (void)refreshStatusItemMenu { // 0x10000b6fc
    self.statusItemMenu = [[NSMenu alloc] init];
#define ITEM(title, actionSelector) [self.statusItemMenu addItem:[[NSMenuItem alloc] initWithTitle:localized(@title) action:@selector(actionSelector) keyEquivalent:@""]]
    ITEM("Preferences", OpenPreferences:);
    [self.statusItemMenu addItem:NSMenuItem.separatorItem];
    NSDictionary *shortcuts = [NSUserDefaults.standardUserDefaults objectForKey:@"dicOfShortCutKey"];
#define SHORTCUT(title, actionSelector, key) { \
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:localized(@title) action:@selector(actionSelector) keyEquivalent:@""]; \
    item.keyEquivalentModifierMask = [shortcuts[@key][@"modifierFlags"] unsignedIntegerValue]; \
    NSString *characters = shortcuts[@key][@"charactersIgnoringModifiers"]; \
    if (characters) item.keyEquivalent = characters; \
    [self.statusItemMenu addItem:item]; \
}
    SHORTCUT("ScreenShot", regionalScreenshots:, "regionalScreenshotsRecorder");
    SHORTCUT("Pin From Pasteboard", mapFromPaste:, "mapFromPasteRecorder");
    SHORTCUT("Delay Full Screen Screenshot", delayScreenShot:, "delayScreenshotsRecorder");
    SHORTCUT("Screenshot with Shell", screenShotWithShell:, "screenshotWithShellRecorder");
    SHORTCUT("Start/Stop Record Screen", recordScreenClicked:, "recordScreenRecorder");
    SHORTCUT("Start Record Audio", startRecordAudio:, "recordingRecorder");
    SHORTCUT("Open Pin Library", openPinLibraryWindow:, "openPinLibraryWindowRecorder");
#undef SHORTCUT
    [self.statusItemMenu addItem:NSMenuItem.separatorItem];
    ITEM("Open the Last Saved Directory", SelectTheLastSavedFile:);
    [self.statusItemMenu addItem:NSMenuItem.separatorItem];
    ITEM("Quit", Quit:);
#undef ITEM
}
- (void)regionalScreenshots:(id)sender { telliShot(@"TelliShotToScreenShots"); } // 0x10000cf34
- (void)recordScreenClicked:(id)sender { telliShot(@"TelliShotToRecordScreen"); } // 0x10000cf40
- (void)delayScreenShot:(id)sender { telliShot(@"TelliShotToDelayScreenShot"); } // 0x10000cf4c
- (void)screenShotWithShell:(id)sender { telliShot(@"TelliShotToScreenShotWithShell"); } // 0x10000cf58
- (void)screenShotToOCR:(id)sender { telliShot(@"TelliShotToScreenShotToOCR"); } // 0x10000cf70
- (void)startRecordAudio:(id)sender { telliShot(@"TelliShotToStartRecordAudio"); } // 0x10000cf7c
- (void)openPinLibraryWindow:(id)sender { telliShot(@"TelliShotToOpenPinLibraryWindow"); } // 0x10000cf88
- (void)mapFromPaste:(id)sender { telliShot(@"TelliShotToMapFromPaste"); } // 0x10000cf94
- (void)OpenPreferences:(id)sender { telliShot(@"TelliShotToOpenPreferencesWindow"); } // 0x10000cfa0
- (void)SelectTheLastSavedFile:(id)sender { telliShot(@"TelliShotToSelectTheLastSavedFile"); } // 0x10000cfac
- (void)FeedbackProblem:(id)sender { // 0x10000cfb8
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/support.html"]];
}
- (void)RateOnAppStore:(id)sender { // 0x10000d020
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"macappstore://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=1485844094&type=Productivity"]];
}
- (void)Quit:(id)sender { // 0x10000d088
    telliShot(@"TelliShotToQuit");
    [NSApp terminate:self];
}
- (void)MoreApps:(id)sender { // 0x10000d0c0
    NSInteger installed = [[NSUserDefaults.standardUserDefaults objectForKey:@"installTime"] integerValue];
    long elapsed = (long)(int)NSDate.date.timeIntervalSince1970 - installed;
    NSString *url = @"https://www.better365.cn";
    if (elapsed < 0x2a301) url = @"https://apps.apple.com/cn/developer/%E5%AE%81%E6%B3%A2%E4%B8%8A%E5%AE%98%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/id1470350546";
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:url]];
}
- (void)userNotificationOfSaveFile:(NSString *)path { // 0x10000d1c0
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    [defaults removeObjectForKey:@"InfoOfNSUserNotification"];
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    if (!path || [path isEqualToString:@""]) {
        NSUInteger times = [defaults integerForKey:@"timesOfSavedtoPasteboardNotification"];
        if (times < 6) {
            notification.soundName = NSUserNotificationDefaultSoundName;
            notification.title = localized(@"Screenshot saved to pasteboard");
            notification.informativeText = [NSString stringWithFormat:localized(@"Left %ld more reminders about saving to pasteboard"), 5 - times];
            [defaults setInteger:times + 1 forKey:@"timesOfSavedtoPasteboardNotification"];
        }
    } else {
        notification.soundName = NSUserNotificationDefaultSoundName;
        if ([path hasPrefix:@"/"]) notification.title = localized(@"The file saved ( click to open the save path )");
        notification.informativeText = [NSString stringWithFormat:@"%@", path];
    }
    [defaults synchronize];
    [NSUserNotificationCenter.defaultUserNotificationCenter scheduleNotification:notification];
    NSUserNotificationCenter.defaultUserNotificationCenter.delegate = self;
}
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification { // 0x10000d4a8
    if ([notification.title hasPrefix:localized(@"The file saved")]) {
        NSString *path = notification.informativeText;
        [NSWorkspace.sharedWorkspace selectFile:path inFileViewerRootedAtPath:path.stringByDeletingLastPathComponent];
    }
}
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification { return YES; } // 0x10000d5b8
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification {} // 0x10000d5c0, RET only
@end

#ifndef ISHOT_HELPER_NO_MAIN
int main(int argc, const char *argv[]) { // entry 0x100009f04
    @autoreleasepool {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"4K6FWZU8C4.group.cn.better365"];
        id languages = [defaults objectForKey:@"iShotAppleLanguages"];
        if ([languages count]) [NSUserDefaults.standardUserDefaults setObject:languages forKey:@"AppleLanguages"];
    }
    return NSApplicationMain(argc, argv);
}
#endif
