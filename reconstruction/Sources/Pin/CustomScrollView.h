#pragma once
#import <Cocoa/Cocoa.h>
@interface CustomScrollView : NSScrollView
@property (nonatomic) BOOL enableShadow;
- (NSMenu *)menuForEvent:(NSEvent *)sender;
- (void)buttonPressed:(id)sender;
- (void)saveToLibrary:(id)sender;
- (void)saveAs:(id)sender;
- (void)saveToPaste:(id)sender;
- (void)openFileFrom:(id)sender;
- (void)annotate:(id)sender;
- (void)cancelShadow:(id)sender;
- (void)scaleImageTo50:(id)sender;
- (void)scaleImageTo100:(id)sender;
- (void)scaleImageTo200:(id)sender;
- (void)moveLeftOnePixel:(id)sender;
- (void)moveRightOnePixel:(id)sender;
- (void)moveUpOnePixel:(id)sender;
- (void)moveDownOnePixel:(id)sender;
- (void)turnLeft:(id)sender;
- (void)turnRight:(id)sender;
- (void)verticallyFlip:(id)sender;
- (void)horizontalFlip:(id)sender;
- (void)close:(id)sender;
- (void)closeAll:(id)sender;
- (void)hiddenOrShowAllPinWindow:(id)sender;
- (BOOL)mouseDownCanMoveWindow;
- (void)mouseUp:(NSEvent *)sender;
- (void)mouseDown:(NSEvent *)sender;
- (void)keyDown:(NSEvent *)sender;
- (void)scrollWheel:(NSEvent *)sender;
- (void)magnifyWithEvent:(NSEvent *)sender;
- (void)touchesBegan:(id)touches withEvent:(id)event;
- (NSBitmapImageRep *)unscaledBitmapImageRep:(NSImage *)sender;
- (NSArray *)handlerApplicationsForFile:(NSString *)sender;
@end
