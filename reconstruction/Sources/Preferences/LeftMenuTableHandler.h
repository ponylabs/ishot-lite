#import <Cocoa/Cocoa.h>
@interface LCTableRowView : NSTableRowView
@property(nonatomic) CGFloat contentHeight, horizontalInset, rowCornerRadius, selectionOffsetX;
@property(nonatomic,strong) NSColor *selectedBackgroundColor, *hoverBackgroundColorLight, *hoverBackgroundColorDark;
@property(nonatomic) BOOL hoverEnabled, selectedHasCorner, mouseInside;
- (BOOL)isDarkMode;
- (void)updateBackgroundColor:(NSColor *)color cornerRadius:(CGFloat)radius;
@end
@interface LeftMenuTableHandler : NSObject <NSTableViewDelegate,NSTableViewDataSource>
@property(nonatomic,strong) NSArray *dataList;
@property(nonatomic,copy) void (^didSelectBlock)(NSInteger row);
@property(nonatomic,weak) NSTableView *tableView;
@end
