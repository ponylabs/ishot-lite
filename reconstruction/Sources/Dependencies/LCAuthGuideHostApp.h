#import <AppKit/AppKit.h>
@interface LCAuthGuideHostApp : NSObject
@property(nonatomic,readonly,copy) NSString *displayName;
@property(nonatomic,readonly) NSURL *bundleURL;
@property(nonatomic,readonly) NSImage *icon;
- (instancetype)initWithDisplayName:(NSString *)name bundleURL:(NSURL *)url icon:(NSImage *)icon;
+ (instancetype)currentApp;
+ (instancetype)currentAppWithBundle:(NSBundle *)bundle;
@end
