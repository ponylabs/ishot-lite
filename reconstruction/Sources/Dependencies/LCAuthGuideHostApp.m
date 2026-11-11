#import "LCAuthGuideHostApp.h"
@implementation LCAuthGuideHostApp
- (instancetype)initWithDisplayName:(NSString *)name bundleURL:(NSURL *)url icon:(NSImage *)icon { if((self=[super init])) { _displayName=[name copy]; _bundleURL=url; _icon=icon; } return self; }
+ (instancetype)currentApp { return [self currentAppWithBundle:NSBundle.mainBundle]; }
+ (instancetype)currentAppWithBundle:(NSBundle *)bundle {
    NSString *name=bundle.infoDictionary[@"CFBundleDisplayName"];
    if(!name) name=bundle.infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    if(!name) name=bundle.bundleURL.URLByDeletingPathExtension.lastPathComponent;
    NSImage *icon=[NSWorkspace.sharedWorkspace iconForFile:bundle.bundlePath]; icon.size=NSMakeSize(48,48);
    return [[LCAuthGuideHostApp alloc] initWithDisplayName:name bundleURL:bundle.bundleURL icon:icon];
}
@end
