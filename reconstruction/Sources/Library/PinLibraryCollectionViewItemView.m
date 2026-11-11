#import "PinLibrary.h"
@implementation PinLibraryCollectionViewItemView
- (void)drawRect:(NSRect)rect { // 0x100053d90, FP arguments verified against assembly
    self.closeButton.transparent = YES;
    self.pinButton.transparent = YES;
    self.pinButton.image = nil;
    self.closeButton.image = nil;
    [super drawRect:rect];
    @autoreleasepool {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.frame, 1, 1) xRadius:2 yRadius:2];
        path.lineWidth = 2;
        NSColor *color;
        if (_isMouseEntered) color = NSColor.linkColor;
        else {
            color = NSColor.grayColor;
            path = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.frame, 0, 0) xRadius:3.5 yRadius:3.5];
            path.lineWidth = 1;
        }
        [color set];
        [path stroke];
        if (self.trackingAreas.count == 0) [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:rect options:0x683 owner:self userInfo:nil]];
    }
}
- (void)mouseMoved:(NSEvent *)event { // 0x100054000
    self.closeButton.transparent = NO;
    self.pinButton.transparent = NO;
    if (!self.pinButton.image) self.pinButton.image = [NSImage imageNamed:@"pinlibrary"];
    if (!self.closeButton.image) self.closeButton.image = [NSImage imageNamed:@"pindelte"];
    [super mouseMoved:event];
}
- (void)mouseEntered:(NSEvent *)event { _isMouseEntered = YES; self.needsDisplay = YES; } // 0x1000541a8
- (void)mouseExited:(NSEvent *)event { // 0x1000541c0
    self.closeButton.transparent = YES;
    self.pinButton.transparent = YES;
    self.pinButton.image = nil;
    self.closeButton.image = nil;
    _isMouseEntered = NO;
    self.needsDisplay = YES;
}
- (void)mouseDown:(NSEvent *)event { [super mouseDown:event]; } // 0x10005427c
@end
