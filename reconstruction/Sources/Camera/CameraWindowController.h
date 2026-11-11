#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

extern NSRect IShotPreviousCameraConstraint_1001ddd70;
extern NSRect IShotCameraConstraint_1001f1870;
int IShotCameraAuthorization_100048a4c(void);
uint64_t IShotCameraPermissionAlert_100048b18(void);

@interface CameraWindowController : NSWindowController
@property(atomic, strong) AVCaptureSession *session;
@property(atomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property(nonatomic) NSRect constrainedRect;
- (void)windowWillClose:(NSNotification *)notification;
- (void)refreshCamera;
- (void)setSelectedVideoDevice:(AVCaptureDevice *)device;
- (void)adjustCameraWindowWithRect:(NSRect)rect atPosition:(int)position;
- (BOOL)isTwoSideOutRecordScreen:(NSRect)rect;
@end
