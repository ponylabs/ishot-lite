#import "NSColor+Moxtra.h"
#pragma clang fp contract(off)
@implementation NSColor (Moxtra)
+ (NSColor *)moxtraMeetBaseColor { return [NSColor colorWithDeviceRed:0x1.fae147ae147aep-1 green:0x1.0a3d70a3d70a4p-1 blue:0x1.1eb851eb851ecp-3 alpha:1]; }
+ (NSColor *)moxtraBackgroundColorStyle1 { return [NSColor colorWithDeviceRed:0x1.f0a3d70a3d70ap-1 green:0x1.f0a3d70a3d70ap-1 blue:0x1.f0a3d70a3d70ap-1 alpha:1]; }
+ (NSColor *)moxtraBackgroundColorStyle3 { return [NSColor colorWithDeviceRed:0x1.e147ae147ae14p-1 green:0x1.e147ae147ae14p-1 blue:0x1.eb851eb851eb8p-1 alpha:1]; }
+ (NSColor *)moxtraDarkGrayColor { return [NSColor colorWithDeviceRed:0x1.99999a0000000p-3 green:0x1.99999a0000000p-3 blue:0x1.99999a0000000p-3 alpha:1]; }
+ (NSColor *)moxtraBlueColor { return [NSColor colorWithDeviceRed:0x1.5c28f60000000p-3 green:0x1.570a3e0000000p-1 blue:1.0 alpha:1]; }
+ (NSColor *)moxtraDarkBlueColor { return [NSColor colorWithDeviceRed:0x1.47ae140000000p-6 green:0x1.c28f5c0000000p-3 blue:0x1.ae147a0000000p-2 alpha:1]; }
+ (NSColor *)brandingColor { return [NSColor colorWithDeviceRed:0x1.29292a0000000p-3 green:0x1.2323240000000p-1 blue:0x1.adadae0000000p-1 alpha:0x1.9eb8520000000p-1]; }
+ (NSColor *)moxtraGridColor { return [NSColor gridColor]; }
+ (NSColor *)moxtraWhiteColor { return [NSColor whiteColor]; }
+ (NSColor *)moxtraBackgroundColorStyle2 { return [NSColor whiteColor]; }
+ (NSColor *)moxtraRedColor { return [NSColor redColor]; }
+ (NSColor *)moxtraBadgeColor { return [NSColor redColor]; }
+ (NSColor *)moxtraBrandingColor { return [NSColor moxtraBlueColor]; }
+ (NSColor *)moxtraOrangeColor { return [NSColor colorWithDeviceRed:1 green:0x1.0a3d700000000p-1 blue:0 alpha:1]; }
+ (NSColor *)moxtraGreenColor { return [NSColor moxtraColorWithHex:0xc853 alpha:1]; }
+ (NSColor *)moxtraGray60Color { return [NSColor moxtraColorWithHex:0x646466 alpha:1]; }
+ (NSColor *)moxtraPageTextureColor { return [NSColor colorWithPatternImage:[NSImage imageNamed:@"texture_page"]]; }
+ (NSColor *)moxtraColorWithHexString:(NSString *)string {
    if(!string.length) return nil;
    unsigned int value=0;
    NSScanner *scanner=[NSScanner scannerWithString:string];
    scanner.scanLocation=1;
    [scanner scanHexInt:&value];
    return [NSColor colorWithDeviceRed:((value>>16)&255)/255.0 green:((value>>8)&255)/255.0 blue:(value&255)/255.0 alpha:1];
}
+ (NSColor *)moxtraColorWithHex:(NSInteger)hex alpha:(double)alpha {
    return [NSColor colorWithRed:(double)((float)((hex>>16)&255)/255.f) green:(double)((float)((hex>>8)&255)/255.f) blue:(double)((float)(hex&255)/255.f) alpha:alpha];
}
@end
