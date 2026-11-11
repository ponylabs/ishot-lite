#import "AppPrefsWindowController.h"
#import "PreferenceHelpers.h"
#import "../MainApplication/AppDelegate.h"
#import "../MainApplication/LaunchAtLoginController.h"
#import "../Global/Global.h"
#import "../Dependencies/AppSandboxFileAccess.h"
#import "../Shell/CollectionViewItem.h"
#import "../PTHotKey/PTHotKey.h"
#import <QuartzCore/QuartzCore.h>
#import <ApplicationServices/ApplicationServices.h>
extern NSArray *IShotGlobal_1001de130;
extern NSString *IShotFunction_10004ab58(id dictionary);
static NSArray *IShotGlobal_1001de2a8, *IShotGlobal_1001de2b0;
static NSString *PrefsLocalized(NSString *key) { return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:nil]; }
@implementation AppPrefsWindowController
- (instancetype)init {
    if((self=[super init])) {
        for(NSString *key in @[@"qualityOfScreenshot",@"dicOfShortCutKey",@"widthOfPresetAreaSizeScreenshots",@"heightOfPresetAreaSizeScreenshots",@"pathofSaveScreenShotsPhoto",@"pathofSaveVideo",@"pathofSaveAudio"])
            [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:key options:1 context:NULL];
        IShotGlobal_1001de2a8=@[@"Square",@"Ellipse",@"Line",@"Arrow",@"Pencil",@"Mosaic",@"Text",@"Note",@"Highlight",@"Pin",@"Undo",@"Scroll Screenshot",@"Cancel",@"Save",@"Save to Clipboard",@"Copy",@"Save as ...",@"Redo"];
        IShotGlobal_1001de2b0=@[
            @{@"ID":@"regionalScreenshotsRecorder",@"Name":@"Screenshot (Standard Mode)"},
            @{@"ID":@"quickScreenshotsRecorder",@"Name":@"Screenshot (Performance Mode)"},
            @{@"ID":@"presetAreaSizeScreenshotsRecorder",@"Name":@"Screenshot Preset Area Size"},
            @{@"ID":@"screenshotPreviousAreaRecorder",@"Name":@"Screenshot previous area"},
            @{@"ID":@"screenshotWindowUnderCursorRecorder",@"Name":@"Screenshot window under cursor"},
            @{@"ID":@"delayScreenshotsRecorder",@"Name":@"Delay full screen screenshot"},
            @{@"ID":@"screenshotWithShellRecorder",@"Name":@"Screenshot with shell"},
            @{@"Name":@"Multi window screenshot"},@{@"Name":@"Scroll screenshot"}];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowDidBecomeKey:) name:NSWindowDidBecomeKeyNotification object:self.window];
    } return self;
}
- (void)windowDidBecomeKey:(NSNotification *)notification {
    if(![[notification.object identifier] isEqualToString:@"PreferencesWindow"]) return;
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSString *keys[]={@"pathofSaveScreenShotsPhoto",@"pathofSaveVideo",@"pathofSaveAudio"};
    NSPopUpButton *buttons[]={self.buttonOfSaveImagePath,self.buttonOfSaveVideoPath,self.buttonOfSaveAudioPath};
    for(int i=0;i<3;i++) { NSString *path=[defaults objectForKey:keys[i]];
        if(![path isEqualToString:@"Not Specified"] && ![NSFileManager.defaultManager fileExistsAtPath:path]) {
            [defaults setObject:@"Not Selected" forKey:keys[i]];
            buttons[i].menu.itemArray[0].title=PrefsLocalized(@"Not Selected"); [buttons[i] selectItemAtIndex:0];
        }
    }
    [self checkAllOpenSavePath]; [_AnnotatedShortcutTableView reloadData];
}
- (void)checkAllOpenSavePath {
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    self.buttonOfOpenPathofSaveScreenShotsPhoto.hidden=![NSFileManager.defaultManager fileExistsAtPath:[defaults objectForKey:@"pathofSaveScreenShotsPhoto"]];
    self.buttonOfOpenPathofSaveVideo.hidden=![NSFileManager.defaultManager fileExistsAtPath:[defaults objectForKey:@"pathofSaveVideo"]];
    self.buttonOfOpenPathofSaveAudio.hidden=![NSFileManager.defaultManager fileExistsAtPath:[defaults objectForKey:@"pathofSaveAudio"]];
}
- (void)setupLeftMenuTableView {
    self.leftMenuHandler=[[LeftMenuTableHandler alloc] init];
    self.leftMenuHandler.dataList=@[
        @{@"title":PrefsLocalized(@"menu.left.screenshot"),@"image":@"Screenshot4"},
        @{@"title":PrefsLocalized(@"menu.left.annotate"),@"image":@"Annotate"},
        @{@"title":PrefsLocalized(@"menu.left.pin"),@"image":@"pin"},
        @{@"title":PrefsLocalized(@"menu.left.pickColor"),@"image":@"pickcolor"},
        @{@"title":PrefsLocalized(@"menu.left.screenRecord"),@"image":@"screenrecording1"},
        @{@"title":PrefsLocalized(@"menu.left.audioRecord"),@"image":@"Recording"},
        @{@"title":PrefsLocalized(@"menu.left.generalSetting"),@"image":@"General1"}];
    self.leftTabTableView.delegate=self.leftMenuHandler; self.leftTabTableView.dataSource=self.leftMenuHandler;
    self.leftTabTableView.headerView=nil; self.leftTabTableView.selectionHighlightStyle=0; self.leftTabTableView.backgroundColor=NSColor.clearColor;
    __weak AppPrefsWindowController *weakSelf=self;
    self.leftMenuHandler.didSelectBlock=^(NSInteger row){ [weakSelf switchTabWithIndex:row]; };
    [self.leftTabTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}
- (void)windowDidLoad {
    [super windowDidLoad]; self.leftBox.boxCornerRadius=0; [self setupLeftMenuTableView];
    NSMutableArray<NSView *> *views=[NSMutableArray arrayWithObject:self.window.contentView];
    while(views.count) {
        NSView *view=views.lastObject; [views removeLastObject];
        [views addObjectsFromArray:view.subviews];
        if([view isKindOfClass:NSPopUpButton.class]) {
            for(NSMenuItem *item in [(NSPopUpButton *)view itemArray]) {
                if([item.title containsString:@"OCR"] || [item.title containsString:@"截图翻译"] || [item.title containsString:@"Screenshot to Translate"]) item.hidden=YES;
            }
        }
        if([view isKindOfClass:NSControl.class] && [(NSControl *)view action]==@selector(rateOnAppStore:)) {
            [(NSControl *)view setTarget:nil]; [(NSControl *)view setAction:NULL];
            [view removeFromSuperview];
        }
    }

    self.annotatedShortcutScrollView.isTransparentBackground=NO; self.screenShotShortcutScrollView.isTransparentBackground=YES;
    [_ScreenShotShortcutTableView scrollRowToVisible:0]; _ScreenShotShortcutTableView.selectionHighlightStyle=-1; _AnnotatedShortcutTableView.selectionHighlightStyle=-1;
    [self.window standardWindowButton:2].hidden=YES;
    [NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(systemThemeChanged:) name:@"AppleInterfaceThemeChangedNotification" object:nil];
}
- (void)systemThemeChanged:(id)notification { dispatch_async(dispatch_get_main_queue(), ^{ [self->_ScreenShotShortcutTableView reloadData]; }); }
- (void)awakeFromNib {
    NSInteger owner=[[NSFileManager.defaultManager attributesOfItemAtPath:NSBundle.mainBundle.executablePath error:NULL][NSFileOwnerAccountID] integerValue];
    self.version.stringValue=[NSString stringWithFormat:owner==0?@"%@: %@":@"%@ %@",@"iShot Lite",IShotFunction_10004a51c()];
    self.window.title=@"iShot Lite";
    self.window.movableByWindowBackground=YES;
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSString *identifier=[defaults objectForKey:@"appOfUserSpecified"][@"bundleIdentifier"] ?: @"com.apple.Preview";
    NSImage *icon=[NSWorkspace.sharedWorkspace iconForFile:[NSWorkspace.sharedWorkspace absolutePathForAppBundleWithIdentifier:identifier]];
    self.selectedAppName.image=[[NSImage alloc] initWithCGImage:[icon CGImageForProposedRect:NULL context:nil hints:nil] size:icon.size];
    NSDictionary *shortcuts=[defaults objectForKey:@"dicOfShortCutKey"];
    self.mapFromPasteRecorder.objectValue=shortcuts[@"mapFromPasteRecorder"];
    self.openPinLibraryWindowRecorder.objectValue=shortcuts[@"openPinLibraryWindowRecorder"];
    self.hiddenAndShowAllPinWindowRecorder.objectValue=shortcuts[@"hiddenAndShowAllPinWindowRecorder"];
    self.recordScreenRecorder.objectValue=shortcuts[@"recordScreenRecorder"];
    self.pauseScreenRecorder.objectValue=shortcuts[@"pauseScreenRecorder"];
    self.annotateOfScreenRecorder.objectValue=shortcuts[@"annotateOfScreenRecorder"];
    self.recordingRecorder.objectValue=shortcuts[@"recordingRecorder"];
    self.OCRRecorder.objectValue=shortcuts[@"OCRRecorder"];
    NSString *keys[]={@"pathofSaveScreenShotsPhoto",@"pathofSaveVideo",@"pathofSaveAudio"};
    NSString *oldKeys[]={@"oldPathofSaveScreenShotsPhoto",@"oldPathofSaveVideo",@"oldPathofSaveAudio"};
    NSPopUpButton *buttons[]={self.buttonOfSaveImagePath,self.buttonOfSaveVideoPath,self.buttonOfSaveAudioPath};
    for(int i=0;i<3;i++) { NSString *path=[defaults objectForKey:keys[i]];
        if([path isEqualToString:@"Not Specified"]) {
            NSString *old=[defaults objectForKey:oldKeys[i]];
            buttons[i].menu.itemArray[0].title=[NSFileManager.defaultManager fileExistsAtPath:old] ? [NSFileManager.defaultManager displayNameAtPath:old] : PrefsLocalized(@"Not Selected");
            [buttons[i] selectItemAtIndex:1];
        } else {
            buttons[i].menu.itemArray[0].title=[path isEqualToString:@"Not Selected"] ? PrefsLocalized(@"Not Selected") : [[NSFileManager.defaultManager displayNameAtPath:path] lastPathComponent];
            [buttons[i] selectItemAtIndex:0];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{ [self switchTabWithIndex:0]; });
}
- (void)observeValueForKeyPath:(NSString *)key ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([key isEqualToString:@"qualityOfScreenshot"]) {
        NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
        [defaults setBool:[defaults objectForKey:@"qualityOfScreenshot"] && [change[@"new"] intValue]==1 forKey:@"nomalQualityImage"];
        [NSUserDefaults.standardUserDefaults synchronize];
    } else if([key isEqualToString:@"dicOfShortCutKey"]) {
        IShotFunction_100047ffc([@"TelliShotHelperToRegisterAllHotKey:" stringByAppendingString:IShotFunction_10004ab58(change[@"new"])]);
    } else if([key isEqualToString:@"widthOfPresetAreaSizeScreenshots"] || [key isEqualToString:@"heightOfPresetAreaSizeScreenshots"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *value=[[change[@"new"] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet]] componentsJoinedByString:@""];
            [NSUserDefaults.standardUserDefaults setObject:value forKey:key]; [NSUserDefaults.standardUserDefaults synchronize];
        });
    } else if([key isEqualToString:@"pathofSaveScreenShotsPhoto"] || [key isEqualToString:@"pathofSaveVideo"] || [key isEqualToString:@"pathofSaveAudio"]) [self checkAllOpenSavePath];
}
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)editor { return [editor.string rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet].location!=NSNotFound; }
- (NSInteger)collectionView:(NSCollectionView *)view numberOfItemsInSection:(NSInteger)section { return [[NSUserDefaults.standardUserDefaults objectForKey:@"arrOfDisplayModelWithShell"] count]; }
- (NSCollectionViewItem *)collectionView:(NSCollectionView *)view itemForRepresentedObjectAtIndexPath:(NSIndexPath *)path {
    CollectionViewItem *item=[[CollectionViewItem alloc] init];
    item.title=[NSUserDefaults.standardUserDefaults objectForKey:@"arrOfDisplayModelWithShell"][path.item][@"Name"]; return item;
}
// 0x1000c0784 is a genuine return-only original IMP.
- (void)shortcutRecorderWillBegin {}
- (CGFloat)tableView:(NSTableView *)view heightOfRow:(NSInteger)row { return view==_ScreenShotShortcutTableView?20:view==_AnnotatedShortcutTableView?23:25; }
- (NSInteger)numberOfRowsInTableView:(NSTableView *)view { return view==_ScreenShotShortcutTableView?IShotGlobal_1001de2b0.count:view==_AnnotatedShortcutTableView?IShotGlobal_1001de2a8.count:0; }
- (NSView *)tableView:(NSTableView *)view viewForTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    if(view==_ScreenShotShortcutTableView) return [self tableViewForScreenShotShortcut:column row:row];
    if(view==_AnnotatedShortcutTableView) return [self tableViewForAnnotatedShortcut:column row:row]; return nil;
}
- (NSView *)tableViewForScreenShotShortcut:(NSTableColumn *)column row:(NSInteger)row {
    NSView *view=[[NSView alloc] initWithFrame:NSMakeRect(0,0,150,20)];
    NSDictionary *shortcuts=[NSUserDefaults.standardUserDefaults objectForKey:@"dicOfShortCutKey"];
    NSDictionary *item=IShotGlobal_1001de2b0[row]; NSString *name=item[@"Name"],*identifier=item[@"ID"];
    NSDictionary *shortcut=shortcuts[identifier];
    if([column.identifier isEqualToString:@"ScreenshotType"]) {
        if(name) [view addSubview:[self creatNSTextFieldWithStringValue:PrefsLocalized(name) isEditable:NO atRow:row]];
    } else if([column.identifier isEqualToString:@"ShortKey"]) {
        if(identifier) {
            SRRecorderControlWithTagid *recorder=[[SRRecorderControlWithTagid alloc] initWithFrame:NSMakeRect(0,0,140,20)];
            recorder.delegate=self; recorder.tagid=row; recorder.identifier=identifier; [recorder centerYInSuperview]; recorder.wantsLayer=YES; recorder.layer.cornerRadius=6;
            NSAppearance *appearance=recorder.effectiveAppearance; NSColor *color=NSColor.blackColor;
            if(@available(macOS 10.14,*)) if([appearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua,NSAppearanceNameAqua]]==NSAppearanceNameDarkAqua) color=NSColor.whiteColor;
            recorder.layer.backgroundColor=[color colorWithAlphaComponent:.08].CGColor;
            [recorder setAllowedModifierFlags:0x1e0000 requiredModifierFlags:0 allowsEmptyModifierFlags:YES];
            NSInteger key=[shortcut[@"keyCode"] integerValue];
            NSInteger flags=[shortcut[@"modifierFlags"] integerValue];
            if(flags>0 || IShotFunction_100049f34(key)) recorder.objectValue=@{@"keyCode":@(key),@"modifierFlags":@(flags)};
            recorder.translatesAutoresizingMaskIntoConstraints=YES; [view addSubview:recorder];
        }
    } else if([column.identifier isEqualToString:@"Preferences"]) {
        if([name isEqualToString:@"Screenshot (Standard Mode)"]) { [helperOfScreenshotStandardMode centerYInSuperview]; [view addSubview:helperOfScreenshotStandardMode]; }
        NSView *control=nil; BOOL matched=YES;
        if([name isEqualToString:@"Delay full screen screenshot"]) control=popupButtonOftimeOfDelayScreenshots;
        else if([name isEqualToString:@"Screenshot previous area"]) control=helperOfScreenshotPreviousArea;
        else if([name isEqualToString:@"Screenshot window under cursor"]) control=helperOfScreenshotWindowUnderCursor;
        else if([name isEqualToString:@"Screenshot with shell"]) control=helperOfScreenshotWithShell;
        else if([name isEqualToString:@"Multi window screenshot"]) control=helperOfMultiWindowScreenshot;
        else if([name isEqualToString:@"Scroll screenshot"]) control=helperOfScrollScreenshot;
        else if([name isEqualToString:@"Screenshot (Performance Mode)"]) control=helperOfScreenshotPerformanceMode;
        else if([name isEqualToString:@"Screenshot Preset Area Size"]) control=boxOfPresetAreaSizeScreenshots;
        else matched=NO;
        if(matched){ [control centerYInSuperview]; [view addSubview:control]; }
    }
    return view;
}
- (NSView *)tableViewForAnnotatedShortcut:(NSTableColumn *)column row:(NSInteger)row {
    NSView *view=[[NSView alloc] initWithFrame:NSMakeRect(0,-1,150,25)]; NSString *name=IShotGlobal_1001de2a8[row];
    if([column.identifier isEqualToString:@"Icon"]) {
        NSString *icon;
        if([name isEqualToString:@"Pencil"]) icon=@"pencilPen";
        else if([name isEqualToString:@"Scroll Screenshot"]) icon=@"scroll";
        else if([name isEqualToString:@"Pin"]) icon=@"map";
        else if([name isEqualToString:@"Save to Clipboard"]) icon=@"paste";
        else if([name isEqualToString:@"Save as ..."]) icon=@"saveAs";
        else if([name isEqualToString:@"OCR"]) icon=name;
        else icon=name.lowercaseString;
        NSImageView *image=[[NSImageView alloc] initWithFrame:NSMakeRect(7,4,16,16)]; image.image=[NSImage imageNamed:[icon stringByAppendingString:@"_on"]]; [view addSubview:image];
    } else if([column.identifier isEqualToString:@"Name"]) {
        NSView *field=[self creatNSTextFieldWithStringValue:PrefsLocalized(name) isEditable:NO atRow:row]; [field setFrameOrigin:NSZeroPoint]; [view addSubview:field];
    } else if([column.identifier isEqualToString:@"ShortKey"]) {
        NSString *fixed=nil;
        if([name isEqualToString:@"Copy"]) fixed=@"⌘ + C";
        else if([name isEqualToString:@"Save as ..."]) fixed=@"⌘ + S";
        else if([name isEqualToString:@"Undo"]) fixed=@"⌘ + Z";
        else if([name isEqualToString:@"Redo"]) fixed=@"⇧ + ⌘ + Z";
        else if([name isEqualToString:@"Cancel"]) fixed=@"ESC";
        if(fixed){ NSView *field=[self creatNSTextFieldWithStringValue:fixed isEditable:NO atRow:row]; [field setFrameOrigin:NSMakePoint(2,0)]; [view addSubview:field]; }
        else {
            NSPopUpButton *button=nil;
            if([name isEqualToString:@"Square"]) button=popupButtonOfSquare;
            else if([name isEqualToString:@"Ellipse"]) button=popupButtonOfEllipse;
            else if([name isEqualToString:@"Line"]) button=popupButtonOfLine;
            else if([name isEqualToString:@"Arrow"]) button=popupButtonOfArrow;
            else if([name isEqualToString:@"Pencil"]) button=popupButtonOfPencil;
            else if([name isEqualToString:@"Mosaic"]) button=popupButtonOfMosaic;
            else if([name isEqualToString:@"Text"]) button=popupButtonOfText;
            else if([name isEqualToString:@"Note"]) button=popupButtonOfNote;
            else if([name isEqualToString:@"Highlight"]) button=popupButtonOfHighlight;
            else if([name isEqualToString:@"Pin"]) button=popupButtonOfPin;
            else if([name isEqualToString:@"OCR"]) button=popupButtonOfOCR;
            else if([name isEqualToString:@"Scroll Screenshot"]) button=popupButtonOfScrollScreenshot;
            else if([name isEqualToString:@"Save"]) button=popupButtonOfSave;
            else if([name isEqualToString:@"Save to Clipboard"]) button=popupButtonOfPaste;
            if(button){ [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleNSPopUpButtonWillPopUpNotification:) name:NSPopUpButtonWillPopUpNotification object:button]; [button setFrameOrigin:NSMakePoint(0,1)]; [view addSubview:button]; }
        }
    } return view;
}
- (BOOL)tableView:(NSTableView *)table shouldSelectRow:(NSInteger)row { return YES; }
- (void)handleNSPopUpButtonWillPopUpNotification:(NSNotification *)notification {
    NSPopUpButton *button=notification.object; button.autoenablesItems=NO;
    NSArray *items=button.itemArray;
    for(NSMenuItem *item in items) {
        NSString *title=item.title; item.enabled=YES;
        for(NSString *key in IShotGlobal_1001de130) {
            NSString *assigned=[NSUserDefaults.standardUserDefaults objectForKey:key];
            if(![title isEqualToString:button.titleOfSelectedItem] && [title isEqualToString:assigned]) item.enabled=NO;
        }
    }
}
- (BOOL)shortcutRecorder:(SRRecorderControl *)recorder shouldUnconditionallyAllowModifierFlags:(NSUInteger)flags forKeyCode:(unsigned short)code {
    if((recorder.requiredModifierFlags & flags)==recorder.requiredModifierFlags && (flags & ~recorder.allowedModifierFlags)==0) return IShotFunction_100049f34(code);
    return NO;
}
- (void)shortcutRecorderDidEndRecording:(SRRecorderControl *)recorder {
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSMutableDictionary *shortcuts=[NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"dicOfShortCutKey"]];
    NSString *identifier=recorder.identifier; PTHotKeyCenter *center=PTHotKeyCenter.sharedCenter;
    PTHotKey *previous=[center hotKeyWithIdentifier:identifier]; if(previous) [center unregisterHotKey:previous];
    NSDictionary *shortcut=recorder.objectValue; NSInteger flags=[shortcut[@"modifierFlags"] integerValue];
    BOOL special=NO;
    if(@available(macOS 15.0,*)) { if(@available(macOS 15.3,*)) {} else special=YES; }
    if(special && flags==0xa0000) NSBeep();
    else {
        if(special && flags==0x80000) {
            if(!AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)@{(__bridge NSString *)kAXTrustedCheckOptionPrompt:@NO})) {
                recorder.objectValue=shortcuts[identifier]; [Global popupRequestPrivacyAccessibilityWithQuit:NO]; return;
            }
            [AppDelegate.appDelegate startCGEventListen];
        }
        if(!shortcut || (id)shortcut==NSNull.null) [shortcuts removeObjectForKey:identifier];
        else {
            PTHotKey *hotkey=[PTHotKey hotKeyWithIdentifier:identifier keyCombo:shortcut target:self action:@selector(HotKeyAction:)];
            [shortcuts setObject:shortcut forKey:identifier]; [center registerHotKey:hotkey];
        }
        [defaults setObject:shortcuts forKey:@"dicOfShortCutKey"]; [defaults synchronize];
    }
    [_ScreenShotShortcutTableView reloadData];
}
- (void)HotKeyAction:(id)sender { [AppDelegate.appDelegate hotKeyAction:sender]; }
- (void)selectAppNameToOpen:(id)sender {
    NSOpenPanel *panel=NSOpenPanel.openPanel; panel.canChooseFiles=YES; panel.allowsMultipleSelection=NO;
    panel.allowedFileTypes=@[@"app"]; panel.directoryURL=[NSURL fileURLWithPath:@"/Applications"];
    panel.message=PrefsLocalized(@"⚠️Select the app name to open the screenshot, select Finder to open the path"); panel.prompt=PrefsLocalized(@"OK"); panel.treatsFilePackagesAsDirectories=NO;
    [panel beginWithCompletionHandler:^(NSModalResponse response){
        if(response!=1) return;
        NSDictionary *info=[NSDictionary dictionaryWithContentsOfFile:[panel.URLs.firstObject.path stringByAppendingString:@"/Contents/Info.plist"]];
        if(!info) NSBeep();
        else {
            NSString *identifier=info[@"CFBundleIdentifier"],*executable=info[@"CFBundleExecutable"];
            [NSUserDefaults.standardUserDefaults setObject:@{@"bundleIdentifier":identifier,@"executableName":executable} forKey:@"appOfUserSpecified"];
            NSImage *icon=[NSWorkspace.sharedWorkspace iconForFile:[NSWorkspace.sharedWorkspace absolutePathForAppBundleWithIdentifier:identifier]];
            self.selectedAppName.image=[[NSImage alloc] initWithCGImage:[icon CGImageForProposedRect:NULL context:nil hints:nil] size:NSZeroSize];
        }
    }];
}
- (void)adjustSizeOfShadow:(id)sender { [NSUserDefaults.standardUserDefaults setObject:@((int)((double)[sender floatValue]+0.5)) forKey:@"sizeOfShadow"]; [NSUserDefaults.standardUserDefaults synchronize]; }
- (void)adjustSizeOfFillet:(id)sender { [NSUserDefaults.standardUserDefaults setObject:@((int)((double)[sender floatValue]+0.5)) forKey:@"sizeOfImageFillet"]; [NSUserDefaults.standardUserDefaults synchronize]; }
- (void)adjustPinSizeOfFillet:(id)sender { [NSUserDefaults.standardUserDefaults setObject:@((int)((double)[sender floatValue]+0.5)) forKey:@"sizeOfPinFillet"]; [NSUserDefaults.standardUserDefaults synchronize]; }
- (void)adjustDefaultTransparencyOfPin:(id)sender { [NSUserDefaults.standardUserDefaults setObject:@((int)((double)[sender floatValue]+0.5)) forKey:@"defaultTransparencyOfPin"]; [NSUserDefaults.standardUserDefaults synchronize]; }
- (void)tryToScreenShotWithShell:(id)sender { [AppDelegate.appDelegate screenShotWithShell]; }
- (void)resumeSavePath:(NSMenuItem *)sender {
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    if([sender.menu.identifier isEqualToString:@"SaveImagePath"]) [defaults setObject:[defaults stringForKey:@"oldPathofSaveScreenShotsPhoto"] forKey:@"pathofSaveScreenShotsPhoto"];
    else if([sender.menu.identifier isEqualToString:@"SaveVideoPath"]) [defaults setObject:[defaults stringForKey:@"oldPathofSaveVideo"] forKey:@"pathofSaveVideo"];
    else if([sender.menu.identifier isEqualToString:@"SaveAudioPath"]) [defaults setObject:[defaults stringForKey:@"oldPathofSaveAudio"] forKey:@"pathofSaveAudio"];
    [defaults synchronize];
}
- (void)selectSavePath:(NSMenuItem *)sender {
    NSOpenPanel *panel=NSOpenPanel.openPanel; panel.canChooseDirectories=YES; panel.canCreateDirectories=YES; panel.canChooseFiles=NO;
    panel.directoryURL=[NSURL fileURLWithPath:NSSearchPathForDirectoriesInDomains(12,1,YES)[0]];
    [panel beginWithCompletionHandler:^(NSModalResponse response){
        if(response!=1) return;
        NSString *path=panel.URLs.firstObject.path;
        [[AppSandboxFileAccess fileAccessWithMessage:@""] persistPermissionURL:panel.URLs.firstObject];
        NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
        NSPopUpButton *button=nil;
        if([sender.menu.identifier isEqualToString:@"SaveImagePath"]) { [defaults setObject:path forKey:@"pathofSaveScreenShotsPhoto"]; button=self.buttonOfSaveImagePath; }
        else if([sender.menu.identifier isEqualToString:@"SaveVideoPath"]) { [defaults setObject:path forKey:@"pathofSaveVideo"]; button=self.buttonOfSaveVideoPath; }
        else if([sender.menu.identifier isEqualToString:@"SaveAudioPath"]) { [defaults setObject:path forKey:@"pathofSaveAudio"]; button=self.buttonOfSaveAudioPath; }
        if(button){ button.menu.itemArray[0].title=[[NSFileManager.defaultManager displayNameAtPath:path] lastPathComponent]; [button selectItemAtIndex:0]; }
        [defaults synchronize];
    }];
}
- (void)selectPathWhenSavePath:(NSMenuItem *)sender {
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    if([sender.menu.identifier isEqualToString:@"SaveImagePath"]) [defaults setObject:@"Not Specified" forKey:@"pathofSaveScreenShotsPhoto"];
    else if([sender.menu.identifier isEqualToString:@"SaveVideoPath"]) [defaults setObject:@"Not Specified" forKey:@"pathofSaveVideo"];
    else if([sender.menu.identifier isEqualToString:@"SaveAudioPath"]) [defaults setObject:@"Not Specified" forKey:@"pathofSaveAudio"];
    [defaults synchronize];
}
- (void)resetCustomizePickColorString:(id)sender { [NSUserDefaults.standardUserDefaults setObject:@"[NSColor colorWithRed:_R/255.0 green:_G/255.0 blue:_B/255.0 alpha:1.0];" forKey:@"customizePickColorString"]; [NSUserDefaults.standardUserDefaults synchronize]; }
- (void)resetScreenShotShortcutTableView:(id)sender {
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSDictionary *original=[NSDictionary dictionaryWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"DefaultPreferences" withExtension:@"plist"]];
    [defaults setObject:original[@"dicOfShortCutKey"] forKey:@"dicOfShortCutKey"]; [defaults setObject:original[@"timeOfDelayScreenshots"] forKey:@"timeOfDelayScreenshots"];
    [defaults synchronize]; [_ScreenShotShortcutTableView reloadData]; [AppDelegate.appDelegate registerAllHotKey];
}
- (void)resetAnnotatedShortcutTableView:(id)sender {
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSDictionary *original=[NSDictionary dictionaryWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"DefaultPreferences" withExtension:@"plist"]];
    for(NSString *key in IShotGlobal_1001de130) [defaults setObject:original[key] forKey:key]; [defaults synchronize];
}
- (void)resetPinSetting:(id)sender {
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    [defaults setBool:NO forKey:@"showButtoninPinWindow"]; [defaults setBool:YES forKey:@"doubleClickToClosePin"]; [defaults setBool:NO forKey:@"pinnedToOneSpace"];
    [defaults setInteger:0 forKey:@"whenPinAction"]; [defaults setObject:@"8" forKey:@"sizeOfPinFillet"]; [defaults setInteger:0 forKey:@"defaultTransparencyOfPin"]; [defaults synchronize];
}
- (void)hideMenuBarIcon:(id)sender { IShotFunction_100047ffc([NSUserDefaults.standardUserDefaults boolForKey:@"hideMenuBarIcon"]?@"TelliShotHelperToHideMenuBarIcon":@"TelliShotHelperToShowMenuBarIcon"); }
- (void)switchTabWithIndex:(NSInteger)index { if(index>=0 && index<tabView.tabViewItems.count) [tabView selectTabViewItem:[tabView tabViewItemAtIndex:index]]; }
// 0x1000c33c4
- (void)rateOnAppStore:(id)sender { /* Removed Lite section. */ }
// 0x1000c342c
- (void)feedbackProblem:(id)sender { /* Removed Lite section. */ }
// 0x1000c3494
- (void)QQExchangeGroup:(id)sender { /* Removed Lite section. */ }
// 0x1000c34fc
- (void)gotoOfficialWebsite:(id)sender { /* Removed Lite section. */ }
// 0x1000c3564
- (void)helpOfRGBprofile:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/colorprofile.html"]]; }
// 0x1000c35cc
- (void)videoOfScreenshotStandardMode:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.yuque.com/qilinzi/better365/ddagbnxlipacyc1o"]]; }
// 0x1000c3634
- (void)videoOfScreenshotWindowUnderCursor:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/screenshotwindowundercursor.html"]]; }
// 0x1000c369c
- (void)videoOfScreenshotPreviousArea:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/screenshotpreviousarea.html"]]; }
// 0x1000c3704
- (void)videoOfScreenshotWithShell:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/screenshotwithshell.html"]]; }
// 0x1000c376c
// 0x1000c37d4
- (void)videoOfMultiWindowScreenshot:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/multiwindowscreenshot.html"]]; }
// 0x1000c383c
- (void)videoOfScrollScreenshot:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/scrollscreenshot.html"]]; }
// 0x1000c38a4
- (void)videoOfPinPicture:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/pinpicture.html"]]; }
// 0x1000c390c
- (void)videoOfPickColor:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/pickcolor.html"]]; }
// 0x1000c3974
- (void)videoOfRecordScreen:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/screenrecording.html"]]; }
// 0x1000c39dc
- (void)videoOfRecordAudio:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/recording.html"]]; }
// 0x1000c3a44
- (void)videoOfOCR:(id)sender { /* Removed Lite section. */ }
// 0x1000c3aac
- (void)FAQ:(id)sender { /* Removed Lite section. */ }
// 0x1000c3b14
- (void)allVideo:(id)sender { /* Removed Lite section. */ }
// 0x1000c3b7c
- (void)helperOfScreenshotPerformanceMode:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishotperformancemode.html"]]; }
// 0x1000c3be4
- (void)viewSettingsPermissions:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/authority.html"]]; }
- (void)buttonOfOpenSavePathClick:(NSButton *)sender {
    NSString *path=[NSUserDefaults.standardUserDefaults stringForKey:sender.identifier];
    [[AppSandboxFileAccess fileAccessWithMessage:@""] accessFilePath:path persistPermission:YES withBlock:^{ [NSWorkspace.sharedWorkspace openURL:[NSURL fileURLWithPath:path]]; }];
}
- (void)resetDefaults:(id)sender {
    NSAlert *alert=[[NSAlert alloc] init]; alert.messageText=PrefsLocalized(@"All setting parameters will be reseted!");
    [alert addButtonWithTitle:PrefsLocalized(@"OK")]; [alert addButtonWithTitle:PrefsLocalized(@"Cancel")];
    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse response){
        if(response==1000) {
            NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
            NSDictionary *dictionary=defaults.dictionaryRepresentation;
            for(NSString *key in dictionary) if(![key isEqualToString:@"receipt"]) [defaults removeObjectForKey:key];
            [defaults setObject:@"YES" forKey:@"needOpenPreferencesWindow"]; [defaults synchronize];
            IShotFunction_100047ffc(@"TelliShotHelperToShowMenuBarIcon"); IShotFunction_100047ffc(@"TelliShotHelperToNotAutoStartAtLogin"); [Global restart];
        }
    }];
}
- (NSTextField *)creatNSTextFieldWithStringValue:(NSString *)value isEditable:(BOOL)editable atRow:(NSInteger)row {
    NSTextField *field=[[NSTextField alloc] initWithFrame:NSMakeRect(0,-1,1000,20)];
    field.cell.wraps=NO; field.cell.scrollable=YES; field.bezeled=NO; field.drawsBackground=NO; field.bezelStyle=0; field.font=[NSFont systemFontOfSize:12]; field.stringValue=value;
    if(editable){ field.editable=YES; field.delegate=self; field.tag=row; } else field.editable=NO;
    field.translatesAutoresizingMaskIntoConstraints=YES; return field;
}
@end
