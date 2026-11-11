#pragma once
#import <Cocoa/Cocoa.h>
@interface NSColor (Moxtra)
+ (NSColor *)moxtraGridColor;
+ (NSColor *)moxtraWhiteColor;
+ (NSColor *)moxtraMeetBaseColor;
+ (NSColor *)moxtraBackgroundColorStyle1;
+ (NSColor *)moxtraBackgroundColorStyle2;
+ (NSColor *)moxtraBackgroundColorStyle3;
+ (NSColor *)moxtraDarkGrayColor;
+ (NSColor *)moxtraBlueColor;
+ (NSColor *)moxtraOrangeColor;
+ (NSColor *)moxtraGreenColor;
+ (NSColor *)moxtraRedColor;
+ (NSColor *)moxtraBadgeColor;
+ (NSColor *)moxtraPageTextureColor;
+ (NSColor *)moxtraDarkBlueColor;
+ (NSColor *)moxtraGray60Color;
+ (NSColor *)moxtraBrandingColor;
+ (NSColor *)brandingColor;
+ (NSColor *)moxtraColorWithHexString:(NSString *)string;
+ (NSColor *)moxtraColorWithHex:(NSInteger)hex alpha:(double)alpha;
@end
