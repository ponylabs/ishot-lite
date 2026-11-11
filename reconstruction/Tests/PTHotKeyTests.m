#import "../Sources/PTHotKey/PTHotKey.h"
#include <assert.h>

@interface CountingHotKey : PTHotKey
@property(nonatomic) NSUInteger presses;
@property(nonatomic) NSUInteger releases;
@end
@implementation CountingHotKey
- (void)invoke { self.presses++; }
- (void)uninvoke { self.releases++; }
@end
static OSStatus Send(PTHotKeyCenter *center, UInt32 kind, UInt32 signature, UInt32 identifier) {
    EventRef event;
    assert(CreateEvent(NULL, kEventClassKeyboard, kind, 0, 0, &event) == noErr);
    EventHotKeyID hotKeyID = {signature, identifier};
    assert(SetEventParameter(event, kEventParamDirectObject, typeEventHotKeyID, sizeof(hotKeyID), &hotKeyID) == noErr);
    OSStatus status = [center sendCarbonEvent:event];
    ReleaseEvent(event);
    return status;
}
int main(void) { @autoreleasepool {
    PTKeyCombo *clear = [PTKeyCombo clearKeyCombo];
    assert([clear keyCode] == -1 && [clear modifiers] == NSUIntegerMax);
    assert(![clear isClearCombo] && ![clear isValidHotKeyCombo]);
    assert([clear copy] == clear);
    for (NSInteger code = -2; code <= 130; code++) {
        BOOL function = code == 64 || code == 79 || code == 80 || code == 90 ||
            (code >= 96 && code <= 101) || code == 103 || (code >= 105 && code <= 107) ||
            code == 109 || code == 111 || code == 113 || code == 118 || code == 120 || code == 122;
        PTKeyCombo *combo = [PTKeyCombo keyComboWithKeyCode:code modifiers:0];
        assert([combo modifiers] == (function ? 0x800000 : 0));
        assert([combo isValidHotKeyCombo] == (code >= 0 && function));
        assert([combo isClearCombo] == (code == -1));
    }
    PTKeyCombo *combo = [[PTKeyCombo alloc] initWithPlistRepresentation:@{@"keyCode":@2, @"modifiers":@256}];
    assert(([[combo plistRepresentation] isEqual:@{@"keyCode":@2, @"modifiers":@256}]));
    assert([combo isEqual:[[PTKeyCombo alloc] initWithPlistRepresentation:[combo plistRepresentation]]]);
    PTKeyCombo *zero = [[PTKeyCombo alloc] initWithPlistRepresentation:@{@"keyCode":@2, @"modifiers":@0}];
    assert([zero modifiers] == NSUIntegerMax);
    PTHotKey *factory = [PTHotKey hotKeyWithIdentifier:@"factory" keyCombo:@{@"keyCode":@2, @"modifierFlags":@0x1e0000} target:nil action:NULL withObject:@"payload"];
    assert([[factory keyCombo] modifiers] == 0x1b00);
    assert([[factory object] isEqual:@"payload"]);
    assert([[[PTHotKey alloc] init] keyCombo] != nil);
    PTHotKeyCenter *center = [[PTHotKeyCenter alloc] init];
    [center pause]; assert([center isPaused]);
    CountingHotKey *key = [[CountingHotKey alloc] initWithIdentifier:@"test" keyCombo:combo];
    assert([center registerHotKey:key]);
    assert([center hotKeyWithIdentifier:@"test"] == key);
    assert([center hotKeyWithIdentifier:nil] == nil);
    UInt32 identifier = [key carbonHotKeyID];
    assert(identifier == 1 && [key carbonEventHotKeyRef] == NULL);
    assert(Send(center, 5, 0x5054486b, identifier) == noErr && key.presses == 1);
    assert(Send(center, 6, 0x5054486b, identifier) == noErr && key.releases == 1);
    assert(Send(center, 7, 0x5054486b, identifier) == eventNotHandledErr);
    assert(Send(center, 5, 0, identifier) == eventNotHandledErr);
    assert(Send(center, 5, 0x5054486b, 0) == eventNotHandledErr);
    assert(Send(center, 5, 0x5054486b, 999) == noErr);
    [center unregisterHotKey:key];
    assert([[center allHotKeys] count] == 0 && [key carbonHotKeyID] == 0);
    [center resume]; assert(![center isPaused]);
    assert([center registerHotKey:[[PTHotKey alloc] init]] && [[center allHotKeys] count] == 0);
    puts("PTHotKey evidence tests passed");
} return 0; }
