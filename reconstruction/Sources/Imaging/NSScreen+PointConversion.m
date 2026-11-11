#import "Imaging.h"
@implementation NSScreen (PointConversion)
+ (id)currentScreenForMouseLocation { // 0x1000b57bc
    NSPoint point = NSEvent.mouseLocation;
    NSEnumerator *enumerator = [NSScreen.screens objectEnumerator];
    NSScreen *screen;
    while ((screen = [enumerator nextObject])) if (NSMouseInRect(point, screen.frame, NO)) return screen;
    return nil;
}
- (CGPoint)convertPointToScreenCoordinates:(CGPoint)point { // 0x1000b5898
    float x = fabsf((float)(fabs(self.frame.origin.x) - fabs(point.x)));
    float y = (float)(point.y - self.frame.origin.y);
    return CGPointMake(x, y);
}
- (CGPoint)flipPoint:(CGPoint)point { return CGPointMake(point.x, self.frame.size.height - point.y); } // 0x1000b58f4
@end
