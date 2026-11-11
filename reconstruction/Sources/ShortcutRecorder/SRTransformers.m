#import "SRTransformers.h"
static NSString *SRUnicharToString(UniChar character) { return [NSString stringWithFormat:@"%C", character]; }
@implementation SRModifierFlagsTransformer
- (instancetype)initWithPlainStrings:(BOOL)plain { if ((self = [super init])) _usesPlainStrings = plain; return self; }
- (instancetype)init { return [self initWithPlainStrings:NO]; }
+ (instancetype)sharedTransformer { static id transformer; static dispatch_once_t once; dispatch_once(&once, ^{ transformer = [[self alloc] initWithPlainStrings:NO]; }); return transformer; }
+ (instancetype)sharedPlainTransformer { static id transformer; static dispatch_once_t once; dispatch_once(&once, ^{ transformer = [[self alloc] initWithPlainStrings:YES]; }); return transformer; }
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(id)value {
    if (![value isKindOfClass:[NSNumber class]]) return nil;
    NSUInteger flags = [value unsignedIntegerValue];
    if (![self usesPlainStrings]) return [NSString stringWithFormat:@"%@%@%@%@", flags & 0x40000 ? @"⌃" : @"", flags & 0x80000 ? @"⌥" : @"", flags & 0x20000 ? @"⇧" : @"", flags & 0x100000 ? @"⌘" : @""];
    NSMutableString *result = [NSMutableString string];
    if (flags & 0x40000) [result appendString:SRLoc(@"Control-")];
    if (flags & 0x80000) [result appendString:SRLoc(@"Option-")];
    if (flags & 0x20000) [result appendString:SRLoc(@"Shift-")];
    if (flags & 0x100000) [result appendString:SRLoc(@"Command-")];
    if ([result length]) [result deleteCharactersInRange:NSMakeRange([result length] - 1, 1)];
    return result;
}
@end
@implementation SRKeyCodeTransformer
- (instancetype)initWithASCIICapableKeyboardInputSource:(BOOL)ascii plainStrings:(BOOL)plain {
    if ((self = [super init])) { _usesASCIICapableKeyboardInputSource = ascii; _usesPlainStrings = plain; } return self;
}
- (instancetype)init { return [self initWithASCIICapableKeyboardInputSource:NO plainStrings:NO]; }
+ (instancetype)sharedTransformer { static id transformer; static dispatch_once_t once; dispatch_once(&once, ^{ transformer = [[self alloc] initWithASCIICapableKeyboardInputSource:NO plainStrings:NO]; }); return transformer; }
+ (instancetype)sharedASCIITransformer { static id transformer; static dispatch_once_t once; dispatch_once(&once, ^{ transformer = [[self alloc] initWithASCIICapableKeyboardInputSource:YES plainStrings:NO]; }); return transformer; }
+ (instancetype)sharedPlainTransformer { static id transformer; static dispatch_once_t once; dispatch_once(&once, ^{ transformer = [[self alloc] initWithASCIICapableKeyboardInputSource:NO plainStrings:YES]; }); return transformer; }
+ (instancetype)sharedPlainASCIITransformer { static id transformer; static dispatch_once_t once; dispatch_once(&once, ^{ transformer = [[self alloc] initWithASCIICapableKeyboardInputSource:YES plainStrings:YES]; }); return transformer; }
+ (NSDictionary *)specialKeyCodesToUnicodeCharactersMapping {
    static NSDictionary *mapping; static dispatch_once_t once;
    dispatch_once(&once, ^{
        mapping = @{
            @122:SRUnicharToString(0xf704), @120:SRUnicharToString(0xf705), @99:SRUnicharToString(0xf706), @118:SRUnicharToString(0xf707),
            @96:SRUnicharToString(0xf708), @97:SRUnicharToString(0xf709), @98:SRUnicharToString(0xf70a), @100:SRUnicharToString(0xf70b),
            @101:SRUnicharToString(0xf70c), @109:SRUnicharToString(0xf70d), @103:SRUnicharToString(0xf70e), @111:SRUnicharToString(0xf70f),
            @105:SRUnicharToString(0xf710), @107:SRUnicharToString(0xf711), @113:SRUnicharToString(0xf712), @106:SRUnicharToString(0xf713),
            @64:SRUnicharToString(0xf714), @79:SRUnicharToString(0xf715), @80:SRUnicharToString(0xf716), @90:SRUnicharToString(0xf717),
            @49:SRUnicharToString(0x20), @51:SRUnicharToString(8), @117:SRUnicharToString(0x7f), @71:SRUnicharToString(0xf739),
            @123:SRUnicharToString(0xf702), @124:SRUnicharToString(0xf703), @126:SRUnicharToString(0xf700), @125:SRUnicharToString(0xf701),
            @119:SRUnicharToString(0xf72b), @115:SRUnicharToString(0xf729), @53:SRUnicharToString(0x1b), @121:SRUnicharToString(0xf72d),
            @116:SRUnicharToString(0xf72c), @36:SRUnicharToString(0xd), @76:SRUnicharToString(3), @48:SRUnicharToString(9), @114:SRUnicharToString(0xf746)
        };
    }); return mapping;
}
+ (NSDictionary *)specialKeyCodesToPlainStringsMapping {
    static NSDictionary *mapping; static dispatch_once_t once;
    dispatch_once(&once, ^{
        mapping = @{@122:@"F1", @120:@"F2", @99:@"F3", @118:@"F4", @96:@"F5", @97:@"F6", @98:@"F7", @100:@"F8", @101:@"F9", @109:@"F10", @103:@"F11", @111:@"F12", @105:@"F13", @107:@"F14", @113:@"F15", @106:@"F16", @64:@"F17", @79:@"F18", @80:@"F19", @90:@"F20",
            @49:SRLoc(@"Space"), @51:SRUnicharToString(0x232b), @117:SRUnicharToString(0x2326), @71:SRUnicharToString(0x2327), @123:SRUnicharToString(0x2190), @124:SRUnicharToString(0x2192), @126:SRUnicharToString(0x2191), @125:SRUnicharToString(0x2193), @119:@"Fn + ▶", @115:@"Fn + ◄", @53:SRUnicharToString(0x238b), @121:@"Fn + ▼", @116:@"Fn + ▲", @36:SRUnicharToString(0x21a9), @76:SRUnicharToString(0x2305), @48:SRUnicharToString(0x21e5), @114:@"?⃝"};
    }); return mapping;
}
- (BOOL)isKeyCodeSpecial:(unsigned short)code {
    switch (code) {
        case 36: case 48: case 49: case 51: case 53: case 64: case 71: case 76: case 79: case 80: case 90: case 96: case 97: case 98: case 99: case 100: case 101: case 103: case 105: case 106: case 107: case 109: case 111: case 113: case 114: case 115: case 116: case 117: case 118: case 119: case 120: case 121: case 122: case 123: case 124: case 125: case 126: return YES;
        default: return NO;
    }
}
+ (BOOL)allowsReverseTransformation { return NO; }
+ (Class)transformedValueClass { return [NSString class]; }
- (id)transformedValue:(id)value { return [self transformedValue:value withModifierFlags:nil]; }
- (NSString *)transformedValue:(id)value withModifierFlags:(NSNumber *)flags { return [self transformedValue:value withImplicitModifierFlags:flags explicitModifierFlags:nil]; }
- (NSString *)transformedValue:(id)value withImplicitModifierFlags:(NSNumber *)implicitFlags explicitModifierFlags:(NSNumber *)explicitFlags {
    if ([implicitFlags unsignedIntegerValue] & [explicitFlags unsignedIntegerValue] & 0x1e0000)
        [NSException raise:NSInvalidArgumentException format:@"anImplicitModifierFlags and anExplicitModifierFlags MUST NOT have common elements"];
    if (![value isKindOfClass:[NSNumber class]]) return @"";
    NSString *special = [self transformedSpecialKeyCode:value withExplicitModifierFlags:explicitFlags];
    if (special) return special;
    CFDataRef data = NULL;
    TISInputSourceRef source = [self usesASCIICapableKeyboardInputSource] ? TISCopyCurrentASCIICapableKeyboardLayoutInputSource() : TISCopyCurrentKeyboardLayoutInputSource();
    if (!source) return @"";
    data = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData); CFRelease(source);
    if (!data && ![self usesASCIICapableKeyboardInputSource]) {
        source = TISCopyCurrentASCIICapableKeyboardLayoutInputSource();
        if (!source) return @"";
        data = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData); CFRelease(source);
    }
    if (!data) return @"";
    const UCKeyboardLayout *layout = (const UCKeyboardLayout *)CFDataGetBytePtr(data);
    UniCharCount length = 0; UniChar characters[255] = {0}; UInt32 deadState = 0;
    OSStatus status = UCKeyTranslate(layout, [value unsignedShortValue], 3, SRCocoaToCarbonFlags([implicitFlags unsignedIntegerValue]) >> 8, LMGetKbdType(), 0, &deadState, 255, &length, characters);
    if (status) return @"";
    NSString *result = [NSString stringWithCharacters:characters length:length];
    return [self usesPlainStrings] ? [result uppercaseString] : result;
}
- (NSString *)transformedSpecialKeyCode:(NSNumber *)code withExplicitModifierFlags:(NSNumber *)flags {
    if (([flags unsignedIntegerValue] & 0x20000) && [code unsignedShortValue] == 48)
        return SRUnicharToString([self usesPlainStrings] ? 0x21e5 : 0x19);
    return [self usesPlainStrings] ? [[self class] specialKeyCodesToPlainStringsMapping][code] : [[self class] specialKeyCodesToUnicodeCharactersMapping][code];
}
@end
@implementation SRKeyEquivalentTransformer
+ (BOOL)allowsReverseTransformation { return NO; }
+ (Class)transformedValueClass { return [NSString class]; }
- (id)transformedValue:(id)value {
    if (![value isKindOfClass:[NSDictionary class]]) return @"";
    id code = value[@"keyCode"]; if (![code isKindOfClass:[NSNumber class]]) return @"";
    id flags = value[@"modifierFlags"]; if (![flags isKindOfClass:[NSNumber class]]) flags = @0;
    return [[SRKeyCodeTransformer sharedASCIITransformer] transformedValue:code withImplicitModifierFlags:nil explicitModifierFlags:flags];
}
@end
@implementation SRKeyEquivalentModifierMaskTransformer
+ (BOOL)allowsReverseTransformation { return NO; }
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value {
    if (![value isKindOfClass:[NSDictionary class]]) return @0;
    id flags = value[@"modifierFlags"]; return [flags isKindOfClass:[NSNumber class]] ? flags : @0;
}
@end
