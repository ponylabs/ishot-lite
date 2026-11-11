#import <Cocoa/Cocoa.h>
#import <float.h>
// 0x10004cf0c. Family membership is tested before fontWithName:size:.
NSFont *IShotFunction_10004cf0c(NSString *name, int size) {
    NSArray *families = NSFontManager.sharedFontManager.availableFontFamilies;
    NSFont *font = [NSFont systemFontOfSize:(double)size];
    if ([families containsObject:name]) font = [NSFont fontWithName:name size:(double)size];
    return font;
}
// 0x100048504 returns usedRect.size in d0/d1 (REA assembly verified).
CGSize IShotFunction_100048504(NSString *text, NSFont *font) {
    if ([text isEqualToString:@""] || text == nil) text = @" ";
    NSDictionary *attributes = @{NSFontAttributeName:font};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    NSTextStorage *storage = [[NSTextStorage alloc] initWithAttributedString:string];
    NSTextContainer *container = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(DBL_MAX, DBL_MAX)];
    NSLayoutManager *manager = [[NSLayoutManager alloc] init];
    [manager addTextContainer:container];
    [storage addLayoutManager:manager];
    container.lineFragmentPadding = 0;
    [manager glyphRangeForTextContainer:container];
    return [manager usedRectForTextContainer:container].size;
}
