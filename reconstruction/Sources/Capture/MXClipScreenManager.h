#import <Cocoa/Cocoa.h>
@interface MXClipScreenManager : NSObject
@property(nonatomic) BOOL isWorking;
@property(nonatomic,strong) NSMutableArray *clipWindowControllerArray;
+ (instancetype)sharedInstance;
- (void)startCaptureFromPinAnnotate:(BOOL)fromPin;
- (void)changeKeyWindowWithScreen:(NSScreen *)screen;
- (void)reset;
- (void)clearClipWindowControllerArray;
- (void)clipWindowController:(id)controller;
- (void)clipWindowControllerDidCancel:(id)controller;
- (void)startScreenShots;
- (void)startAnnotation;
- (void)cancelScreenShot;
- (void)refreshMosaicDrawRect;
- (void)refreshHighlightDrawRect;
- (void)scrollScreenShot;
- (void)disableTextView;
@end
