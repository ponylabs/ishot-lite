#import "SRRecorderControlWithTagid.h"
@implementation SRRecorderControlWithTagid
// 0x100046b1c / 0x100046b2c: direct ivar access, including the original tagis_ spelling.
- (NSInteger)tagid { return tagis_; }
- (void)setTagid:(NSInteger)value { tagis_ = value; }
@end
