#import "RoundedPreviewLayer.h"
@implementation RoundedPreviewLayer
// 0x100004b50; 0x4024000000000000 is double 10.0.
- (void)layoutSublayers {
    [super layoutSublayers];
    self.cornerRadius = 10.0;
    self.masksToBounds = YES;
}
@end
