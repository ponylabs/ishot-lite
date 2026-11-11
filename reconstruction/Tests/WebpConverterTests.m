#import "../Sources/Dependencies/WebpConverter.h"
#import <webp/decode.h>
#include <assert.h>
#include <string.h>
int main(void) { @autoreleasepool {
    unsigned char pixels[16 * 16 * 4];
    for (NSUInteger index = 0; index < sizeof(pixels); index += 4) {
        pixels[index] = 210; pixels[index + 1] = 35; pixels[index + 2] = 70; pixels[index + 3] = 255;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, 16, 16, 8, 16 * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    assert(context);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:NSMakeSize(16, 16)];
    NSError *error = nil;
    NSData *result = [WebpConverter convertImageToWebP:image configBlock:nil error:&error];
    assert(result.length > 12 && error == nil);
    assert(memcmp(result.bytes, "RIFF", 4) == 0);
    assert(memcmp((const unsigned char *)result.bytes + 8, "WEBP", 4) == 0);
    int width = 0, height = 0;
    assert(WebPGetInfo(result.bytes, result.length, &width, &height) && width == 16 && height == 16);
    int decodedWidth = 0, decodedHeight = 0;
    uint8_t *decoded = WebPDecodeRGBA(result.bytes, result.length, &decodedWidth, &decodedHeight);
    assert(decoded && decodedWidth == 16 && decodedHeight == 16 && decoded[3] == 255);
    WebPFree(decoded);
    result = [WebpConverter convertImageToWebP:image configBlock:^(WebPConfig *config) { config->quality = -1; } error:&error];
    assert(result == nil && error != nil && error.code == -101 && error.localizedDescription.length > 0);
    assert([WebpConverter convertImageToWebP:image configBlock:^(WebPConfig *config) { config->quality = 101; } error:NULL] == nil);
    CGImageRelease(cgImage); CGContextRelease(context); CGColorSpaceRelease(colorSpace);
    puts("WebP current contract: encode/decode dimensions and invalid configuration PASS");
} return 0; }
