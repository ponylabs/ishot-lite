#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
// 0x10004cfe4: render a CALayer into an RGBA bitmap at its unscaled bounds size.
NSImage *IShotFunction_10004cfe4(CALayer *layer) {
 NSInteger width=(NSInteger)layer.bounds.size.width;
 NSInteger height=(NSInteger)layer.bounds.size.height;
 NSInteger rowBytes=(NSInteger)(layer.bounds.size.width*4.);
 NSBitmapImageRep *bitmap=[[NSBitmapImageRep alloc]initWithBitmapDataPlanes:NULL pixelsWide:width pixelsHigh:height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:rowBytes bitsPerPixel:32];
 NSGraphicsContext *context=[NSGraphicsContext graphicsContextWithBitmapImageRep:bitmap];
 [NSGraphicsContext saveGraphicsState];[NSGraphicsContext setCurrentContext:context];
 [layer renderInContext:NSGraphicsContext.currentContext.CGContext];[NSGraphicsContext restoreGraphicsState];
 return [[NSImage alloc]initWithCGImage:bitmap.CGImage size:bitmap.size];
}
