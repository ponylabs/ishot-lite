#import "AppKitCategories.h"
#pragma clang fp contract(off)
@implementation NSButton (TextColor)
- (NSColor *)textColor { // 0x100055d64
    NSAttributedString *title=self.attributedTitle;
    NSDictionary *attributes=[title fontAttributesInRange:NSMakeRange(0,title.length!=0)];
    return attributes?attributes[NSForegroundColorAttributeName]:NSColor.controlTextColor;
}
- (void)setTextColor:(NSColor *)color { // 0x100055e14
    NSMutableAttributedString *title=[[NSMutableAttributedString alloc] initWithAttributedString:self.attributedTitle];
    NSRange range=NSMakeRange(0,title.length);
    [title addAttribute:NSForegroundColorAttributeName value:color range:range];
    [title fixAttributesInRange:range]; self.attributedTitle=title;
}
- (void)setText:(NSString *)text withColor:(NSColor *)color isShadow:(BOOL)enabled { // 0x100055ed8
    NSShadow *shadow=[[NSShadow alloc] init]; shadow.shadowColor=NSColor.grayColor;
    shadow.shadowOffset=NSMakeSize(0,-1); shadow.shadowBlurRadius=1;
    NSMutableAttributedString *title=[[NSMutableAttributedString alloc] initWithAttributedString:self.attributedTitle];
    NSRange range=NSMakeRange(0,title.length);
    [title addAttribute:NSForegroundColorAttributeName value:color range:range];
    if(enabled) [title addAttribute:NSShadowAttributeName value:shadow range:range];
    else [title removeAttribute:NSShadowAttributeName range:range];
    [title fixAttributesInRange:range]; [title replaceCharactersInRange:range withString:text]; self.attributedTitle=title;
}
- (void)setText:(NSString *)text withColor:(NSColor *)color isUnderLine:(BOOL)enabled { // 0x100056074
    NSShadow *shadow=[[NSShadow alloc] init]; shadow.shadowColor=NSColor.grayColor;
    shadow.shadowOffset=NSMakeSize(0,-1); shadow.shadowBlurRadius=1;
    NSMutableAttributedString *title=[[NSMutableAttributedString alloc] initWithAttributedString:self.attributedTitle];
    NSRange range=NSMakeRange(0,title.length);
    [title addAttribute:NSForegroundColorAttributeName value:color range:range];
    if(enabled) [title addAttribute:NSUnderlineStyleAttributeName value:@1 range:range];
    else [title removeAttribute:NSUnderlineStyleAttributeName range:range];
    [title fixAttributesInRange:range]; [title replaceCharactersInRange:range withString:text]; self.attributedTitle=title;
}
@end
@implementation NSView (Frame)
- (void)centerYInSuperview { // 0x1000562e4
    NSView *parent=self.superview;
    if(parent) { NSRect r=self.frame,b=parent.bounds; r.origin.y=(b.origin.y+b.size.height*.5)-r.size.height*.5; self.frame=r; }
}
- (void)centerXInSuperview { // 0x10005636c
    NSView *parent=self.superview;
    if(parent) { NSRect r=self.frame,b=parent.bounds; r.origin.x=(b.origin.x+b.size.width*.5)-r.size.width*.5; self.frame=r; }
}
- (void)centerInSuperview { [self centerXInSuperview]; [self centerYInSuperview]; }
@end
@implementation NSImageView (customImageView)
- (BOOL)mouseDownCanMoveWindow { return YES; } // 0x100046dbc
@end
