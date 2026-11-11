#import <AppKit/AppKit.h>
#import "LCAuthGuideHostApp.h"
@class OverlayWindowController;
NSString *IShotPermissionTitle_10009e4d4(NSInteger type);
NSURL *IShotPermissionURL_10009e518(NSInteger type);
@interface LCPermisoAssistant : NSObject
@property(nonatomic,strong) OverlayWindowController *overlayController;
@property(nonatomic,strong) NSTimer *trackingTimer;
@property(nonatomic,strong) id activationObserver;
@property(nonatomic) NSInteger activePanel;
@property(nonatomic) NSRect pendingSourceFrameInScreen;
@property(nonatomic) BOOL didPresentCurrentOverlay;
+ (instancetype)shared;
- (void)presentWithPermissionType:(NSInteger)type;
- (void)presentWithPermissionType:(NSInteger)type hostApp:(LCAuthGuideHostApp *)app sourceFrameInScreen:(NSRect)rect;
- (void)dismiss;
- (void)startTracking;
- (void)refreshPosition;
@end
