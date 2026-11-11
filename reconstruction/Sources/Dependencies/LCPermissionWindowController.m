#import "LCPermissionWindowController.h"
#import "LCAuthGuideKit.h"
#import "LCAuthGuideHostApp.h"
@implementation LCPermissionWindowController
- (instancetype)init {
    NSWindow *window=[[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:0x8007 backing:2 defer:YES];
    window.titlebarAppearsTransparent=YES; window.opaque=NO; window.level=3;
    [window standardWindowButton:2].hidden=YES; [window standardWindowButton:1].hidden=YES; window.movableByWindowBackground=YES;
    if((self=[super initWithWindow:window])) { _permissionVC=[[LCPermissionViewController alloc] init]; window.contentViewController=_permissionVC; window.delegate=self; [window center]; } return self;
}
- (instancetype)initWithWindow:(NSWindow *)window { return [super initWithWindow:window]; }
- (instancetype)initWithCoder:(NSCoder *)coder { if((self=[super initWithCoder:coder])) [NSException raise:NSInvalidArgumentException format:@"initWithCoder: 未实现"]; return nil; }
- (NSString *)buildMessageText:(NSString *)text {
    if(self.closeWindowAlertMessage) return [NSString stringWithFormat:@"%@ %@",text,self.closeWindowAlertMessage];
    return [NSString stringWithFormat:[LCAuthGuideKit localizedString:self.shouldTerminateOnClose ? @"close_alert_default_terminate" : @"close_alert_default_normal"],text];
}
- (BOOL)windowShouldClose:(NSWindow *)window {
    NSString *message=[self buildMessageText:LCAuthGuideHostApp.currentApp.displayName];
    NSAlert *alert=[[NSAlert alloc] init]; alert.messageText=[LCAuthGuideKit localizedString:@"close_alert_title"]; alert.informativeText=message;
    if(self.shouldTerminateOnClose) { [alert addButtonWithTitle:[LCAuthGuideKit localizedString:@"close_alert_continue"]]; [alert addButtonWithTitle:[LCAuthGuideKit localizedString:@"close_alert_quit"]]; }
    else [alert addButtonWithTitle:[LCAuthGuideKit localizedString:@"close_alert_confirm"]];
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse response) { if(self.shouldTerminateOnClose && response==1001) [NSApplication.sharedApplication terminate:nil]; }]; return NO;
}
- (void)windowWillClose:(NSNotification *)notification { if(self.closeHandler) self.closeHandler(); }
@end
