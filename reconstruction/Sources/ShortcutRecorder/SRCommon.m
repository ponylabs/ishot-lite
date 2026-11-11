#import "SRCommon.h"
#import "SRTransformers.h"
NSBundle *SRBundle(void) {
    static NSBundle *bundle; static dispatch_once_t once;
    dispatch_once(&once, ^{
        bundle = [NSBundle bundleWithIdentifier:@"com.kulakov.ShortcutRecorder"];
        if (!bundle) {
            bundle = [NSBundle bundleWithIdentifier:@"org.cocoapods.ShortcutRecorder"];
            if (!bundle) { Class control = NSClassFromString(@"SRRecorderControl"); if (control) bundle = [NSBundle bundleForClass:control]; }
            if (bundle) bundle = [NSBundle bundleWithPath:[bundle pathForResource:@"ShortcutRecorder" ofType:@"bundle"]];
        }
    });
    if (!bundle) @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unable to find bundle with resources." userInfo:nil];
    return bundle;
}
NSString *SRLoc(NSString *key) { return [SRBundle() localizedStringForKey:key value:@"" table:@"ShortcutRecorder"]; }
NSImage *SRImage(NSString *name) {
    if ((NSInteger)NSAppKitVersionNumber <= 1038) return [[NSImage alloc] initByReferencingURL:[SRBundle() URLForImageResource:name]];
    return [SRBundle() imageForResource:name];
}
UInt32 SRCocoaToCarbonFlags(NSUInteger flags) {
    UInt32 result = 0;
    if (flags & 0x100000) result = 0x100;
    if (flags & 0x80000) result |= 0x800;
    if (flags & 0x40000) result |= 0x1000;
    if (flags & 0x20000) result |= 0x200;
    return result;
}
NSUInteger SRCarbonToCocoaFlags(UInt32 flags) {
    NSUInteger result = 0;
    if (flags & 0x100) result = 0x100000;
    if (flags & 0x800) result |= 0x80000;
    if (flags & 0x1000) result |= 0x40000;
    if (flags & 0x200) result |= 0x20000;
    return result;
}
NSString *SRReadableStringForCocoaModifierFlagsAndKeyCode(NSUInteger flags, unsigned short code) {
    NSString *key = [[SRKeyCodeTransformer sharedPlainTransformer] transformedValue:@(code)];
    return [NSString stringWithFormat:@"%@%@%@%@%@", flags & 0x100000 ? SRLoc(@"Command-") : @"", flags & 0x80000 ? SRLoc(@"Option-") : @"", flags & 0x40000 ? SRLoc(@"Control-") : @"", flags & 0x20000 ? SRLoc(@"Shift-") : @"", key];
}
NSString *SRReadableASCIIStringForCocoaModifierFlagsAndKeyCode(NSUInteger flags, unsigned short code) {
    NSString *key = [[SRKeyCodeTransformer sharedPlainASCIITransformer] transformedValue:@(code)];
    return [NSString stringWithFormat:@"%@%@%@%@%@", flags & 0x100000 ? SRLoc(@"Command-") : @"", flags & 0x80000 ? SRLoc(@"Option-") : @"", flags & 0x40000 ? SRLoc(@"Control-") : @"", flags & 0x20000 ? SRLoc(@"Shift-") : @"", key];
}
static BOOL SRKeyCodeEqual(unsigned short code, NSUInteger flags, NSString *equivalent, NSUInteger equivalentFlags, SRKeyCodeTransformer *transformer) {
    if (!equivalent) return NO;
    flags &= 0x1e0000; equivalentFlags &= 0x1e0000;
    if (flags == equivalentFlags) return [[transformer transformedValue:@(code) withImplicitModifierFlags:nil explicitModifierFlags:@(flags)] isEqual:equivalent];
    if (equivalentFlags == 0 || (flags & equivalentFlags) == equivalentFlags) {
        if ([[transformer transformedValue:@(code) withImplicitModifierFlags:nil explicitModifierFlags:@(flags)] isEqual:equivalent]) return NO;
        return [[transformer transformedValue:@(code) withImplicitModifierFlags:@(flags & ~equivalentFlags) explicitModifierFlags:@(equivalentFlags)] isEqual:equivalent];
    }
    return NO;
}
BOOL SRKeyCodeWithFlagsEqualToKeyEquivalentWithFlags(unsigned short code, NSUInteger flags, NSString *equivalent, NSUInteger equivalentFlags) {
    if (SRKeyCodeEqual(code, flags, equivalent, equivalentFlags, [SRKeyCodeTransformer sharedASCIITransformer])) return YES;
    return SRKeyCodeEqual(code, flags, equivalent, equivalentFlags, [SRKeyCodeTransformer sharedTransformer]);
}
