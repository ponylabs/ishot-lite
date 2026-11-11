#import "MJMosaicUtil.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#pragma clang fp contract(off)
@implementation MJMosaicUtil
// 0x100014da0: despite the selector, argument is NSImage (metadata @, TIFFRepresentation call).
+ (CGImageRef)createMosaicImageFromCGImage:(NSImage *)image blockLevel:(NSUInteger)level {
 CIImage *input=[[CIImage alloc]initWithData:image.TIFFRepresentation];CIFilter *filter=[CIFilter filterWithName:@"CIPixellate"];
 [filter setValue:input forKey:kCIInputImageKey];[filter setValue:@(level) forKey:kCIInputScaleKey];CIImage *output=[filter valueForKey:kCIOutputImageKey];
 return [[CIContext contextWithOptions:nil]createCGImage:output fromRect:output.extent];
}
// 0x100014f08
+ (NSImage *)createNSImageFromCGImageRef:(CGImageRef)image {
 NSBitmapImageRep *bitmap=[[NSBitmapImageRep alloc]initWithCGImage:image];size_t height=CGImageGetHeight(image),width=CGImageGetWidth(image);
 NSImage *result=[[NSImage alloc]initWithSize:NSMakeSize((double)width,(double)height)];[result addRepresentation:bitmap];return result;
}
// 0x100014f8c: preserves the excluded last row/column and AArch64 zero-divisor quotient.
+ (NSImage *)transToMosaicImage:(CGImageRef)image blockLevel:(NSUInteger)level {
 CGColorSpaceRef space=CGColorSpaceCreateDeviceRGB();double width=(double)CGImageGetWidth(image),height=(double)CGImageGetHeight(image);
 int64_t w=(int64_t)width,h=(int64_t)height,rowBytes=(int64_t)(width*4.);
 CGContextRef source=CGBitmapContextCreate(NULL,w,h,8,rowBytes,space,1);CGContextDrawImage(source,CGRectMake(0,0,width,height),image);
 uint32_t *pixels=CGBitmapContextGetData(source);uint32_t color=0;
 for(uint64_t y=0;(double)y<height-1.;y++)for(uint64_t x=0;(double)x<width-1.;x++){
  int64_t index=(int64_t)((double)y*width+(double)x);
  uint64_t rowGroup=level?y/level:0;
  if(y==rowGroup*level){uint64_t colGroup=level?x/level:0;if(x==colGroup*level)color=pixels[index];else pixels[index]=color;}
  else pixels[index]=pixels[(int64_t)(width*(double)(y-1)+(double)x)];
 }
 CGDataProviderRef provider=CGDataProviderCreateWithData(NULL,pixels,(int64_t)(width*height*4.),NULL);
 CGImageRef modified=CGImageCreate(w,h,8,32,rowBytes,space,1,provider,NULL,false,kCGRenderingIntentDefault);
 CGContextRef destination=CGBitmapContextCreate(NULL,w,h,8,rowBytes,space,1);CGContextDrawImage(destination,CGRectMake(0,0,width,height),modified);
 CGImageRef result=CGBitmapContextCreateImage(destination);NSImage *output=[self createNSImageFromCGImageRef:result];
 if(result)CFRelease(result);if(modified)CFRelease(modified);if(space)CGColorSpaceRelease(space);if(provider)CGDataProviderRelease(provider);if(source)CGContextRelease(source);if(destination)CGContextRelease(destination);return output;
}
// 0x1000151ec: uses NSImage logical size as crop, not the filter's unbounded extent.
+ (CGImageRef)gaussianBlured:(NSImage *)image Radius:(double)radius {
 if(radius==0.)return [self createCGImageRefFromNSImage:image];
 CIImage *input=[[CIImage alloc]initWithData:image.TIFFRepresentation];CIFilter *filter=[CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey,input,@"inputRadius",@(radius),nil];
 CIImage *output=[filter valueForKey:@"outputImage"];CIContext *context=[CIContext contextWithOptions:nil];double width=image.size.width,height=image.size.height;
 return [context createCGImage:output fromRect:CGRectMake(0,0,width,height)];
}
// 0x1000153a4: clamp -> blur; radius is narrowed to float before NSNumber construction.
+ (CGImageRef)blurSourceImage:(NSImage *)image Radius:(double)radius {
 if(radius==0.)return [self createCGImageRefFromNSImage:image];
 CGRect rect=CGRectMake(0,0,image.size.width,image.size.height);CIContext *context=[CIContext contextWithOptions:nil];
 CGImageRef cg=[image CGImageForProposedRect:&rect context:nil hints:nil];CIImage *input=[CIImage imageWithCGImage:cg];
 CIFilter *clamp=[CIFilter filterWithName:@"CIAffineClamp"];[clamp setValue:input forKey:kCIInputImageKey];CGAffineTransform transform=CGAffineTransformMakeScale(1,1);
 [clamp setValue:[NSValue valueWithBytes:&transform objCType:"{CGAffineTransform=dddddd}"]forKey:@"inputTransform"];
 CIFilter *blur=[CIFilter filterWithName:@"CIGaussianBlur"];[blur setValue:clamp.outputImage forKey:kCIInputImageKey];[blur setValue:@((float)radius)forKey:@"inputRadius"];
 CIImage *output=[blur valueForKey:kCIOutputImageKey];return [context createCGImage:output fromRect:input.extent];
}
// 0x100014c5c; LSDA 0x1001a306c type2 binds _OBJC_EHTYPE_$_NSException.
+ (CGImageRef)createCGImageRefFromNSImage:(NSImage *)image {
 if(!image)return NULL;
 @try {
  NSData *data=image.TIFFRepresentation;if(!data)return NULL;
  CGImageSourceRef source=CGImageSourceCreateWithData((__bridge CFDataRef)data,NULL);
  NSDictionary *options=@{(__bridge NSString *)kCGImageSourceShouldCache:(__bridge id)kCFBooleanFalse,(__bridge NSString *)kCGImageSourceShouldAllowFloat:(__bridge id)kCFBooleanTrue};
  CGImageRef result=CGImageSourceCreateImageAtIndex(source,0,(__bridge CFDictionaryRef)options);if(source)CFRelease(source);return result;
 } @catch(NSException *exception){return NULL;}
}
@end
