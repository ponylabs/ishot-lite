#import "../NSScrollView+ToImage.h"
#import <QuartzCore/QuartzCore.h>
extern NSImage *IShotFunction_10004cfe4(CALayer *);
@interface ImageFixture:NSScrollView
@property NSRect allocatedRect,cachedRect;
@property NSInteger caches;
@end
@implementation ImageFixture
- (NSBitmapImageRep *)bitmapImageRepForCachingDisplayInRect:(NSRect)r {
 self.allocatedRect=r;return [[NSBitmapImageRep alloc]initWithBitmapDataPlanes:NULL pixelsWide:r.size.width pixelsHigh:r.size.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:32];
}
- (void)cacheDisplayInRect:(NSRect)r toBitmapImageRep:(NSBitmapImageRep *)bitmap {
 self.cachedRect=r;self.caches++;for(NSInteger y=0;y<bitmap.pixelsHigh;y++)for(NSInteger x=0;x<bitmap.pixelsWide;x++)[bitmap setColor:[NSColor colorWithDeviceRed:1 green:0 blue:0 alpha:1] atX:x y:y];
}
@end
int main(){@autoreleasepool{
 [NSApplication sharedApplication];ImageFixture *view=[[ImageFixture alloc]initWithFrame:NSMakeRect(7,9,40,30)];view.bounds=NSMakeRect(2,3,20,15);
 NSImage *image=[view toImage];NSCAssert(NSEqualRects(view.allocatedRect,NSMakeRect(0,0,40,30)),@"frame-sized allocation");NSCAssert(NSEqualRects(view.cachedRect,view.bounds)&&NSEqualSizes(image.size,NSMakeSize(40,30)),@"bounds cache, frame image");
 NSRect crop=NSMakeRect(3,4,12,10);image=[view toImageWithRect:crop];NSCAssert(NSEqualRects(view.cachedRect,crop)&&NSEqualSizes(image.size,crop.size),@"crop rectangle");NSInteger before=view.caches;[view toBitmapImageRep];NSCAssert(view.caches==before,@"original allocation-only behavior");
 NSData *png=[view toData];const unsigned char *bytes=png.bytes;NSCAssert(png.length>8&&bytes[0]==137&&bytes[1]=='P',@"default PNG serialization");NSCAssert(NSEqualRects(view.cachedRect,view.bounds),@"data caches bounds");
 CALayer *layer=[CALayer layer];layer.bounds=CGRectMake(0,0,16,12);layer.backgroundColor=NSColor.redColor.CGColor;image=IShotFunction_10004cfe4(layer);NSCAssert(NSEqualSizes(image.size,NSMakeSize(16,12)),@"layer bitmap geometry");NSBitmapImageRep *rep=[[NSBitmapImageRep alloc]initWithCGImage:[image CGImageForProposedRect:NULL context:nil hints:nil]];NSColor *pixel=[[rep colorAtX:8 y:6]colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace];NSCAssert(pixel.redComponent>.99&&pixel.greenComponent<.01,@"layer render pixels");
 NSLog(@"PASS scroll image allocation/cache/crop/PNG and layer raster tests");
}}
