#import <AppKit/AppKit.h>
#import <webp/encode.h>
@interface WebpConverter : NSObject
+ (NSData *)convertImageToWebP:(NSImage *)image configBlock:(void (^)(WebPConfig *))block error:(NSError **)error;
@end
