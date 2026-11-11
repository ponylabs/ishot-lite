#import "AppDragSourceView.h"
#import "LCAuthGuideKit.h"
#import <QuartzCore/QuartzCore.h>
@implementation AppDragSourceView
- (instancetype)initWithHostApp:(LCAuthGuideHostApp *)app { if((self=[super init])){_hostApp=app;self.translatesAutoresizingMaskIntoConstraints=NO;[self setupUI];[self updateAppearance];}return self; }
- (instancetype)initWithCoder:(NSCoder *)coder { [NSException raise:@"NSInvalidArgumentException" format:@"initWithCoder: 未实现"];return nil; }
- (void)dealloc { if(_originalBackgroundColor)CGColorRelease(_originalBackgroundColor);if(_originalBorderColor)CGColorRelease(_originalBorderColor); }
- (void)updateTrackingAreas { [super updateTrackingAreas];for(NSTrackingArea *area in self.trackingAreas)[self removeTrackingArea:area];[self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.bounds options:0x285 owner:self userInfo:nil]]; }
- (void)mouseEntered:(NSEvent *)event {
    [super mouseEntered:event];BOOL dark=NO;if(@available(macOS 10.14,*))dark=[[self.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua,NSAppearanceNameAqua]] isEqualToString:NSAppearanceNameDarkAqua];
    NSColor *color=dark?NSColor.whiteColor:NSColor.blackColor;
    self.rowView.layer.backgroundColor=[color colorWithAlphaComponent:0.15].CGColor;self.rowView.layer.borderColor=[color colorWithAlphaComponent:0.3].CGColor;self.rightTextLabel.textColor=NSColor.redColor;
}
- (void)mouseExited:(NSEvent *)event { [super mouseExited:event];if(self.originalBackgroundColor && self.originalBorderColor){self.rowView.layer.backgroundColor=self.originalBackgroundColor;self.rowView.layer.borderColor=self.originalBorderColor;}self.rightTextLabel.textColor=NSColor.labelColor; }
- (void)setupUI {self.wantsLayer=YES;[self setupRowView];[self setupIconChrome];[self setupIconView];[self setupLabel];[self setupRightIcon];[self setupRightText];[self setupConstraints];}
- (void)setupRowView {NSView *view=[[NSView alloc] init];view.wantsLayer=YES;view.layer.cornerRadius=10;view.layer.borderWidth=1;view.translatesAutoresizingMaskIntoConstraints=NO;[self addSubview:view];self.rowView=view;}
- (void)setupIconChrome {NSView *view=[[NSView alloc] init];view.wantsLayer=YES;view.layer.backgroundColor=[NSColor.whiteColor colorWithAlphaComponent:0.9].CGColor;view.layer.cornerRadius=6;view.translatesAutoresizingMaskIntoConstraints=NO;[self.rowView addSubview:view];self.iconBgView=view;}
- (void)setupIconView {
    NSImageView *view=[[NSImageView alloc] init];view.image=self.hostApp.icon;view.translatesAutoresizingMaskIntoConstraints=NO;view.imageScaling=3;[self.iconBgView addSubview:view];
    [NSLayoutConstraint activateConstraints:@[[view.centerXAnchor constraintEqualToAnchor:self.iconBgView.centerXAnchor],[view.centerYAnchor constraintEqualToAnchor:self.iconBgView.centerYAnchor],[view.widthAnchor constraintEqualToConstant:22],[view.heightAnchor constraintEqualToConstant:22]]];
}
- (void)setupLabel {NSTextField *label=[NSTextField labelWithString:self.hostApp.displayName];label.font=[NSFont systemFontOfSize:15 weight:NSFontWeightSemibold];label.textColor=NSColor.labelColor;label.translatesAutoresizingMaskIntoConstraints=NO;[self.rowView addSubview:label];self.label=label;}
- (void)setupRightIcon {NSImageView *view=[[NSImageView alloc] init];view.image=[NSImage imageNamed:@"handDrag"];view.image.template=YES;view.translatesAutoresizingMaskIntoConstraints=NO;view.imageScaling=0;view.contentTintColor=NSColor.secondaryLabelColor;[self.rowView addSubview:view];self.rightIconView=view;}
- (void)setupRightText {NSTextField *label=[NSTextField labelWithString:[LCAuthGuideKit localizedString:@"drag_here"]];label.font=[NSFont systemFontOfSize:13];label.textColor=NSColor.secondaryLabelColor;label.translatesAutoresizingMaskIntoConstraints=NO;[self.rowView addSubview:label];self.rightTextLabel=label;}
- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.rowView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],[self.rowView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],[self.rowView.topAnchor constraintEqualToAnchor:self.topAnchor],[self.rowView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],[self.rowView.heightAnchor constraintEqualToConstant:43],
        [self.iconBgView.leadingAnchor constraintEqualToAnchor:self.rowView.leadingAnchor constant:10],[self.iconBgView.centerYAnchor constraintEqualToAnchor:self.rowView.centerYAnchor],[self.iconBgView.widthAnchor constraintEqualToConstant:26],[self.iconBgView.heightAnchor constraintEqualToConstant:26],
        [self.label.leadingAnchor constraintEqualToAnchor:self.iconBgView.trailingAnchor constant:11],[self.label.trailingAnchor constraintLessThanOrEqualToAnchor:self.rowView.trailingAnchor constant:-12],[self.label.centerYAnchor constraintEqualToAnchor:self.rowView.centerYAnchor],
        [self.rightIconView.trailingAnchor constraintEqualToAnchor:self.rowView.trailingAnchor constant:-12],[self.rightIconView.centerYAnchor constraintEqualToAnchor:self.rowView.centerYAnchor],[self.rightIconView.widthAnchor constraintEqualToConstant:16],[self.rightIconView.heightAnchor constraintEqualToConstant:16],
        [self.rightTextLabel.trailingAnchor constraintEqualToAnchor:self.rightIconView.leadingAnchor constant:-6],[self.rightTextLabel.centerYAnchor constraintEqualToAnchor:self.rowView.centerYAnchor]]];
}
- (void)viewDidChangeEffectiveAppearance {[super viewDidChangeEffectiveAppearance];[self updateAppearance];}
- (void)updateAppearance {
    BOOL dark=NO;if(@available(macOS 10.14,*))dark=[[self.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua,NSAppearanceNameAqua]] isEqualToString:NSAppearanceNameDarkAqua];
    NSColor *background=[NSColor.whiteColor colorWithAlphaComponent:dark?0.06:0.65];NSColor *border=[(dark?NSColor.whiteColor:NSColor.blackColor) colorWithAlphaComponent:dark?0.08:0.15];
    self.rowView.layer.backgroundColor=background.CGColor;self.rowView.layer.borderColor=border.CGColor;
    if(_originalBackgroundColor)CGColorRelease(_originalBackgroundColor);if(_originalBorderColor)CGColorRelease(_originalBorderColor);_originalBackgroundColor=CGColorRetain(background.CGColor);_originalBorderColor=CGColorRetain(border.CGColor);
}
- (BOOL)acceptsFirstMouse:(NSEvent *)event {return YES;}
- (void)mouseDown:(NSEvent *)event {
    NSPasteboardItem *writer=[[NSPasteboardItem alloc] init];[writer setDataProvider:self forTypes:@[NSPasteboardTypeFileURL]];NSDraggingItem *item=[[NSDraggingItem alloc] initWithPasteboardWriter:writer];NSRect rect=[self convertRect:self.rowView.bounds fromView:self.rowView];[item setDraggingFrame:rect contents:self.draggingImage];
    NSDraggingSession *session=[self beginDraggingSessionWithItems:@[item] event:event source:(id<NSDraggingSource>)self];session.animatesToStartingPositionsOnCancelOrFail=YES;
}
- (NSImage *)draggingImage {NSImage *image=[[NSImage alloc] initWithSize:self.rowView.bounds.size];[image lockFocus];NSGraphicsContext *context=NSGraphicsContext.currentContext;[self.rowView displayRectIgnoringOpacity:self.rowView.bounds inContext:context];[image unlockFocus];return image;}
- (void)pasteboard:(NSPasteboard *)pasteboard item:(NSPasteboardItem *)item provideDataForType:(NSPasteboardType)type {if([type isEqualToString:NSPasteboardTypeFileURL])[item setData:self.hostApp.bundleURL.dataRepresentation forType:NSPasteboardTypeFileURL];}
- (void)draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)point {self.rowView.hidden=YES;}
// Preserve the selector shipped by this binary, including its nonstandard spelling.
- (NSUInteger)draggingSession:(NSDraggingSession *)session sourceOperationForMask:(NSUInteger)mask {return 1;}
- (BOOL)ignoreModifierKeysForDraggingSession:(NSDraggingSession *)session {return NO;}
- (void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)point operation:(NSDragOperation)operation {
    self.rowView.hidden=NO;if(operation && self.onDragCompleted)dispatch_after(dispatch_time(DISPATCH_TIME_NOW,500000000),dispatch_get_main_queue(),^{self.onDragCompleted();});
}
@end
