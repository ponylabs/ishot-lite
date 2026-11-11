#import <Cocoa/Cocoa.h>
@interface MXRecordScreenManager : NSObject
@property(nonatomic) BOOL isWorking;
@property(nonatomic,strong) NSMutableArray *arrayRect;
@property(nonatomic,strong) NSMutableArray *recordWindowControllerArray;
+ (instancetype)sharedInstance;
- (void)readyToRecordScreen;
- (void)changeKeyWindowWithScreen:(NSScreen *)screen;
- (void)reset;
- (void)recordScreenWindowController:(id)controller finishRecordWithFileName:(id)name saveToLocal:(BOOL)save;
- (void)recordScreenWindowControllerDidSelectRegion:(id)controller;
- (void)recordScreenWindowControllerRemoveEventMonitor:(id)controller;
- (void)recordScreenWindowControllerDidCancel:(id)controller;
- (void)clearRecordWindowControllerArray;
@end
