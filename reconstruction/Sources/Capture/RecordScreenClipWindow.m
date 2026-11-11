#import "RecordScreenClipWindow.h"
@implementation RecordScreenClipWindow
// 0x10009ca80. Original forwards the screen/style but overrides backing and defer.
- (instancetype)initWithContentRect:(NSRect)rect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backing defer:(BOOL)defer screen:(NSScreen *)screen {
    if ((self = [super initWithContentRect:rect styleMask:style backing:2 defer:NO screen:screen])) {
        self.backgroundColor = [NSColor clearColor];
        self.alphaValue = 1;
        self.acceptsMouseMovedEvents = YES;
        self.floatingPanel = YES;
        if (@available(macOS 16.0, *)) {} else self.collectionBehavior = 0x100;
        self.movableByWindowBackground = NO;
        self.excludedFromWindowsMenu = YES;
        self.opaque = NO;
        self.hasShadow = NO;
        self.hidesOnDeactivate = NO;
        self.level = 0x7fffffed;
        self.restorable = NO;
        [self disableSnapshotRestoration];
        self.movable = NO;
    }
    return self;
}
- (BOOL)canBecomeKeyWindow { return YES; } // 0x10009cbb0
- (BOOL)canBecomeMainWindow { return YES; } // 0x10009cbb8
- (void)dealloc {} // 0x10009cbc0, only super dealloc; ARC supplies it.
- (void)mouseMoved:(NSEvent *)event {} // 0x10009cbf4, RET-only.
@end
