#import <AppKit/AppKit.h>
#import "LCAuthGuideHostApp.h"
@interface AppDragSourceView : NSView <NSPasteboardItemDataProvider>
@property(nonatomic,strong) LCAuthGuideHostApp *hostApp;
@property(nonatomic,copy) void (^onDragCompleted)(void);
@property(nonatomic) CGColorRef originalBackgroundColor;
@property(nonatomic) CGColorRef originalBorderColor;
@property(nonatomic,strong) NSView *rowView;
@property(nonatomic,strong) NSView *iconBgView;
@property(nonatomic,strong) NSTextField *label;
@property(nonatomic,strong) NSImageView *rightIconView;
@property(nonatomic,strong) NSTextField *rightTextLabel;
- (instancetype)initWithHostApp:(LCAuthGuideHostApp *)app;
- (void)setupUI;
- (void)setupRowView;
- (void)setupIconChrome;
- (void)setupIconView;
- (void)setupLabel;
- (void)setupRightIcon;
- (void)setupRightText;
- (void)setupConstraints;
- (void)updateAppearance;
- (NSImage *)draggingImage;
- (NSUInteger)draggingSession:(NSDraggingSession *)session sourceOperationForMask:(NSUInteger)mask;
@end
