#import "CustomScrollView.h"
#import "CustomView.h"
#import "../Global/Global.h"
#import "../Imaging/Imaging.h"
#import "../MainApplication/AppDelegate.h"
#import "../Capture/MXClipScreenManager.h"
#import <CoreServices/CoreServices.h>
extern NSMutableArray *IShotGlobal_1001ddcd0;
extern uint32_t IShotGlobal_1001ddd10;
extern NSScreen *IShotGlobal_1001dde80;
extern double IShotGlobal_1001ddd18, IShotGlobal_1001ddd20, IShotGlobal_1001ddd28, IShotGlobal_1001ddd30;
extern BOOL IShotGlobal_1001ddd50, IShotGlobal_1001ddfb8;
extern BOOL IShotFunction_10004c448(NSArray *names);
extern void IShotFunction_100047ffc(NSString *name);
NSSavePanel *IShotGlobal_1001ddfb0;
@implementation CustomScrollView
- (instancetype)init { self=[super init]; if (self) self.enableShadow=YES; return self; }
- (NSMenu *)menuForEvent:(NSEvent *)event {
    int maxScale=400;
    for (CustomView *view in IShotGlobal_1001ddcd0) {
        if ([view isEqual:self.window.contentView]) {
            IShotGlobal_1001ddd10=(uint32_t)view.window.windowNumber; maxScale=view.maxImageScale;
        }
    }
    NSMenu *menu=[[NSMenu alloc] init];
    [menu insertItemWithTitle:NSLocalizedString(@"Copy",@"") action:@selector(saveToPaste:) keyEquivalent:@"c" atIndex:0];
    [menu insertItemWithTitle:NSLocalizedString(@"Save to Library",@"") action:@selector(saveToLibrary:) keyEquivalent:@"s" atIndex:1];
    [menu insertItemWithTitle:NSLocalizedString(@"Save As...",@"") action:@selector(saveAs:) keyEquivalent:@"S" atIndex:2];
    [menu insertItemWithTitle:NSLocalizedString(@"Open File From...",@"") action:@selector(openFileFrom:) keyEquivalent:@"o" atIndex:3];
    [menu insertItem:NSMenuItem.separatorItem atIndex:4];
    NSMenuItem *item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Annotate",@"") action:@selector(annotate:) keyEquivalent:@" "];
    item.keyEquivalentModifierMask=0; [menu addItem:item];
    item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Cancel Shadow",@"") action:@selector(cancelShadow:) keyEquivalent:@"h"];
    item.keyEquivalentModifierMask=0; item.state=self.enableShadow^1; [menu addItem:item];
    [menu insertItem:NSMenuItem.separatorItem atIndex:6];
    item=[[NSMenuItem alloc] initWithTitle:@"50%" action:@selector(scaleImageTo50:) keyEquivalent:@"0"];
    item.keyEquivalentModifierMask=0; [menu addItem:item];
    item=[[NSMenuItem alloc] initWithTitle:@"100%" action:@selector(scaleImageTo100:) keyEquivalent:@"1"];
    item.keyEquivalentModifierMask=0; [menu addItem:item];
    item=[[NSMenuItem alloc] init]; item.title=@"200%";
    if (maxScale>100) item.action=@selector(scaleImageTo200:);
    item.keyEquivalent=@"2"; item.keyEquivalentModifierMask=0; [menu addItem:item];
    item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Move Left One Pixel",@"") action:@selector(moveLeftOnePixel:) keyEquivalent:@"←"];
    item.keyEquivalentModifierMask=0;
    [menu addItem:item];
    item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Move Right One Pixel",@"") action:@selector(moveRightOnePixel:) keyEquivalent:@"→"];
    item.keyEquivalentModifierMask=0;
    [menu addItem:item];
    item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Move Up One Pixel",@"") action:@selector(moveUpOnePixel:) keyEquivalent:@"↑"];
    item.keyEquivalentModifierMask=0;
    [menu addItem:item];
    item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Move Down One Pixel",@"") action:@selector(moveDownOnePixel:) keyEquivalent:@"↓"];
    item.keyEquivalentModifierMask=0;
    [menu addItem:item];
    item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Turn Left",@"") action:@selector(turnLeft:) keyEquivalent:@"←"];
    [menu addItem:item];
    item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Turn Right",@"") action:@selector(turnRight:) keyEquivalent:@"→"];
    [menu addItem:item];
    item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Horizontal Flip",@"") action:@selector(horizontalFlip:) keyEquivalent:@"↑"];
    [menu addItem:item];
    item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Vertically Flip",@"") action:@selector(verticallyFlip:) keyEquivalent:@"↓"];
    [menu addItem:item];
    [menu insertItem:NSMenuItem.separatorItem atIndex:19];
    [menu insertItemWithTitle:NSLocalizedString(@"Close",@"") action:@selector(close:) keyEquivalent:@"w" atIndex:20];
    [menu insertItemWithTitle:NSLocalizedString(@"Close All",@"") action:@selector(closeAll:) keyEquivalent:@"W" atIndex:21];
    item=[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Hidden/Show All Pin Window",@"") action:@selector(hiddenOrShowAllPinWindow:) keyEquivalent:@"2"];
    item.keyEquivalentModifierMask=0;
    NSDictionary *keys=[NSUserDefaults.standardUserDefaults objectForKey:@"dicOfShortCutKey"];
    item.keyEquivalentModifierMask=[keys[@"hiddenAndShowAllPinWindowRecorder"][@"modifierFlags"] unsignedIntegerValue];
    NSString *characters=keys[@"hiddenAndShowAllPinWindowRecorder"][@"charactersIgnoringModifiers"];
    if (characters) item.keyEquivalent=characters;
    [menu addItem:item]; return menu;
}
- (void)saveToLibrary:(id)sender {
    for (CustomView *view in IShotGlobal_1001ddcd0)
        if ([view isEqual:self.window.contentView]) { [[AppDelegate appDelegate] savePinImageToTempDirectory:view.image]; return; }
}
- (void)saveToPaste:(id)sender {
    for (CustomView *view in IShotGlobal_1001ddcd0)
        if ([view isEqual:self.window.contentView]) { IShotGlobal_1001dde80=self.window.screen; [NSImage saveImageToPaste:view.image]; break; }
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"playSoundWhenScreenShots"]) IShotFunction_100047ffc(@"TelliShotHelperToPlayScreenShotAudio");
}
- (void)cancelShadow:(id)sender {
    self.enableShadow^=1;
    NSString *description=self.window.contentView.description;
    for (CustomView *view in IShotGlobal_1001ddcd0) {
        if ([view.description isEqualToString:description]) {
            NSColor *color;
            if (!self.enableShadow) color=NSColor.clearColor;
            else if (view.window.keyWindow) color=[NSColor colorWithDeviceRed:0 green:(double).51f blue:(double).84f alpha:1];
            else color=[NSColor.shadowColor colorWithAlphaComponent:.5];
            view.mapImageView.image=[NSImage resizeImage:view.image scale:(float)(view.maxImageScale/100) addShadowWithColor:color]; return;
        }
    }
}
- (void)buttonPressed:(id)sender {
    NSString *extension;
    if ([sender indexOfSelectedItem]==0) { IShotGlobal_1001ddfb0.allowsOtherFileTypes=YES; extension=@"jpg"; }
    else { IShotGlobal_1001ddfb0.allowsOtherFileTypes=YES; extension=[sender indexOfSelectedItem]==1?@"png":@"tiff"; }
    IShotGlobal_1001ddfb0.allowedFileTypes=@[extension]; [IShotGlobal_1001ddfb0 validateVisibleColumns];
}
- (void)saveAs:(id)sender {
    IShotGlobal_1001ddfb0=NSSavePanel.savePanel;
    IShotGlobal_1001ddfb0.contentView.window.level=-1;
    dispatch_async(dispatch_get_main_queue(), ^{ IShotGlobal_1001ddfb0.contentView.window.level=26; });
    IShotGlobal_1001ddfb0.allowsOtherFileTypes=YES; IShotGlobal_1001ddfb0.allowedFileTypes=@[@"png"];
    IShotGlobal_1001ddfb0.title=NSLocalizedString(@"Save Image to File...",@"");
    NSFont *font=[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:0]];
    NSTextView *label=[[NSTextView alloc] initWithFrame:NSMakeRect(0,0,60,22)];
    label.font=font; label.editable=NO; label.drawsBackground=NO;
    label.horizontallyResizable=YES; label.verticallyResizable=YES; label.alignment=2;
    label.textColor=NSColor.secondaryLabelColor; label.string=NSLocalizedString(@"Format:",@"");
    NSPopUpButton *popup=[[NSPopUpButton alloc] initWithFrame:NSMakeRect(63,0,225,25) pullsDown:NO];
    [popup addItemWithTitle:NSLocalizedString(@"PNG",@"")]; [popup addItemWithTitle:NSLocalizedString(@"JPG",@"")]; [popup addItemWithTitle:NSLocalizedString(@"TIFF",@"")];
    popup.action=@selector(buttonPressed:); popup.target=self;
    NSView *accessory=[[NSView alloc] initWithFrame:NSMakeRect(-30,0,popup.frame.size.width+100,26)];
    [accessory addSubview:label]; [accessory addSubview:popup]; IShotGlobal_1001ddfb0.accessoryView=accessory;
    [IShotGlobal_1001ddfb0 beginWithCompletionHandler:^(NSModalResponse response) {
        if (response==1) {
            NSString *path=IShotGlobal_1001ddfb0.URL.path;
            NSBitmapImageFileType type=popup.indexOfSelectedItem==0?4:popup.indexOfSelectedItem==1?3:0;
            for (CustomView *view in IShotGlobal_1001ddcd0) {
                if ([view isEqual:self.window.contentView]) {
                    [NSImage saveImage:view.image toFile:path withType:type]; IShotGlobal_1001ddfb0=nil; break;
                }
            }
        }
    }];
}
- (void)openFileFrom:(id)sender {
    NSOpenPanel *panel=NSOpenPanel.openPanel;
    panel.canCreateDirectories=NO; panel.canChooseFiles=YES; panel.allowedFileTypes=NSImage.imageTypes;
    panel.allowsMultipleSelection=NO; panel.level=25;
    NSString *path=[NSUserDefaults.standardUserDefaults stringForKey:@"pathofSaveScreenShotsPhoto"];
    if (!path) path=[NSHomeDirectory() stringByAppendingString:@"/Desktop"];
    panel.directoryURL=[NSURL fileURLWithPath:path];
    [panel beginWithCompletionHandler:^(NSModalResponse response) {
        if (response==1) {
            NSData *data=[[NSData alloc] initWithContentsOfFile:panel.URLs.firstObject.path];
            NSImage *image=[[NSImage alloc] initWithData:data];
            image=[NSImage addRoundImgae:image withRadius:(float)[NSUserDefaults.standardUserDefaults integerForKey:@"sizeOfPinFillet"]];
            for (CustomView *view in IShotGlobal_1001ddcd0) {
                if ([view isEqual:self.window.contentView]) {
                    NSRect frame=NSMakeRect(self.window.frame.origin.x,self.window.frame.origin.y,image.size.width,image.size.height);
                    [self.window close]; [IShotGlobal_1001ddcd0 removeObject:view];
                    [Global pinToScreenWithImage:image rect:frame];
                    // Original block 0x10004eff8 re-adds the closed view.
                    [IShotGlobal_1001ddcd0 addObject:view]; break;
                }
            }
        }
    }];
}
- (void)annotate:(id)sender {
    IShotGlobal_1001ddd50=YES; IShotGlobal_1001ddfb8=YES;
    [[MXClipScreenManager sharedInstance] startCaptureFromPinAnnotate:YES];
    NSScreen *screen=[NSScreen currentScreenForMouseLocation]; IShotGlobal_1001dde80=screen;
    NSRect rect=self.window.frame;
    IShotGlobal_1001ddd18=rect.origin.x; IShotGlobal_1001ddd20=rect.origin.y;
    IShotGlobal_1001ddd28=rect.size.width; IShotGlobal_1001ddd30=rect.size.height;
    IShotGlobal_1001ddd18-=screen.frame.origin.x; IShotGlobal_1001ddd20-=screen.frame.origin.y;
    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"startAnnotation" object:nil userInfo:nil];
}
- (void)scaleImageTo50:(id)sender {
    NSString *description=self.window.contentView.description;
    for (CustomView *view in IShotGlobal_1001ddcd0)
        if ([view.description isEqualToString:description]) { [view scaleImageTo:.5f]; return; }
}
- (void)scaleImageTo100:(id)sender {
    NSString *description=self.window.contentView.description;
    for (CustomView *view in IShotGlobal_1001ddcd0)
        if ([view.description isEqualToString:description]) { [view scaleImageTo:1.f]; return; }
}
- (void)scaleImageTo200:(id)sender {
    NSString *description=self.window.contentView.description;
    for (CustomView *view in IShotGlobal_1001ddcd0)
        if ([view.description isEqualToString:description]) { [view scaleImageTo:2.f]; return; }
}
- (void)turnLeft:(id)sender {
    NSString *description=self.window.contentView.description;
    for (CustomView *view in IShotGlobal_1001ddcd0)
        if ([view.description isEqualToString:description]) { [view changeImage:@"turnLeft"]; return; }
}
- (void)turnRight:(id)sender {
    NSString *description=self.window.contentView.description;
    for (CustomView *view in IShotGlobal_1001ddcd0)
        if ([view.description isEqualToString:description]) { [view changeImage:@"turnRight"]; return; }
}
- (void)verticallyFlip:(id)sender {
    NSString *description=self.window.contentView.description;
    for (CustomView *view in IShotGlobal_1001ddcd0)
        if ([view.description isEqualToString:description]) { [view changeImage:@"UpDown"]; return; }
}
- (void)horizontalFlip:(id)sender {
    NSString *description=self.window.contentView.description;
    for (CustomView *view in IShotGlobal_1001ddcd0)
        if ([view.description isEqualToString:description]) { [view changeImage:@"LeftRight"]; return; }
}
- (void)moveLeftOnePixel:(id)sender { NSPoint point=self.window.frame.origin; point.x+=-1; [self.window setFrameOrigin:point]; }
- (void)moveRightOnePixel:(id)sender { NSPoint point=self.window.frame.origin; point.x+=1; [self.window setFrameOrigin:point]; }
- (void)moveUpOnePixel:(id)sender { NSPoint point=self.window.frame.origin; point.y+=1; [self.window setFrameOrigin:point]; }
- (void)moveDownOnePixel:(id)sender { NSPoint point=self.window.frame.origin; point.y+=-1; [self.window setFrameOrigin:point]; }
- (void)close:(id)sender {
    NSString *description=self.window.contentView.description;
    [self.window close];
    for (CustomView *view in IShotGlobal_1001ddcd0)
        if ([view.description isEqualToString:description]) { [IShotGlobal_1001ddcd0 removeObject:view]; return; }
}
- (void)closeAll:(id)sender {
    for (CustomView *view in IShotGlobal_1001ddcd0) [view.window close];
    [IShotGlobal_1001ddcd0 removeAllObjects];
}
- (void)hiddenOrShowAllPinWindow:(id)sender { [[AppDelegate appDelegate] hiddenOrShowAllPinWindow]; }
- (BOOL)mouseDownCanMoveWindow { return YES; }
- (void)mouseUp:(NSEvent *)event { [self.window.contentView mouseUp:event]; }
- (void)mouseDown:(NSEvent *)event { [self.window.contentView mouseDown:event]; }
- (void)scrollWheel:(NSEvent *)event { [self.window.contentView scrollWheel:event]; }
- (void)magnifyWithEvent:(NSEvent *)event { [super magnifyWithEvent:event]; }
- (void)touchesBegan:(id)touches withEvent:(id)event { NSLog(@"Event:%@",event); }
- (void)keyDown:(NSEvent *)event {
    int key=event.keyCode;
    if (IShotFunction_10004c448(@[@"CommandFn"])) {
        switch (key) {
            case 123:[self turnLeft:self];break;
            case 124:[self turnRight:self];break;
            case 125:[self verticallyFlip:self];break;
            case 126:[self horizontalFlip:self];break;
        }
    } else if (IShotFunction_10004c448(@[@"Command",@"Option",@"Control",@"Shift",@"Fn"])) {
        if (IShotFunction_10004c448(@[@"Command"])) {
            switch (key) {
                case 1:[self saveToLibrary:self];break;
                case 8:[self saveToPaste:self];break;
                case 13:[self close:self];break;
                case 31:[self openFileFrom:self];break;
            }
        } else if (IShotFunction_10004c448(@[@"Fn"])) {
            switch (key) {
                case 123:[self moveLeftOnePixel:self];break;
                case 124:[self moveRightOnePixel:self];break;
                case 125:[self moveDownOnePixel:self];break;
                case 126:[self moveUpOnePixel:self];break;
            }
        }
    } else {
        NSUInteger flags=event.modifierFlags&0x9e0000;
        if (!flags) {
            switch (key) {
                case 4:[self cancelShadow:self];break;
                case 18:[self scaleImageTo100:self];break;
                case 19:[self scaleImageTo200:self];break;
                case 29:[self scaleImageTo50:self];break;
            }
        } else if (flags==0x120000) {
            if (key==1) [self saveAs:self]; else if (key==13) [self closeAll:self];
        }
    }
}
- (NSBitmapImageRep *)unscaledBitmapImageRep:(NSImage *)image {
    NSBitmapImageRep *rep=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:(NSInteger)image.size.width pixelsHigh:(NSInteger)image.size.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    rep.size=image.size;
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext.currentContext=[NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
    [image drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:2 fraction:1];
    [NSGraphicsContext restoreGraphicsState]; return rep;
}
- (NSArray *)handlerApplicationsForFile:(NSString *)file {
    CFArrayRef urls=LSCopyApplicationURLsForURL((__bridge CFURLRef)[NSURL fileURLWithPath:file],0xffffffff);
    if (!urls) return @[];
    NSArray *applications=CFBridgingRelease(urls); NSMutableArray *paths=[NSMutableArray array];
    for (NSURL *url in applications) [paths addObject:url.path]; return paths;
}
@end
