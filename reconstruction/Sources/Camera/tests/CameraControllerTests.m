#import "../CameraWindowController.h"
#import "../CameraView.h"
#include <assert.h>

// Test doubles are only in this test file; production has no replacement windows/devices.
@interface GeometryScreen : NSObject
@property NSRect frame;
@end
@implementation GeometryScreen @end
@interface GeometryWindow : NSObject
@property NSRect frame;
@property GeometryScreen *screen;
@property BOOL isVisible;
@property int hideCount;
@property int showCount;
@property int frameCount;
@property int originCount;
- (void)setFrame:(NSRect)frame display:(BOOL)display;
- (void)setFrameOrigin:(NSPoint)point;
- (void)makeKeyAndOrderFront:(id)sender;
- (void)orderOut:(id)sender;
@end
@implementation GeometryWindow
- (void)setFrame:(NSRect)frame display:(BOOL)display { assert(!display); _frame = frame; ++_frameCount; }
- (void)setFrameOrigin:(NSPoint)point { _frame.origin = point; ++_originCount; }
- (void)makeKeyAndOrderFront:(id)sender { _isVisible = YES; ++_showCount; }
- (void)orderOut:(id)sender { _isVisible = NO; ++_hideCount; }
@end
@interface GeometryController : CameraWindowController
@property GeometryWindow *testWindow;
@property int refreshCalls;
@end
@implementation GeometryController
- (NSWindow *)window { return (NSWindow *)(id)self.testWindow; }
- (void)refreshCamera { ++_refreshCalls; }
@end
@interface ConfigurationSession : NSObject
@property NSMutableArray<NSString *> *calls;
- (void)beginConfiguration;
- (void)removeInput:(id)input;
- (void)commitConfiguration;
@end
@implementation ConfigurationSession
- (void)beginConfiguration { [_calls addObject:@"begin"]; }
- (void)removeInput:(id)input { [_calls addObject:@"remove"]; }
- (void)commitConfiguration { [_calls addObject:@"commit"]; }
@end
static void equal(NSRect actual, NSRect expected) {
    if (!NSEqualRects(actual, expected)) {
        fprintf(stderr, "actual=%s expected=%s\n", NSStringFromRect(actual).UTF8String, NSStringFromRect(expected).UTF8String);
        abort();
    }
}
int main(void) {
    @autoreleasepool {
        // Inherited initWithWindow: bypasses the permission-checking -init and nib.
        GeometryController *controller = [[GeometryController alloc] initWithWindow:nil];
        GeometryWindow *window = [GeometryWindow new];
        window.screen = [GeometryScreen new];
        controller.testWindow = window;
        for (int position = 0; position <= 9; position++) {
            window.frame = NSMakeRect(100, 100, 320, 180);
            window.isVisible = YES;
            IShotPreviousCameraConstraint_1001ddd70 = NSMakeRect(0, 0, 800, 600);
            [controller adjustCameraWindowWithRect:NSMakeRect(0, 0, 800, 600) atPosition:position];
            equal(window.frame, NSMakeRect(100, 100, 320, 180));
        }
        NSPoint growthOrigins[] = {{100,100}, {100,55}, {100,100}, {100,100}, {100,100}, {100,100}, {20,100}, {20,100}};
        for (int position = 1; position <= 8; position++) {
            window.frame = NSMakeRect(100, 100, 160, 90);
            window.isVisible = YES;
            IShotPreviousCameraConstraint_1001ddd70 = NSMakeRect(0, 0, 700, 500);
            [controller adjustCameraWindowWithRect:NSMakeRect(0, 0, 800, 600) atPosition:position];
            equal(window.frame, (NSRect){growthOrigins[position - 1], {240,135}});
        }
        // Screen origin is added independently to input x/y (d0 and d1).
        window.screen.frame = NSMakeRect(-1000, 200, 800, 600);
        window.frame = NSMakeRect(-990, 210, 320, 180);
        window.isVisible = YES;
        [controller adjustCameraWindowWithRect:NSMakeRect(10, 10, 800, 600) atPosition:0];
        equal(IShotCameraConstraint_1001f1870, NSMakeRect(-990, 210, 800, 600));
        equal(window.frame, NSMakeRect(-990, 210, 320, 180));
        // Inclusive coverage along either axis, not both axes.
        assert([controller isTwoSideOutRecordScreen:NSMakeRect(-990, 250, 800, 10)]);
        assert([controller isTwoSideOutRecordScreen:NSMakeRect(-900, 210, 10, 600)]);
        assert(![controller isTwoSideOutRecordScreen:NSMakeRect(-900, 250, 10, 10)]);
        window.screen.frame = NSZeroRect;
        window.frame = NSMakeRect(100, 100, 160, 90);
        window.isVisible = YES;
        int hides = window.hideCount;
        [controller adjustCameraWindowWithRect:NSMakeRect(0, 0, 100, 80) atPosition:1];
        assert(window.hideCount == hides + 1);
        int shows = window.showCount;
        window.frame = NSMakeRect(100, 100, 320, 180);
        [controller adjustCameraWindowWithRect:NSMakeRect(0, 0, 800, 600) atPosition:0];
        assert(window.showCount == shows + 1);
        equal(IShotCameraMinimumRect_1001ddcb0, window.frame);
        equal(IShotPreviousCameraConstraint_1001ddd70, NSMakeRect(0, 0, 800, 600));
        [controller observeValueForKeyPath:@"other" ofObject:nil change:nil context:NULL];
        assert(controller.refreshCalls == 0);
        [controller observeValueForKeyPath:@"selectedCameraOfRecordScreen" ofObject:nil change:nil context:NULL];
        assert(controller.refreshCalls == 1);
        ConfigurationSession *session = [ConfigurationSession new];
        session.calls = [NSMutableArray new];
        controller.session = (AVCaptureSession *)(id)session;
        controller.videoDeviceInput = (AVCaptureDeviceInput *)(id)[NSObject new];
        [controller setSelectedVideoDevice:nil];
        assert(([session.calls isEqualToArray:@[@"begin", @"remove", @"commit"]]));
        assert(controller.videoDeviceInput == nil);
        puts("CameraControllerTests passed: 10 positions, 8 growth caps, screen offsets, inclusive bounds, hide/show cache, KVO routing, input removal.");
    }
    return 0;
}
