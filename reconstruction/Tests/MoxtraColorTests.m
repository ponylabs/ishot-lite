#import "../Sources/Common/NSColor+Moxtra.h"
#include <assert.h>
int main(void) { @autoreleasepool {
    [NSApplication sharedApplication];
    NSColor *blue=[NSColor moxtraBlueColor];
    assert(blue.redComponent==(double).17f && blue.greenComponent==(double).67f && blue.blueComponent==1 && blue.alphaComponent==1);
    assert([[NSColor moxtraBrandingColor] isEqual:blue]);
    assert(![[NSColor brandingColor] isEqual:blue]);
    NSColor *hex=[NSColor moxtraColorWithHexString:@"#123456"];
    assert(hex.redComponent==18./255. && hex.greenComponent==52./255. && hex.blueComponent==86./255.);
    assert([NSColor moxtraColorWithHexString:@""]==nil);
    assert([NSColor moxtraColorWithHexString:@"xFF0000"].redComponent==1);
    assert([NSColor moxtraColorWithHexString:@"#not-hex"].redComponent==0);
    NSColor *numeric=[NSColor moxtraColorWithHex:0x123456 alpha:.7];
    assert(numeric.redComponent==(double)(18.f/255.f) && numeric.alphaComponent==.7);
    assert([NSColor moxtraGreenColor].greenComponent==(double)(200.f/255.f));
    assert([NSColor moxtraGray60Color].blueComponent==(double)(102.f/255.f));
    // The pattern's shipped image is a separate resource dependency; use a test
    // image under its exact name to exercise this method without copying assets.
    NSImage *pattern=[[NSImage alloc] initWithSize:NSMakeSize(2,2)]; [pattern setName:@"texture_page"];
    assert([NSColor moxtraPageTextureColor].type==NSColorTypePattern);
    NSLog(@"PASS Moxtra color constants, exact float/double conversions, scanner behavior and pattern lookup");
} return 0; }
