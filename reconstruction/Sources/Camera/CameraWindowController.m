#import "CameraWindowController.h"
#import "CameraView.h"
#import "RoundedPreviewLayer.h"
#include <math.h>

NSRect IShotPreviousCameraConstraint_1001ddd70;
NSRect IShotCameraConstraint_1001f1870;

// 0x100048a4c, availability builtin 0x10014e83c; completion 0x100048aec.
int IShotCameraAuthorization_100048a4c(void) {
    if (@available(macOS 10.14, *)) {
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
            case AVAuthorizationStatusNotDetermined:
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    NSLog(@"%@", granted ? @"-- granted" : @"-- not granted");
                }];
                return 0;
            case AVAuthorizationStatusAuthorized: return 1;
            default: return -1;
        }
    }
    return 1;
}
// 0x100048b18; exact strings decoded from __cfstring.
uint64_t IShotCameraPermissionAlert_100048b18(void) {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = [NSBundle.mainBundle localizedStringForKey:@"To enable the camera, you need to obtain camera permissions. Please check the option of iShot in the camera." value:@"" table:nil];
    [alert addButtonWithTitle:[NSBundle.mainBundle localizedStringForKey:@"OK" value:@"" table:nil]];
    [alert runModal];
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Camera"]];
    return 0;
}

@implementation CameraWindowController
// 0x100004ba8
- (instancetype)init {
    if (IShotCameraAuthorization_100048a4c() == -1) {
        [NSUserDefaults.standardUserDefaults setObject:@"None" forKey:@"selectedCameraOfRecordScreen"];
        [NSUserDefaults.standardUserDefaults synchronize];
        [NSNotificationCenter.defaultCenter postNotificationName:@"RecordScreenWindowControllerDidCancel" object:nil];
        IShotCameraPermissionAlert_100048b18();
        return nil;
    }
    self = [super init];
    if (self) {
        [NSBundle.mainBundle loadNibNamed:@"CameraWindow" owner:self topLevelObjects:NULL];
        self.window.backgroundColor = NSColor.clearColor;
    }
    return self;
}
// 0x100004d2c; original has no super awakeFromNib call.
- (void)awakeFromNib {
    self.window.level = 0x7fffffef;
    self.session = [[AVCaptureSession alloc] init];
    [self refreshCamera];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"selectedCameraOfRecordScreen" options:NSKeyValueObservingOptionNew context:NULL];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:self.window];
}
// 0x100004e48
- (void)windowWillClose:(NSNotification *)notification {
    if ([[notification.object identifier] isEqualToString:@"CameraWindow"]) {
        [NSUserDefaults.standardUserDefaults removeObserver:self forKeyPath:@"selectedCameraOfRecordScreen"];
        [NSNotificationCenter.defaultCenter removeObserver:self name:NSWindowWillCloseNotification object:self.window];
    }
}
// 0x100004f44: other paths are ignored, matching the original.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedCameraOfRecordScreen"]) [self refreshCamera];
}
// 0x100004f88, background block 0x100005060, main block 0x10000523c.
- (void)refreshCamera {
    if ([[NSUserDefaults.standardUserDefaults objectForKey:@"selectedCameraOfRecordScreen"] isEqualToString:@"None"]) return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *selected = [NSUserDefaults.standardUserDefaults objectForKey:@"selectedCameraOfRecordScreen"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            if ([selected isEqualToString:device.uniqueID]) [self setSelectedVideoDevice:device];
        }
#pragma clang diagnostic pop
        dispatch_async(dispatch_get_main_queue(), ^{
            CALayer *layer = self.window.contentView.layer;
            // Original does not release this created CGColor; ownership is preserved.
            layer.backgroundColor = CGColorCreateGenericRGB(0, 0, 0, 0.002);
            RoundedPreviewLayer *preview = [[RoundedPreviewLayer alloc] initWithSession:self.session];
            preview.connection.automaticallyAdjustsVideoMirroring = NO;
            preview.connection.videoMirrored = YES;
            preview.frame = layer.bounds;
            preview.autoresizingMask = 0x12;
            [layer addSublayer:preview];
            [self.session startRunning];
        });
    });
}
// 0x1000053a0, error block 0x1000055ec.
- (void)setSelectedVideoDevice:(AVCaptureDevice *)device {
    [self.session beginConfiguration];
    if (self.videoDeviceInput) {
        [self.session removeInput:self.videoDeviceInput];
        self.videoDeviceInput = nil;
    }
    if (device) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (input) {
            if (![device supportsAVCaptureSessionPreset:self.session.sessionPreset]) self.session.sessionPreset = AVCaptureSessionPresetHigh;
            [self.session addInput:input];
            self.videoDeviceInput = input;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{ [self presentError:error]; });
        }
    }
    [self.session commitConfiguration];
}
// 0x100005648: scalar transcription of SIMD/FP assembly. See README.md.
- (void)adjustCameraWindowWithRect:(NSRect)rect atPosition:(int)position {
    IShotCameraConstraint_1001f1870 = rect;
    IShotCameraConstraint_1001f1870.origin.x += self.window.screen.frame.origin.x;
    IShotCameraConstraint_1001f1870.origin.y += self.window.screen.frame.origin.y;
    NSRect constraint = IShotCameraConstraint_1001f1870;
    NSRect frame = self.window.frame;
    double x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height;
    double left = constraint.origin.x, bottom = constraint.origin.y;
    double cw = constraint.size.width, ch = constraint.size.height;
    double right = left + cw, top = bottom + ch;
    double oldW = IShotPreviousCameraConstraint_1001ddd70.size.width;
    double oldH = IShotPreviousCameraConstraint_1001ddd70.size.height;
    switch (position) {
        case 0:
            if (x < left) x = left;
            if (y < bottom) y = bottom;
            if (x + w > right) x = right - w;
            if (y + h > top) y = top - h;
            [self.window setFrameOrigin:NSMakePoint(x, y)];
            break;
        case 1:
        case 3:
        case 5: {
            if (oldW <= cw && oldH <= ch && w < 240.0) {
                float dw = (float)(cw - oldW), dh = (float)(ch - oldH);
                if ((double)dw > (double)dh * 1.7778) { w += (double)dw; h = w * 0.5625; }
                else if (dw + dh > 0) { h += (double)dh; w = h * 1.7778; }
                if (w > 240.0) h = 135.0;
                // fmin at 0x100005d48/5da8/5e90 was dropped by the decompiler.
                w = isnan(w) ? w : fmin(w, 240.0);
            }
            if (position == 1) { if (x < left) x = left; }
            else { if (x + w > right) x = right - w; }
            if (position == 5) { if (y + h > top) y = top - h; }
            else { if (y < bottom) y = bottom; }
            if ((position == 1 && x + w > right) || (position != 1 && x < left)) {
                x = left; w = cw; h = cw * 0.5625;
            } else if ((position == 5 && y < bottom) || (position != 5 && y + h > top)) {
                y = bottom; w = ch * 1.7778; h = ch;
            }
            break;
        }
        case 2:
        case 6: {
            if (position == 2) {
                if (y < bottom) y = bottom;
                if (y + h > top) { y = bottom; h = ch; w = ch * 1.7778; }
            } else {
                if (y + h > top) y = top - h;
                if (y < bottom) { y = bottom; h = ch; w = ch * 1.7778; }
            }
            if (oldW <= cw && oldH <= ch && w < 240.0) {
                double dh = (double)(float)(ch - oldH);
                if (position == 2) y -= dh;
                h += dh; w = h * 1.7778;
                if (x + w > right) x = right - w;
                if (x < left) { x = left; w = cw; h = cw * 0.5625; }
                if (w > 240.0) {
                    if (position == 2) y = y + h - 135.0;
                    w = 240.0; h = 135.0;
                    goto show;
                }
            }
            break;
        }
        case 4:
        case 8: {
            if (position == 4) {
                if (x + w > right) x = right - w;
                if (x < left) { x = left; w = cw; h = cw * 0.5625; }
            } else {
                if (x < left) x = left;
                if (x + w > right) { x = left; w = cw; h = cw * 0.5625; }
            }
            if (oldW <= cw && oldH <= ch && w < 240.0) {
                double dw = (double)(float)(cw - oldW);
                if (position == 8) x -= dw;
                w += dw; h = w * 0.5625;
                if (y + h > top) y = top - h;
                if (y < bottom) { y = bottom; w = ch * 1.7778; h = ch; }
                if (w > 240.0) {
                    if (position == 8) x = x + w - 240.0;
                    w = 240.0; h = 135.0;
                    goto show;
                }
            }
            break;
        }
        case 7: {
            if (oldW <= cw && oldH <= ch && w < 240.0) {
                float dw = (float)(cw - oldW), dh = (float)(ch - oldH);
                if ((double)dw > (double)dh * 1.7778) {
                    x -= (double)dw; w += (double)dw; h = w * 0.5625;
                } else if (dw + dh > 0) {
                    h += (double)dh;
                    double oldRight = x + w;
                    w = h * 1.7778; x = oldRight - w;
                }
                if (w > 240.0) { x = x + w - 240.0; w = 240.0; h = 135.0; }
            }
            if (x < left) x = left;
            if (y + h > top) y = top - h;
            if (x + w > right) { x = left; w = cw; h = cw * 0.5625; }
            else if (y < bottom) { y = bottom; w = ch * 1.7778; h = ch; }
            break;
        }
    }
    IShotPreviousCameraConstraint_1001ddd70 = constraint;
    if (!(w > 120.0) && [self isTwoSideOutRecordScreen:NSMakeRect(x, y, w, h)]) {
        [self.window orderOut:nil];
        return;
    }
show:
    IShotPreviousCameraConstraint_1001ddd70 = constraint;
    if (!self.window.isVisible) {
        IShotCameraMinimumRect_1001ddcb0 = NSMakeRect(x, y, w, h);
        [self.window makeKeyAndOrderFront:self];
    }
    [self.window setFrame:NSMakeRect(x, y, w, h) display:NO];
}
// 0x100005ff8, inclusive opposite-edge coverage; either axis is sufficient.
- (BOOL)isTwoSideOutRecordScreen:(NSRect)rect {
    NSRect constraint = IShotCameraConstraint_1001f1870;
    return (rect.origin.x <= constraint.origin.x && constraint.origin.x + constraint.size.width <= rect.origin.x + rect.size.width)
        || (rect.origin.y <= constraint.origin.y && constraint.origin.y + constraint.size.height <= rect.origin.y + rect.size.height);
}
// Atomic retain accessors 0x100006048..0x100006074; nonatomic rect accessors
// 0x100006080/6098; ARC destructor 0x1000060b0 releases both object ivars.
@end
