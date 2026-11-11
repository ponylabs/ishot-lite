#import <Cocoa/Cocoa.h>
// 0x100048c68. Localized strings and URL are literal shipped CFStrings.
uint64_t IShotFunction_100048c68(void) {
    NSAlert *alert=[[NSAlert alloc] init];
    alert.messageText=[NSBundle.mainBundle localizedStringForKey:@"In order for iShot to listen for key events, please grant input monitoring permission." value:@"" table:nil];
    [alert addButtonWithTitle:[NSBundle.mainBundle localizedStringForKey:@"OK" value:@"" table:nil]];
    [alert runModal];
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent"]];
    return 0;
}
