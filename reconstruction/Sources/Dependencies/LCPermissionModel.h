#import <Foundation/Foundation.h>
@interface LCPermissionModel : NSObject
@property(nonatomic) NSInteger authType;
@property(nonatomic,copy) NSString *desc;
- (instancetype)initWithAuthType:(NSInteger)type desc:(NSString *)desc;
+ (instancetype)modelWithAuthType:(NSInteger)type desc:(NSString *)desc;
@end
