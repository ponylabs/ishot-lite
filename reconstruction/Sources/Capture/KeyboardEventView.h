#import <Cocoa/Cocoa.h>
@interface KeyboardEventView : NSView
@property(nonatomic) NSPoint mouseDownPoint;
@property(nonatomic) NSPoint mouseDraggedPoint;
- (void)checkTimeOut;
- (NSPoint)getPointFromDragged;
@end
