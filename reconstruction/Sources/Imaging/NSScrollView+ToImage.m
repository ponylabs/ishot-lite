#import "NSScrollView+ToImage.h"
@implementation NSScrollView (ToImage)
- (NSImage *)toImage { // 0x1000bcd7c
 NSBitmapImageRep *bitmap=[self bitmapImageRepForCachingDisplayInRect:NSMakeRect(0,0,self.frame.size.width,self.frame.size.height)];
 [self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmap];
 NSImage *image=[[NSImage alloc]initWithSize:NSMakeSize(self.frame.size.width,self.frame.size.height)];[image addRepresentation:bitmap];return image;
}
- (NSImage *)toImageWithRect:(NSRect)rect { // 0x1000bce38
 NSBitmapImageRep *bitmap=[self bitmapImageRepForCachingDisplayInRect:rect];[self cacheDisplayInRect:rect toBitmapImageRep:bitmap];
 NSImage *image=[[NSImage alloc]initWithSize:rect.size];[image addRepresentation:bitmap];return image;
}
- (NSBitmapImageRep *)toBitmapImageRep { // 0x1000bced0: original does not cache display.
 return [self bitmapImageRepForCachingDisplayInRect:NSMakeRect(0,0,self.frame.size.width,self.frame.size.height)];
}
- (NSData *)toData {return [self toDataWithFileType:4];} // 0x1000bcf14
- (NSData *)toDataWithFileType:(NSBitmapImageFileType)type { // 0x1000bcf1c
 NSBitmapImageRep *bitmap=[self bitmapImageRepForCachingDisplayInRect:self.bounds];[self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmap];return [bitmap representationUsingType:type properties:@{}];
}
@end
