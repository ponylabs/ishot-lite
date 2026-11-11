#import "Zoom.h"
#import "../Editor/AnnotatedImageController.h"
extern AnnotatedImageController *IShotGlobal_1001de160;
extern NSString *IShotGlobal_1001de090;
extern CFArrayRef IShotCGWindowListCreate(CGWindowListOption,CGWindowID) __asm__("_CGWindowListCreate");
extern CGImageRef IShotCGWindowListCreateImageFromArray(CGRect,CFArrayRef,CGWindowImageOption) __asm__("_CGWindowListCreateImageFromArray");
@implementation ZoomWindow
// 0x100047ce8 forces backing=2/defer=NO; preserves the supplied screen and mask.
- (instancetype)initWithContentRect:(NSRect)rect styleMask:(NSWindowStyleMask)mask backing:(NSBackingStoreType)backing defer:(BOOL)defer screen:(NSScreen *)screen {
    self=[super initWithContentRect:rect styleMask:mask backing:2 defer:NO screen:screen];
    if (self) {
        self.backgroundColor=[NSColor.clearColor colorWithAlphaComponent:.002];
        self.alphaValue=1; self.acceptsMouseMovedEvents=YES; self.floatingPanel=YES;
        if (@available(macOS 16.0,*)) {} else self.collectionBehavior=0x100;
        self.movableByWindowBackground=NO; self.excludedFromWindowsMenu=YES;
        self.opaque=NO; self.hasShadow=NO; self.hidesOnDeactivate=NO;
        self.level=0x7fffffef; self.identifier=@"ZoomWindow"; self.restorable=NO;
        [self disableSnapshotRestoration]; self.movable=NO;
        self.contentView=[[ZoomView alloc] initWithFrame:rect];
    }
    return self;
}
- (BOOL)canBecomeKeyWindow { return NO; }
- (BOOL)canBecomeMainWindow { return YES; }
- (void)dealloc {} // 0x100047eb8 only calls super dealloc; ARC supplies that call.
- (void)mouseMoved:(NSEvent *)event { [self.contentView mouseMoved:event]; }
@end
@implementation ZoomView
- (instancetype)initWithFrame:(NSRect)frame { return [super initWithFrame:frame]; }
- (void)mouseMoved:(NSEvent *)event {
    NSPoint point=event.locationInWindow;
    self.zoomFrame=NSMakeRect(point.x-150-self.frame.origin.x,point.y-150-self.frame.origin.y,300,300);
    [IShotGlobal_1001de160 handleMouseEvent:event];
}
- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,100000000),dispatch_get_main_queue(),^{ self.needsDisplay=YES; });
    if (![IShotGlobal_1001de090 isEqualToString:@"zoom"]) { [self.window orderOut:nil]; return; }
    if (!self.window.visible) return;
    NSBezierPath *clip=[NSBezierPath bezierPathWithOvalInRect:self.zoomFrame]; [clip addClip];
    CGEventRef event=CGEventCreate(NULL); CGPoint mouse=CGEventGetLocation(event); if (event) CFRelease(event);
    CFArrayRef windows=IShotCGWindowListCreate(1,0);
    CFMutableArrayRef filtered=CFArrayCreateMutableCopy(NULL,0,windows);
    for (CFIndex i=CFArrayGetCount(filtered)-1;i>=0;i--) {
        CGWindowID windowID=(CGWindowID)(uintptr_t)CFArrayGetValueAtIndex(filtered,i);
        if (self.window.windowNumber==windowID) CFArrayRemoveValueAtIndex(filtered,i);
        NSArray *info=CFBridgingRelease(CGWindowListCopyWindowInfo(8,windowID));
        for (NSDictionary *window in info) {
            NSString *name=window[@"kCGWindowName"], *owner=window[@"kCGWindowOwnerName"];
            if ([name isEqualToString:@"Cursor"] && ([owner isEqualToString:@"Window Server"] || [owner isEqualToString:@"WindowServer"])) CFArrayRemoveValueAtIndex(filtered,i);
        }
    }
    CGImageRef cg=IShotCGWindowListCreateImageFromArray(CGRectMake(mouse.x-50,mouse.y-50,100,100),filtered,8);
    if (windows) CFRelease(windows); if (filtered) CFRelease(filtered);
    NSImage *image=[[NSImage alloc] initWithCGImage:cg size:NSMakeSize(100,100)]; if (cg) CGImageRelease(cg);
    if (image) [image drawInRect:self.zoomFrame fromRect:NSZeroRect operation:2 fraction:1 respectFlipped:YES hints:nil];
}
@end
