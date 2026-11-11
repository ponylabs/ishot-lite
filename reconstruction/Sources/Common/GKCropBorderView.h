#pragma once
#import <Cocoa/Cocoa.h>
@interface GKCropBorderView : NSView {
    NSMutableArray *_handleTrackRectArray;
    NSRect _contentTrackRect;
    BOOL _beDragging, _isInResizeRect, _isCanMove;
    int _numberOfReSize;
}
@property(nonatomic) BOOL hideHandleRect, onlyClipCurrentWindow, isCanMove;
@property(nonatomic,strong) NSColor *borderColor;
@property(nonatomic) float borderRadius;
@property(nonatomic) int whichInResizeRect;
- (int)numberOfReSize;
- (BOOL)isInResizeRect;
- (BOOL)mouseOnLinOfNote:(CGPoint)point;
- (CGPoint)getPointFrom:(CGPoint)point to:(CGRect)rect;
- (double)distanceBetweenPoint:(CGPoint)point and:(CGPoint)other;
- (BOOL)point:(CGPoint)point andPoint:(CGPoint)other crossWithCyclePoint:(CGPoint)center radius:(float)radius;
- (NSArray *)_calculateAllNeededHandleTrackRects:(CGRect)rect;
- (NSDictionary *)isOnStrokesUnderMouse:(CGPoint)point;
- (BOOL)isLineIntersectingCircleWithPoint1:(CGPoint)point point2:(CGPoint)other center:(CGPoint)center radius:(double)radius;
- (double)angleBetweenPoint:(CGPoint)point and:(CGPoint)other;
- (BOOL)containsPoint:(CGPoint)point withPath:(CGPathRef)path;
- (void)drawCurrentHighlightStroke;
- (void)drawAllHighlight;
- (void)drawAllBackgroundOfText;
- (NSArray *)_calculateAllNeededHandleSquareRects:(CGRect)rect;
- (BOOL)_calculateMouseIsOnActivedResizeRectWithPoint:(CGPoint)point;
- (int)_calculateMouseIsOnCropBorderViewWithPoint:(CGPoint)point;
@end
