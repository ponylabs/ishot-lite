#import <AppKit/AppKit.h>
typedef struct { int processIdentifier; CGRect frame; CGRect visibleFrame; } IShotSettingsWindow;
@interface SettingsWindowLocator : NSObject
+ (BOOL)isSystemSettingsFrontmost;
+ (IShotSettingsWindow)frontmostWindow;
+ (void)appKitGeometryFromCGFrame:(CGRect)cg outFrame:(CGRect *)frame outVisibleFrame:(CGRect *)visible;
@end
