#import "LeftMenuTableHandler.h"
@implementation LCTableRowView
// 0x100075988
- (instancetype)init {
    if ((self=[super init])) {
        _contentHeight=25; _horizontalInset=8; _rowCornerRadius=10; _selectionOffsetX=5;
        _hoverEnabled=YES; _selectedHasCorner=YES; _mouseInside=NO;
        _selectedBackgroundColor=[NSColor colorWithWhite:0 alpha:.35];
        _hoverBackgroundColorLight=[NSColor colorWithWhite:0 alpha:.1];
        _hoverBackgroundColorDark=[NSColor colorWithWhite:1 alpha:.1];
    } return self;
}
- (BOOL)isEmphasized { return YES; }
- (void)setEmphasized:(BOOL)value { [super setEmphasized:YES]; }
- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    for (NSTrackingArea *area in self.trackingAreas) [self removeTrackingArea:area];
    [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.bounds options:0x81 owner:self userInfo:nil]];
}
- (void)mouseEntered:(NSEvent *)event { if(self.hoverEnabled){ self.mouseInside=YES; self.needsDisplay=YES; } }
- (void)mouseExited:(NSEvent *)event { if(self.hoverEnabled){ self.mouseInside=NO; self.needsDisplay=YES; } }
- (void)drawSelectionInRect:(NSRect)rect {
    if(self.selectionHighlightStyle != -1) [self updateBackgroundColor:self.selectedBackgroundColor cornerRadius:self.selectedHasCorner ? self.rowCornerRadius : 0];
}
- (void)drawBackgroundInRect:(NSRect)rect {
    [super drawBackgroundInRect:rect];
    if(self.hoverEnabled && self.mouseInside && !self.selected)
        [self updateBackgroundColor:self.isDarkMode ? self.hoverBackgroundColorDark : self.hoverBackgroundColorLight cornerRadius:self.rowCornerRadius];
}
// 0x100075e28: assembly confirms fixed 2.5 inset; contentHeight/horizontalInset are not read.
- (void)updateBackgroundColor:(NSColor *)color cornerRadius:(CGFloat)radius {
    CGFloat x=self.selectionOffsetX;
    CGFloat width=self.bounds.size.width - 2*self.selectionOffsetX;
    NSRect rect=NSInsetRect(NSMakeRect(x,0,width,self.bounds.size.height),2.5,2.5);
    [color setFill]; [[NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius] fill];
}
- (BOOL)isDarkMode { return [self.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua,NSAppearanceNameAqua]]==NSAppearanceNameDarkAqua; }
- (void)viewDidChangeEffectiveAppearance {
    [super viewDidChangeEffectiveAppearance];
    if(self.hoverEnabled && self.mouseInside && !self.selected) self.needsDisplay=YES;
}
@end
@implementation LeftMenuTableHandler
- (instancetype)init { if((self=[super init])) [NSApp addObserver:self forKeyPath:@"effectiveAppearance" options:1 context:NULL]; return self; }
- (void)dealloc { [NSApp removeObserver:self forKeyPath:@"effectiveAppearance" context:NULL]; }
- (void)observeValueForKeyPath:(NSString *)key ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([key isEqualToString:@"effectiveAppearance"] && self.tableView) dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger row=self.tableView.selectedRow; [self.tableView reloadData];
        if(row>=0) [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    });
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)table { if(!_tableView) _tableView=table; return self.dataList.count; }
- (NSView *)tableView:(NSTableView *)table viewForTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    NSTableCellView *cell=[table makeViewWithIdentifier:column.identifier owner:self];
    NSDictionary *item=self.dataList[row]; cell.textField.stringValue=item[@"title"];
    cell.imageView.image=[NSImage imageNamed:item[@"image"]]; cell.textField.textColor=NSColor.labelColor;
    return cell;
}
- (CGFloat)tableView:(NSTableView *)table heightOfRow:(NSInteger)row { return 32; }
- (NSTableRowView *)tableView:(NSTableView *)table rowViewForRow:(NSInteger)row {
    LCTableRowView *view=[[LCTableRowView alloc] init];
    view.contentHeight=22; view.horizontalInset=10; view.hoverEnabled=YES; view.rowCornerRadius=8;
    view.selectedBackgroundColor=NSColor.controlAccentColor;
    view.hoverBackgroundColorLight=[NSColor.blackColor colorWithAlphaComponent:.2];
    view.hoverBackgroundColorDark=[NSColor.blackColor colorWithAlphaComponent:.35]; return view;
}
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row=[notification.object selectedRow]; if(row>=0 && self.didSelectBlock) self.didSelectBlock(row);
}
@end
