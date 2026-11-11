#import <AppKit/AppKit.h>
@interface SnipUtil : NSObject
+ (BOOL)isPoint:(NSPoint)point inRect:(NSRect)rect;
+ (double)pointDistance:(NSPoint)a toPoint:(NSPoint)b;
+ (NSRect)uniformRect:(NSRect)rect;
+ (NSRect)rectToZero:(NSRect)rect;
+ (NSRect)cgWindowRectToScreenRect:(NSRect)rect;
@end
