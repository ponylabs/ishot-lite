#import "FreeAppsViewController.h"
@implementation NSObject (IShotValidString)
// 0x10007689c: actual category target is NSObject, not NSString.
- (BOOL)isValidString { return [self isKindOfClass:NSString.class] && [(NSString *)self length]!=0; }
@end
@implementation LCFlipView
@synthesize tag=_tag;
- (BOOL)isFlipped { return YES; }
@end
@implementation FreeAppModel
+ (instancetype)modelWithIcon:(NSString *)icon name:(NSString *)name desc:(NSString *)desc link:(NSString *)link {
    FreeAppModel *model=[[FreeAppModel alloc] init];
    model.icon=icon; model.name=name; model.desc=desc; model.link=link; return model;
}
@end
@implementation FreeAppsItem
- (void)setModel:(FreeAppModel *)model { _model=model; self.iconView.image=[NSImage imageNamed:model.icon]; self.nameView.stringValue=model.name; self.descView.stringValue=model.desc; }
- (void)viewDidLoad { [super viewDidLoad]; }
@end
@implementation FreeAppsViewController
- (void)loadView { self.view=[[LCFlipView alloc] init]; }
- (void)viewDidLoad { [super viewDidLoad]; [self setupAllSubviews]; [self setupAutoLayoutConstraints]; [self configCollectionView]; }
- (void)viewDidLayout { [super viewDidLayout]; }
- (void)viewDidAppear { [super viewDidAppear]; }
- (void)setupAllSubviews {
    self.boxView=[[LCBox alloc] init]; self.boxView.translatesAutoresizingMaskIntoConstraints=NO; [self.view addSubview:self.boxView];
    self.webTitleLabel=[[NSTextField alloc] init]; self.webTitleLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.webTitleLabel.stringValue=[NSBundle.mainBundle localizedStringForKey:@"Official Website:" value:@"" table:nil];
    self.webTitleLabel.bezeled=NO; self.webTitleLabel.drawsBackground=NO; self.webTitleLabel.editable=NO;
    [self.view addSubview:self.webTitleLabel];
    self.webBtn=[[NSButton alloc] init]; self.webBtn.translatesAutoresizingMaskIntoConstraints=NO; self.webBtn.title=@"www.better365.com";
    self.webBtn.bordered=NO; self.webBtn.target=self; self.webBtn.action=@selector(openOfficialWebsite:);
    if(@available(macOS 10.14,*)) self.webBtn.contentTintColor=NSColor.controlAccentColor;
    [self.view addSubview:self.webBtn];
    self.scrollView=[[NSScrollView alloc] init]; self.scrollView.translatesAutoresizingMaskIntoConstraints=NO;
    self.scrollView.hasVerticalScroller=YES; self.scrollView.hasHorizontalScroller=NO; self.scrollView.scrollerInsets=NSEdgeInsetsMake(0,0,0,-100);
    self.scrollView.drawsBackground=NO; if(@available(macOS 10.14,*)) self.scrollView.backgroundColor=NSColor.clearColor;
    NSCollectionViewFlowLayout *layout=[[NSCollectionViewFlowLayout alloc] init]; layout.scrollDirection=0; layout.itemSize=NSMakeSize(700,90); layout.sectionInset=NSEdgeInsetsZero;
    self.collectionView=[[NSCollectionView alloc] init]; self.collectionView.translatesAutoresizingMaskIntoConstraints=NO; self.collectionView.collectionViewLayout=layout;
    [self.collectionView registerClass:FreeAppsItem.class forItemWithIdentifier:@"FreeAppsItemID"];
    self.collectionView.dataSource=self; self.collectionView.delegate=self; self.collectionView.backgroundColors=@[NSColor.clearColor];
    self.scrollView.documentView=self.collectionView; [self.boxView.contentView addSubview:self.scrollView];
}
- (void)setupAutoLayoutConstraints {
    NSView *view=self.view,*content=self.boxView.contentView;
    [NSLayoutConstraint activateConstraints:@[
        [self.boxView.topAnchor constraintEqualToAnchor:view.topAnchor constant:40],
        [self.boxView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:40],
        [self.boxView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-40],
        [self.boxView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-40]]];
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:content.topAnchor constant:10],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:content.leadingAnchor constant:15],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:content.trailingAnchor constant:-20],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:content.bottomAnchor constant:-10]]];
    [NSLayoutConstraint activateConstraints:@[
        [self.webBtn.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-40],
        [self.webBtn.topAnchor constraintEqualToAnchor:self.boxView.bottomAnchor constant:10]]];
    [NSLayoutConstraint activateConstraints:@[
        [self.webTitleLabel.centerYAnchor constraintEqualToAnchor:self.webBtn.centerYAnchor],
        [self.webTitleLabel.trailingAnchor constraintEqualToAnchor:self.webBtn.leadingAnchor constant:-5]]];
}
- (void)configCollectionView { self.collectionView.allowsMultipleSelection=NO; self.collectionView.allowsEmptySelection=YES; self.collectionView.selectable=YES; }
- (void)openOfficialWebsite:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.com"]]; }
- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { return self.appArr.count; }
- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)path {
    FreeAppsItem *item=(id)[collectionView makeItemWithIdentifier:@"FreeAppsItemID" forIndexPath:path]; item.model=self.appArr[path.item]; return item;
}
- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)paths {
    NSIndexPath *path=paths.anyObject;
    if(path){ FreeAppModel *model=self.appArr[path.item]; if([model.link isValidString]) [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:model.link]]; [collectionView deselectAll:nil]; }
}
- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)path { return NSMakeSize(collectionView.bounds.size.width,90); }
- (NSArray *)appArr {
    if(!_appArr){
        _appArr=@[
            [FreeAppModel modelWithIcon:@"BAB_new_logo" name:[NSBundle.mainBundle localizedStringForKey:@"MagicMouse" value:@"" table:nil] desc:[NSBundle.mainBundle localizedStringForKey:@"MagicMouse desc" value:@"" table:nil] link:@"https://www.better365.com/bab2.html"],
            [FreeAppModel modelWithIcon:@"State_logo" name:[NSBundle.mainBundle localizedStringForKey:@"State" value:@"" table:nil] desc:[NSBundle.mainBundle localizedStringForKey:@"State desc" value:@"" table:nil] link:@"https://www.better365.com/state.html"],
            [FreeAppModel modelWithIcon:@"auto_keyboard" name:[NSBundle.mainBundle localizedStringForKey:@"AutoSwitchInput" value:@"" table:nil] desc:[NSBundle.mainBundle localizedStringForKey:@"AutoSwitchInput desc" value:@"" table:nil] link:@"https://www.better365.com/AutoSwitchInput.html"],
            [FreeAppModel modelWithIcon:@"XApp_logo" name:[NSBundle.mainBundle localizedStringForKey:@"XApp" value:@"" table:nil] desc:[NSBundle.mainBundle localizedStringForKey:@"XApp desc" value:@"" table:nil] link:@"https://www.better365.com/xapp.html"],
            [FreeAppModel modelWithIcon:@"FastZip_logo" name:[NSBundle.mainBundle localizedStringForKey:@"FastZip" value:@"" table:nil] desc:[NSBundle.mainBundle localizedStringForKey:@"FastZip desc" value:@"" table:nil] link:@"https://www.better365.com/fastzip.html"],
            [FreeAppModel modelWithIcon:@"iRightMouse_logo" name:[NSBundle.mainBundle localizedStringForKey:@"iRightMouse" value:@"" table:nil] desc:[NSBundle.mainBundle localizedStringForKey:@"iRightMouse desc" value:@"" table:nil] link:@"https://www.better365.com/irightmouse.html"],
            [FreeAppModel modelWithIcon:@"iFan_logo" name:[NSBundle.mainBundle localizedStringForKey:@"iFan" value:@"" table:nil] desc:[NSBundle.mainBundle localizedStringForKey:@"iFan desc" value:@"" table:nil] link:@"https://www.better365.com/h-col-195.html"],
            [FreeAppModel modelWithIcon:@"iGet_logo" name:[NSBundle.mainBundle localizedStringForKey:@"iGet" value:@"" table:nil] desc:[NSBundle.mainBundle localizedStringForKey:@"iGet desc" value:@"" table:nil] link:@"https://www.better365.com/h-col-197.html"],
            [FreeAppModel modelWithIcon:@"FlyKey_logo" name:[NSBundle.mainBundle localizedStringForKey:@"FlyKey" value:@"" table:nil] desc:[NSBundle.mainBundle localizedStringForKey:@"FlyKey desc" value:@"" table:nil] link:@"https://www.better365.com/FlyKey.html"],
        ];
    } return _appArr;
}
@end
