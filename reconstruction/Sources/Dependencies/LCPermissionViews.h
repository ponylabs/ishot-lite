#import <AppKit/AppKit.h>
#import "LCPermissionModel.h"
@interface LCPermissionView : NSView
@end
@interface LCPermissionBoxView : NSBox
- (void)setBackgroundColor;
@end
@interface LCPermissionItem : NSView
@property(nonatomic,strong) NSImageView *iconView;
@property(nonatomic,strong) NSTextField *permissionDesLabel;
@property(nonatomic,strong) NSTextField *infoLabel;
@property(nonatomic,strong) NSButton *authButton;
@property(nonatomic,strong) LCPermissionModel *model;
@property(nonatomic,copy) void (^onAuthorizeTapped)(NSInteger,NSRect);
+ (instancetype)itemWithModel:(LCPermissionModel *)model;
- (void)setupSubviews;
- (BOOL)refreshStatus;
- (void)authButtonClicked;
@end
