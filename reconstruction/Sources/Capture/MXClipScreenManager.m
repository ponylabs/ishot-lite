#import "MXClipScreenManager.h"
#import "CaptureDependencies.h"
#import "../Editor/AnnotatedImageController.h"
#import "../Imaging/Imaging.h"
#import <unistd.h>
#import <math.h>
extern CGImageRef IShotCGWindowListCreateImage(CGRect, CGWindowListOption, CGWindowID, CGWindowImageOption) __asm__("_CGWindowListCreateImage");
@interface Global : NSObject
+ (CGRect)calcuateRealRectFromIMageRef:(CGImageRef)image withOriginalRect:(CGRect)rect; // 0x10000d510
+ (void)screenCaptureOverMacOS15:(unsigned int)windowID withSize:(CGSize)size; // 0x1000119b4
@end
extern NSMutableArray *IShotGlobal_1001de148, *IShotGlobal_1001de138;
extern NSMutableDictionary *IShotGlobal_1001ddff8;
extern NSCursor *IShotGlobal_1001dddf8;
extern BOOL IShotGlobal_1001de181, IShotGlobal_1001de182;
extern NSString *IShotGlobal_1001ddfe0;
extern AnnotatedImageController *IShotGlobal_1001de160;
extern NSWindow *IShotGlobal_1001de0b8;
extern double IShotGlobal_1001ddcf8;
extern NSScreen *IShotGlobal_1001dde80;
static NSMutableArray *IShotMenuRects_1001f19e8;
static BOOL IShotCapturedFront_1001f19f0;

// Block 0x10005ed30. Floating-point reads, crop scale and size checked against ARM64 assembly.
static void IShotProcessCaptureWindows(NSMutableArray *windows, NSArray *heights, int required) {
    dispatch_async(dispatch_get_main_queue(), ^{ [NSApp activateIgnoringOtherApps:YES]; }); // 0x10005f2c4
    if (@available(macOS 100.0, *)) {
        NSLog(@"needScreenShotCount:%d", required);
        while (IShotGlobal_1001ddff8.count != (NSUInteger)(NSInteger)required) usleep(1000);
    }
    for (NSUInteger index = 0; index < windows.count; index++) {
        NSMutableDictionary *window = [NSMutableDictionary dictionaryWithDictionary:windows[index]];
        int layer = [window[@"kCGWindowLayer"] intValue];
        NSMutableDictionary *bounds = [NSMutableDictionary dictionaryWithDictionary:window[@"kCGWindowBounds"]];
        float x = [bounds[@"X"] floatValue], y = [bounds[@"Y"] floatValue];
        float width = [bounds[@"Width"] floatValue], height = [bounds[@"Height"] floatValue];
        (void)window[@"kCGWindowCGImageRef"];
        CGImageRef image;
        if (@available(macOS 100.0, *)) image = (__bridge CGImageRef)IShotGlobal_1001ddff8[window[@"kCGWindowNumber"]];
        else image = (__bridge CGImageRef)window[@"kCGWindowCGImageRef"];
        if (image) {
            NSImage *result;
            // Original checks Height on the window dictionary (not its bounds dictionary).
            if ((layer > 0 && layer != 24) || (layer == 0 && [heights containsObject:window[@"Height"]])) {
                CGRect adjusted = [Global calcuateRealRectFromIMageRef:image withOriginalRect:CGRectMake(x, y, width, height)];
                if (adjusted.size.width < 10 || adjusted.size.height < 10) continue;
                if (fabs(adjusted.size.width - width) <= 5 && fabs(adjusted.size.height - height) <= 5) {
                    result = [[NSImage alloc] initWithCGImage:image size:NSMakeSize(width, height)];
                } else {
                    bounds[@"X"] = @(adjusted.origin.x); bounds[@"Y"] = @(adjusted.origin.y);
                    bounds[@"Width"] = @(adjusted.size.width); bounds[@"Height"] = @(adjusted.size.height);
                    window[@"kCGWindowBounds"] = bounds;
                    double scale = (double)(float)((double)CGImageGetWidth(image) / (double)width);
                    CGImageRef cropped = CGImageCreateWithImageInRect(image, CGRectMake((adjusted.origin.x - x) * scale, (adjusted.origin.y - y) * scale, adjusted.size.width * scale, adjusted.size.height * scale));
                    if (cropped) {
                        result = [[NSImage alloc] initWithCGImage:cropped size:NSMakeSize(adjusted.size.width * scale, adjusted.size.height * scale)];
                        CFRelease(cropped);
                    }
                }
            } else result = [[NSImage alloc] initWithCGImage:image size:NSMakeSize(width, height)];
            if (result) {
                [window removeObjectForKey:@"kCGWindowCGImageRef"];
                window[@"KCGWindowImage"] = result;
            }
        }
        [IShotGlobal_1001de148 addObject:window];
    }
    [windows removeAllObjects];
}
@implementation MXClipScreenManager
// 0x10005da08, block 0x10005da48
+ (instancetype)sharedInstance {
    static MXClipScreenManager *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[MXClipScreenManager alloc] init];
        IShotGlobal_1001ddff8 = [NSMutableDictionary dictionaryWithCapacity:2];
    });
    return instance;
}
// 0x10005daa4
- (instancetype)init {
    if ((self = [super init])) {
        self.clipWindowControllerArray = [NSMutableArray array];
        self.isWorking = NO;
        NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(startScreenShots) name:@"StartScreenShots" object:nil suspensionBehavior:4];
        [center addObserver:self selector:@selector(cancelScreenShot) name:@"cancelScreenShot" object:nil suspensionBehavior:4];
        [center addObserver:self selector:@selector(refreshMosaicDrawRect) name:@"refreshMosaicDrawRect" object:nil suspensionBehavior:4];
        [center addObserver:self selector:@selector(scrollScreenShot) name:@"scrollScreenShot" object:nil suspensionBehavior:4];
        [center addObserver:self selector:@selector(disableTextView) name:@"disableTextView" object:nil suspensionBehavior:4];
        [center addObserver:self selector:@selector(refreshHighlightDrawRect) name:@"refreshHighlightDrawRect" object:nil suspensionBehavior:4];
        [center addObserver:self selector:@selector(startAnnotation) name:@"startAnnotation" object:nil suspensionBehavior:4];
    }
    return self;
}
// 0x10005dc3c
- (void)startCaptureFromPinAnnotate:(BOOL)fromPin {
    if (self.isWorking) return;
    self.isWorking = YES;
    if (!fromPin) [NSCursor hide];
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{ // 0x10005ece0
        while (self.isWorking) {
            if (IShotGlobal_1001dddf8) [IShotGlobal_1001dddf8 set];
            usleep(1000);
        }
    });
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IndicatorFieldWidth"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IndicatorFieldHeight"];
    IShotGlobal_1001dddf8 = [NSCursor crosshairCursor];
    [self clearClipWindowControllerArray];
    [IShotGlobal_1001de148 removeAllObjects];
    if (!IShotMenuRects_1001f19e8) IShotMenuRects_1001f19e8 = [NSMutableArray array];
    else [IShotMenuRects_1001f19e8 removeAllObjects];
    NSArray *windows = CFBridgingRelease(CGWindowListCopyWindowInfo(1, 0));
    NSMutableArray *heights = [NSMutableArray new], *widths = [NSMutableArray new];
    for (NSScreen *screen in [NSScreen screens]) {
        [heights addObject:@(screen.frame.size.height)];
        [widths addObject:@(screen.frame.size.width)];
    }
    IShotCapturedFront_1001f19f0 = NO;
    for (NSUInteger index = 0; index < windows.count; index++) {
        NSDictionary *window = windows[index];
        NSString *name = window[@"kCGWindowName"], *owner = window[@"kCGWindowOwnerName"];
        if ([window[@"kCGWindowLayer"] intValue] == 24 && [name isEqualToString:@"Menubar"] && ([owner isEqualToString:@"Window Server"] || [owner isEqualToString:@"WindowServer"])) {
            CGRect bounds;
            CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)window[@"kCGWindowBounds"], &bounds);
            [IShotMenuRects_1001f19e8 addObject:NSStringFromRect(bounds)];
        }
    }
    int required = 0;
    for (NSUInteger index = 0; index < windows.count; index++) {
        NSMutableDictionary *window = [NSMutableDictionary dictionaryWithDictionary:windows[index]];
        int layer = [window[@"kCGWindowLayer"] intValue];
        NSString *name = window[@"kCGWindowName"] ?: @"", *owner = window[@"kCGWindowOwnerName"] ?: @"";
        NSMutableDictionary *bounds = [NSMutableDictionary dictionaryWithDictionary:window[@"kCGWindowBounds"]];
        if ([name isEqualToString:@""] && [owner isEqualToString:@"DDMP"]) continue;
        if (layer == 3 && [owner isEqualToString:@"LyricsX"] && [heights containsObject:bounds[@"Height"]]) continue;
        if ([name isEqualToString:@"Cursor"] && ([owner isEqualToString:@"Window Server"] || [owner isEqualToString:@"WindowServer"])) continue;
        if (layer == 0 && [owner isEqualToString:@"HazeOver"] && [heights containsObject:bounds[@"Height"]]) continue;
        if (layer == 1000 && ([owner isEqualToString:@"TencentMeeting"] || [owner isEqualToString:@"腾讯会议"])) continue;
        if ([name isEqualToString:@"mappingWindowByiShot"]) {
            int x = [bounds[@"X"] intValue], y = [bounds[@"Y"] intValue], h = [bounds[@"Height"] intValue], w = [bounds[@"Width"] intValue];
            bounds[@"X"] = @(x + 6); bounds[@"Y"] = @(y + 6);
            bounds[@"Width"] = @(w - 12); bounds[@"Height"] = @(h - 12);
            window[@"kCGWindowBounds"] = bounds;
        }
        if (layer < 0 && ![name hasPrefix:@"Desktop Picture -"] && ![name hasPrefix:@"Wallpaper-"]) continue;
        if (IShotGlobal_1001de181) {
            if (layer < 1) [IShotGlobal_1001de148 addObject:window];
            continue;
        }
        if (layer >= 102) continue;
        CGRect rect;
        CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)bounds, &rect);
        BOOL intersectsMenu = NO;
        for (NSString *rectString in IShotMenuRects_1001f19e8) {
            if (CGRectContainsPoint(NSRectFromString(rectString), CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.5)))
                intersectsMenu |= ![name isEqualToString:@"Menubar"];
        }
        if (intersectsMenu) continue;
        unsigned int windowID = [window[@"kCGWindowNumber"] intValue];
        BOOL capture = NO;
        if (layer >= 0 && ![name isEqualToString:@"mappingWindowByiShot"] && !(layer == 24 && [name isEqualToString:@"Menubar"] && ([owner isEqualToString:@"Window Server"] || [owner isEqualToString:@"WindowServer"]))) {
            if (layer == 0) {
                if (!IShotCapturedFront_1001f19f0 && [[[NSRunningApplication runningApplicationWithProcessIdentifier:[window[@"kCGWindowOwnerPID"] intValue]] bundleIdentifier] isEqualToString:IShotGlobal_1001ddfe0]) {
                    if ([widths containsObject:bounds[@"Width"]] && [bounds[@"Height"] intValue] < 120) continue;
                    IShotCapturedFront_1001f19f0 = YES;
                    capture = YES;
                }
            } else if (layer > 0) capture = YES;
        }
        CGImageRef image = NULL;
        if (capture) {
            required++;
            if (@available(macOS 100.0, *)) [Global screenCaptureOverMacOS15:windowID withSize:rect.size];
            else image = IShotCGWindowListCreateImage(CGRectNull, 8, windowID, 1);
        }
        NSDictionary *record;
        if (image) {
            record = @{@"kCGWindowNumber":@(windowID), @"kCGWindowBounds":bounds, @"kCGWindowName":name, @"kCGWindowOwnerName":owner, @"kCGWindowLayer":@(layer), @"kCGWindowCGImageRef":(__bridge id)image};
            // The source retains the create result without a matching CGImageRelease here.
        } else record = @{@"kCGWindowNumber":@(windowID), @"kCGWindowBounds":bounds, @"kCGWindowName":name, @"kCGWindowOwnerName":owner, @"kCGWindowLayer":@(layer)};
        [IShotGlobal_1001de148 addObject:record];
    }
    if (!IShotGlobal_1001de182) {
        for (NSScreen *screen in [NSScreen screens]) {
            MXClipWindowController *controller = [[MXClipWindowController alloc] initWithDelegate:self];
            [controller startCaptureWithScreen:screen];
            [self.clipWindowControllerArray addObject:controller];
        }
    } else {
        NSScreen *screen = [NSScreen currentScreenForMouseLocation];
        MXClipWindowController *controller = [[MXClipWindowController alloc] initWithDelegate:self];
        [controller startCaptureWithScreen:screen];
        [self.clipWindowControllerArray addObject:controller];
    }
    NSMutableArray *copy = [IShotGlobal_1001de148 mutableCopy];
    [IShotGlobal_1001de148 removeAllObjects];
    dispatch_async(queue, ^{ IShotProcessCaptureWindows(copy, heights, required); });
}
// 0x10005f2d8
- (void)changeKeyWindowWithScreen:(NSScreen *)screen {
    for (MXClipWindowController *controller in self.clipWindowControllerArray)
        if ([[controller screen] isEqual:screen]) [[controller window] makeKeyAndOrderFront:nil];
}
// 0x10005f440
- (void)reset { self.isWorking = NO; [self clearClipWindowControllerArray]; }
// 0x10005f468, block 0x10005f584
- (void)clearClipWindowControllerArray {
    [IShotGlobal_1001de160 unregisterAllHotKey];
    if (IShotGlobal_1001de0b8) {
        [[IShotGlobal_1001de0b8 contentView] removeFromSuperview];
        [IShotGlobal_1001de0b8 close];
        IShotGlobal_1001de0b8 = nil;
    }
    IShotGlobal_1001ddcf8 = 0;
    [IShotGlobal_1001de148 removeAllObjects];
    [IShotGlobal_1001de138 removeAllObjects];
    if (self.clipWindowControllerArray.count) {
        [self.clipWindowControllerArray enumerateObjectsUsingBlock:^(MXClipWindowController *controller, NSUInteger index, BOOL *stop) {
            [controller setDelegate:nil];
            if ([[controller window] isVisible]) [[controller window] orderOut:nil];
        }];
        [self.clipWindowControllerArray removeAllObjects];
    }
}
- (void)clipWindowController:(id)controller {} // 0x10005f608 RET-only
// 0x10005f60c, block 0x10005f6c8
- (void)clipWindowControllerDidCancel:(id)controller {
    [self.clipWindowControllerArray enumerateObjectsUsingBlock:^(MXClipWindowController *item, NSUInteger index, BOOL *stop) {
        if (![item isEqual:controller]) [item endCapture];
    }];
    [self clearClipWindowControllerArray];
    self.isWorking = NO;
}
// 0x10005f708
- (void)startScreenShots {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id width = [defaults objectForKey:@"IndicatorFieldWidth"], height = [defaults objectForKey:@"IndicatorFieldHeight"];
    if (width && height) {
        [defaults setObject:width forKey:@"widthOfPresetAreaSizeScreenshots"];
        [defaults setObject:height forKey:@"heightOfPresetAreaSizeScreenshots"];
        [defaults synchronize];
    }
    for (MXClipWindowController *controller in self.clipWindowControllerArray) {
        NSScreen *screen = [controller screen];
        NSScreen *current = [NSScreen currentScreenForMouseLocation];
        if (IShotGlobal_1001dde80) current = IShotGlobal_1001dde80;
        if ([screen isEqual:current]) [controller startScreenShots];
    }
}
- (void)startAnnotation { // 0x10005f92c
    for (MXClipWindowController *controller in self.clipWindowControllerArray) [controller startAnnotation];
}
- (void)cancelScreenShot { // 0x10005fa1c
    for (MXClipWindowController *controller in self.clipWindowControllerArray) [controller endCapture];
    [self clearClipWindowControllerArray]; self.isWorking = NO;
}
- (void)refreshMosaicDrawRect { // 0x10005fb24
    for (MXClipWindowController *controller in self.clipWindowControllerArray)
        if ([[controller screen] isEqual:[NSScreen currentScreenForMouseLocation]]) [controller refreshMosaic];
}
- (void)refreshHighlightDrawRect { // 0x10005fc74
    for (MXClipWindowController *controller in self.clipWindowControllerArray)
        if ([[controller screen] isEqual:[NSScreen currentScreenForMouseLocation]]) [controller refreshHighlight];
}
- (void)scrollScreenShot { // 0x10005fdc4
    for (MXClipWindowController *controller in self.clipWindowControllerArray)
        if ([[controller screen] isEqual:[NSScreen currentScreenForMouseLocation]]) [controller scrollScreenShot];
}
- (void)disableTextView { // 0x10005ff14
    for (MXClipWindowController *controller in self.clipWindowControllerArray)
        if ([[controller screen] isEqual:[NSScreen currentScreenForMouseLocation]]) [controller disableTextView];
}
@end
