#import <Cocoa/Cocoa.h>
// 0x10004c448: exact mask and equality tests; combinations not listed return NO.
BOOL IShotFunction_10004c448(NSArray *names) {
    NSUInteger flags=NSApp.currentEvent.modifierFlags & 0x9e0000;
    NSString *name;
    switch (flags) {
        case 0x20000: name=@"Shift"; break;
        case 0x40000: name=@"Control"; break;
        case 0x80000:
            if ([names containsObject:@"Option"]) return YES;
            name=@"Option"; break;
        case 0x100000: name=@"Command"; break;
        case 0x800000: name=@"Fn"; break;
        case 0x900000: name=@"CommandFn"; break;
        default: return NO;
    }
    return [names containsObject:name];
}
