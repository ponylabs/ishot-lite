#import <Cocoa/Cocoa.h>
// 0x1000483f0: ARM64 0x1000484e0/e4 returns both d0 (width) and d1 (height).
NSSize IShotFunction_1000483f0(NSString *text,int pointSize) {
    NSFont *font=[NSFont systemFontOfSize:(double)pointSize];
    if([text isEqualToString:@""] || text==nil) text=@" ";
    return [text sizeWithAttributes:@{NSFontAttributeName:font}];
}
