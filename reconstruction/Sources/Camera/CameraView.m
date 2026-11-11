#import "CameraView.h"
#import "NSValue+CGPoint.h"
#include <math.h>

BOOL IShotCameraDragging_1001ddca8;
NSRect IShotCameraMinimumRect_1001ddcb0;
NSRect IShotRecordScreenRect_1001ddd90;
NSCursor *IShotGlobal_1001ddf90;
NSCursor *IShotGlobal_1001ddf88;
uint64_t IShotHandleSize_1001dcb30 = 20; // __DATA bytes: 14 00 00 00 00 00 00 00
int IShotCameraBoundarySide_1001f1840;
NSRect IShotCameraBoundaryRect_1001f1848;

@implementation CameraView
// 0x100001b90
- (instancetype)initWithFrame:(NSRect)frame { return [super initWithFrame:frame]; }
// 0x100001bc4
- (void)mouseDown:(NSEvent *)event {
    IShotCameraDragging_1001ddca8 = NO;
    self.initialMouseLocation = self.resizeType == 0 ? event.locationInWindow : NSEvent.mouseLocation;
    self.lastContentRectBeforeResize = self.window.frame;
}
// 0x100001c54
- (void)mouseDragged:(NSEvent *)event {
    IShotCameraDragging_1001ddca8 = YES;
    if (self.resizeType >= 0) {
        if (self.resizeType == 0) {
            [self moveCameraWindow:event.locationInWindow];
        } else {
            NSRect rect = [self getNewRectByReSize:NSEvent.mouseLocation resizeposition:self.resizeType];
            if (rect.size.width > 0) [self.window setFrame:rect display:NO];
        }
    }
}
// 0x100001d44
- (void)mouseUp:(NSEvent *)event { IShotCameraDragging_1001ddca8 = NO; }
// 0x100001d50
- (void)mouseEntered:(NSEvent *)event {
    if (IShotCameraDragging_1001ddca8) return;
    NSDictionary *data = (__bridge NSDictionary *)event.userData;
    self.resizeType = [data[@"number"] intValue];
    if (self.resizeType >= 0 && self.resizeType < 9) {
        if (self.resizeType == 0) [NSCursor.openHandCursor set];
        else if (self.resizeType == 2 || self.resizeType == 6) [NSCursor.resizeUpDownCursor set];
        else if (self.resizeType == 4 || self.resizeType == 8) [NSCursor.resizeLeftRightCursor set];
        else if (self.resizeType == 1 || self.resizeType == 5) [IShotGlobal_1001ddf90 set];
        else if (self.resizeType == 3 || self.resizeType == 7) [IShotGlobal_1001ddf88 set];
    }
}
// 0x100001ef8; original compares window-local event location to the window frame.
- (void)mouseExited:(NSEvent *)event {
    if (IShotCameraDragging_1001ddca8) return;
    if (NSPointInRect(event.locationInWindow, self.window.frame)) {
        self.resizeType = 0;
        [NSCursor.openHandCursor set];
    } else {
        self.resizeType = -1;
        [NSCursor.arrowCursor set];
    }
}
// 0x100001ff4; d1 window-frame origin is recovered from assembly at 0x100002058.
- (void)moveCameraWindow:(NSPoint)point {
    double x = self.window.frame.origin.x + (point.x - self.initialMouseLocation.x);
    double y = self.window.frame.origin.y + (point.y - self.initialMouseLocation.y);
    if (x < IShotRecordScreenRect_1001ddd90.origin.x) x = IShotRecordScreenRect_1001ddd90.origin.x;
    if (y < IShotRecordScreenRect_1001ddd90.origin.y) y = IShotRecordScreenRect_1001ddd90.origin.y;
    double maxX = IShotRecordScreenRect_1001ddd90.origin.x + IShotRecordScreenRect_1001ddd90.size.width;
    double maxY = IShotRecordScreenRect_1001ddd90.origin.y + IShotRecordScreenRect_1001ddd90.size.height;
    if (maxX < x + self.window.frame.size.width) x = maxX - self.window.frame.size.width;
    if (maxY < y + self.window.frame.size.height) y = maxY - self.window.frame.size.height;
    if (IShotCameraMinimumRect_1001ddcb0.size.width != 0) IShotCameraMinimumRect_1001ddcb0.origin = NSMakePoint(x, y);
    [self.window setFrameOrigin:NSMakePoint(x, y)];
}
// 0x1000021c0. Integer truncation, approximate reciprocal 1.7778, shared
// boundary latch and <=120 cache are all present in the artifact.
- (NSRect)getNewRectByReSize:(NSPoint)point resizeposition:(int)position {
    NSRect rect = NSZeroRect;
    double x = 0, y = 0, width = 0, height = 0;
    int right = 0, top = 0;
    if ((position & ~1) == 4) {
        int left = (int)self.lastContentRectBeforeResize.origin.x;
        int bottom = (int)self.lastContentRectBeforeResize.origin.y;
        int mouseX = (int)point.x;
        NSRect last = self.lastContentRectBeforeResize;
        top = (int)(last.origin.y + last.size.height);
        x = MIN(left, mouseX); y = MIN(bottom, top);
        width = abs(mouseX - left); height = (int)(width * 0.5625);
    } else if ((position & ~1) == 2) {
        int left = (int)self.lastContentRectBeforeResize.origin.x;
        NSRect last = self.lastContentRectBeforeResize;
        right = (int)(last.origin.x + last.size.width);
        last = self.lastContentRectBeforeResize;
        top = (int)(last.origin.y + last.size.height);
        x = MIN(left, right); y = MIN((int)point.y, top);
        height = abs(top - (int)point.y); width = (int)(height * 1.7778);
    } else if (position == 6) {
        int left = (int)self.lastContentRectBeforeResize.origin.x;
        int bottom = (int)self.lastContentRectBeforeResize.origin.y;
        NSRect last = self.lastContentRectBeforeResize;
        right = (int)(last.origin.x + last.size.width);
        x = MIN(left, right); y = MIN(bottom, (int)point.y);
        height = abs((int)point.y - bottom); width = (int)(height * 1.7778);
    } else if ((unsigned)position - 7 < 2) {
        int bottom = (int)self.lastContentRectBeforeResize.origin.y;
        NSRect last = self.lastContentRectBeforeResize;
        right = (int)(last.origin.x + last.size.width);
        last = self.lastContentRectBeforeResize;
        top = (int)(last.origin.y + last.size.height);
        x = MIN((int)point.x, right); y = MIN(bottom, top);
        width = abs(right - (int)point.x); height = (int)(width * 0.5625);
    } else if (position == 1) {
        NSRect last = self.lastContentRectBeforeResize;
        right = (int)(last.origin.x + last.size.width);
        last = self.lastContentRectBeforeResize;
        top = (int)(last.origin.y + last.size.height);
        x = MIN((int)point.x, right); width = abs(right - (int)point.x);
        height = (int)(width * 0.5625); y = MIN(top - (int)height, top);
    } else {
        goto minimum;
    }
    rect = NSMakeRect(x, y, width, height);
    int side = [self whichSideOutRecordScreen:rect];
    if (side == 0) {
        IShotCameraBoundarySide_1001f1840 = 0;
        goto minimum;
    }
    double maxX = IShotRecordScreenRect_1001ddd90.origin.x + IShotRecordScreenRect_1001ddd90.size.width;
    double maxY = IShotRecordScreenRect_1001ddd90.origin.y + IShotRecordScreenRect_1001ddd90.size.height;
    if ((position & ~1) == 4 || position == 6) {
        if (side == 4 && IShotCameraBoundarySide_1001f1840 != 6) {
            width = (int)fabs(maxX - x); height = (int)(width * 0.5625);
        } else if (side == 6 && IShotCameraBoundarySide_1001f1840 != 4) {
            height = (int)fabs(maxY - y); width = (int)(height * 1.7778);
        } else goto latched;
    } else if ((position & ~1) == 2) {
        if (side == 4 && IShotCameraBoundarySide_1001f1840 != 2) {
            double oldTop = y + height;
            width = (int)fabs(maxX - x); height = (int)(width * 0.5625);
            y = (int)(oldTop - height);
        } else if (side == 2 && IShotCameraBoundarySide_1001f1840 != 4) {
            height = (int)fabs((y + height) - IShotRecordScreenRect_1001ddd90.origin.y);
            width = (int)(height * 1.7778); y = (int)IShotRecordScreenRect_1001ddd90.origin.y;
        } else goto latched;
    } else if ((unsigned)position - 7 < 2) {
        if (side == 6 && IShotCameraBoundarySide_1001f1840 != 8) {
            double oldRight = x + width;
            height = (int)fabs(maxY - y); width = (int)(height * 1.7778);
            x = (int)(oldRight - width);
        } else if (side == 8 && IShotCameraBoundarySide_1001f1840 != 6) {
            double oldRight = x + width;
            x = (int)IShotRecordScreenRect_1001ddd90.origin.x;
            width = (int)fabs(oldRight - x); height = (int)(width * 0.5625);
        } else goto latched;
    } else { // position 1
        if (side == 2 && IShotCameraBoundarySide_1001f1840 != 8) {
            double oldRight = x + width;
            y = (int)IShotRecordScreenRect_1001ddd90.origin.y;
            height = abs(top - (int)y); width = (int)(height * 1.7778);
            x = (int)(oldRight - width);
        } else if (side == 8 && IShotCameraBoundarySide_1001f1840 != 2) {
            x = (int)IShotRecordScreenRect_1001ddd90.origin.x;
            width = abs(right - (int)x); height = (int)(width * 0.5625);
            y = top - (int)height;
        } else goto latched;
    }
    IShotCameraBoundarySide_1001f1840 = side;
    IShotCameraBoundaryRect_1001f1848 = NSMakeRect(x, y, width, height);
    return IShotCameraBoundaryRect_1001f1848;
latched:
    if (IShotCameraBoundarySide_1001f1840 != 0) return IShotCameraBoundaryRect_1001f1848;
minimum:
    if (rect.size.width <= 120.0) {
        if (IShotCameraMinimumRect_1001ddcb0.size.width == 0) IShotCameraMinimumRect_1001ddcb0 = rect;
        return IShotCameraMinimumRect_1001ddcb0;
    }
    IShotCameraMinimumRect_1001ddcb0 = NSZeroRect;
    return rect;
}
// 0x1000028c4 and its block at 0x100002ab4. No super call in the original.
- (void)updateTrackingAreas {
    [self.trackingAreas enumerateObjectsUsingBlock:^(NSTrackingArea *area, NSUInteger __unused index, BOOL * __unused stop) {
        [self removeTrackingArea:area];
    }];
    NSArray<NSValue *> *rects = [self _calculateAllNeededHandleSquareRects:self.frame];
    for (NSUInteger index = 0; index < rects.count; ++index) {
        NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:rects[index].CGRectValue
            options:0x81 owner:self userInfo:@{@"number": @((int)index)}];
        [self addTrackingArea:area];
    }
}
// 0x100002ad0; float-width/height intermediates and asymmetric +1/+2 offsets preserved.
- (NSArray<NSValue *> *)_calculateAllNeededHandleSquareRects:(NSRect)rect {
    double x = rect.origin.x, y = rect.origin.y;
    float w = (float)rect.size.width, h = (float)rect.size.height;
    uint64_t handle = IShotHandleSize_1001dcb30;
    double half = (double)(handle >> 1), size = (double)handle;
    double innerW = (double)((w - (float)handle) - 2.0f);
    double innerH = (double)((h - (float)handle) - 2.0f);
    NSMutableArray *rects = [NSMutableArray new];
    [rects addObject:[NSValue valueWithCGRect:NSMakeRect(x + half + 2, y + half + 2, innerW, (h - (float)handle) - 4.0f)]];
    [rects addObject:[NSValue valueWithCGRect:NSMakeRect(x - half, y - half, size, size)]];
    [rects addObject:[NSValue valueWithCGRect:NSMakeRect(x + half + 1, y - half, innerW, size)]];
    [rects addObject:[NSValue valueWithCGRect:NSMakeRect(x + w - half, y - half, size, size)]];
    [rects addObject:[NSValue valueWithCGRect:NSMakeRect(x + w - half + 1, y + half + 1, size, innerH)]];
    [rects addObject:[NSValue valueWithCGRect:NSMakeRect(x + w - half, y + h - half, size, size)]];
    [rects addObject:[NSValue valueWithCGRect:NSMakeRect(x + half + 1, y + h - half, innerW, size)]];
    [rects addObject:[NSValue valueWithCGRect:NSMakeRect(x - half, y + h - half, size, size)]];
    [rects addObject:[NSValue valueWithCGRect:NSMakeRect(x - half + 1, y + half + 1, size, innerH)]];
    return rects;
}
// 0x100002e2c: left, right, bottom, top precedence.
- (int)whichSideOutRecordScreen:(NSRect)rect {
    NSRect screen = IShotRecordScreenRect_1001ddd90;
    if (rect.origin.x < screen.origin.x) return 8;
    if (screen.origin.x + screen.size.width < rect.origin.x + rect.size.width) return 4;
    if (rect.origin.y < screen.origin.y) return 2;
    if (rect.origin.y + rect.size.height <= screen.origin.y + screen.size.height) return 0;
    return 6;
}
// Synthesized nonatomic accessors: 0x100002e94, 0x100002ea8, 0x100002ebc,
// 0x100002ecc, 0x100002edc, 0x100002ef4; property types in objc/metadata.json.
@end
