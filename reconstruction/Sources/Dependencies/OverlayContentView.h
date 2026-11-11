#import <AppKit/AppKit.h>
#import "LCAuthGuideHostApp.h"
@interface OverlayContentView : NSView
@property(nonatomic,copy) void (^onBack)(void);
@property(nonatomic) double windowWidth;
- (instancetype)initWithHostApp:(LCAuthGuideHostApp *)app permissionType:(NSInteger)type onBack:(void (^)(void))back;
- (void)setupWithHostApp:(LCAuthGuideHostApp *)app permissionType:(NSInteger)type;
- (NSTextField *)createStepLabelWithText:(NSString *)text;
@end
