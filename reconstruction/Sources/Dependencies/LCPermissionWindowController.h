#import <AppKit/AppKit.h>
@class LCPermissionBoxView;
@interface LCPermissionViewController : NSViewController
@property(nonatomic,strong) NSVisualEffectView *effectView;
@property(nonatomic,strong) NSImageView *appIconView;
@property(nonatomic,strong) NSTextField *appNameLabel;
@property(nonatomic,strong) NSTextField *titleLabel;
@property(nonatomic,strong) LCPermissionBoxView *box;
@property(nonatomic,strong) NSButton *showInFinderBtn;
@property(nonatomic,strong) NSButton *lookBtn;
@property(nonatomic,strong) NSButton *quitBtn;
@property(nonatomic,strong) NSTimer *permissionCheckTimer;
@property(nonatomic,strong) NSArray *authTypes;
@property(nonatomic,copy) void (^allAuthPassedHandler)(void);
@property(nonatomic,copy) void (^skipHandler)(void);
@property(nonatomic,copy) void (^quitHandler)(void);
- (void)commonInit;
- (void)refreshAllAuthState;
- (void)showInFinder;
- (void)quitApp;
- (void)skip;
- (void)lookTutorialVideo;
- (void)startPermissionCheckWithType:(NSInteger)type;
@end
@interface LCPermissionWindowController : NSWindowController <NSWindowDelegate>
@property(nonatomic,readonly) LCPermissionViewController *permissionVC;
@property(nonatomic,copy) void (^closeHandler)(void);
@property(nonatomic) BOOL shouldTerminateOnClose;
@property(nonatomic,copy) NSString *closeWindowAlertMessage;
- (NSString *)buildMessageText:(NSString *)text;
@end
