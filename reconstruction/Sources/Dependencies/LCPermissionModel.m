#import "LCPermissionModel.h"
@implementation LCPermissionModel
// 0x10009f630 uses a strong ivar store, whereas the generated setter copies.
- (instancetype)initWithAuthType:(NSInteger)type desc:(NSString *)desc { if((self=[super init])) { _authType=type; _desc=desc; } return self; }
+ (instancetype)modelWithAuthType:(NSInteger)type desc:(NSString *)desc { return [[self alloc] initWithAuthType:type desc:desc]; }
@end
