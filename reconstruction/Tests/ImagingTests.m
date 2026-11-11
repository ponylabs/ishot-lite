#import "../Sources/Imaging/Imaging.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <ImageIO/ImageIO.h>
#include <assert.h>
// Link-only dependency sentinels: any accidental side effect or out-of-scope call fails.
NSScreen *IShotGlobal_1001dde80;
BOOL IShotGlobal_1001de089;
void IShotFunction_100047ffc(NSString *name) { abort(); }
@interface WebpConverter : NSObject @end
@implementation WebpConverter
+ (NSData *)convertImageToWebP:(NSImage *)image configBlock:(id)block error:(NSError **)error { abort(); }
@end
@interface Global : NSObject @end
@implementation Global
+ (CGRect)calcuateRealRectFromIMageRef:(CGImageRef)image withOriginalRect:(CGRect)rect { abort(); }
@end
@interface SnipUtil : NSObject @end
@implementation SnipUtil
+ (CGRect)cgWindowRectToScreenRect:(CGRect)rect { abort(); }
@end
@interface SyntheticScreen : NSObject
@property NSRect frame;
@end
@implementation SyntheticScreen
- (double)backingScaleFactor { return 2; }
- (NSColorSpace *)colorSpace { return NSColorSpace.sRGBColorSpace; }
@end
static SyntheticScreen *screen;
static id syntheticCurrentScreen(id receiver, SEL selector) { return screen; }
@interface SyntheticRep : NSImageRep @end
@implementation SyntheticRep
- (NSInteger)pixelsWide { return 1000; }
- (NSInteger)pixelsHigh { return 900; }
@end
@interface ThrowingImage : NSObject @end
@implementation ThrowingImage
- (NSData *)TIFFRepresentation { [NSException raise:@"Synthetic" format:@"test"]; return nil; }
@end
static NSBitmapImageRep *bitmap(NSInteger width, NSInteger height) {
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:width pixelsHigh:height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    for (NSInteger y = 0; y < height; ++y) for (NSInteger x = 0; x < width; ++x) {
        NSUInteger pixel[] = {(NSUInteger)(x * 255 / MAX(1, width-1)), (NSUInteger)(y * 255 / MAX(1, height-1)), 91, 255};
        [rep setPixel:pixel atX:x y:y];
    }
    return rep;
}
static NSImage *makeImage(void) {
    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(40, 30)];
    [image addRepresentation:bitmap(40, 30)]; return image;
}
static void checkSize(NSImage *image, double width, double height) {
    assert(image && fabs(image.size.width-width) < 1e-5 && fabs(image.size.height-height) < 1e-5);
}
static NSUInteger alphaAt(NSImage *image, NSInteger x, NSInteger y) {
    CGImageRef ref = [image CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:ref];
    return (NSUInteger)llround([[rep colorAtX:x y:y] alphaComponent] * 255);
}
int main(void) { @autoreleasepool {
    [NSApplication sharedApplication];
    screen = [SyntheticScreen new]; screen.frame = NSMakeRect(-1920.125, -200.75, 1920, 1080);
    IShotGlobal_1001dde80 = (id)screen;
    Method current = class_getClassMethod(NSScreen.class, @selector(currentScreenForMouseLocation));
    IMP previous = method_setImplementation(current, (IMP)syntheticCurrentScreen);
    CGPoint (^convert)(CGPoint) = ^CGPoint(CGPoint p) {
        return ((CGPoint (*)(id, SEL, CGPoint))class_getMethodImplementation(NSScreen.class, @selector(convertPointToScreenCoordinates:)))(screen, @selector(convertPointToScreenCoordinates:), p);
    };
    CGPoint point = convert(CGPointMake(-1720.2, -101.1));
    assert(point.x == (double)fabsf((float)(1920.125-1720.2)) && point.y == (double)(float)99.65);
    point = ((CGPoint (*)(id, SEL, CGPoint))class_getMethodImplementation(NSScreen.class, @selector(flipPoint:)))(screen, @selector(flipPoint:), CGPointMake(19.125, 80.25));
    assert(point.x == 19.125 && point.y == 999.75);
    NSImage *image = makeImage();
    assert(image.pixelsWide == 40 && image.pixelsHigh == 30 && CGSizeEqualToSize(image.pixelSize, CGSizeMake(40, 30)));
    NSImage *mixed = [[NSImage alloc] initWithSize:NSMakeSize(40, 30)];
    [mixed addRepresentation:[SyntheticRep new]];
    assert(mixed.pixelsWide == 1000 && mixed.pixelsHigh == 900);
    [mixed addRepresentation:bitmap(80, 20)]; [mixed addRepresentation:bitmap(10, 60)];
    assert(mixed.pixelsWide == 80 && mixed.pixelsHigh == 60);
    for (NSNumber *number in @[@0.5f, @1.0f, @1.25f, @2.0f]) {
        float scale = number.floatValue;
        NSImage *a = [NSImage resizeImage:image scale:scale], *b = [NSImage resizeImage:image value:scale];
        checkSize(a, 40*(double)scale, 30*(double)scale); checkSize(b, a.size.width, a.size.height);
        assert([[NSImage md5WithImage:a] isEqual:[NSImage md5WithImage:b]]);
        int pad = (int)(scale*6);
        checkSize([NSImage resizeImage:image scale:scale addShadowWithColor:NSColor.blackColor], 40*(double)scale+2*pad, 30*(double)scale+2*pad);
        NSBitmapImageRep *rep = [image normalRGBBitmapImageRepresentationWithScaleFactor:scale];
        assert(rep.pixelsWide == (NSInteger)(40*(double)scale) && rep.pixelsHigh == (NSInteger)(30*(double)scale));
        assert(NSEqualSizes(rep.size, image.size));
        rep = [image bitmapImageRepresentationWithScaleFactor:scale];
        assert(rep.pixelsWide == (NSInteger)(40*(double)scale) && rep.pixelsHigh == (NSInteger)(30*(double)scale));
    }
    checkSize([NSImage resizeImage:image size:CGSizeMake(12, 8)], 24, 16);
    NSImage *crop = [NSImage cutImageToRect:image Rect:CGRectMake(5, 6, 12, 9)];
    checkSize(crop, 12, 9);
    assert(![NSImage cutImageToRect:nil Rect:CGRectZero]);
    assert(![NSImage cutImageToRect:[ThrowingImage new] Rect:CGRectZero]);
    assert(![NSImage createCGImageRefFromImage:[ThrowingImage new]]);
    CGImageRef ref = [NSImage createCGImageRefFromImage:image];
    assert(CGImageGetWidth(ref) == 40 && CGImageGetHeight(ref) == 30); CGImageRelease(ref);
    NSImage *fillet = [NSImage addFilletImgae:image withRadius:8];
    checkSize(fillet, 40, 30); assert(alphaAt(fillet, 0, 0) == 0 && alphaAt(fillet, 20, 15) == 255);
    NSImage *round = [NSImage addRoundImgae:image withRadius:8];
    checkSize(round, 40, 30); assert(alphaAt(round, 0, 0) == 0);
    checkSize([NSImage addShadow:image withSize:3.5f], 47, 37);
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:[image CGImageForProposedRect:NULL context:nil hints:nil]];
    NSData *png = [rep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
    unsigned char digest[16]; CC_MD5(png.bytes, (CC_LONG)png.length, digest);
    NSMutableString *expected = [NSMutableString string];
    for (int i = 0; i < 16; ++i) [expected appendFormat:@"%02x", digest[i]];
    assert([[NSImage md5WithImage:image] isEqual:expected]);
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSUUID.UUID.UUIDString stringByAppendingPathExtension:@"png"]];
    assert([png writeToFile:path atomically:YES]);
    NSImage *best = [NSImage imageOfBestRepresentationFrom:[NSURL fileURLWithPath:path]];
    checkSize(best, 40, 30); assert(best.representations.count > 0);
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    // Synthetic image only: no OCR test relies on OS model output or network downloads.
    assert([NSImage analysisQRCode:image] == nil);
    method_setImplementation(current, previous);
    puts("Imaging synthetic tests passed: dimensions, mixed reps, float ABI, scale/value pixels, crop/catch, radius, shadow, MD5, decoding, QR empty.");
} return 0; }
