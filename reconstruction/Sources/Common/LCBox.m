#import "LCBox.h"
@implementation LCBox
@synthesize boxCornerRadius = _boxCornerRadius;
- (instancetype)initWithFrame:(NSRect)frame { self = [super initWithFrame:frame]; if (self) [self configUI]; return self; } // 0x1000754c4
- (void)awakeFromNib { [super awakeFromNib]; [self configUI]; } // 0x100075514
- (void)configUI { // 0x10007555c
    self.wantsLayer = YES;
    self.boxType = 4;
    self.titlePosition = 0;
    self.borderWidth = 0;
    self.contentViewMargins = NSZeroSize;
    [self setBgColor];
    [self updateCornerRadius];
    [NSApp addObserver:self forKeyPath:@"effectiveAppearance" options:1 context:NULL];
}
- (void)dealloc { [NSApp removeObserver:self forKeyPath:@"effectiveAppearance" context:NULL]; } // 0x1000755e8
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context { // 0x100075648
    if ([keyPath isEqualToString:@"effectiveAppearance"]) [self setBgColor];
}
- (void)setBgColor { // 0x10007568c
    if (@available(macOS 10.14, *)) {
        NSString *match = [NSApp.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua, NSAppearanceNameAqua]];
        // Original uses pointer identity here, unlike the toolbar subclass.
        self.fillColor = match == NSAppearanceNameDarkAqua ? [NSColor colorWithWhite:0 alpha:0.1] : [NSColor colorWithWhite:1 alpha:0.3];
    } else self.fillColor = [NSColor colorWithWhite:1 alpha:0.3];
}
- (void)updateCornerRadius { self.cornerRadius = self.useCustomCornerRadius ? self.boxCornerRadius : 16.0; } // 0x10007583c
- (void)setBoxCornerRadius:(double)value { _boxCornerRadius = value; self.useCustomCornerRadius = 0.0 <= value; [self updateCornerRadius]; } // 0x100075870
@end
@implementation LCToolbarBox
- (void)configUI { // 0x100053b3c
    [super configUI];
    self.cornerRadius = 10;
    self.borderWidth = 0;
    self.titlePosition = 0;
    self.contentViewMargins = NSZeroSize;
    [self setToolbarBgColor];
}
- (void)setToolbarBgColor { // 0x100053bbc
    NSColor *light = [NSColor colorWithRed:0x1.bbbbbbbbbbbbcp-1 green:0x1.bbbbbbbbbbbbcp-1 blue:0x1.bbbbbbbbbbbbcp-1 alpha:1];
    NSColor *dark = [NSColor colorWithWhite:0.18 alpha:0.95];
    if (@available(macOS 10.14, *)) {
        NSString *match = [self.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua, NSAppearanceNameAqua]];
        self.fillColor = [match isEqualToString:NSAppearanceNameDarkAqua] ? dark : light;
    } else self.fillColor = light;
}
- (void)viewDidChangeEffectiveAppearance { [super viewDidChangeEffectiveAppearance]; [self setToolbarBgColor]; } // 0x100053d48
@end
