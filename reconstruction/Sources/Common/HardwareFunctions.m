#import <Cocoa/Cocoa.h>
#include <sys/sysctl.h>
// 0x10004c554
BOOL IShotFunction_10004c554(NSScreen *screen) {
    NSDictionary *description=screen.deviceDescription;
    if ([description objectForKey:@"NSDeviceIsScreen"]) {
        if (CGDisplayIsBuiltin([[description objectForKey:@"NSScreenNumber"] unsignedIntValue])) return YES;
    }
    return NO;
}
// 0x10004c730
NSString *IShotFunction_10004c730(void) {
    size_t length=0;
    sysctlbyname("hw.model",NULL,&length,NULL,0);
    if (!length) return @"";
    char *buffer=malloc(length);
    sysctlbyname("hw.model",buffer,&length,NULL,0);
    NSString *result=[NSString stringWithUTF8String:buffer];
    free(buffer); return result;
}
