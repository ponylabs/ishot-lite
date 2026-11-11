#import "MXRecordScreenWindowController.h"
#import "MXRecordScreenManager.h"
#import "CaptureWindowDependencies.h"
#import "../Common/CropBorderViewForRecordScreen.h"
#import "../MainApplication/AppDelegate.h"
#import "../Imaging/Imaging.h"
extern BOOL IShotGlobal_1001de210, IShotGlobal_1001ddd58, IShotGlobal_1001ddce8, IShotGlobal_1001de180, IShotGlobal_1001ddde0;
extern NSScreen *IShotGlobal_1001ddd60;
extern SGCaptureSession *IShotGlobal_1001dddb0;
extern KeyboardEventView *IShotGlobal_1001dddd8;
extern double IShotGlobal_1001ddd18, IShotGlobal_1001ddd20, IShotGlobal_1001ddd28, IShotGlobal_1001ddd30;
extern double IShotGlobal_1001dddb8, IShotGlobal_1001dddc0, IShotGlobal_1001dddc8, IShotGlobal_1001dddd0;
@implementation MXRecordScreenWindowController
// 0x100021e40
- (instancetype)initWithDelegate:(id)delegate {
    if ((self = [super init])) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hotKeyArr"];
        self.delegate = delegate;
        self.shadeWindows = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRecording:) name:@"SGVideoControllerBeginRecordingNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordScreenWindowControllerDidCancel:) name:@"RecordScreenWindowControllerDidCancel" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCamera:) name:@"RecordScreenWindowControllerOpenCamera" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeCamera:) name:@"RecordScreenWindowControllerCloseCamera" object:nil];
    }
    return self;
}
// 0x100021ff0
- (void)dealloc { [[NSDistributedNotificationCenter defaultCenter] removeObserver:self.videoControlsViewController name:@"RecordViewDidShowToolBar" object:nil]; }
// 0x10002208c, local event block 0x1000224dc and global event block 0x100022cdc.
- (void)startRecorderScreen:(NSScreen *)screen {
    IShotGlobal_1001de210 = NO;
    self.screen = screen;
    self.window = [[RecordScreenClipWindow alloc] initWithContentRect:screen.frame styleMask:0x80 backing:2 defer:NO screen:screen];
    self.window.backgroundColor = [[NSColor clearColor] colorWithAlphaComponent:0.001];
    [self.shadeWindows addObject:self.window];
    self.recordScreenClipView = [[RecordScreenClipView alloc] initWithFrame:NSMakeRect(0, 0, screen.frame.size.width, screen.frame.size.height) type:1];
    [self.recordScreenClipView setDelegate:self];
    self.recordScreenClipView.wantsLayer = YES;
    [self.recordScreenClipView setHaveSetClearColor:NO];
    self.window.contentView = self.recordScreenClipView;
    [self.window setFrame:screen.frame display:YES animate:NO];
    [self.window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    self.videoControlsViewController = [[SGVideoControlsViewController alloc] init];
    NSRect rect = NSMakeRect(0, 0, screen.frame.size.width, screen.frame.size.height);
    [self.recordScreenClipView showClipViewWithFrame:rect withToolbar:self.videoControlsViewController.view];
    self.currentWindowRect = rect;
    self.selectedScreen = screen;
    self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:0x144f handler:^NSEvent *(NSEvent *event) {
        if (event.type == 5) return nil;
        if (event.type == 10) {
            NSUInteger flags = NSApp.currentEvent.modifierFlags;
            if (event.keyCode == 0x35 || ((flags & 0x9e0000) == 0x100000 && event.keyCode == 0x0d)) {
                IShotGlobal_1001dddb0 = nil;
                if ([self.delegate respondsToSelector:@selector(recordScreenWindowControllerDidCancel:)]) [self.delegate recordScreenWindowControllerDidCancel:self];
                [[NSCursor arrowCursor] set];
                event = nil;
            }
            if (![self.window.firstResponder isKindOfClass:[NSTextView class]]) {
                if ((flags & 0x9e0000) == 0 && event.keyCode == 3 && [self.window.screen isEqual:[NSScreen currentScreenForMouseLocation]]) {
                    [self.recordScreenClipView recordFullScreen];
                    event = nil;
                }
            } else {
                unsigned short key = event.keyCode;
                if (key == 0x24) return nil;
                if (key == 0x33 || key == 0x35 || (key >= 0x7b && key < 0x7f)) return event;
                if (![@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"] containsObject:event.characters]) { NSBeep(); event = nil; }
            }
        } else if (event.type == 1) {
            if (![event.window.identifier isEqualToString:@"CameraWindow"] && !IShotGlobal_1001de210) {
                if (!IShotGlobal_1001ddd60) IShotGlobal_1001ddd60 = [NSScreen currentScreenForMouseLocation];
                if ([self.window.screen isEqual:IShotGlobal_1001ddd60]) [(RecordScreenClipView *)self.window.contentView mousedown:event];
            }
        } else if (event.type == 6) {
            if (![event.window.identifier isEqualToString:@"CameraWindow"] && [self.window.screen isEqual:IShotGlobal_1001ddd60]) [(RecordScreenClipView *)self.window.contentView mousedragged:event];
        } else if (event.type == 2) {
            if (![event.window.identifier isEqualToString:@"CameraWindow"] && !IShotGlobal_1001de210 && [self.window.screen isEqual:IShotGlobal_1001ddd60]) [(RecordScreenClipView *)self.window.contentView mouseup:event];
        } else if (event.type == 3 && [[NSUserDefaults standardUserDefaults] boolForKey:@"RightClickToExitScreenshot"]) {
            IShotGlobal_1001dddb0 = nil;
            if ([self.delegate respondsToSelector:@selector(recordScreenWindowControllerDidCancel:)]) [self.delegate recordScreenWindowControllerDidCancel:self];
            [[NSCursor arrowCursor] set];
        }
        return event;
    }];
    self.eventMonitorGlobal = [NSEvent addGlobalMonitorForEventsMatchingMask:0x40147e handler:^(NSEvent *event) {
        NSScreen *current = [NSScreen currentScreenForMouseLocation];
        if (event.type == 1) {
            if (!IShotGlobal_1001ddd60) IShotGlobal_1001ddd60 = [NSScreen currentScreenForMouseLocation];
            if ([self.window.screen isEqual:current]) {
                [(RecordScreenClipView *)self.window.contentView mousedown:event];
                [self.window orderFront:self];
                [NSApp activateIgnoringOtherApps:YES];
            }
        } else if (event.type == 6) {
            if ([self.window.screen isEqual:current]) [(RecordScreenClipView *)self.window.contentView mousedragged:event];
        } else if (event.type == 2) {
            if ([self.window.screen isEqual:current]) [(RecordScreenClipView *)self.window.contentView mouseup:event];
        } else if (event.type == 5) {
            if ([self.window.screen isEqual:current]) [self.window.contentView mouseMoved:event];
        } else if (event.type == 3 && [[NSUserDefaults standardUserDefaults] boolForKey:@"RightClickToExitScreenshot"]) {
            IShotGlobal_1001dddb0 = nil;
            if ([self.delegate respondsToSelector:@selector(recordScreenWindowControllerDidCancel:)]) [self.delegate recordScreenWindowControllerDidCancel:self];
            [[NSCursor arrowCursor] set];
        }
    }];
}
// 0x100023094: removeMonitor is called unconditionally, including nil tokens.
- (void)removeEventMonitor {
    [NSEvent removeMonitor:self.eventMonitor]; self.eventMonitor = nil;
    [NSEvent removeMonitor:self.eventMonitorGlobal]; self.eventMonitorGlobal = nil;
}
// 0x100023124
- (void)cleanup {
    [self.window resetCursorRects];
    IShotGlobal_1001ddd58 = NO; IShotGlobal_1001ddce8 = NO;
    if (IShotGlobal_1001de180) {
        IShotGlobal_1001de180 = NO;
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"cancelScreenShot" object:nil userInfo:nil];
    }
    if (self.window.isVisible) [self.window orderOut:nil];
    [self removeEventMonitor];
    self.recordScreenClipView = nil;
    [NSCursor unhide];
}
// 0x10002322c
- (void)clipViewMouseMoved:(id)sender {
    if (![self.recordScreenClipView haveSetClearColor]) {
        self.recordScreenClipView.layer.backgroundColor = [NSColor clearColor].CGColor;
        [self.recordScreenClipView setHaveSetClearColor:YES];
    }
    NSPoint point = [NSEvent mouseLocation];
    for (NSDictionary *window in [MXRecordScreenManager sharedInstance].arrayRect) {
        CGRect bounds;
        CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)window[(id)kCGWindowBounds], &bounds);
        CGRect rect = [SnipUtil cgWindowRectToScreenRect:bounds];
        if (CGRectContainsPoint(rect, point)) {
            NSScreen *current = [NSScreen currentScreenForMouseLocation];
            if (![current isEqual:self.screen]) [[MXRecordScreenManager sharedInstance] changeKeyWindowWithScreen:current];
            else if (!self.window.isKeyWindow) [self.window makeKeyAndOrderFront:nil];
            self.currentWindowRect = [self.window convertRectFromScreen:rect];
        }
        int layer = 0;
        CFNumberGetValue((__bridge CFNumberRef)window[(id)kCGWindowLayer], 3, &layer);
        if (layer >= 0 && [SnipUtil isPoint:point inRect:rect] && layer == 0) {
            NSScreen *current = [NSScreen currentScreenForMouseLocation];
            if (![current isEqual:self.screen]) [[MXRecordScreenManager sharedInstance] changeKeyWindowWithScreen:current];
            else if (!self.window.isKeyWindow) [self.window makeKeyAndOrderFront:nil];
            rect = [self.window convertRectFromScreen:rect];
            self.currentWindowRect = rect;
            IShotGlobal_1001ddd18 = rect.origin.x; IShotGlobal_1001ddd20 = rect.origin.y;
            IShotGlobal_1001ddd28 = rect.size.width; IShotGlobal_1001ddd30 = rect.size.height;
            break;
        }
    }
    if (self.currentWindowRect.origin.x < 0) {
        CGRect origin = self.currentWindowRect, size = self.currentWindowRect;
        self.currentWindowRect = CGRectMake(0, origin.origin.y, origin.origin.x + size.size.width, size.size.height);
    }
    if (self.currentWindowRect.origin.y < 0) {
        CGRect origin = self.currentWindowRect, size = self.currentWindowRect;
        self.currentWindowRect = CGRectMake(origin.origin.x, 0, size.size.width, origin.origin.y + size.size.height);
    }
    if (!NSEqualRects(self.currentWindowRect, self.lastWindowRect)) {
        [self.recordScreenClipView setFrameForContentView:self.currentWindowRect];
        [self.recordScreenClipView selectedWindowChanged];
        self.lastWindowRect = self.currentWindowRect;
    }
}
// 0x1000238a8
- (void)recordViewDidShowToolBar:(id)sender {
    if ([self.delegate respondsToSelector:@selector(recordScreenWindowControllerDidSelectRegion:)]) {
        [self.delegate recordScreenWindowControllerDidSelectRegion:self];
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"RecordViewDidShowToolBar" object:nil userInfo:nil];
    }
}
// 0x10002395c
- (void)startRecording:(id)sender {
    if (!IShotGlobal_1001dddb0 || ![self.window.screen isEqual:IShotGlobal_1001ddd60]) return;
    NSRect rect = NSInsetRect([[self.recordScreenClipView cropBorderViewForRecordScreen] frame], 6, 6);
    IShotGlobal_1001dddb8 = rect.origin.x; IShotGlobal_1001dddc0 = rect.origin.y;
    IShotGlobal_1001dddc8 = rect.size.width; IShotGlobal_1001dddd0 = rect.size.height;
    [[self.recordScreenClipView cropBorderViewForRecordScreen] removeFromSuperview];
    [[self.recordScreenClipView shapeLayer1] removeFromSuperlayer];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"displayKeyboardEventWhenRecording"]) {
        [self.shadeWindows enumerateObjectsUsingBlock:^(NSWindow *window, NSUInteger index, BOOL *stop) { [window setIgnoresMouseEvents:YES]; }]; // 0x100023f40
    } else {
        self.window.backgroundColor = [NSColor clearColor];
        IShotGlobal_1001dddd8 = [[KeyboardEventView alloc] initWithFrame:rect];
        [self.window.contentView addSubview:IShotGlobal_1001dddd8];
    }
    if ([self.delegate respondsToSelector:@selector(recordScreenWindowControllerRemoveEventMonitor:)]) [self.delegate recordScreenWindowControllerRemoveEventMonitor:self];
    if (IShotGlobal_1001dddc8 != 0 && IShotGlobal_1001dddd0 != 0 && !NSEqualSizes(self.window.frame.size, NSMakeSize(IShotGlobal_1001dddc8, IShotGlobal_1001dddd0))) {
        CAShapeLayer *shape = [self.recordScreenClipView shapeLayer2];
        shape.strokeColor = [NSColor redColor].CGColor;
        [[self.recordScreenClipView shapeLayer2] setHidden:YES];
        // 0x100023f4c and 0x100024044. The main-queue toggle is submitted before testing superlayer.
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            do {
                [NSThread sleepForTimeInterval:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL hidden = [[self.recordScreenClipView shapeLayer2] isHidden];
                    [[self.recordScreenClipView shapeLayer2] setHidden:!hidden];
                });
            } while ([[self.recordScreenClipView shapeLayer2] superlayer]);
        });
    } else [[self.recordScreenClipView shapeLayer2] removeFromSuperlayer];
    [[self.recordScreenClipView indicatorField] removeFromSuperview];
    if (!IShotGlobal_1001ddde0) {
        IShotGlobal_1001ddde0 = YES;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"keyboardInfoArr"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleControllerEndCaptureNotification:) name:@"SGVideoControllerEndCaptureNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleControllerPauseAndResumeNotification:) name:@"SGVideoControllerPauseAndResumeNotification" object:nil];
        int delay = [[[NSUserDefaults standardUserDefaults] objectForKey:@"startDelayTimesOfRecordScreen"] intValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay ? 100000000 : 1000000000), dispatch_get_main_queue(), ^{
            [IShotGlobal_1001dddb0 beginRecordScreenWithRect:CGRectMake(IShotGlobal_1001dddb8, IShotGlobal_1001dddc0, IShotGlobal_1001dddc8, IShotGlobal_1001dddd0)]; // 0x1000240dc
        });
        [[AppDelegate appDelegate] startRecordScreen];
    }
}
// 0x1000240f8
- (void)recordToolbarViewControllerCanceSGote:(id)sender {
    if (IShotGlobal_1001dddd8) [IShotGlobal_1001dddd8 removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(recordScreenWindowControllerDidCancel:)]) [self.delegate recordScreenWindowControllerDidCancel:self];
    [[NSCursor arrowCursor] set];
}
// 0x1000241b4; block 0x1000243a4 releases the global session.
- (void)handleControllerEndCaptureNotification:(id)sender {
    if (!IShotGlobal_1001dddb0) {
        if ([self.delegate respondsToSelector:@selector(recordScreenWindowControllerDidCancel:)]) [self.delegate recordScreenWindowControllerDidCancel:self];
    } else {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"formatOfRecordScreen"] isEqualToString:@"gif"]) {
            [[self.videoControlsViewController indicatorView] setHidden:NO];
            [[self.videoControlsViewController indicator] startAnimation:self];
        }
        self.window.level = 0;
        if (IShotGlobal_1001dddd8) [IShotGlobal_1001dddd8 removeFromSuperview];
        [[self.recordScreenClipView shapeLayer2] removeFromSuperlayer];
        [IShotGlobal_1001dddb0 endRecordingComplete:^{ IShotGlobal_1001dddb0 = nil; }];
    }
    [[NSCursor arrowCursor] set];
}
- (void)handleControllerPauseAndResumeNotification:(id)sender { [IShotGlobal_1001dddb0 pauseAndResumeRecordingAction]; } // 0x1000243b4
- (void)recordScreenWindowControllerDidCancel:(id)sender { // 0x1000243c0
    if ([self.delegate respondsToSelector:@selector(recordScreenWindowControllerDidCancel:)]) [self.delegate recordScreenWindowControllerDidCancel:self];
}
- (void)openCamera:(id)sender { [self.recordScreenClipView addCameraWindow]; } // 0x100024440
- (void)closeCamera:(id)sender { [self.recordScreenClipView closeCameraWindow]; } // 0x100024470
@end
