#import <Cocoa/Cocoa.h>

// Address suffixes preserve identity of shared storage in the arm64 artifact.
extern BOOL IShotCameraDragging_1001ddca8;
extern NSRect IShotCameraMinimumRect_1001ddcb0;
extern NSRect IShotRecordScreenRect_1001ddd90;
extern NSCursor *IShotGlobal_1001ddf90;
extern NSCursor *IShotGlobal_1001ddf88;
extern uint64_t IShotHandleSize_1001dcb30;
extern int IShotCameraBoundarySide_1001f1840;
extern NSRect IShotCameraBoundaryRect_1001f1848;

@interface CameraView : NSView
@property(nonatomic) NSPoint initialMouseLocation;
@property(nonatomic) int resizeType;
@property(nonatomic) NSRect lastContentRectBeforeResize;
- (void)moveCameraWindow:(NSPoint)point;
- (NSRect)getNewRectByReSize:(NSPoint)point resizeposition:(int)position;
- (NSArray<NSValue *> *)_calculateAllNeededHandleSquareRects:(NSRect)rect;
- (int)whichSideOutRecordScreen:(NSRect)rect;
@end
