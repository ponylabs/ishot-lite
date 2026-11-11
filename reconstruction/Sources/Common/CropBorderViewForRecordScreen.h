#pragma once
#import <Cocoa/Cocoa.h>
@interface CropBorderViewForRecordScreen : NSView {
    NSMutableArray *_handleTrackRectArray;
    NSRect _contentTrackRect;
    BOOL _beDragging, _isInResizeRect, _isCanMove;
    int _numberOfReSize;
}
@property(nonatomic) BOOL hideHandleRect, onlyClipCurrentWindow, isCanMove;
@property(nonatomic,strong) NSColor *borderColor;
@property(nonatomic) int whichInResizeRect;
@property(nonatomic) NSRect toolBarViewRect;
- (int)numberOfReSize;
- (BOOL)isInResizeRect;
- (NSArray *)_calculateAllNeededHandleTrackRects:(CGRect)rect;
- (int)_calculateMouseIsOnCropBorderViewWithPoint:(CGPoint)point;
@end
