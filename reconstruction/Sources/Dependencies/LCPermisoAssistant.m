#import "LCPermisoAssistant.h"
#import "LCAuthGuideKit.h"
#import "OverlayWindowController.h"
#import "SettingsWindowLocator.h"
NSString *IShotPermissionTitle_10009e4d4(NSInteger type) {
    if((NSUInteger)type>10) return @"";
    static NSString *const titles[]={@"Accessibility permission",@"Screen recording permission",@"Full disk access",@"Files and Folders permission",@"Contacts permission",@"Calendars permission",@"Reminders permission",@"Camera permission",@"Microphone permission",@"Location Services permission",@"Input monitoring permission"};
    return [LCAuthGuideKit localizedString:titles[type]];
}
NSURL *IShotPermissionURL_10009e518(NSInteger type) {
    static NSString *const panels[]={@"Privacy_Accessibility",@"Privacy_ScreenCapture",@"Privacy_AllFiles",@"Privacy_FilesAndFolders",@"Privacy_Contacts",@"Privacy_Calendars",@"Privacy_Reminders",@"Privacy_Camera",@"Privacy_Microphone",@"Privacy_LocationServices",@"Privacy_ListenEvent"};
    return [NSURL URLWithString:[NSString stringWithFormat:@"x-apple.systempreferences:com.apple.preference.security?%@",(NSUInteger)type<=10 ? panels[type] : @""]];
}
@implementation LCPermisoAssistant
+ (instancetype)shared { static LCPermisoAssistant *shared;static dispatch_once_t once;dispatch_once(&once,^{shared=[[LCPermisoAssistant alloc] init];});return shared; }
- (instancetype)init { if((self=[super init])) {_didPresentCurrentOverlay=NO;_pendingSourceFrameInScreen=NSZeroRect;}return self; }
- (void)presentWithPermissionType:(NSInteger)type { [self presentWithPermissionType:type hostApp:LCAuthGuideHostApp.currentApp sourceFrameInScreen:NSZeroRect]; }
- (void)presentWithPermissionType:(NSInteger)type hostApp:(LCAuthGuideHostApp *)app sourceFrameInScreen:(NSRect)rect {
    [self dismiss];self.activePanel=type;self.pendingSourceFrameInScreen=rect;self.didPresentCurrentOverlay=NO;
    __weak LCPermisoAssistant *weakSelf=self;
    self.overlayController=[[OverlayWindowController alloc] initWithHostApp:app type:type onBack:^{[weakSelf dismiss];}];
    [NSWorkspace.sharedWorkspace openURL:IShotPermissionURL_10009e518(type)];[self startTracking];
}
- (void)dismiss {
    [self.trackingTimer invalidate];self.trackingTimer=nil;
    if(self.activationObserver) {[NSWorkspace.sharedWorkspace.notificationCenter removeObserver:self.activationObserver];self.activationObserver=nil;}
    [self.overlayController close];self.overlayController=nil;self.didPresentCurrentOverlay=NO;
}
- (void)startTracking {
    [self.trackingTimer invalidate];self.trackingTimer=[NSTimer scheduledTimerWithTimeInterval:0.15 repeats:YES block:^(NSTimer *timer) {dispatch_async(dispatch_get_main_queue(),^{[self refreshPosition];});}];
    if(self.activationObserver) [NSWorkspace.sharedWorkspace.notificationCenter removeObserver:self.activationObserver];
    self.activationObserver=[NSWorkspace.sharedWorkspace.notificationCenter addObserverForName:NSWorkspaceDidActivateApplicationNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {[self refreshPosition];}];
    [self refreshPosition];
}
- (void)refreshPosition {
    IShotSettingsWindow window=SettingsWindowLocator.frontmostWindow;
    if(!window.processIdentifier) [self.overlayController hide];
    else if(!self.didPresentCurrentOverlay) { [self.overlayController presentFromSourceFrame:self.pendingSourceFrameInScreen settingsFrame:window.frame visibleFrame:window.visibleFrame];self.didPresentCurrentOverlay=YES; }
    else [self.overlayController updatePositionWithSettingsFrame:window.frame visibleFrame:window.visibleFrame];
}
@end
