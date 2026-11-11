#import "SRValidator.h"
@implementation SRValidator
- (instancetype)initWithDelegate:(id<SRValidatorDelegate>)delegate { if ((self = [super init])) _delegate = delegate; return self; }
- (instancetype)init { return [self initWithDelegate:nil]; }
- (BOOL)isKeyCode:(unsigned short)code andFlagsTaken:(NSUInteger)flags error:(NSError **)error {
    if ([self isKeyCode:code andFlagTakenInDelegate:flags error:error]) return YES;
    if ((![[self delegate] respondsToSelector:@selector(shortcutValidatorShouldCheckSystemShortcuts:)] || [[self delegate] shortcutValidatorShouldCheckSystemShortcuts:self]) && [self isKeyCode:code andFlagsTakenInSystemShortcuts:flags error:error]) return YES;
    if ((![[self delegate] respondsToSelector:@selector(shortcutValidatorShouldCheckMenu:)] || [[self delegate] shortcutValidatorShouldCheckMenu:self]) && [self isKeyCode:code andFlags:flags takenInMenu:[NSApp mainMenu] error:error]) return YES;
    return NO;
}
- (BOOL)isKeyCode:(unsigned short)code andFlagTakenInDelegate:(NSUInteger)flags error:(NSError **)error {
    if (![self delegate]) return NO;
    NSString *reason = nil;
    if (![[self delegate] respondsToSelector:@selector(shortcutValidator:isKeyCode:andFlagsTaken:reason:)] || ![[self delegate] shortcutValidator:self isKeyCode:code andFlagsTaken:flags reason:&reason]) return NO;
    if (error) {
        BOOL ascii = YES;
        if ([[self delegate] respondsToSelector:@selector(shortcutValidatorShouldUseASCIIStringForKeyCodes:)]) ascii = [[self delegate] shortcutValidatorShouldUseASCIIStringForKeyCodes:self];
        NSString *key = ascii ? SRReadableASCIIStringForCocoaModifierFlagsAndKeyCode(flags, code) : SRReadableStringForCocoaModifierFlagsAndKeyCode(flags, code);
        NSString *failure = [NSString stringWithFormat:SRLoc(@"The key combination \"%@\" can't be used!"), key];
        NSString *description = [NSString stringWithFormat:SRLoc(@"The key combination \"%@\" can't be used because %@."), key, [reason length] ? reason : @"it's already used"];
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:failure, NSLocalizedDescriptionKey:description}];
    }
    return YES;
}
- (BOOL)isKeyCode:(unsigned short)code andFlagsTakenInSystemShortcuts:(NSUInteger)flags error:(NSError **)error {
    CFArrayRef values = NULL;
    if (CopySymbolicHotKeys(&values) != noErr) return YES;
    NSArray *shortcuts = CFBridgingRelease(values); flags &= 0x1e0000;
    for (NSDictionary *shortcut in shortcuts) {
        if (shortcut[@"kHISymbolicHotKeyEnabled"] == (__bridge id)kCFBooleanTrue && (unsigned short)[shortcut[@"kHISymbolicHotKeyCode"] integerValue] == code && SRCarbonToCocoaFlags([shortcut[@"kHISymbolicHotKeyModifiers"] unsignedIntValue] & 0x1b00) == flags) {
            if (error) {
                BOOL ascii = YES;
                if ([[self delegate] respondsToSelector:@selector(shortcutValidatorShouldUseASCIIStringForKeyCodes:)]) ascii = [[self delegate] shortcutValidatorShouldUseASCIIStringForKeyCodes:self];
                NSString *key = ascii ? SRReadableASCIIStringForCocoaModifierFlagsAndKeyCode(flags, code) : SRReadableStringForCocoaModifierFlagsAndKeyCode(flags, code);
                NSString *failure = [NSString stringWithFormat:SRLoc(@"The key combination \"%@\" can't be used!"), key];
                NSString *description = [NSString stringWithFormat:SRLoc(@"The key combination \"%@\" can't be used because it's already used by a system-wide keyboard shortcut. If you really want to use this key combination, most shortcuts can be changed in the Keyboard panel in System Preferences."), key];
                *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:failure, NSLocalizedDescriptionKey:description}];
            }
            return YES;
        }
    }
    return NO;
}
- (BOOL)isKeyCode:(unsigned short)code andFlags:(NSUInteger)flags takenInMenu:(NSMenu *)menu error:(NSError **)error {
    flags &= 0x1e0000;
    for (NSMenuItem *item in [menu itemArray]) {
        if ([item hasSubmenu] && [self isKeyCode:code andFlags:flags takenInMenu:[item submenu] error:error]) return YES;
        NSString *equivalent = [item keyEquivalent];
        if (![equivalent length]) continue;
        if (SRKeyCodeWithFlagsEqualToKeyEquivalentWithFlags(code, flags, equivalent, [item keyEquivalentModifierMask])) {
            if (error) {
                BOOL ascii = YES;
                if ([[self delegate] respondsToSelector:@selector(shortcutValidatorShouldUseASCIIStringForKeyCodes:)]) ascii = [[self delegate] shortcutValidatorShouldUseASCIIStringForKeyCodes:self];
                NSString *key = ascii ? SRReadableASCIIStringForCocoaModifierFlagsAndKeyCode(flags, code) : SRReadableStringForCocoaModifierFlagsAndKeyCode(flags, code);
                NSString *failure = [NSString stringWithFormat:SRLoc(@"The key combination \"%@\" can't be used!"), key];
                NSString *description = [NSString stringWithFormat:SRLoc(@"The key combination \"%@\" can't be used because it's already used by the menu item \"%@\"."), key, [item SR_path]];
                *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:failure, NSLocalizedDescriptionKey:description}];
            }
            return YES;
        }
    }
    return NO;
}
@end
@implementation NSMenuItem (SRValidator)
- (NSString *)SR_path {
    NSMutableArray *items = [NSMutableArray array]; NSMenuItem *item = self; NSUInteger count = 0;
    do { [items insertObject:item atIndex:0]; item = [item parentItem]; count++; } while (item && count < 1000);
    NSMutableString *result = [NSMutableString string];
    for (NSMenuItem *ancestor in items) [result appendFormat:@"%@➝", [ancestor title]];
    if ([result length] > 1) [result deleteCharactersInRange:NSMakeRange([result length] - 1, 1)];
    return result;
}
@end
