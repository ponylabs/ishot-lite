#import "../MJMosaicUtil.h"
#import <ImageIO/ImageIO.h>
#define CHECK(x) do{if(!(x)){NSLog(@"FAIL %s",#x);abort();}}while(0)
@interface ThrowImage:NSImage @end
@implementation ThrowImage
- (NSData *)TIFFRepresentation { [NSException raise:@"fixture" format:@"Original NSException catch"];return nil; }
@end
static NSData *pixels(CGImageRef image){CGColorSpaceRef space=CGColorSpaceCreateDeviceRGB();CGContextRef context=CGBitmapContextCreate(NULL,5,5,8,20,space,1);CGContextDrawImage(context,CGRectMake(0,0,5,5),image);NSData *result=[NSData dataWithBytes:CGBitmapContextGetData(context) length:100];CGContextRelease(context);CGColorSpaceRelease(space);return result;}
int main(){@autoreleasepool{
 [NSApplication sharedApplication];CHECK([MJMosaicUtil createCGImageRefFromNSImage:nil]==NULL);CHECK([MJMosaicUtil createCGImageRefFromNSImage:[[ThrowImage alloc]initWithSize:NSMakeSize(5,5)]]==NULL);
 uint8_t bytes[100];for(int i=0;i<25;i++){bytes[i*4]=i*7;bytes[i*4+1]=i*3;bytes[i*4+2]=240-i*5;bytes[i*4+3]=255;}
 CGColorSpaceRef space=CGColorSpaceCreateDeviceRGB();CGContextRef context=CGBitmapContextCreate(bytes,5,5,8,20,space,1);CGImageRef cg=CGBitmapContextCreateImage(context);NSImage *input=[MJMosaicUtil createNSImageFromCGImageRef:cg];
 NSData *original=pixels(cg);NSImage *identity=[MJMosaicUtil transToMosaicImage:cg blockLevel:1];CGImageRef out=[identity CGImageForProposedRect:NULL context:nil hints:nil];CHECK([pixels(out)isEqualToData:original]);
 for(NSNumber *level in @[@0,@2]){NSImage *result=[MJMosaicUtil transToMosaicImage:cg blockLevel:level.unsignedIntegerValue];out=[result CGImageForProposedRect:NULL context:nil hints:nil];NSData *actual=pixels(out);const uint32_t *src=original.bytes,*dst=actual.bytes;
  for(unsigned y=0;y<5;y++)for(unsigned x=0;x<5;x++){unsigned sourceX=x,sourceY=y;if(x<4&&y<4){sourceX=level.unsignedIntValue?(x/2)*2:0;sourceY=level.unsignedIntValue?(y/2)*2:0;}CHECK(dst[y*5+x]==src[sourceY*5+sourceX]);}}
 CGImageRef pix=[MJMosaicUtil createMosaicImageFromCGImage:input blockLevel:2];CHECK(pix);NSLog(@"CIPixellate extent output %zu x %zu",CGImageGetWidth(pix),CGImageGetHeight(pix));CGImageRelease(pix);
 for(NSNumber *radius in @[@0,@1]){CGImageRef a=[MJMosaicUtil gaussianBlured:input Radius:radius.doubleValue],b=[MJMosaicUtil blurSourceImage:input Radius:radius.doubleValue];CHECK(a&&b&&CGImageGetWidth(a)==5&&CGImageGetHeight(b)==5);CGImageRelease(a);CGImageRelease(b);}
 CGImageRelease(cg);CGContextRelease(context);CGColorSpaceRelease(space);NSLog(@"PASS Mosaic pixel-block boundaries, zero level, NSException, conversion and blur");
}return 0;}
