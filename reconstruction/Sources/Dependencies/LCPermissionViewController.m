#import "LCPermissionWindowController.h"
#import "LCPermissionViews.h"
#import "LCAuthGuideKit.h"
#import "LCAuthGuideHostApp.h"
#import "LCPermisoAssistant.h"
@implementation LCPermissionViewController
@synthesize authTypes=_authTypes;
- (instancetype)init { if((self=[super init])) [self commonInit];return self; }
- (void)commonInit {
    _effectView=[[NSVisualEffectView alloc] init];_effectView.material=15;_effectView.blendingMode=0;_effectView.state=1;
    _appIconView=[[NSImageView alloc] init];_appIconView.imageScaling=3;_appIconView.image=NSApp.applicationIconImage;
    NSString *title=[NSString stringWithFormat:[LCAuthGuideKit localizedString:@"Permission Title"],LCAuthGuideHostApp.currentApp.displayName];
    _appNameLabel=[NSTextField labelWithString:title];_appNameLabel.font=[NSFont systemFontOfSize:15];
    title=[NSString stringWithFormat:[LCAuthGuideKit localizedString:@"Permission sub Title"],LCAuthGuideHostApp.currentApp.displayName];
    _titleLabel=[NSTextField labelWithString:title];_titleLabel.font=[NSFont systemFontOfSize:13];
    _box=[[LCPermissionBoxView alloc] init];
    NSImage *image=[LCAuthGuideKit bundleImage:@"search_finder@2x.png"];if(!image) image=[[NSImage alloc] init];
    _showInFinderBtn=[[NSButton alloc] init];_showInFinderBtn.image=image;_showInFinderBtn.target=self;_showInFinderBtn.action=@selector(showInFinder);_showInFinderBtn.bordered=NO;_showInFinderBtn.image.template=YES;_showInFinderBtn.toolTip=[LCAuthGuideKit localizedString:@"Show in Finder"];_showInFinderBtn.hidden=YES;
    _lookBtn=[NSButton buttonWithTitle:[LCAuthGuideKit localizedString:@"View permission setting tutorail"] target:self action:@selector(lookTutorialVideo)];_lookBtn.bezelColor=NSColor.controlAccentColor;_lookBtn.hidden=LCAuthGuideKit.shared.tutorialLink.length==0;
    _quitBtn=[NSButton buttonWithTitle:[LCAuthGuideKit localizedString:@"Quit App"] target:self action:@selector(quitApp)];_quitBtn.hidden=YES;
}
- (void)loadView {
    self.view=[[LCPermissionView alloc] initWithFrame:NSMakeRect(0,0,600,280)];
    [self.view addSubview:self.effectView];[self.view addSubview:self.appIconView];[self.view addSubview:self.appNameLabel];[self.view addSubview:self.titleLabel];[self.view addSubview:self.box];[self.view addSubview:self.lookBtn];[self.view addSubview:self.quitBtn];[self.view addSubview:self.showInFinderBtn];
}
// Floating-point values corroborated against 0x1000a2514..0x1000a2cf4 assembly.
- (void)viewDidLayout {
    [super viewDidLayout];CGFloat width=self.view.bounds.size.width;
    self.effectView.frame=self.view.bounds;self.showInFinderBtn.frame=NSMakeRect(width-26,8,18,18);self.appIconView.frame=NSMakeRect(width*0.5-40,20,80,80);
    [self.appNameLabel sizeToFit];self.appNameLabel.frame=NSMakeRect(width*0.5-self.appNameLabel.bounds.size.width*0.5,CGRectGetMaxY(self.appIconView.frame)+10,self.appNameLabel.bounds.size.width,self.appNameLabel.bounds.size.height);
    [self.titleLabel sizeToFit];self.titleLabel.frame=NSMakeRect(width*0.5-self.titleLabel.bounds.size.width*0.5,CGRectGetMaxY(self.appNameLabel.frame)+8,self.titleLabel.bounds.size.width,self.titleLabel.bounds.size.height);
    CGFloat y=CGRectGetMaxY(self.titleLabel.frame)+(self.lookBtn.hidden?20:10);
    CGFloat height=(double)self.authTypes.count*50+(double)(self.authTypes.count+1)*25;
    self.box.frame=NSMakeRect(30,y,width-60,height);
    CGFloat itemY=25;
    for(NSView *view in self.box.contentView.subviews.reverseObjectEnumerator.allObjects) if([view isKindOfClass:LCPermissionItem.class]) { view.frame=NSMakeRect(30,itemY,self.box.contentView.bounds.size.width-60,50);itemY=CGRectGetMaxY(view.frame)+25; }
    [self.lookBtn sizeToFit];[self.quitBtn sizeToFit];y=CGRectGetMaxY(self.box.frame)+8;
    self.lookBtn.frame=NSMakeRect(CGRectGetMinX(self.box.frame),y,self.lookBtn.frame.size.width,self.lookBtn.frame.size.height);
    self.quitBtn.frame=NSMakeRect(CGRectGetMaxX(self.box.frame)-self.quitBtn.frame.size.width,y,self.quitBtn.frame.size.width,self.quitBtn.frame.size.height);
}
- (void)setAuthTypes:(NSArray *)types {
    _authTypes=types;
    for(NSView *view in self.box.contentView.subviews) [view removeFromSuperview];
    for(LCPermissionModel *model in types) {
        LCPermissionItem *item=[LCPermissionItem itemWithModel:model];
        item.onAuthorizeTapped=^(NSInteger type,NSRect source) {
            NSWindow *window=self.view.window;
            if(window) {
                NSRect screen=[window convertRectToScreen:source];
                if((NSUInteger)(type-1)<4) {
                    // 0x10016d680 contains the four signed 64-bit panel values.
                    const NSInteger panel[]={0,2,1,10};
                    [LCPermisoAssistant.shared presentWithPermissionType:panel[type-1] hostApp:LCAuthGuideHostApp.currentApp sourceFrameInScreen:screen];
                    [self startPermissionCheckWithType:type];
                }
            }
        };
        [self.box.contentView addSubview:item];
    }
    NSUInteger n=types.count,second=types.count; NSWindow *window=self.view.window;
    if(window) { NSRect frame=window.frame;frame.size.height=(double)n*50+(double)(second+1)*25+200;[window setFrame:frame display:YES]; }
    self.view.needsLayout=YES;
}
- (void)viewDidDisappear { [super viewDidDisappear];[self.permissionCheckTimer invalidate];self.permissionCheckTimer=nil; }
- (void)refreshAllAuthState {
    BOOL all=YES;
    for(NSView *view in self.box.contentView.subviews) if([view isKindOfClass:LCPermissionItem.class]) all &= [(LCPermissionItem *)view refreshStatus];
    if(all && self.allAuthPassedHandler) self.allAuthPassedHandler();
}
- (void)showInFinder { [NSWorkspace.sharedWorkspace activateFileViewerSelectingURLs:@[[NSURL fileURLWithPath:NSBundle.mainBundle.bundlePath]]]; }
- (void)quitApp { if(self.quitHandler) self.quitHandler();[NSApp terminate:nil]; }
- (void)skip { if(self.skipHandler) self.skipHandler(); }
- (void)lookTutorialVideo { NSString *link=LCAuthGuideKit.shared.tutorialLink;if(link.length) { NSURL *url=[NSURL URLWithString:link];if(url) [NSWorkspace.sharedWorkspace openURL:url]; } }
- (void)startPermissionCheckWithType:(NSInteger)type {
    BOOL granted=NO;
    switch(type) {case 1:granted=[LCAuthGuideKit getPrivacyAccessibilityIsEnabled];break;case 2:granted=[LCAuthGuideKit getFullDiskAccessIsEnabled];break;case 3:granted=[LCAuthGuideKit getScreenCaptureIsEnabled];break;case 4:granted=[LCAuthGuideKit isInputMonitoringEnabled];break;default:break;}
    if(granted)return;
    [self.permissionCheckTimer invalidate];
    self.permissionCheckTimer=[NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
        dispatch_async(dispatch_get_main_queue(),^{
            BOOL passed=NO;
            switch(type) {case 1:passed=[LCAuthGuideKit getPrivacyAccessibilityIsEnabled];break;case 2:passed=[LCAuthGuideKit getFullDiskAccessIsEnabled];break;case 3:passed=[LCAuthGuideKit getScreenCaptureIsEnabled];break;case 4:passed=[LCAuthGuideKit isInputMonitoringEnabled];break;default:break;}
            if(passed) { [LCPermisoAssistant.shared dismiss];[timer invalidate];self.permissionCheckTimer=nil;[self refreshAllAuthState]; }
        });
    }];
}
@end
