#import <Cocoa/Cocoa.h>
@interface MJMosaicUtil : NSObject
+ (CGImageRef)createCGImageRefFromNSImage:(NSImage *)image CF_RETURNS_RETAINED;
+ (CGImageRef)createMosaicImageFromCGImage:(NSImage *)image blockLevel:(NSUInteger)level CF_RETURNS_RETAINED;
+ (NSImage *)createNSImageFromCGImageRef:(CGImageRef)image;
+ (NSImage *)transToMosaicImage:(CGImageRef)image blockLevel:(NSUInteger)level;
+ (CGImageRef)gaussianBlured:(NSImage *)image Radius:(double)radius CF_RETURNS_RETAINED;
+ (CGImageRef)blurSourceImage:(NSImage *)image Radius:(double)radius CF_RETURNS_RETAINED;
@end
