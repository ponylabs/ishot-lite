#import "LCAuthGuideKit.h"
#import "LCPermissionModel.h"
#import "LCPermissionWindowController.h"
#import <ApplicationServices/ApplicationServices.h>
#import <IOKit/hid/IOHIDLib.h>
#import <pwd.h>
#import <unistd.h>
#import <fcntl.h>
extern CGImageRef IShotCGWindowListCreateImage(CGRect, CGWindowListOption, CGWindowID, CGWindowImageOption) __asm__("_CGWindowListCreateImage");
@implementation LCAuthGuideKit
+ (instancetype)shared { static LCAuthGuideKit *shared; static dispatch_once_t once; dispatch_once(&once,^{shared=[[LCAuthGuideKit alloc] init];}); return shared; }
- (instancetype)init { if((self=[super init])) { _shouldTerminateOnClose=YES; _closeWindowAlertMessage=nil; } return self; }
- (void)showPermissionAuth:(NSArray *)models {
    for(LCPermissionModel *model in models) {
        if(![self isPermissionGranted:model.authType]) {
            [self.monitorTimer invalidate];
            self.monitorTimer=[NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
                if(!self.permissionWC) {
                    LCPermissionWindowController *controller=[[LCPermissionWindowController alloc] init]; self.permissionWC=controller;
                    controller.permissionVC.allAuthPassedHandler=^{ [self.monitorTimer invalidate]; self.monitorTimer=nil; [self passAuth]; };
                    controller.permissionVC.skipHandler=^{ [self skipAuth]; };
                    controller.closeHandler=^{ [self.monitorTimer invalidate]; self.monitorTimer=nil; self.permissionWC=nil; };
                    controller.shouldTerminateOnClose=self.shouldTerminateOnClose; controller.closeWindowAlertMessage=self.closeWindowAlertMessage;
                    controller.permissionVC.authTypes=models; [controller.window makeKeyAndOrderFront:nil]; [NSApp activateIgnoringOtherApps:YES];
                }
            }]; return;
        }
    }
    [self passAuth];
}
- (BOOL)isPermissionGranted:(NSInteger)type { switch(type) { case 1:return [LCAuthGuideKit getPrivacyAccessibilityIsEnabled]; case 2:return [LCAuthGuideKit getFullDiskAccessIsEnabled]; case 3:return [LCAuthGuideKit getScreenCaptureIsEnabled]; case 4:return [LCAuthGuideKit isInputMonitoringEnabled]; default:return YES; } }
- (void)passAuth { [self.permissionWC close]; self.permissionWC=nil; if(self.allAuthPassedHandler) self.allAuthPassedHandler(); }
- (void)skipAuth { [self.permissionWC close]; self.permissionWC=nil; [self.monitorTimer invalidate]; self.monitorTimer=nil; }
- (void)dismissAuthWindow { [self.monitorTimer invalidate]; self.monitorTimer=nil; [self.permissionWC close]; self.permissionWC=nil; }
+ (BOOL)getPrivacyAccessibilityIsEnabled { return AXIsProcessTrusted()!=0; }
+ (BOOL)getScreenCaptureIsEnabled {
    if(@available(macOS 10.15,*)) {
        pid_t pid=NSRunningApplication.currentApplication.processIdentifier;
        NSArray *windows=CFBridgingRelease(CGWindowListCopyWindowInfo(0x10,0));
        for(NSDictionary *window in windows) {
            NSNumber *owner=window[(__bridge NSString *)kCGWindowOwnerPID];
            if(window[(__bridge NSString *)kCGWindowName] && owner && owner.intValue!=pid) {
                NSString *name=[NSRunningApplication runningApplicationWithProcessIdentifier:owner.intValue].executableURL.lastPathComponent;
                if(name && ![name isEqualToString:@"Dock"]) return YES;
            }
        } return NO;
    } return YES;
}
+ (BOOL)getFullDiskAccessIsEnabled {
    if(@available(macOS 10.14,*)) {
        NSString *home;
        if(NSProcessInfo.processInfo.environment[@"APP_SANDBOX_CONTAINER_ID"]) { struct passwd *entry=getpwuid(getuid()); if(entry) home=[NSString stringWithUTF8String:entry->pw_dir]; }
        if(!home) home=NSHomeDirectory();
        NSArray *paths=@[[home stringByAppendingPathComponent:@"Library/Safari/CloudTabs.db"],[home stringByAppendingPathComponent:@"Library/Safari/Bookmarks.plist"],@"/Library/Application Support/com.apple.TCC/TCC.db",@"/Library/Preferences/com.apple.TimeMachine.plist"];
        for(NSString *path in paths) { int fd=open(path.UTF8String,0); if(fd!=-1) {close(fd);return YES;} } return NO;
    } return YES;
}
+ (BOOL)isInputMonitoringEnabled { if(@available(macOS 10.15,*)) return IOHIDCheckAccess(1)==0; return YES; }
- (void)openPrivacyAccessibilitySetting {
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"]];
    CGEventRef event=CGEventCreate(NULL); CGPoint location=CGEventGetLocation(event); CFRelease(event);
    event=CGEventCreateMouseEvent(NULL,2,location,0); CGEventPost(0,event); CFRelease(event);
}
- (void)openScreenCaptureSetting {
    if(@available(macOS 10.15,*)) {
        if(@available(macOS 11.0,*)) CGRequestScreenCaptureAccess();
        else {
            // The original retains this returned image; preserve its lifetime behavior.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            IShotCGWindowListCreateImage(CGRectMake(0,0,1,1),1,0,0);
#pragma clang diagnostic pop
        }
        dispatch_async(dispatch_get_main_queue(),^{ [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"]]; });
    }
}
- (void)openFullDiskAccessSetting { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"]]; }
+ (NSBundle *)bundle { static NSBundle *bundle; static dispatch_once_t once; dispatch_once(&once,^{bundle=[NSBundle bundleForClass:self];});return bundle; }
+ (NSString *)localizedString:(NSString *)key { return [[self bundle] localizedStringForKey:key value:@"" table:@"LCAuthGuideKit"]; }
+ (NSImage *)bundleImage:(NSString *)name { NSURL *url=[[self bundle] URLForResource:name withExtension:nil];return url ? [[NSImage alloc] initWithContentsOfURL:url] : nil; }
@end
