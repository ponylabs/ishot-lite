#import "../CameraView.h"
#import "../NSValue+CGPoint.h"
#include <assert.h>

static void equal(NSRect actual, NSRect expected) {
    if (!NSEqualRects(actual, expected)) {
        fprintf(stderr, "actual=%s expected=%s\n", NSStringFromRect(actual).UTF8String, NSStringFromRect(expected).UTF8String);
        abort();
    }
}
static void reset(void) {
    IShotCameraMinimumRect_1001ddcb0 = NSZeroRect;
    IShotCameraBoundaryRect_1001f1848 = NSZeroRect;
    IShotCameraBoundarySide_1001f1840 = 0;
    IShotRecordScreenRect_1001ddd90 = NSMakeRect(0, 0, 1920, 1080);
}
int main(void) {
    @autoreleasepool {
        CameraView *view = [[CameraView alloc] initWithFrame:NSMakeRect(0, 0, 320, 180)];
        reset();
        view.lastContentRectBeforeResize = NSMakeRect(100, 100, 320, 180);
        NSRect cases[] = {
            NSMakeRect(20, 55, 400, 225), NSMakeRect(100, 20, 462, 260),
            NSMakeRect(100, 20, 462, 260), NSMakeRect(20, 100, 80, 45),
            NSMakeRect(20, 100, 80, 45), NSMakeRect(100, 20, 142, 80),
            NSMakeRect(20, 100, 400, 225), NSMakeRect(20, 100, 400, 225)
        };
        for (int position = 1; position <= 8; position++) {
            reset();
            equal([view getNewRectByReSize:NSMakePoint(20, 20) resizeposition:position], cases[position - 1]);
        }
        reset();
        // <=120 stores the first small frame and keeps it until width exceeds 120.
        equal([view getNewRectByReSize:NSMakePoint(200, 100) resizeposition:4], NSMakeRect(100, 100, 100, 56));
        equal([view getNewRectByReSize:NSMakePoint(160, 100) resizeposition:4], NSMakeRect(100, 100, 100, 56));
        equal([view getNewRectByReSize:NSMakePoint(221, 100) resizeposition:4], NSMakeRect(100, 100, 121, 68));
        equal(IShotCameraMinimumRect_1001ddcb0, NSZeroRect);
        // A right-edge latch suppresses a subsequent top-edge correction.
        IShotRecordScreenRect_1001ddd90 = NSMakeRect(0, 0, 800, 800);
        equal([view getNewRectByReSize:NSMakePoint(900, 100) resizeposition:4], NSMakeRect(100, 100, 700, 393));
        assert(IShotCameraBoundarySide_1001f1840 == 4);
        IShotRecordScreenRect_1001ddd90 = NSMakeRect(0, 0, 800, 300);
        equal([view getNewRectByReSize:NSMakePoint(700, 100) resizeposition:4], NSMakeRect(100, 100, 700, 393));
        assert(IShotCameraBoundarySide_1001f1840 == 4);
        equal([view getNewRectByReSize:NSMakePoint(300, 100) resizeposition:4], NSMakeRect(100, 100, 200, 112));
        assert(IShotCameraBoundarySide_1001f1840 == 0);
        reset();
        assert([view whichSideOutRecordScreen:NSMakeRect(-1, -1, 2000, 2000)] == 8);
        assert([view whichSideOutRecordScreen:NSMakeRect(1, -1, 2000, 2000)] == 4);
        assert([view whichSideOutRecordScreen:NSMakeRect(1, -1, 10, 2000)] == 2);
        assert([view whichSideOutRecordScreen:NSMakeRect(1, 1, 10, 2000)] == 6);
        assert([view whichSideOutRecordScreen:NSMakeRect(0, 0, 1920, 1080)] == 0);
        // Tracking rectangles retain the original asymmetric offsets.
        NSArray<NSValue *> *handles = [view _calculateAllNeededHandleSquareRects:NSMakeRect(10, 20, 320, 180)];
        NSRect expectedHandles[] = {
            {{22, 32}, {298, 156}}, {{0, 10}, {20, 20}}, {{21, 10}, {298, 20}},
            {{320, 10}, {20, 20}}, {{321, 31}, {20, 158}}, {{320, 190}, {20, 20}},
            {{21, 190}, {298, 20}}, {{0, 190}, {20, 20}}, {{1, 31}, {20, 158}}
        };
        assert(handles.count == 9);
        for (NSUInteger i = 0; i < 9; i++) equal(handles[i].CGRectValue, expectedHandles[i]);
        NSPoint point = NSMakePoint(3.5, -7.25);
        assert(NSEqualPoints([NSValue valueWithCGPoint:point].CGPointValue, point));
        puts("CameraGeometryTests passed: 8 resize branches, small-size cache, boundary latch, precedence, 9 handles, category roundtrip.");
    }
    return 0;
}
