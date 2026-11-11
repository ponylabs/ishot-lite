#import <Cocoa/Cocoa.h>
@interface NSButton (TextColor)
@property(nonatomic,strong) NSColor *textColor;
- (void)setText:(NSString *)text withColor:(NSColor *)color isShadow:(BOOL)shadow;
- (void)setText:(NSString *)text withColor:(NSColor *)color isUnderLine:(BOOL)underline;
@end
@interface NSView (Frame)
- (void)centerYInSuperview;
- (void)centerXInSuperview;
- (void)centerInSuperview;
@end
