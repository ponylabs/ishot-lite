#import <Cocoa/Cocoa.h>
#import "../Common/LCBox.h"
@interface NSObject (IShotValidString)
- (BOOL)isValidString;
@end
@interface LCFlipView : NSView
@property NSInteger tag;
@end
@interface FreeAppModel : NSObject
@property(nonatomic,copy) NSString *icon, *name, *desc, *link;
+ (instancetype)modelWithIcon:(NSString *)icon name:(NSString *)name desc:(NSString *)desc link:(NSString *)link;
@end
@interface FreeAppsItem : NSCollectionViewItem
@property(weak) IBOutlet NSImageView *iconView;
@property(weak) IBOutlet NSTextField *nameView, *descView;
@property(nonatomic,strong) FreeAppModel *model;
@end
@interface FreeAppsViewController : NSViewController <NSCollectionViewDataSource,NSCollectionViewDelegateFlowLayout>
@property(nonatomic,strong) LCBox *boxView;
@property(nonatomic,strong) NSScrollView *scrollView;
@property(nonatomic,strong) NSCollectionView *collectionView;
@property(nonatomic,strong) NSTextField *webTitleLabel;
@property(nonatomic,strong) NSButton *webBtn;
@property(nonatomic,strong) NSArray<FreeAppModel *> *appArr;
- (void)setupAllSubviews;
- (void)setupAutoLayoutConstraints;
- (void)configCollectionView;
- (void)openOfficialWebsite:(id)sender;
@end
