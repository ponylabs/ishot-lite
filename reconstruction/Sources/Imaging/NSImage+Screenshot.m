#import "Imaging.h"
#import <ImageIO/ImageIO.h>
#import <Quartz/Quartz.h>
#import <Vision/Vision.h>
#import <CommonCrypto/CommonDigest.h>
extern NSScreen *IShotGlobal_1001dde80;
extern BOOL IShotGlobal_1001de089;
extern void IShotFunction_100047ffc(NSString *);
@interface WebpConverter : NSObject
+ (NSData *)convertImageToWebP:(NSImage *)image configBlock:(void (^)(void *))block error:(NSError **)error;
@end
@interface Global : NSObject
+ (CGRect)calcuateRealRectFromIMageRef:(CGImageRef)image withOriginalRect:(CGRect)rect;
@end
@interface SnipUtil : NSObject
+ (CGRect)cgWindowRectToScreenRect:(CGRect)rect;
@end
// Explicit symbol aliases preserve the shipped calls also on SDKs marking them unavailable.
extern CGImageRef IShotCGWindowListCreateImage(CGRect, CGWindowListOption, CGWindowID, CGWindowImageOption) __asm__("_CGWindowListCreateImage");
extern CGImageRef IShotCGWindowListCreateImageFromArray(CGRect, CFArrayRef, CGWindowImageOption) __asm__("_CGWindowListCreateImageFromArray");
extern CGImageRef IShotCGDisplayCreateImage(CGDirectDisplayID) __asm__("_CGDisplayCreateImage");
extern CGImageRef IShotCGDisplayCreateImageForRect(CGDirectDisplayID, CGRect) __asm__("_CGDisplayCreateImageForRect");

// 0x10003f474; float normalization and half-size operations are intentional.
static void IShotRoundedPath(CGContextRef context, CGRect rect, float rx, float ry) {
    if (rx == 0 || ry == 0) { CGContextAddRect(context, rect); return; }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, rx, ry);
    float width = CGRectGetWidth(rect) / (double)rx;
    float height = CGRectGetHeight(rect) / (double)ry;
    CGContextMoveToPoint(context, width, height * 0.5f);
    CGContextAddArcToPoint(context, width, height, width * 0.5f, height, 1);
    CGContextAddArcToPoint(context, 0, height, 0, height * 0.5f, 1);
    CGContextAddArcToPoint(context, 0, 0, width * 0.5f, 0, 1);
    CGContextAddArcToPoint(context, width, 0, width, height * 0.5f, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
@implementation NSImage (Screenshot)
- (id)normalRGBBitmapImageRepresentationWithScaleFactor:(double)scale { // 0x1000bd110
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:(NSInteger)(self.size.width*scale) pixelsHigh:(NSInteger)(self.size.height*scale) bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    rep.size = self.size;
    NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext.currentContext = context;
    [self drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1];
    [context flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    return rep;
}
- (id)bitmapImageRepresentationWithScaleFactor:(float)scale { // 0x1000bd238
    NSData *profile = IShotGlobal_1001dde80.colorSpace.ICCProfileData;
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:(NSInteger)(self.size.width*(double)scale) pixelsHigh:(NSInteger)(self.size.height*(double)scale) bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    rep = [rep bitmapImageRepByConvertingToColorSpace:[[NSColorSpace alloc] initWithICCProfileData:profile] renderingIntent:0];
    rep.size = self.size;
    NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext.currentContext = context;
    context.imageInterpolation = scale == 1 ? 2 : 3;
    context.shouldAntialias = YES;
    context.compositingOperation = 1;
    [self drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:1 fraction:1];
    [context flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    return rep;
}
- (long long)pixelsWide { // 0x1000a69e4
    NSInteger bitmap = 0, other = 0;
    for (NSImageRep *rep in self.representations) {
        if ([rep isKindOfClass:NSBitmapImageRep.class]) bitmap = MAX(bitmap, rep.pixelsWide);
        else other = MAX(other, rep.pixelsWide);
    }
    return bitmap ? bitmap : other;
}
- (long long)pixelsHigh { // 0x1000a6b58
    NSInteger bitmap = 0, other = 0;
    for (NSImageRep *rep in self.representations) {
        if ([rep isKindOfClass:NSBitmapImageRep.class]) bitmap = MAX(bitmap, rep.pixelsHigh);
        else other = MAX(other, rep.pixelsHigh);
    }
    return bitmap ? bitmap : other;
}
- (CGSize)pixelSize { return CGSizeMake(self.pixelsWide, self.pixelsHigh); } // 0x1000a6ccc
+ (id)imageOfBestRepresentationFrom:(id)url { // 0x1000bcfa0
    NSArray *reps = [NSBitmapImageRep imageRepsWithContentsOfURL:url];
    NSInteger width = 0, height = 0;
    for (NSImageRep *rep in reps) { width = MAX(width, rep.pixelsWide); height = MAX(height, rep.pixelsHigh); }
    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(width, height)];
    [image addRepresentations:reps]; return image;
}
+ (id)imageFullScreen { // 0x10003cfb4
    CGImageRef ref = IShotCGWindowListCreateImage(CGRectInfinite, 1, 0, 0);
    NSScreen *screen = NSScreen.mainScreen;
    double scale = [screen respondsToSelector:@selector(backingScaleFactor)] ? screen.backingScaleFactor : 1;
    NSImage *image = [[NSImage alloc] initWithCGImage:ref size:NSMakeSize(CGImageGetWidth(ref)/scale, CGImageGetHeight(ref)/scale)];
    if (ref) CFRelease(ref); return image;
}
+ (id)imageMainFullScreen { // 0x10003d0ac
    NSSize size = NSScreen.mainScreen.frame.size;
    CGImageRef ref = IShotCGDisplayCreateImage(CGMainDisplayID());
    NSImage *image = [[NSImage alloc] initWithCGImage:ref size:size];
    if (ref) CFRelease(ref); return image;
}
+ (id)imageMainScreenForRect:(CGRect)rect { // 0x10003d134
    CGRect capture = CGRectMake(rect.origin.x, NSScreen.mainScreen.frame.size.height-rect.size.height-rect.origin.y, rect.size.width, rect.size.height);
    CGImageRef ref = IShotCGDisplayCreateImageForRect(CGMainDisplayID(), capture);
    NSImage *image = [[NSImage alloc] initWithCGImage:ref size:rect.size];
    if (ref) CFRelease(ref); return image;
}
+ (id)imageRectangleScreen:(CGRect)rect exceptWinodws:(id)windows { // 0x10003d1f0 / block 0x10003d37c
    if (CGRectIsNull(rect)) return nil;
    CFArrayRef list = CGWindowListCreate(1, 0);
    CFMutableArrayRef mutable = CFArrayCreateMutableCopy(NULL, 0, list);
    for (CFIndex index = CFArrayGetCount(mutable)-1; index >= 0; --index) {
        CGWindowID windowID = (CGWindowID)(uintptr_t)CFArrayGetValueAtIndex(mutable, index);
        [windows enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            if ([object isKindOfClass:NSNumber.class] && [object unsignedIntValue] == windowID) CFArrayRemoveValueAtIndex(mutable, index);
        }];
    }
    CGImageRef ref = IShotCGWindowListCreateImageFromArray(rect, mutable, 0x10);
    CFRelease(list); CFRelease(mutable);
    NSImage *image = [[NSImage alloc] initWithCGImage:ref size:rect.size];
    if (ref) CFRelease(ref); return image;
}
+ (id)captureCurrentScreenshot:(CGRect)rect { // 0x10003d3e0
    CGImageRef ref = IShotCGWindowListCreateImage(rect, 1, 0, 0);
    NSImage *image = [[NSImage alloc] initWithCGImage:ref size:rect.size];
    if (ref) CFRelease(ref); return image;
}
+ (id)captureScreenshot { // 0x10003d44c
    CGImageRef ref = IShotCGWindowListCreateImage(CGRectInfinite, 1, 0, 0);
    NSImage *image = [[NSImage alloc] initWithCGImage:ref size:NSMakeSize(CGImageGetWidth(ref), CGImageGetHeight(ref))];
    if (ref) CFRelease(ref); return image;
}
+ (id)captureScreenhotBelowWindow:(id)window onRect:(CGRect)rect { // 0x10003d4dc
    CGImageRef ref = IShotCGWindowListCreateImage(rect, 4, (CGWindowID)[window windowNumber], 0);
    NSImage *image = [[NSImage alloc] initWithCGImage:ref size:NSMakeSize(CGImageGetWidth(ref), CGImageGetHeight(ref))];
    if (ref) CFRelease(ref); return image;
}
+ (id)captureWindowWithWindowID:(unsigned int)windowID { // 0x10003d58c
    float scale = IShotGlobal_1001dde80.backingScaleFactor;
    CGImageRef ref = IShotCGWindowListCreateImage(CGRectNull, 8, windowID, 0);
    NSImage *image = [[NSImage alloc] initWithCGImage:ref size:NSMakeSize((float)CGImageGetWidth(ref)/scale, (float)CGImageGetHeight(ref)/scale)];
    if (ref) CFRelease(ref); return image;
}
+ (void)saveImageToPaste:(id)image { // 0x10003d644
    if (!IShotGlobal_1001dde80) IShotGlobal_1001dde80 = NSScreen.mainScreen;
    NSBitmapImageRep *rep = [NSUserDefaults.standardUserDefaults boolForKey:@"genericRGBProfile"] ? [image normalRGBBitmapImageRepresentationWithScaleFactor:IShotGlobal_1001dde80.backingScaleFactor] : [image bitmapImageRepresentationWithScaleFactor:(float)IShotGlobal_1001dde80.backingScaleFactor];
    NSData *data = [rep representationUsingType:4 properties:@{}];
    NSPasteboard *pasteboard = NSPasteboard.generalPasteboard;
    [pasteboard clearContents]; [pasteboard setData:data forType:NSPasteboardTypePNG];
}
+ (id)cutImageToRect:(id)image Rect:(CGRect)rect { // 0x10003d77c; LSDA type index 2 = NSException
    if (!image) return nil;
    @try {
        NSData *data = [image TIFFRepresentation];
        if (!data) return nil;
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        NSDictionary *options = @{(__bridge id)kCGImageSourceShouldCache:@NO, (__bridge id)kCGImageSourceShouldAllowFloat:@YES};
        CGImageRef original = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef)options);
        if (source) CFRelease(source);
        CGImageRef crop = CGImageCreateWithImageInRect(original, rect);
        if (original) CFRelease(original);
        NSImage *result = [[NSImage alloc] initWithCGImage:crop size:NSZeroSize];
        if (crop) CFRelease(crop);
        return result;
    } @catch (NSException *exception) { return nil; }
}
+ (CGImageRef)createCGImageRefFromImage:(id)image { // 0x10003d940; returned +1 CGImage
    if (!image) return NULL;
    @try {
        NSData *data = [image TIFFRepresentation];
        if (!data) return NULL;
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        NSDictionary *options = @{(__bridge id)kCGImageSourceShouldCache:@NO, (__bridge id)kCGImageSourceShouldAllowFloat:@YES};
        CGImageRef result = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef)options);
        if (source) CFRelease(source);
        return result;
    } @catch (NSException *exception) { return NULL; }
}
+ (void)saveImage:(id)image toFile:(id)file withType:(unsigned long long)type { // 0x10003da84
    [NSUserDefaults.standardUserDefaults setObject:file forKey:@"LastSavedFile"];
    [NSUserDefaults.standardUserDefaults synchronize];
    if (!IShotGlobal_1001dde80) IShotGlobal_1001dde80 = NSScreen.mainScreen;
    double backing = IShotGlobal_1001dde80.backingScaleFactor;
    BOOL normal = [NSUserDefaults.standardUserDefaults boolForKey:@"nomalQualityImage"];
    BOOL generic = [NSUserDefaults.standardUserDefaults boolForKey:@"genericRGBProfile"];
    double scale = normal && (float)backing >= 2 ? 1 : IShotGlobal_1001dde80.backingScaleFactor;
    NSBitmapImageRep *rep = generic ? [image normalRGBBitmapImageRepresentationWithScaleFactor:scale] : [image bitmapImageRepresentationWithScaleFactor:(float)scale];
    if (type == 100000) {
        NSImage *converted = [[NSImage alloc] initWithCGImage:rep.CGImage size:[image size]];
        NSError *error = nil;
        NSData *data = [WebpConverter convertImageToWebP:converted configBlock:^(void *configuration) { // 0x10003e1ec
            *(int *)configuration = 0;
            *(int *)((char *)configuration + 8) = 4;
        } error:&error];
        if (!error) [self saveData:data toFile:file]; else NSBeep();
    } else if (type == 100001) {
        CIImage *ciImage = [[CIImage alloc] initWithBitmapImageRep:rep];
        CIContext *context = [CIContext context];
        CGColorSpaceRef colorSpace = rep.colorSpace.CGColorSpace;
        if (@available(macOS 10.13.4, *)) {
            NSURL *url = [NSURL fileURLWithPath:file];
            NSDictionary *options = @{NSImageCompressionFactor:@0.7};
            dispatch_async(dispatch_get_global_queue(0, 0), ^{ // 0x10003e0b0
                if ([context writeHEIFRepresentationOfImage:ciImage toURL:url format:kCIFormatRGBA8 colorSpace:colorSpace options:options error:NULL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{ [self postNotificationOrOpenFile:file]; }); // 0x10003e160
                }
            });
        } else NSBeep();
    } else if (type == 100002) {
        NSImage *converted = [[NSImage alloc] initWithCGImage:rep.CGImage size:[image size]];
        PDFPage *page = [[PDFPage alloc] initWithImage:converted];
        PDFDocument *document = [[PDFDocument alloc] init];
        [document insertPage:page atIndex:0];
        NSData *data = document.dataRepresentation;
        if (data) [self saveData:data toFile:file]; else NSBeep();
    } else {
        NSDictionary *options = type == 0 ? @{NSImageCompressionMethod:@1.0f} : @{NSImageCompressionFactor:@(type == 4 ? 1.0f : 0.85f)};
        NSData *data = [rep representationUsingType:type properties:options];
        if (data) [self saveData:data toFile:file]; else NSBeep();
    }
}
+ (void)saveData:(id)data toFile:(id)file { // 0x10003e1fc
    if ([data writeToFile:file atomically:YES]) [self postNotificationOrOpenFile:file]; else NSBeep();
}
+ (void)postNotificationOrOpenFile:(id)file { // 0x10003e25c
    if (!IShotGlobal_1001de089) {
        IShotFunction_100047ffc([@"TelliShotHelperToUserNotification:" stringByAppendingString:file]);
    } else {
        IShotGlobal_1001de089 = NO;
        NSDictionary *app = [NSUserDefaults.standardUserDefaults objectForKey:@"appOfUserSpecified"];
        NSString *executable = app[@"executableName"] ?: @"Preview";
        NSString *identifier = app[@"bundleIdentifier"];
        if ([identifier isEqualToString:@"com.apple.finder"]) [NSWorkspace.sharedWorkspace selectFile:file inFileViewerRootedAtPath:[file stringByDeletingLastPathComponent]];
        else [NSWorkspace.sharedWorkspace openFile:file withApplication:executable];
        NSArray *running = [NSRunningApplication runningApplicationsWithBundleIdentifier:identifier ?: @"com.apple.Preview"];
        if (running.count) [running[0] activateWithOptions:2];
    }
}
+ (id)resizeImage:(id)image size:(CGSize)size { // 0x10003ed20
    NSData *data = [image TIFFRepresentation];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    float scale = [[NSScreen currentScreenForMouseLocation] backingScaleFactor];
    if (!source) return nil;
    CGImageRef original = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CFRelease(source);
    size.width *= (double)scale; size.height *= (double)scale;
    CGContextRef context = CGBitmapContextCreate(NULL, (size_t)size.width, (size_t)size.height, 8, 0, NSColorSpace.genericRGBColorSpace.CGColorSpace, 0x2002);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), original);
    CGImageRef output = CGBitmapContextCreateImage(context);
    if (context) CGContextRelease(context);
    NSImage *result = [[NSImage alloc] initWithCGImage:output size:size];
    if (output) CGImageRelease(output); if (original) CGImageRelease(original);
    return result;
}
+ (id)resizeImage:(id)image scale:(float)scale addShadowWithColor:(id)color { // 0x10003ee8c
    NSData *data = [image TIFFRepresentation];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    NSSize size = [image size];
    if (!source) return nil;
    int padding = (int)(scale * 6.0f);
    double doubled = (int)(padding << 1);
    size.width = size.width * (double)scale + doubled; size.height = size.height * (double)scale + doubled;
    CGImageRef original = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CFRelease(source);
    CGContextRef context = CGBitmapContextCreate(NULL, (size_t)size.width, (size_t)size.height, 8, 0, NSColorSpace.genericRGBColorSpace.CGColorSpace, 0x2002);
    CGContextSetShadowWithColor(context, CGSizeZero, (double)padding * 1.5, [color CGColor]);
    CGContextDrawImage(context, CGRectMake(padding, padding, size.width-doubled, size.height-doubled), original);
    CGImageRef output = CGBitmapContextCreateImage(context);
    if (context) CGContextRelease(context);
    NSImage *result = [[NSImage alloc] initWithCGImage:output size:size];
    if (output) CGImageRelease(output); if (original) CGImageRelease(original);
    return result;
}
+ (id)resizeImage:(id)image scale:(float)scale { // 0x10003f054
    NSData *data = [image TIFFRepresentation];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    NSSize size = [image size];
    if (!source) return nil;
    size.width *= (double)scale; size.height *= (double)scale;
    CGImageRef original = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CFRelease(source);
    CGContextRef context = CGBitmapContextCreate(NULL, (size_t)size.width, (size_t)size.height, 8, 0, NSColorSpace.genericRGBColorSpace.CGColorSpace, 0x2002);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), original);
    CGImageRef output = CGBitmapContextCreateImage(context);
    if (context) CGContextRelease(context);
    NSImage *result = [[NSImage alloc] initWithCGImage:output size:size];
    if (output) CGImageRelease(output); if (original) CGImageRelease(original);
    return result;
}
+ (id)addRoundImgae:(id)image withRadius:(float)radius { // 0x10003f1b0
    NSImage *result = [[NSImage alloc] initWithSize:NSMakeSize([image size].width, [image size].height)];
    [result lockFocus];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 0, [image size].width, [image size].height) xRadius:radius yRadius:radius];
    [NSGraphicsContext saveGraphicsState];
    [path addClip];
    [(NSImage *)image drawInRect:NSMakeRect(0, 0, [image size].width, [image size].height)];
    [NSGraphicsContext restoreGraphicsState];
    [result unlockFocus]; return result;
}
+ (id)addFilletImgae:(id)image withRadius:(float)radius { // 0x10003f2cc
    NSData *data = [image TIFFRepresentation];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (!source) return nil;
    CGImageRef original = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CFRelease(source);
    NSSize size = NSMakeSize([image size].width, [image size].height);
    CGContextRef context = CGBitmapContextCreate(NULL, (size_t)size.width, (size_t)size.height, 8, 0, NSColorSpace.genericRGBColorSpace.CGColorSpace, 0x2002);
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, [image size].width, [image size].height);
    IShotRoundedPath(context, rect, radius, radius);
    CGContextClosePath(context); CGContextClip(context);
    CGContextDrawImage(context, rect, original);
    CGImageRef output = CGBitmapContextCreateImage(context);
    if (context) CGContextRelease(context);
    NSImage *result = [[NSImage alloc] initWithCGImage:output size:[image size]];
    if (output) CGImageRelease(output); if (original) CGImageRelease(original);
    return result;
}
+ (id)resizeImage:(id)image value:(float)value { // 0x10003f644
    NSData *data = [image TIFFRepresentation];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    NSSize size = NSMakeSize([image size].width, [image size].height);
    if (!source) return nil;
    CGImageRef original = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CFRelease(source);
    size.width *= (double)value; size.height *= (double)value;
    CGContextRef context = CGBitmapContextCreate(NULL, (size_t)size.width, (size_t)size.height, 8, 0, NSColorSpace.genericRGBColorSpace.CGColorSpace, 0x2002);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), original);
    CGImageRef output = CGBitmapContextCreateImage(context);
    if (context) CGContextRelease(context);
    NSImage *result = [[NSImage alloc] initWithCGImage:output size:size];
    if (output) CGImageRelease(output); if (original) CGImageRelease(original);
    return result;
}
+ (id)addShadow:(id)image withSize:(float)padding { // 0x10003f7a8
    double doubled = (double)(padding + padding);
    NSImage *result = [[NSImage alloc] initWithSize:NSMakeSize([image size].width+doubled, [image size].height+doubled)];
    [result lockFocus]; [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext *context = NSGraphicsContext.currentContext;
    NSColor *color = [NSColor.shadowColor colorWithAlphaComponent:0.3];
    NSData *stored = [NSUserDefaults.standardUserDefaults objectForKey:@"colorOfShadow"];
    if (stored) color = [NSKeyedUnarchiver unarchiveObjectWithData:stored];
    CGContextSetShadowWithColor((CGContextRef)context.graphicsPort, CGSizeZero, (double)padding * 1.1, color.CGColor);
    [(NSImage *)image drawInRect:NSMakeRect(padding, padding, [image size].width, [image size].height)];
    [NSGraphicsContext restoreGraphicsState]; [result unlockFocus]; return result;
}
+ (id)analysisQRCode:(id)image { // 0x10003f99c
    CIContext *context = [CIContext contextWithOptions:nil];
    // The shipped key/value ordering is reversed from the usual detector option.
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracyHigh:CIDetectorTypeQRCode}];
    NSRect rect = NSMakeRect(0, 0, [image size].width, [image size].height);
    CIImage *ciImage = [CIImage imageWithCGImage:[image CGImageForProposedRect:&rect context:nil hints:nil]];
    NSArray *features = [detector featuresInImage:ciImage];
    if (!features.count) return nil;
    NSMutableArray *result = [NSMutableArray new];
    for (CIQRCodeFeature *feature in features) [result addObject:feature.messageString];
    return result;
}
+ (id)ocrFromImage:(id)image { // 0x10003fc04; completion 0x10003feb0
    if (@available(macOS 10.15, *)) {
        id codes = [self analysisQRCode:image];
        if ([codes count]) return codes;
        NSMutableArray *result = [NSMutableArray new];
        VNRecognizeTextRequest *request = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError *error) {
            if (error) { NSLog(@"error = %@", error); return; }
            for (VNRecognizedTextObservation *observation in request.results) {
                if ([observation isKindOfClass:VNRecognizedTextObservation.class]) {
                    for (VNRecognizedText *candidate in [observation topCandidates:2]) [result addObject:candidate.string];
                }
            }
        }];
        request.recognitionLevel = 0;
        request.minimumTextHeight = 0.001f;
        request.recognitionLanguages = @[@"zh-Hans", @"zh-Hant", @"en-US", @"fr-FR", @"it-IT", @"de-DE", @"es-ES", @"pt-BR"];
        request.usesLanguageCorrection = NO;
        VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:[image CGImageForProposedRect:NULL context:nil hints:nil] orientation:1 options:@{}];
        NSError *error = nil;
        [handler performRequests:@[request] error:&error];
        return result;
    }
    return nil;
}
+ (id)ocrGetTextYFromImage:(id)image { // 0x1000400c4; completion 0x1000402b0
    if (@available(macOS 10.15, *)) {
        NSMutableArray *result = [NSMutableArray new];
        VNRecognizeTextRequest *request = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError *error) {
            if (error) { NSLog(@"error = %@", error); return; }
            for (VNRecognizedTextObservation *observation in request.results) {
                if ([observation isKindOfClass:VNRecognizedTextObservation.class]) {
                    CGRect box = observation.boundingBox;
                    CGRect rect = VNImageRectForNormalizedRect(box, (size_t)[image size].width, (size_t)[image size].height);
                    NSInteger y = (NSInteger)(rect.origin.y + rect.size.height * 0.5 + 0.5);
                    if (![result containsObject:@(y)]) [result addObject:@(y)];
                }
            }
        }];
        VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:[image CGImageForProposedRect:NULL context:nil hints:nil] orientation:1 options:@{}];
        NSError *error = nil;
        [handler performRequests:@[request] error:&error];
        return result;
    }
    return nil;
}
+ (id)md5WithImage:(id)image { // 0x1000404dc
    NSMutableData *data = [NSMutableData data];
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:[image CGImageForProposedRect:NULL context:nil hints:nil]];
    [data appendData:[rep representationUsingType:4 properties:@{}]];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:32];
    for (int i = 0; i != 16; ++i) [result appendFormat:@"%02x", digest[i]];
    return result;
}
+ (id)getImageWindowUnderMouse { // 0x10003e438; never invoked by synthetic tests
    CGEventRef event = CGEventCreate(NULL);
    CGPoint point = CGEventGetLocation(event);
    if (event) CFRelease(event);
    double height = NSScreen.deepestScreen.frame.size.height;
    NSArray *windows = CFBridgingRelease(CGWindowListCopyWindowInfo(1, 0));
    CGRect windowRect = CGRectZero;
    NSMutableArray *menuHeights = [NSMutableArray array];
    for (NSUInteger i = 0; i < windows.count; ++i) {
        NSDictionary *window = windows[i];
        int layer = [window[@"kCGWindowLayer"] intValue];
        NSString *name = window[@"kCGWindowName"], *owner = window[@"kCGWindowOwnerName"];
        if (layer == 24 && [name isEqualToString:@"Menubar"] && ([owner isEqualToString:@"Window Server"] || [owner isEqualToString:@"WindowServer"])) {
            id value = window[@"kCGWindowBounds"][@"Height"];
            if (![menuHeights containsObject:value]) [menuHeights addObject:value];
        }
    }
    NSScreen *screen = [NSScreen currentScreenForMouseLocation];
    int layer = 0;
    CGWindowID windowID = UINT32_MAX;
    NSString *name = nil;
    BOOL adjusted = NO;
    point.y = height - point.y;
    for (NSUInteger i = 0; i < windows.count; ++i) {
        NSDictionary *window = windows[i], *bounds = window[@"kCGWindowBounds"];
        NSString *owner = window[@"kCGWindowOwnerName"] ?: @"";
        name = window[@"kCGWindowName"] ?: @"";
        CFNumberGetValue((__bridge CFNumberRef)window[(__bridge id)kCGWindowLayer], 3, &layer);
        if ((layer == 3 && [owner isEqualToString:@"LyricsX"] && screen.frame.size.height == [window[@"Height"] intValue]) ||
            ([name isEqualToString:@"Cursor"] && ([owner isEqualToString:@"Window Server"] || [owner isEqualToString:@"WindowServer"])) ||
            (layer == 1000 && ([owner isEqualToString:@"TencentMeeting"] || [owner isEqualToString:@"腾讯会议"])) ||
            (layer == 0 && [owner isEqualToString:@"HazeOver"] && screen.frame.size.height == [window[@"Height"] intValue])) {
            adjusted = NO; continue;
        }
        windowID = [window[@"kCGWindowNumber"] intValue];
        CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)window[(__bridge id)kCGWindowBounds], &windowRect);
        adjusted = [name isEqualToString:@"mappingWindowByiShot"];
        if (adjusted) windowRect = CGRectMake([bounds[@"X"] intValue]+6, [bounds[@"Y"] intValue]+6, [bounds[@"Width"] intValue]-12, [bounds[@"Height"] intValue]-12);
        if (layer < 0 && ![name hasPrefix:@"Desktop Picture -"] && ![name hasPrefix:@"Wallpaper-"]) continue;
        if (layer == 25 && [menuHeights containsObject:window[@"Height"]]) continue;
        if (layer > 0 && layer != 24 && ![name isEqualToString:@"mappingWindowByiShot"]) {
            CGImageRef ref = IShotCGWindowListCreateImage(CGRectNull, 8, [window[@"kCGWindowNumber"] intValue], 1);
            if (ref) {
                CGRect original = CGRectZero;
                CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)window[(__bridge id)kCGWindowBounds], &original);
                CGRect real = [Global calcuateRealRectFromIMageRef:ref withOriginalRect:original];
                if (real.size.width < 10 || real.size.height < 10) { CFRelease(ref); continue; }
                if (fabs(real.size.width-original.size.width) > 5 || fabs(real.size.height-original.size.height) > 5) { adjusted = YES; windowRect = real; }
                CFRelease(ref);
            }
        }
        if (CGRectContainsPoint([SnipUtil cgWindowRectToScreenRect:windowRect], point)) break;
    }
    CGRect rect = adjusted ? windowRect : CGRectNull;
    CGWindowListOption listOptions = 8;
    CGWindowImageOption imageOptions = 1;
    if (!adjusted && layer == 24 && [name isEqualToString:@"Menubar"]) { rect = windowRect; windowID = 0; listOptions = 1; imageOptions = 0; }
    CGImageRef ref = IShotCGWindowListCreateImage(rect, listOptions, windowID, imageOptions);
    NSImage *result = [[NSImage alloc] initWithCGImage:ref size:windowRect.size];
    if (ref) CFRelease(ref);
    return result;
}
@end
