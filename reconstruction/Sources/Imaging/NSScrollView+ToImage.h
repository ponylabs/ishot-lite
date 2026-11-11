#pragma once
#import <Cocoa/Cocoa.h>
@interface NSScrollView (ToImage)
- (NSImage *)toImage;
- (NSImage *)toImageWithRect:(NSRect)rect;
- (NSBitmapImageRep *)toBitmapImageRep;
- (NSData *)toData;
- (NSData *)toDataWithFileType:(NSBitmapImageFileType)type;
@end
