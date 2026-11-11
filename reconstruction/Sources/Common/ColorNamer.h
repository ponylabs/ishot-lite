#import <Cocoa/Cocoa.h>
@interface ColorNamer : NSObject {
    NSDictionary *colorDictionary;
    NSMutableDictionary *colorAttributes;
}
- (NSDictionary *)findNameForColor:(NSColor *)color;
- (NSDictionary *)findNameForColorHexString:(NSString *)hex;
- (NSDictionary *)algorithm:(NSColor *)color;
- (NSString *)nameOfColor:(NSColor *)color;
- (NSString *)nameForColor:(NSColor *)color;
- (NSArray *)colorList;
+ (NSColor *)colorFromHexString:(NSString *)hex;
+ (NSString *)hexStringFromColor:(NSColor *)color;
+ (instancetype)sharedInstance;
+ (NSString *)nameOfColor:(NSColor *)color;
@end
