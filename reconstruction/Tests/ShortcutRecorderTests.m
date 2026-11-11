#import "../Sources/ShortcutRecorder/SRRecorderControl.h"
#import "../Sources/ShortcutRecorder/SRTransformers.h"
#import "../Sources/ShortcutRecorder/SRValidator.h"
#include <assert.h>
@interface SRTestDelegate : NSObject <SRValidatorDelegate, SRRecorderControlDelegate>
@property(nonatomic) NSUInteger begins, ends;
@property(nonatomic) BOOL reject;
@end
@implementation SRTestDelegate
- (void)shortcutRecorderWillBegin { _begins++; }
- (void)shortcutRecorderDidEndRecording:(SRRecorderControl *)control { _ends++; }
- (BOOL)shortcutValidator:(SRValidator *)validator isKeyCode:(unsigned short)code andFlagsTaken:(NSUInteger)flags reason:(NSString **)reason { if (reason) *reason = @"test reason"; return _reject; }
- (BOOL)shortcutValidatorShouldCheckSystemShortcuts:(SRValidator *)validator { return NO; }
- (BOOL)shortcutValidatorShouldCheckMenu:(SRValidator *)validator { return NO; }
@end
static id Null(id value) { return value ?: [NSNull null]; }
int main(void) { @autoreleasepool {
    [NSApplication sharedApplication]; [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    NSMutableArray *transforms = [NSMutableArray array];
    NSArray *transformers = @[[SRKeyCodeTransformer sharedTransformer], [SRKeyCodeTransformer sharedASCIITransformer], [SRKeyCodeTransformer sharedPlainTransformer], [SRKeyCodeTransformer sharedPlainASCIITransformer]];
    for (SRKeyCodeTransformer *transformer in transformers) {
        for (NSUInteger code = 0; code < 128; code++) {
            [transforms addObject:@[@(code), @([transformer isKeyCodeSpecial:code]), Null([transformer transformedValue:@(code)]), Null([transformer transformedValue:@(code) withImplicitModifierFlags:nil explicitModifierFlags:@0x20000]), Null([transformer transformedValue:@(code) withModifierFlags:@0x20000])]];
        }
    }
    results[@"transformers"] = transforms;
    NSMutableArray *flags = [NSMutableArray array];
    for (NSUInteger mask = 0; mask < 16; mask++) [flags addObject:@[Null([[SRModifierFlagsTransformer sharedTransformer] transformedValue:@(mask << 17)]), Null([[SRModifierFlagsTransformer sharedPlainTransformer] transformedValue:@(mask << 17)])]];
    results[@"flags"] = flags;
    // Stable current-contract assertions; these do not require a vendor binary or keyboard layout.
    NSArray *glyphs = @[@"", @"⇧", @"⌃", @"⌃⇧", @"⌥", @"⌥⇧", @"⌃⌥", @"⌃⌥⇧",
                        @"⌘", @"⇧⌘", @"⌃⌘", @"⌃⇧⌘", @"⌥⌘", @"⌥⇧⌘", @"⌃⌥⌘", @"⌃⌥⇧⌘"];
    NSArray *plainFlags = @[@"", @"Shift", @"Control", @"Control-Shift", @"Option", @"Option-Shift", @"Control-Option", @"Control-Option-Shift",
                            @"Command", @"Shift-Command", @"Control-Command", @"Control-Shift-Command", @"Option-Command", @"Option-Shift-Command", @"Control-Option-Command", @"Control-Option-Shift-Command"];
    for (NSUInteger mask = 0; mask < 16; mask++) {
        assert([flags[mask][0] isEqual:glyphs[mask]]);
        assert([flags[mask][1] isEqual:plainFlags[mask]]);
    }
    NSArray *functionCodes = @[@122, @120, @99, @118, @96, @97, @98, @100, @101, @109, @103, @111, @105, @107, @113, @106, @64, @79, @80, @90];
    for (NSUInteger index = 0; index < functionCodes.count; index++) {
        NSNumber *code = functionCodes[index];
        assert([[SRKeyCodeTransformer sharedTransformer] isKeyCodeSpecial:code.unsignedShortValue]);
        assert(([[[SRKeyCodeTransformer sharedPlainTransformer] transformedValue:code] isEqual:[NSString stringWithFormat:@"F%lu", index + 1]]));
        UniChar scalar = 0xf704 + index;
        assert([[[SRKeyCodeTransformer sharedTransformer] transformedValue:code] isEqual:[NSString stringWithCharacters:&scalar length:1]]);
    }
    assert(![[SRKeyCodeTransformer sharedTransformer] isKeyCodeSpecial:0]);
    assert([[[SRKeyCodeTransformer sharedPlainTransformer] transformedValue:@123] isEqual:@"←"]);
    assert([[[SRKeyCodeTransformer sharedPlainTransformer] transformedValue:@124] isEqual:@"→"]);
    assert([[[SRKeyCodeTransformer sharedPlainTransformer] transformedValue:@126] isEqual:@"↑"]);
    assert([[[SRKeyCodeTransformer sharedPlainTransformer] transformedValue:@125] isEqual:@"↓"]);
    assert([[[SRKeyCodeTransformer sharedTransformer] transformedValue:@48 withImplicitModifierFlags:nil explicitModifierFlags:@0x20000] isEqual:@"\x19"]);

    assert([[SRKeyEquivalentTransformer new] transformedValue:@"bad"] != nil);
    assert([[[SRKeyEquivalentModifierMaskTransformer new] transformedValue:@{}] isEqual:@0]);
    BOOL raised = NO; @try { [[SRKeyCodeTransformer sharedTransformer] transformedValue:@0 withImplicitModifierFlags:@0x20000 explicitModifierFlags:@0x20000]; } @catch (NSException *exception) { raised = [exception.name isEqual:NSInvalidArgumentException]; } assert(raised);
    SRTestDelegate *delegate = [SRTestDelegate new]; SRValidator *validator = [[SRValidator alloc] initWithDelegate:delegate];
    assert(![validator isKeyCode:0 andFlagsTaken:0 error:NULL]); delegate.reject = YES;
    NSError *error; assert([validator isKeyCode:122 andFlagsTaken:0x100000 error:&error]); results[@"delegateError"] = error.userInfo;
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Root"];
    NSMenuItem *parent = [[NSMenuItem alloc] initWithTitle:@"Parent" action:NULL keyEquivalent:@""];
    NSMenu *childMenu = [[NSMenu alloc] initWithTitle:@"ChildMenu"];
    NSMenuItem *child = [[NSMenuItem alloc] initWithTitle:@"Child" action:NULL keyEquivalent:@"\r"];
    [child setKeyEquivalentModifierMask:0x100000]; [childMenu addItem:child]; [parent setSubmenu:childMenu]; [menu addItem:parent];
    assert([validator isKeyCode:36 andFlags:0x100000 takenInMenu:menu error:&error]); results[@"menuError"] = error.userInfo; results[@"menuPath"] = [child SR_path];
    NSMutableArray *controls = [NSMutableArray array];
    for (NSNumber *width in @[@40, @100, @200]) {
        SRRecorderControl *control = [[SRRecorderControl alloc] initWithFrame:NSMakeRect(0, 0, width.doubleValue, 20)]; control.delegate = delegate;
        assert(control.isEnabled && !control.isRecording && control.allowedModifierFlags == 0x1e0000);
        for (NSDictionary *value in @[@{}, @{@"keyCode":@122, @"modifierFlags":@0x100000}, @{@"keyCode":@48, @"modifierFlags":@0x20000}]) {
            [control setObjectValue:value];
            for (NSUInteger recording = 0; recording < 2; recording++) {
                if (recording) assert([control beginRecording]);
                [controls addObject:@{ @"width":width, @"value":value, @"recording":@(recording), @"label":Null([control label]), @"accessibility":Null([control accessibilityLabel]), @"string":Null([control stringValue]), @"shape":NSStringFromRect([[control controlShape] bounds]), @"clear":NSStringFromRect([control clearButtonRect]), @"snap":NSStringFromRect([control snapBackButtonRect]), @"labelRect":NSStringFromRect([control rectForLabel:[control label] withAttributes:[control labelAttributes]]), @"intrinsic":NSStringFromSize([control intrinsicContentSize]), @"tracking":@([[control trackingAreas] count]) }];
                if (recording) [control endRecording];
            }
        }
        [control setAllowedModifierFlags:0x60000 requiredModifierFlags:0x20000 allowsEmptyModifierFlags:NO];
        assert(![control areModifierFlagsValid:0 forKeyCode:0]); assert([control areModifierFlagsValid:0x20000 forKeyCode:0]); assert(![control areModifierFlagsValid:0x100000 forKeyCode:0]);
        [control beginRecording]; [control setEnabled:NO]; assert(!control.isRecording && ![control beginRecording]);
    }
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 200, 40) styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
    SRRecorderControl *control = [[SRRecorderControl alloc] initWithFrame:NSMakeRect(0, 0, 200, 20)]; control.delegate = delegate;
    [[window contentView] addSubview:control]; [window makeFirstResponder:control];
    NSEvent *space = [NSEvent keyEventWithType:NSEventTypeKeyDown location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:[window windowNumber] context:nil characters:@" " charactersIgnoringModifiers:@" " isARepeat:NO keyCode:49];
    assert([control performKeyEquivalent:space] && control.isRecording);
    NSEvent *record = [NSEvent keyEventWithType:NSEventTypeKeyDown location:NSZeroPoint modifierFlags:0x100000 timestamp:0 windowNumber:[window windowNumber] context:nil characters:@"a" charactersIgnoringModifiers:@"a" isARepeat:NO keyCode:0];
    assert([control performKeyEquivalent:record] && !control.isRecording); results[@"recordedEvent"] = control.objectValue;
    assert([control.objectValue[@"keyCode"] isEqual:@0] && [control.objectValue[@"modifierFlags"] isEqual:@0x100000]);
    [window makeFirstResponder:control]; [control beginRecording];
    NSEvent *escape = [NSEvent keyEventWithType:NSEventTypeKeyDown location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:[window windowNumber] context:nil characters:@"\x1b" charactersIgnoringModifiers:@"\x1b" isARepeat:NO keyCode:53];
    assert([control performKeyEquivalent:escape] && !control.isRecording && control.objectValue != nil);
    [window makeFirstResponder:control]; [control beginRecording];
    NSEvent *delete = [NSEvent keyEventWithType:NSEventTypeKeyDown location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:[window windowNumber] context:nil characters:@"\x7f" charactersIgnoringModifiers:@"\x7f" isARepeat:NO keyCode:51];
    assert([control performKeyEquivalent:delete] && !control.isRecording && control.objectValue == nil);
    [window setReleasedWhenClosed:NO]; [window close];
    assert(delegate.begins == delegate.ends && delegate.begins > 0);
    results[@"controls"] = controls;
    NSData *data = [NSJSONSerialization dataWithJSONObject:results options:NSJSONWritingSortedKeys error:NULL];
    fwrite(data.bytes, 1, data.length, stdout); putchar('\n');
} return 0; }
