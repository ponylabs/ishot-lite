#import <Cocoa/Cocoa.h>
@interface NSValue (CGPoint)
+ (NSValue *)valueWithCGPoint:(CGPoint)point;
+ (NSValue *)valueWithCGRect:(CGRect)rect;
- (CGPoint)CGPointValue;
- (CGRect)CGRectValue;
@end
