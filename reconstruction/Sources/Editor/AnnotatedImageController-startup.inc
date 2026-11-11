- (void)windowDidLoad { // 0x100078914; font-menu block 0x1000795a4
    [super windowDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFontManager *manager = NSFontManager.sharedFontManager;
        NSArray *families = manager.availableFontFamilies;
        NSString *selected = [NSUserDefaults.standardUserDefaults objectForKey:@"fontNameOfText"];
        for (NSString *family in families) {
            NSString *title = [manager localizedNameForFamily:family face:nil];
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title action:NULL keyEquivalent:@""];
            item.representedObject = family;
            [self.popUpButtonTextFont.menu addItem:item];
            if ([selected isEqualToString:family]) self.popUpButtonTextFont.title = title;
        }
        selected = [NSUserDefaults.standardUserDefaults objectForKey:@"fontNameOfNote"];
        for (NSString *family in families) {
            NSString *title = [manager localizedNameForFamily:family face:nil];
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title action:NULL keyEquivalent:@""];
            item.representedObject = family;
            [self.popUpButtonNoteFont.menu addItem:item];
            if ([selected isEqualToString:family]) self.popUpButtonNoteFont.title = title;
        }
    });
    self.backgroundImageWindow.level = 0x7fffffec;
    self.backgroundImageWindow.backgroundColor = NSColor.clearColor;
    IShotGlobal_1001f1a30 = [NSMutableArray new];
    IShotGlobal_1001de088 = YES;
    self.userCanceled = YES;
    IShotGlobal_1001de089 = NO;
    [self getUsersData];
    self.window.backgroundColor = NSColor.clearColor;
    self.window.alphaValue = 1.0;
    self.window.acceptsMouseMovedEvents = YES;
    if (@available(macOS 16.0, *)) {} else { self.window.collectionBehavior = 0x100; }
    self.window.movableByWindowBackground = NO;
    self.window.excludedFromWindowsMenu = YES;
    self.window.opaque = NO;
    self.window.hasShadow = NO;
    self.window.hidesOnDeactivate = NO;
    self.window.level = 0x7fffffee;
    self.window.restorable = NO;
    [self.window disableSnapshotRestoration];
    self.window.opaque = NO;
    self.window.acceptsMouseMovedEvents = YES;
    NSDistributedNotificationCenter *center = NSDistributedNotificationCenter.defaultCenter;
    [center addObserver:self selector:@selector(closeWindow) name:@"closeClipToolbarWindow" object:nil suspensionBehavior:4];
    [center addObserver:self selector:@selector(hiddenButton) name:@"hiddenButtonOfClipToolbarWindow" object:nil suspensionBehavior:4];
    [center addObserver:self selector:@selector(unhiddenButton) name:@"unhiddenButtonOfClipToolbarWindow" object:nil suspensionBehavior:4];
    if ([(NSView *)annotatedImageView frame].size.height == 0.0) [self.window orderOut:nil];
    else [self resetButtonBox];
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    if (![defaults boolForKey:@"selectedGaussianBlured"] && ![defaults boolForKey:@"selectedMosaic"]) [defaults setBool:YES forKey:@"selectedGaussianBlured"];
    if ([defaults boolForKey:@"selectedGaussianBlured"]) [defaults setBool:NO forKey:@"selectedMosaic"];
    if (![defaults boolForKey:@"ellipseOfHighlight"] && ![defaults boolForKey:@"squareOfHighlight"]) [defaults setBool:YES forKey:@"squareOfHighlight"];
    if ([defaults boolForKey:@"ellipseOfHighlight"]) [defaults setBool:NO forKey:@"squareOfHighlight"];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"selectedMosaic" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"selectedGaussianBlured" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"ellipseOfHighlight" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"squareOfHighlight" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"filledOfSquare" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"filledOfEllipse" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"enableRoundOfSquare" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"normalTypeOfArrow" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"typeIndexOfText" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"colorIndexOfText" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"typeIndexOfNote" options:1 context:NULL];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"colorIndexOfNote" options:1 context:NULL];
    CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), NULL, IShotFunction_100079980, CFSTR("com.apple.HIToolbox.endMenuTrackingNotification"), NULL, 4);
    [NSWorkspace.sharedWorkspace.notificationCenter addObserver:self selector:@selector(displayChanged:) name:nil object:nil];
    self.colorBox.hidden = YES;
    self.sanjiao.hidden = YES;
    self.buttonBox.hidden = YES;
    self.undoButton.enabled = NO;
    self.buttonBox.cornerRadius = 10.0;
    self.buttonBox.borderWidth = 0.3;
    [self updateToolbarBoxStyle];
    [self.window addObserver:self forKeyPath:@"effectiveAppearance" options:1 context:NULL];
    self.colorBox.borderColor = [NSColor.clearColor colorWithAlphaComponent:0.002];
    self.realColorBox.borderWidth = 0.3;
    self.boxSquare.hidden = YES;
    self.boxEllipse.hidden = YES;
    self.boxLine.hidden = YES;
    self.boxArrow.hidden = YES;
    self.boxPencil.hidden = YES;
    self.boxMosaic.hidden = YES;
    self.boxText.hidden = YES;
    self.boxNote.hidden = YES;
    self.boxHighlight.hidden = YES;
    self.boxUndo.hidden = YES;
    self.boxMap.hidden = YES;
    self.boxClear.hidden = YES;
    self.boxZoom.hidden = YES;
    self.boxCancel.hidden = YES;
    self.boxScrollScreenshot.hidden = YES;
    self.boxOCR.hidden = YES;
    self.boxSave.hidden = YES;
    self.boxCopyToPaste.hidden = YES;
    self.boxSelectMosaic.hidden = YES;
    self.boxSelectHighlight.hidden = YES;
}
- (void)getUsersData { // 0x10007e320
    NSDictionary *saved = [NSUserDefaults.standardUserDefaults dictionaryForKey:@"DataOfUsers"];
    if (saved) { IShotGlobal_1001de0c8 = [NSMutableDictionary dictionaryWithDictionary:saved]; return; }
    IShotGlobal_1001de0c8 = [NSMutableDictionary dictionaryWithCapacity:10];
    NSData *color = [NSKeyedArchiver archivedDataWithRootObject:NSColor.redColor];
    [IShotGlobal_1001de0c8 setObject:@{@"size": @3, @"color": color} forKey:@"square"];
    [IShotGlobal_1001de0c8 setObject:@{@"size": @3, @"color": color} forKey:@"ellipse"];
    [IShotGlobal_1001de0c8 setObject:@{@"size": @16, @"color": color} forKey:@"line"];
    [IShotGlobal_1001de0c8 setObject:@{@"size": @10, @"color": color} forKey:@"arrow"];
    [IShotGlobal_1001de0c8 setObject:@{@"size": @16, @"color": color} forKey:@"pencilPen"];
    [IShotGlobal_1001de0c8 setObject:@{@"size": @3, @"color": color} forKey:@"mosaic"];
    [IShotGlobal_1001de0c8 setObject:@{@"size": @18, @"color": color} forKey:@"text"];
    [IShotGlobal_1001de0c8 setObject:@{@"size": @18, @"color": color} forKey:@"note"];
    [IShotGlobal_1001de0c8 setObject:@{@"size": @3, @"color": color} forKey:@"highlight"];
}
- (void)updateToolbarBoxStyle { // 0x1000799b0
    NSArray *boxes = @[self.boxSquare, self.boxEllipse, self.boxLine, self.boxArrow, self.boxPencil, self.boxMosaic, self.boxSelectMosaic, self.boxSelectHighlight, self.boxText, self.boxNote, self.boxHighlight, self.boxOCR, self.boxUndo, self.boxMap, self.boxZoom, self.boxClear, self.boxCancel, self.boxScrollScreenshot, self.boxSave, self.boxCopyToPaste];
    [NSAppearance appearanceNamed:NSAppearanceNameDarkAqua];
    NSColor *fill, *text;
    if (@available(macOS 10.14, *)) {
        NSString *matched = [NSApp.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua, NSAppearanceNameAqua]];
        if (matched != NSAppearanceNameDarkAqua) { fill = NSColor.whiteColor; text = NSColor.blackColor; }
        else { fill = [NSColor colorWithRed:0.1411764705882353 green:0.1411764705882353 blue:0.1411764705882353 alpha:1.0]; text = NSColor.whiteColor; }
    } else { fill = NSColor.blackColor; text = NSColor.whiteColor; }
    for (NSBox *box in boxes) {
        box.cornerRadius = 10.0;
        box.borderColor = NSColor.grayColor;
        box.borderWidth = 0.3;
        box.fillColor = fill;
        [self setTextColor:text inView:box];
    }
}
- (void)closeWindow { // 0x100085db4; block 0x100086184
    [self.backgroundImageWindow orderOut:nil];
    for (NSView *view in IShotGlobal_1001f1a30) [view removeFromSuperview];
    [IShotGlobal_1001f1a30 removeAllObjects];
    IShotGlobal_1001de099 = NO;
    IShotGlobal_1001de0c2 = NO;
    IShotGlobal_1001ddfb8 = NO;
    IShotGlobal_1001ddd50 = NO;
    [IShotGlobal_1001dde88 removeAllObjects];
    if (IShotGlobal_1001de088 && IShotGlobal_1001de0c8) {
        [NSUserDefaults.standardUserDefaults setObject:IShotGlobal_1001de0c8 forKey:@"DataOfUsers"];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
    IShotGlobal_1001de088 = NO;
    IShotGlobal_1001de0c0 = NO;
    IShotGlobal_1001de090 = @"";
    IShotGlobal_1001dd440 = -1;
    [IShotGlobal_1001de058 removeAllObjects];
    [IShotGlobal_1001de050 removeAllObjects];
    [(NSView *)annotatedImageView setNeedsDisplay:YES];
    [self.window.contentView discardCursorRects];
    [self.window.contentView resetCursorRects];
    IShotGlobal_1001dddf8 = 0;
    [NSCursor.arrowCursor set];
    [self.window orderOut:nil];
    for (NSWindow *window in NSApp.windows) if (window.visible) break;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{ usleep(100000); IShotGlobal_1001de0d5 = NO; });
}
- (void)openWindow { // 0x1000862d4; all CGRect register transfers checked in ARM64 assembly
    if (!IShotGlobal_1001ddd50 && IShotGlobal_1001de138.count) {
        NSScreen *screen = NSScreen.currentScreenForMouseLocation;
        if (IShotGlobal_1001dde80) screen = IShotGlobal_1001dde80;
        CGRect frame = [(NSView *)annotatedImageView frame];
        frame.origin.x += screen.frame.origin.x;
        frame.origin.y += screen.frame.origin.y;
        [self.backgroundImageWindow setFrame:frame display:NO];
        self.backgroundImageWindow.backgroundColor = NSColor.whiteColor;
        [self.backgroundImageWindow orderFront:self];
        int shadowSize = [[NSUserDefaults.standardUserDefaults stringForKey:@"sizeOfShadow"] intValue];
        NSColor *shadowColor = [NSColor.shadowColor colorWithAlphaComponent:0.3];
        if (shadowSize > 0 && !IShotGlobal_1001ddd50) {
            NSData *data = [NSUserDefaults.standardUserDefaults objectForKey:@"colorOfShadow"];
            if (data) shadowColor = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = shadowColor;
        shadow.shadowBlurRadius = (double)shadowSize;
        for (NSInteger i = (NSInteger)IShotGlobal_1001de138.count - 1; i >= 0; --i) {
            NSDictionary *item = IShotGlobal_1001de138[i];
            CGRect rect = [item[@"rect"] rectValue];
            rect.origin.x -= [(NSView *)annotatedImageView frame].origin.x;
            rect.origin.y -= [(NSView *)annotatedImageView frame].origin.y;
            NSImage *image = item[@"KCGWindowImage"];
            if ([item[@"kCGWindowName"] isEqualToString:@"mappingWindowByiShot"]) {
                rect = NSInsetRect(rect, -6.0, -6.0);
                image.size = rect.size;
            }
            NSImageView *imageView = [[NSImageView alloc] initWithFrame:rect];
            if (![item[@"kCGWindowName"] isEqualToString:@"mappingWindowByiShot"] && shadowSize > 0) imageView.shadow = shadow;
            imageView.image = image;
            [self.backgroundImageWindow.contentView addSubview:imageView];
            [IShotGlobal_1001f1a30 addObject:imageView];
        }
    }
    NSString *title;
    if (!IShotGlobal_1001ddd50) {
        self.pasteButton.alternateImage = [NSImage imageNamed:@"paste_on"];
        title = @"Copy to Paste";
    } else {
        self.pasteButton.alternateImage = [NSImage imageNamed:@"refresh_on"];
        title = @"Update Map";
    }
    self.cpToPasteOrUpdateMapOfTextField.stringValue = [NSBundle.mainBundle localizedStringForKey:title value:@"" table:nil];
    IShotGlobal_1001de0c2 = NO;
    IShotGlobal_1001de0b0 = -1;
    IShotGlobal_1001de099 = NO;
    IShotGlobal_1001de0d5 = NO;
    IShotGlobal_1001de089 = NO;
    IShotGlobal_1001f1a44 = NO;
    IShotGlobal_1001de088 = YES;
    IShotGlobal_1001de0c0 = NO;
    IShotGlobal_1001de0d0 = NO;
    IShotGlobal_1001de0d6 = NO;
    IShotGlobal_1001de0d4 = NO;
    IShotGlobal_1001de0d2 = NO;
    [self resetButtonBox];
    IShotGlobal_1001de090 = @"";
    [self unhiddenButton];
    self.scrollScreenshotButton.enabled = YES;
    self.scrollScreenshotErrorWarnButton.hidden = YES;
    [self.window orderFront:self];
    if (IShotGlobal_1001de180) {
        self.OCRButton.alternateImage = [NSImage imageNamed:@"save_on"];
        self.mosaicButton.alternateImage = [NSImage imageNamed:@"zoom_on"];
        self.mapButton.alternateImage = [NSImage imageNamed:@"clear_on"];
        [self pencilButtonClick:self];
    } else {
        self.OCRButton.alternateImage = [NSImage imageNamed:@"OCR_on"];
        self.mosaicButton.alternateImage = [NSImage imageNamed:@"mosaic_on"];
        self.mapButton.alternateImage = [NSImage imageNamed:@"map_on"];
    }
}
- (void)resetButtonBox { // 0x10007a3f0; geometry REA ev_c7cb43695cfadaa7dd794f98f354aae1541a552ae8888b6aeb983c7d78dd42e0
    self.OCRButton.hidden = !IShotGlobal_1001de180; // Preserve the recording-mode Save button.
    self.scrollScreenshotButton.hidden = IShotGlobal_1001de0c0;
    BOOL dark = [self.window.effectiveAppearance.name isEqualToString:@"NSAppearanceNameDarkAqua"];
    double component = dark ? 0.1411764705882353 : 1.0;
    self.buttonBox.fillColor = [NSColor colorWithRed:component green:component blue:component alpha:1.0];
    self.realColorBox.fillColor = [NSColor colorWithRed:component green:component blue:component alpha:1.0];
    self.colorBox.fillColor = [NSColor colorWithRed:component green:component blue:component alpha:0.002];
    self.boxSelectMosaic.fillColor = [NSColor colorWithRed:component green:component blue:component alpha:1.0];
    self.boxSelectHighlight.fillColor = [NSColor colorWithRed:component green:component blue:component alpha:1.0];
    self.squareButton.image = [NSImage imageNamed:dark ? @"square_off" : @"squareDark_off"];
    self.ellipseButton.image = [NSImage imageNamed:dark ? @"ellipse_off" : @"ellipseDark_off"];
    self.lineButton.image = [NSImage imageNamed:dark ? @"line_off" : @"lineDark_off"];
    self.arrowButton.image = [NSImage imageNamed:dark ? @"arrow_off" : @"arrowDark_off"];
    self.pencilPenButton.image = [NSImage imageNamed:dark ? @"pencilPen_off" : @"pencilPenDark_off"];
    self.textButton.image = [NSImage imageNamed:dark ? @"text_off" : @"textDark_off"];
    self.noteButton.image = [NSImage imageNamed:dark ? @"note_off" : @"noteDark_off"];
    self.highlightButton.image = [NSImage imageNamed:dark ? @"highlight_off" : @"highlightDark_off"];
    if (dark) self.mapButton.image = [NSImage imageNamed:@"map_off"];
    if (IShotGlobal_1001de180) {
        self.OCRButton.image = [NSImage imageNamed:dark ? @"save_off" : @"saveDark_off"];
        if (dark) {
            self.mosaicButton.image = [NSImage imageNamed:@"zoom_off"];
            self.mapButton.image = [NSImage imageNamed:@"clear_off"];
        } else {
            self.mapButton.image = [NSImage imageNamed:@"clearDark_off"];
            self.mosaicButton.image = [NSImage imageNamed:@"zoomDark_off"];
        }
    } else {
        self.OCRButton.image = [NSImage imageNamed:dark ? @"OCR_off" : @"OCRDark_off"];
        if (dark) {
            self.mosaicButton.image = [NSImage imageNamed:@"mosaic_off"];
            self.mapButton.image = [NSImage imageNamed:@"map_off"];
        } else {
            self.mapButton.image = [NSImage imageNamed:@"mapDark_off"];
            self.mosaicButton.image = [NSImage imageNamed:@"mosaicDark_off"];
        }
    }
    self.scrollScreenshotButton.image = [NSImage imageNamed:dark ? @"scroll_off" : @"scrollDark_off"];
    self.undoButton.image = [NSImage imageNamed:dark ? @"undo_off" : @"undoDark_off"];
    self.cancelButton.image = [NSImage imageNamed:dark ? @"cancel_off" : @"cancelDark_off"];
    self.saveButton.image = [NSImage imageNamed:dark ? @"save_off" : @"saveDark_off"];
    self.pasteButton.image = [NSImage imageNamed:IShotGlobal_1001ddd50 ? (dark ? @"refresh_off" : @"refreshDark_off") : (dark ? @"paste_off" : @"pasteDark_off")];
    NSScreen *screen = NSScreen.currentScreenForMouseLocation;
    if (IShotGlobal_1001dde80) screen = IShotGlobal_1001dde80;
    self.buttonBox.layer.masksToBounds = YES;
    BOOL recording = IShotGlobal_1001de180;
    [self.buttonBox setFrameSize:NSMakeSize(recording ? 429.0 : 526.0, 40.0)];
    self.pasteLeftSideDistance.constant = recording ? -84.0 : 12.0;
    uint64_t width = (uint64_t)self.buttonBox.frame.size.width;
    CGRect target = [(NSView *)annotatedImageView frame];
    if (target.origin.y > 93.0) {
        IShotGlobal_1001f1a98 = (double)(int)(target.origin.x + target.size.width * 0.5 - (double)(width >> 1));
        IShotGlobal_1001f1aa0 = (double)((int)target.origin.y - 50);
        self.sanjiao.image = [NSImage imageNamed:@""];
    } else {
        float gap = (float)(screen.frame.size.height - (target.origin.y + target.size.height));
        CGRect notch = [Global currentScreenNotchRect];
        double y = 53.0;
        if (gap > 115.0f) y = (double)(int)(target.origin.y + target.size.height + 23.0 + 53.0);
        double x = (double)(int)(target.origin.x + target.size.width * 0.5 - (double)width * 0.5);
        CGRect box = CGRectMake(x, y, self.buttonBox.frame.size.width, self.buttonBox.frame.size.height);
        BOOL overlap = [Global checkRect:box OverlapWithRect:notch];
        IShotGlobal_1001f1a98 = x;
        IShotGlobal_1001f1aa0 = overlap ? 53.0 : y;
    }
    if (IShotGlobal_1001f1a98 < 0.0) IShotGlobal_1001f1a98 = 0.0;
    if (IShotGlobal_1001f1a98 + (double)width > screen.frame.size.width) IShotGlobal_1001f1a98 = screen.frame.size.width - (double)width;
    [self.buttonBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98, IShotGlobal_1001f1aa0)];
    self.colorBox.hidden = YES;
    self.sanjiao.hidden = YES;
    self.undoButton.enabled = NO;
    self.buttonBox.borderWidth = 0.3;
    self.colorBox.borderWidth = 0.3;
    self.scrollScreenshotButton.alternateImage = [NSImage imageNamed:@"scroll_on"];
    self.boxSquare.hidden = YES;
    self.boxEllipse.hidden = YES;
    self.boxLine.hidden = YES;
    self.boxArrow.hidden = YES;
    self.boxPencil.hidden = YES;
    self.boxMosaic.hidden = YES;
    self.boxText.hidden = YES;
    self.boxNote.hidden = YES;
    self.boxOCR.hidden = YES;
    self.boxHighlight.hidden = YES;
    self.boxUndo.hidden = YES;
    self.boxMap.hidden = YES;
    self.boxClear.hidden = YES;
    self.boxZoom.hidden = YES;
    self.boxCancel.hidden = YES;
    self.boxScrollScreenshot.hidden = YES;
    self.boxSave.hidden = YES;
    self.boxCopyToPaste.hidden = YES;
    self.boxSelectMosaic.hidden = YES;
    self.boxSelectHighlight.hidden = YES;
    IShotGlobal_1001f1a38 = @"";
    if (![IShotGlobal_1001de090 isEqualToString:@""] && IShotGlobal_1001de090) {
        if ([IShotGlobal_1001de090 isEqualToString:@"square"]) [self squareButtonClick:self];
        else if ([IShotGlobal_1001de090 isEqualToString:@"ellipse"]) [self ellipseButtonClick:self];
        else if ([IShotGlobal_1001de090 isEqualToString:@"line"]) [self lineButtonClick:self];
        else if ([IShotGlobal_1001de090 isEqualToString:@"arrow"]) [self arrowButtonClick:self];
        else if ([IShotGlobal_1001de090 isEqualToString:@"pencilPen"]) [self pencilButtonClick:self];
        else if ([IShotGlobal_1001de090 isEqualToString:@"mosaic"]) [self mosaicButtonClick:self];
        else if ([IShotGlobal_1001de090 isEqualToString:@"text"]) [self textButtonClick:self];
        else if ([IShotGlobal_1001de090 isEqualToString:@"note"]) [self noteButtonClick:self];
        else if ([IShotGlobal_1001de090 isEqualToString:@"highlight"]) [self highlightButtonClick:self];
    } else IShotGlobal_1001de090 = @"";
}
