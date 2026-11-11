#import <Cocoa/Cocoa.h>
@interface LCBox : NSBox
@property(nonatomic) BOOL useCustomCornerRadius;
@property(nonatomic) double boxCornerRadius;
@property(nonatomic,strong) NSColor *bgLightColor;
@property(nonatomic,strong) NSColor *bgDarkColor;
- (void)configUI;
- (void)setBgColor;
- (void)updateCornerRadius;
@end
@interface LCToolbarBox : LCBox
- (void)setToolbarBgColor;
@end
