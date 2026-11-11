#pragma once
#import <Cocoa/Cocoa.h>
// Runtime metadata: recovery/objc/metadata.json, AnnotatedImageView.
@interface AnnotatedImageView : NSView {
    unsigned long long currentFunction;
    NSColor * currentColor;
    float currentLineWidth;
    NSMutableArray * arrayOfPoints;
    NSTextField * _textField;
}
@property (nonatomic, strong) NSTextField * textField;
- (void)selectFunctionToolChanged; // 0x100062384
- (id)initWithFrame:(CGRect)arg0; // 0x1000623bc
- (void)textViewDidChange:(id)arg0; // 0x1000624fc
- (BOOL)acceptsFirstResponder; // 0x100062914
- (void)awakeFromNib; // 0x10006291c
- (void)refreshOthersDrawRect; // 0x100062974
- (void)mouseMoved:(id)arg0; // 0x1000629d4
- (void)keyDown:(id)arg0; // 0x1000629d8
- (void)mousedown:(id)arg0; // 0x1000629dc
- (void)setupNewStroke:(int)arg0 AtOrigin:(CGPoint)arg1; // 0x1000634cc
- (void)mouseDragged:(id)arg0; // 0x100063d38
- (void)mouseup:(id)arg0; // 0x1000649e8
- (void)scrollWheel:(id)arg0; // 0x100065a14
- (void)undoDraw; // 0x100065a64
- (void)redoDraw; // 0x100065df8
- (void)reSetUndo; // 0x100065fb4
- (void)drawRect; // 0x100066038
- (void)drawRect:(CGRect)arg0; // 0x100066040
- (void)updateTrackingAreas; // 0x1000665c8
- (void)mouseEntered:(id)arg0; // 0x100066ab8
- (void)mouseExited:(id)arg0; // 0x100066dfc
- (int)getListNumberFromArrayOfStrokes:(int)arg0; // 0x100067018
- (void)drawAllSquare:(id)arg0; // 0x100067194
- (void)drawAllEllipse:(id)arg0; // 0x100067504
- (void)drawAllLine:(id)arg0; // 0x100067810
- (void)drawAllPencilPen:(id)arg0; // 0x100067f1c
- (void)drawAllText:(id)arg0 withAlpha:(float)arg1; // 0x100068274
- (BOOL)AllIsEnglish:(id)arg0; // 0x1000684f0
- (BOOL)isChinese:(id)arg0; // 0x100068584
- (void)drawAllNote:(id)arg0 withAlpha:(float)arg1; // 0x100068608
- (void)drawSquareOfCurrentStroke:(id)arg0; // 0x100068c34
- (void)drawEllipseOfCurrentStroke:(id)arg0; // 0x100069110
- (void)drawLineOfCurrentStroke:(id)arg0; // 0x100069570
- (void)drawPencilPenOfCurrentStroke:(id)arg0; // 0x100069f74
- (void)drawTextOfCurrentStroke:(id)arg0; // 0x10006a3e8
- (BOOL)getdicOfCurrentStrokeUnderMouse:(CGPoint)arg0; // 0x10006a620
- (double)angleBetweenPoint:(CGPoint)arg0 and:(CGPoint)arg1; // 0x10006b5dc
- (double)distanceBetweenPoint:(CGPoint)arg0 and:(CGPoint)arg1; // 0x10006b5ec
- (void)moveSquare:(id)arg0; // 0x10006b608
- (void)moveEllipse:(id)arg0; // 0x10006bb98
- (void)moveLine:(id)arg0; // 0x10006c0c4
- (void)movePencilPen:(id)arg0; // 0x10006cb80
- (CGPoint)getPointFrom:(CGPoint)arg0 to:(CGRect)arg1; // 0x10006d220
- (void)resizeSquare; // 0x10006d274
- (void)resizeEllipse; // 0x10006d618
- (void)resizeLine; // 0x10006d958
- (CGRect)getNewRectOfResizeAllStroke; // 0x10006e704
- (id)_calculateAllNeededHandleSquareRects:(CGRect)arg0; // 0x10006eb0c
- (CGPoint)getNewPointForSqureOrEllipse:(CGPoint)arg0; // 0x10006f07c
- (CGPoint)getNewPointForArrowOrLine:(CGPoint)arg0; // 0x10006f1b8
- (BOOL)point:(CGPoint)arg0 andPoint:(CGPoint)arg1 crossWithCyclePoint:(CGPoint)arg2 radius:(float)arg3; // 0x10006f354
- (id)makeBubble:(id)arg0 withBubbleRect:(CGRect)arg1 cornerRight:(double)arg2 cornerLeft:(double)arg3; // 0x10006f45c
@end
