#import "NSValue+CGPoint.h"
@implementation NSValue (CGPoint)
// 0x1000471dc -> objc_stub::valueWithPoint: (0x100164620)
+ (NSValue *)valueWithCGPoint:(CGPoint)point { return [NSValue valueWithPoint:point]; }
// 0x1000471e8 -> objc_stub::pointValue (0x10015c380)
- (CGPoint)CGPointValue { return self.pointValue; }
// 0x1000471ec -> objc_stub::valueWithRect: (0x100164640)
+ (NSValue *)valueWithCGRect:(CGRect)rect { return [NSValue valueWithRect:rect]; }
// 0x1000471f8 -> objc_stub::rectValue (0x10015cd20)
- (CGRect)CGRectValue { return self.rectValue; }
@end
