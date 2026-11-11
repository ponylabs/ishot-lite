#import "LCPermissionViews.h"
#import "LCAuthGuideKit.h"
@implementation LCPermissionView
- (BOOL)isFlipped { return YES; }
@end
@implementation LCPermissionBoxView
- (instancetype)initWithFrame:(NSRect)frame {
    if((self=[super initWithFrame:frame])) { self.boxType=4;self.titlePosition=0;self.cornerRadius=15;self.borderWidth=0;self.contentViewMargins=NSZeroSize;[self setBackgroundColor];[NSApp addObserver:self forKeyPath:@"effectiveAppearance" options:1 context:NULL]; } return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder { if((self=[super initWithCoder:coder])) [NSException raise:@"NSInvalidArgumentException" format:@"initWithCoder: 未实现"]; return self; }
- (void)dealloc { [NSApp removeObserver:self forKeyPath:@"effectiveAppearance"]; }
- (void)observeValueForKeyPath:(NSString *)key ofObject:(id)object change:(NSDictionary *)change context:(void *)context { if([key isEqualToString:@"effectiveAppearance"]) [self setBackgroundColor]; }
- (void)setBackgroundColor {
    NSAppearance *appearance=NSApp.effectiveAppearance;
    if(@available(macOS 10.14,*)) if([[appearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua,NSAppearanceNameAqua]] isEqualToString:NSAppearanceNameDarkAqua]) { self.fillColor=[NSColor colorWithWhite:0 alpha:0.15]; return; }
    self.fillColor=[NSColor colorWithWhite:1 alpha:0.4];
}
@end
@implementation LCPermissionItem
@synthesize model=_model;
- (instancetype)init { if((self=[super init])) [self setupSubviews];return self; }
+ (instancetype)itemWithModel:(LCPermissionModel *)model { LCPermissionItem *item=[[self alloc] init];item.model=model;return item; }
- (void)setupSubviews {
    _iconView=[[NSImageView alloc] init];_iconView.imageScaling=3;
    _permissionDesLabel=[NSTextField labelWithString:@""];_permissionDesLabel.font=[NSFont systemFontOfSize:13];_permissionDesLabel.textColor=NSColor.labelColor;
    _infoLabel=[NSTextField labelWithString:@""];_infoLabel.font=[NSFont systemFontOfSize:10];_infoLabel.textColor=NSColor.labelColor;
    _authButton=[[NSButton alloc] init];_authButton.title=[LCAuthGuideKit localizedString:@"Authorize"];_authButton.target=self;_authButton.action=@selector(authButtonClicked);_authButton.bezelColor=NSColor.controlAccentColor;
    [self addSubview:_iconView];[self addSubview:_permissionDesLabel];[self addSubview:_infoLabel];[self addSubview:_authButton];
}
- (void)setModel:(LCPermissionModel *)model {
    _model=model;NSString *image,*title;
    switch(model.authType) {
        case 1:image=@"Accessbility@2x.png";title=@"Accessibility permission";break;
        case 2:image=@"FullDiskAccess@2x.png";title=@"Full disk access";break;
        case 3:image=@"ScreenRecording@2x.png";title=@"Screen recording permission";break;
        case 4:image=@"InputMonitoring@2x.png";title=@"Input monitoring permission";break;
        default:break;
    }
    if(image) { self.iconView.image=[LCAuthGuideKit bundleImage:image]; self.permissionDesLabel.stringValue=[LCAuthGuideKit localizedString:title]; }
    self.infoLabel.stringValue=[NSString stringWithFormat:@"%@",model.desc]; [self refreshStatus];
}
- (BOOL)isFlipped { return YES; }
- (void)layout {
    [super layout];CGFloat height=self.bounds.size.height,width=self.bounds.size.width;
    self.iconView.frame=NSMakeRect(0,(height-28)*0.5,28,28);NSRect icon=self.iconView.frame;
    NSUInteger length=self.infoLabel.stringValue.length;[self.permissionDesLabel sizeToFit];
    CGFloat x=CGRectGetMaxX(icon)+10,y=CGRectGetMidY(icon)-self.permissionDesLabel.bounds.size.height*0.5;
    if(length) y-=5;
    self.permissionDesLabel.frame=NSMakeRect(x,y,self.permissionDesLabel.bounds.size.width,self.permissionDesLabel.bounds.size.height);
    [self.infoLabel sizeToFit]; self.infoLabel.frame=NSMakeRect(x,height*0.5+5,self.infoLabel.bounds.size.width,self.infoLabel.bounds.size.height);
    self.authButton.frame=NSMakeRect(width-100,height*0.5-14,100,28);
}
- (BOOL)refreshStatus {
    BOOL granted=NO;
    switch(self.model.authType) { case 1:granted=[LCAuthGuideKit getPrivacyAccessibilityIsEnabled];break;case 2:granted=[LCAuthGuideKit getFullDiskAccessIsEnabled];break;case 3:granted=[LCAuthGuideKit getScreenCaptureIsEnabled];break;case 4:granted=[LCAuthGuideKit isInputMonitoringEnabled];break;default:break; }
    self.authButton.title=[LCAuthGuideKit localizedString:granted ? @"Granted" : @"Authorize"];
    self.authButton.enabled=!granted; self.authButton.bezelColor=granted ? nil : NSColor.controlAccentColor; return granted;
}
- (void)authButtonClicked { NSRect rect=[self.authButton convertRect:self.authButton.bounds toView:nil];if(self.onAuthorizeTapped) self.onAuthorizeTapped(self.model.authType,rect); }
@end
