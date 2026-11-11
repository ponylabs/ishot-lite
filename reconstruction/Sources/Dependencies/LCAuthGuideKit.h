#import <AppKit/AppKit.h>
@class LCPermissionWindowController;
@interface LCAuthGuideKit : NSObject
@property(nonatomic) BOOL shouldTerminateOnClose;
@property(nonatomic,copy) NSString *tutorialLink;
@property(nonatomic,copy) NSString *closeWindowAlertMessage;
@property(nonatomic,copy) void (^allAuthPassedHandler)(void);
@property(nonatomic,strong) LCPermissionWindowController *permissionWC;
@property(nonatomic,strong) NSTimer *monitorTimer;
+ (instancetype)shared;
- (void)showPermissionAuth:(NSArray *)models;
- (BOOL)isPermissionGranted:(NSInteger)type;
- (void)passAuth;
- (void)skipAuth;
- (void)dismissAuthWindow;
- (void)openPrivacyAccessibilitySetting;
- (void)openScreenCaptureSetting;
- (void)openFullDiskAccessSetting;
+ (BOOL)getPrivacyAccessibilityIsEnabled;
+ (BOOL)getScreenCaptureIsEnabled;
+ (BOOL)getFullDiskAccessIsEnabled;
+ (BOOL)isInputMonitoringEnabled;
+ (NSBundle *)bundle;
+ (NSString *)localizedString:(NSString *)key;
+ (NSImage *)bundleImage:(NSString *)name;
@end
