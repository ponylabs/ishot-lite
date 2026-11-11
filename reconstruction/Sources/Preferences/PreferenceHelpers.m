#import "PreferenceHelpers.h"
NSString *IShotFunction_10004a51c(void) {
    NSString *path=[NSString stringWithFormat:@"%@/Contents/Info.plist",NSBundle.mainBundle.bundleURL.path];
    return [NSDictionary dictionaryWithContentsOfFile:path][@"CFBundleShortVersionString"];
}
BOOL IShotFunction_100049f34(uint64_t keyCode) {
    uint64_t offset=keyCode-0x40;
    return (0x542aebf04018001ULL >> (offset & 0x3f)) & (offset < 0x3b);
}
