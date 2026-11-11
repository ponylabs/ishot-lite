#import "KeyboardEventView.h"
#import "../Global/Global.h"
static NSMutableArray *IShotKeyboard_1001f1b08;
static BOOL IShotKeyboard_1001f1b10, IShotKeyboard_1001f1b28;
static CFMachPortRef IShotKeyboard_1001f1b18;
static CFRunLoopSourceRef IShotKeyboard_1001f1b20;
// 0x10008b29c. The original tap monitors key down/up/flags; only down and flags are saved.
static CGEventRef IShotKeyboardTap(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *context) {
    @autoreleasepool {
        if (type == (CGEventType)-2) CGEventTapEnable(IShotKeyboard_1001f1b18,true);
        else if (type == 12) [Global saveFlagsChangedEventInfo:[NSEvent eventWithCGEvent:event]];
        else if (type == 10) [Global saveKeyEventInfo:[NSEvent eventWithCGEvent:event]];
    }
    return event;
}
@implementation KeyboardEventView
- (instancetype)initWithFrame:(NSRect)frame { // 0x10008b168
    if ((self = [super initWithFrame:frame])) {
        IShotKeyboard_1001f1b08 = [NSMutableArray arrayWithCapacity:3];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"keyboardInfoArr" options:1 context:NULL];
        if (!(IShotKeyboard_1001f1b10 & 1)) {
            IShotKeyboard_1001f1b10 = YES;
            IShotKeyboard_1001f1b18 = CGEventTapCreate(0,0,1,0x1c00,IShotKeyboardTap,NULL);
            IShotKeyboard_1001f1b20 = CFMachPortCreateRunLoopSource(NULL,IShotKeyboard_1001f1b18,0);
            CFRunLoopAddSource(CFRunLoopGetCurrent(),IShotKeyboard_1001f1b20,kCFRunLoopCommonModes);
            CFRelease(IShotKeyboard_1001f1b20);
        }
        CGEventTapEnable(IShotKeyboard_1001f1b18,true);
    }
    return self;
}
- (void)checkTimeOut { // 0x10008b368
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    NSMutableArray *items = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"keyboardInfoArr"]];
    if (!items.count) { IShotKeyboard_1001f1b28 = YES; return; }
    NSArray *copy = [items copy]; NSEventModifierFlags flags = NSEvent.modifierFlags;
    for (NSDictionary *item in copy) {
        NSString *text = item[@"String"];
        if (([text isEqualToString:@"⇧"] && (flags & 0x20000)) || ([text isEqualToString:@"⌃"] && (flags & 0x40000)) || ([text isEqualToString:@"⌘"] && (flags & 0x100000)) || ([text isEqualToString:@"⌥"] && (flags & 0x80000))) continue;
        double timestamp = [item[@"Timestamp"] doubleValue];
        float delay = [[NSUserDefaults standardUserDefaults] floatForKey:@"delayOfKeyEvent"];
        if ((double)delay < now - timestamp) [items removeObject:item];
    }
    if (items) [[NSUserDefaults standardUserDefaults] setObject:items forKey:@"keyboardInfoArr"];
}
- (void)removeFromSuperview { // 0x10008b5fc
    [super removeFromSuperview];
    id info = (__bridge id)[NSUserDefaults standardUserDefaults].observationInfo;
    if ([[info debugDescription] containsString:@"keyboardInfoArr"]) [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"keyboardInfoArr"];
    CGEventTapEnable(IShotKeyboard_1001f1b18,false);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context { // 0x10008b6ec
    if (![keyPath isEqualToString:@"keyboardInfoArr"]) return;
    IShotKeyboard_1001f1b28 = NO;
    [self checkTimeOut]; self.needsDisplay = YES;
    if (!(IShotKeyboard_1001f1b28 & 1)) {
        float delay = [[NSUserDefaults standardUserDefaults] floatForKey:@"delayOfKeyEvent"];
        dispatch_async(dispatch_get_global_queue(0,0), ^{ // 0x10008b7e0 / 0x10008b898
            do { [NSThread sleepForTimeInterval:(double)delay]; dispatch_async(dispatch_get_main_queue(), ^{ [self checkTimeOut]; }); } while (IShotKeyboard_1001f1b28 != YES);
        });
    }
}
- (void)drawRect:(NSRect)dirtyRect { // 0x10008b8a0; geometry verified in ARM64 FP registers.
    [super drawRect:dirtyRect];
    NSArray *items = [[NSUserDefaults standardUserDefaults] objectForKey:@"keyboardInfoArr"];
    float size = [[NSUserDefaults standardUserDefaults] floatForKey:@"sizeOfKeyEvent"];
    int right = 0;
    for (NSUInteger i = 0; i < items.count; ++i) {
        NSDictionary *item = items[i]; NSString *text = item[@"String"];
        NSInteger code = [item[@"KeyCode"] integerValue];
        int width = (int)size;
        if ([text isEqualToString:@"⌘"] || [text isEqualToString:@"⇧"] || [text isEqualToString:@"⌥"] || [text isEqualToString:@"⌃"]) width = (int)((double)size * 1.3333);
        if (code == 49) width = (int)(size + size);
        NSPoint point = [self getPointFromDragged];
        double x = i ? right + 10 : (int)point.x;
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(x,point.y,width,size) xRadius:5 yRadius:5];
        NSColor *background = NSColor.textBackgroundColor, *foreground = NSColor.textColor;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"appearanceDarkOfKeyEvent"]) { background = NSColor.blackColor; foreground = NSColor.whiteColor; }
        else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"appearanceLightOfKeyEvent"]) { background = NSColor.whiteColor; foreground = NSColor.blackColor; }
        right = (int)(x + width);
        [[background colorWithAlphaComponent:0.9] setFill]; [path fill];
        NSDictionary *attributes = @{NSFontAttributeName:[NSFont systemFontOfSize:(int)(size * 0.25f)],NSForegroundColorAttributeName:foreground};
        NSSize textSize = [text sizeWithAttributes:attributes];
        [text drawInRect:NSMakeRect(width * 0.5 + x - textSize.width * 0.5, (double)size * 0.5 + point.y - textSize.height * 0.5, textSize.width, textSize.height) withAttributes:attributes];
    }
}
- (void)mouseDown:(NSEvent *)event { self.mouseDownPoint = event.locationInWindow; } // 0x10008bd58
- (void)mouseDragged:(NSEvent *)event { self.mouseDraggedPoint = event.locationInWindow; self.needsDisplay = YES; } // 0x10008bd80
- (void)mouseUp:(NSEvent *)event { // 0x10008bdb4
    NSPoint point = [self getPointFromDragged]; self.mouseDownPoint = NSZeroPoint; self.mouseDraggedPoint = NSZeroPoint;
    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromPoint(point) forKey:@"originOfKeyEvent"];
    [[NSUserDefaults standardUserDefaults] synchronize]; self.needsDisplay = YES;
}
- (NSPoint)getPointFromDragged { // 0x10008be9c
    double size = (double)[[NSUserDefaults standardUserDefaults] floatForKey:@"sizeOfKeyEvent"];
    NSPoint origin = NSPointFromString([[NSUserDefaults standardUserDefaults] objectForKey:@"originOfKeyEvent"]);
    double x = origin.x + self.mouseDraggedPoint.x - self.mouseDownPoint.x; if (x <= 0.0) x = 0.0;
    double y = origin.y + self.mouseDraggedPoint.y - self.mouseDownPoint.y; if (y <= 0.0) y = 0.0;
    if (self.frame.size.height < y + size) y = self.frame.size.height - size;
    if (self.frame.size.width < size * 2.6666 + x + 10.0) x = self.frame.size.width - size * 2.6666 - 10.0;
    return NSMakePoint(x,y);
}
@end
