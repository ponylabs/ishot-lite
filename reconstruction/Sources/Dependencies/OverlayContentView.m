#import "OverlayContentView.h"
#import "AppDragSourceView.h"
#import "LCAuthGuideKit.h"
#import "LCPermisoAssistant.h"
#import <QuartzCore/QuartzCore.h>
@implementation OverlayContentView
- (instancetype)initWithHostApp:(LCAuthGuideHostApp *)app permissionType:(NSInteger)type onBack:(void (^)(void))back {if((self=[super init])){_onBack=[back copy];self.translatesAutoresizingMaskIntoConstraints=NO;[self setupWithHostApp:app permissionType:type];}return self;}
- (instancetype)initWithCoder:(NSCoder *)coder {[NSException raise:@"NSInvalidArgumentException" format:@"initWithCoder: 未实现"];return nil;}
- (void)setupWithHostApp:(LCAuthGuideHostApp *)app permissionType:(NSInteger)type {
    self.allowedTouchTypes=1;
    NSVisualEffectView *effect=[[NSVisualEffectView alloc] init];effect.translatesAutoresizingMaskIntoConstraints=NO;effect.material=15;effect.blendingMode=0;effect.state=1;effect.wantsLayer=YES;effect.layer.cornerRadius=18;effect.layer.masksToBounds=YES;effect.layer.borderWidth=0.5;effect.layer.borderColor=[NSColor.separatorColor colorWithAlphaComponent:0.18].CGColor;[self addSubview:effect];
    NSView *empty=[[NSView alloc] init];empty.translatesAutoresizingMaskIntoConstraints=NO;[effect addSubview:empty];
    NSImageView *arrow=[[NSImageView alloc] init];arrow.translatesAutoresizingMaskIntoConstraints=NO;arrow.image=[LCAuthGuideKit bundleImage:@"arrowUp@2x.png"];arrow.image.template=YES;[effect addSubview:arrow];
    NSString *first,*second;
    if(type==2) {
        NSString *key;if(@available(macOS 13,*))key=@"FDA_Step_One";else key=@"FDA_Step_One_With_Monterrey";
        first=[NSString stringWithFormat:[LCAuthGuideKit localizedString:key],app.displayName];second=[NSString stringWithFormat:[LCAuthGuideKit localizedString:@"FDA_Step_Two"],app.displayName];
    }else {
        NSString *permission=IShotPermissionTitle_10009e4d4(type);NSString *key;if(@available(macOS 13,*))key=@"Drag_Step_One";else key=@"Drag_Step_One_With_Monterrey";
        first=[NSString stringWithFormat:[LCAuthGuideKit localizedString:key],app.displayName];second=[NSString stringWithFormat:[LCAuthGuideKit localizedString:@"Drag_Step_Two"],app.displayName,permission];
    }
    NSTextField *step1=[self createStepLabelWithText:first],*step2=[self createStepLabelWithText:second];[effect addSubview:step1];[effect addSubview:step2];
    AppDragSourceView *drag=[[AppDragSourceView alloc] initWithHostApp:app];drag.onDragCompleted=^{if(self.onBack)self.onBack();};[effect addSubview:drag];
    (void)self.windowWidth;
    [NSLayoutConstraint activateConstraints:@[
        [self.heightAnchor constraintGreaterThanOrEqualToConstant:110],
        [effect.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],[effect.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],[effect.topAnchor constraintEqualToAnchor:self.topAnchor],[effect.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [arrow.leadingAnchor constraintEqualToAnchor:effect.leadingAnchor constant:20],[arrow.topAnchor constraintEqualToAnchor:effect.topAnchor constant:10],[arrow.widthAnchor constraintEqualToConstant:24],[arrow.heightAnchor constraintEqualToConstant:28],
        [step1.leadingAnchor constraintEqualToAnchor:arrow.trailingAnchor constant:10],[step1.topAnchor constraintEqualToAnchor:arrow.topAnchor],[step1.trailingAnchor constraintEqualToAnchor:effect.trailingAnchor constant:-22],
        [step2.leadingAnchor constraintEqualToAnchor:step1.leadingAnchor],[step2.topAnchor constraintEqualToAnchor:step1.bottomAnchor constant:4],[step2.trailingAnchor constraintEqualToAnchor:step1.trailingAnchor],
        [drag.leadingAnchor constraintEqualToAnchor:step2.leadingAnchor],[drag.trailingAnchor constraintEqualToAnchor:effect.trailingAnchor constant:-20],[drag.topAnchor constraintEqualToAnchor:step2.bottomAnchor constant:10],[drag.bottomAnchor constraintEqualToAnchor:effect.bottomAnchor constant:-10]]];
}
- (NSTextField *)createStepLabelWithText:(NSString *)text {
    NSTextField *label=[[NSTextField alloc] init];label.translatesAutoresizingMaskIntoConstraints=NO;label.stringValue=text;label.font=[NSFont systemFontOfSize:13 weight:NSFontWeightMedium];label.textColor=NSColor.labelColor;label.maximumNumberOfLines=0;label.lineBreakMode=0;label.usesSingleLineMode=NO;label.editable=NO;label.selectable=NO;label.drawsBackground=NO;label.bezeled=NO;return label;
}
- (void)resetCursorRects {[super resetCursorRects];[self addCursorRect:[self convertRect:self.bounds fromView:self] cursor:NSCursor.openHandCursor];}
- (void)viewDidMoveToWindow {[super viewDidMoveToWindow];if(self.window)[self.window invalidateCursorRectsForView:self];}
@end
