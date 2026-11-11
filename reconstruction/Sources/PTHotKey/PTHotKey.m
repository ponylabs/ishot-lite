#import "PTHotKey.h"

@implementation PTKeyCombo
+ (instancetype)clearKeyCombo { return [self keyComboWithKeyCode:-1 modifiers:(NSUInteger)-1]; }
+ (instancetype)keyComboWithKeyCode:(NSInteger)code modifiers:(NSUInteger)modifiers {
    return [[self alloc] initWithKeyCode:code modifiers:modifiers];
}
- (instancetype)initWithKeyCode:(NSInteger)code modifiers:(NSUInteger)modifiers {
    if ((self = [super init])) {
        switch (code) {
            case 64: case 79: case 80: case 90: case 96: case 97: case 98:
            case 99: case 100: case 101: case 103: case 105: case 106:
            case 107: case 109: case 111: case 113: case 118: case 120: case 122:
                mModifiers = modifiers | 0x800000; break;
            default: mModifiers = modifiers;
        }
        mKeyCode = code;
    }
    return self;
}
- (instancetype)initWithPlistRepresentation:(NSDictionary *)plist {
    int code = -1, modifiers = -1;
    if (plist && [plist count]) {
        code = [[plist objectForKey:@"keyCode"] intValue];
        if (code < 0) code = -1;
        modifiers = [[plist objectForKey:@"modifiers"] intValue];
        if (modifiers < 1) modifiers = -1;
    }
    return [self initWithKeyCode:code modifiers:(NSUInteger)(NSInteger)modifiers];
}
- (NSDictionary *)plistRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[self keyCode]], @"keyCode", [NSNumber numberWithInteger:(NSInteger)[self modifiers]], @"modifiers", nil];
}
- (id)copyWithZone:(NSZone *)zone { return self; }
- (BOOL)isEqual:(id)other { return [self keyCode] == [(PTKeyCombo *)other keyCode] && [self modifiers] == [(PTKeyCombo *)other modifiers]; }
- (NSInteger)keyCode { return mKeyCode; }
- (NSUInteger)modifiers { return mModifiers; }
- (BOOL)isValidHotKeyCombo { return mKeyCode >= 0 && mModifiers != 0; }
- (BOOL)isClearCombo { return mKeyCode == -1 && mModifiers == 0; }
@end

static UInt32 SRCocoaToCarbonFlags(NSUInteger flags) {
    UInt32 result = 0;
    if (flags & 0x100000) result = 0x100;
    if (flags & 0x80000) result |= 0x800;
    if (flags & 0x40000) result |= 0x1000;
    if (flags & 0x20000) result |= 0x200;
    return result;
}

@implementation PTHotKey
@synthesize keyCombo = _keyCombo;
- (instancetype)init { return [self initWithIdentifier:nil keyCombo:nil withObject:nil]; }
- (instancetype)initWithIdentifier:(id)identifier keyCombo:(PTKeyCombo *)combo {
    return [self initWithIdentifier:identifier keyCombo:combo withObject:nil];
}
- (instancetype)initWithIdentifier:(id)identifier keyCombo:(PTKeyCombo *)combo withObject:(id)object {
    if ((self = [super init])) {
        [self setIdentifier:identifier]; [self setKeyCombo:combo]; [self setObject:object];
    }
    return self;
}
- (void)setKeyCombo:(PTKeyCombo *)combo { _keyCombo = combo ?: [PTKeyCombo clearKeyCombo]; }
- (NSString *)description { return [NSString stringWithFormat:@"<%@: %@, %@>", NSStringFromClass([self class]), [self identifier], [self keyCombo]]; }
- (void)invoke { if (_action) [NSApp sendAction:_action to:_target from:self]; }
- (void)uninvoke { if (_keyUpAction) [NSApp sendAction:_keyUpAction to:_target from:self]; }
+ (instancetype)hotKeyWithIdentifier:(id)identifier keyCombo:(NSDictionary *)combo target:(id)target action:(SEL)action {
    return [PTHotKey hotKeyWithIdentifier:identifier keyCombo:combo target:target action:action withObject:nil];
}
+ (instancetype)hotKeyWithIdentifier:(id)identifier keyCombo:(NSDictionary *)combo target:(id)target action:(SEL)action withObject:(id)object {
    NSInteger code = [[combo objectForKey:@"keyCode"] integerValue];
    UInt32 flags = SRCocoaToCarbonFlags([[combo objectForKey:@"modifierFlags"] unsignedIntegerValue]);
    PTKeyCombo *keyCombo = [[PTKeyCombo alloc] initWithKeyCode:code modifiers:flags];
    PTHotKey *hotKey = [[PTHotKey alloc] initWithIdentifier:identifier keyCombo:keyCombo];
    [hotKey setTarget:target]; [hotKey setAction:action]; [hotKey setObject:object];
    return hotKey;
}
+ (instancetype)hotKeyWithIdentifier:(id)identifier keyCombo:(NSDictionary *)combo target:(id)target action:(SEL)action keyUpAction:(SEL)up {
    PTHotKey *hotKey = [PTHotKey hotKeyWithIdentifier:identifier keyCombo:combo target:target action:action];
    [hotKey setKeyUpAction:up]; return hotKey;
}
@end

static OSStatus hotKeyEventHandler(EventHandlerCallRef handler, EventRef event, void *context) {
    return [[PTHotKeyCenter sharedCenter] sendCarbonEvent:event];
}
@implementation PTHotKeyCenter
+ (instancetype)sharedCenter {
    static PTHotKeyCenter *center;
    if (!center) center = [[self alloc] init];
    return center;
}
- (instancetype)init { if ((self = [super init])) mHotKeys = [[NSMutableDictionary alloc] init]; return self; }
- (BOOL)registerHotKey:(PTHotKey *)hotKey {
    if (!mIsPaused) {
        if ([[self allHotKeys] containsObject:hotKey]) [self unregisterHotKey:hotKey];
        if (![[hotKey keyCombo] isValidHotKeyCombo]) return YES;
        EventHotKeyID identifier = {0x5054486b, ++mHotKeyCount};
        EventHotKeyRef ref;
        OSStatus status = RegisterEventHotKey((UInt32)[[hotKey keyCombo] keyCode], (UInt32)[[hotKey keyCombo] modifiers], identifier, GetEventDispatcherTarget(), 0, &ref);
        if (status != noErr) return NO;
        [hotKey setCarbonHotKeyID:identifier.id]; [hotKey setCarbonEventHotKeyRef:ref];
        if (hotKey) [mHotKeys setObject:hotKey forKey:@(identifier.id)];
        [self _updateEventHandler];
    } else {
        UInt32 identifier = ++mHotKeyCount;
        [hotKey setCarbonHotKeyID:identifier];
        if (hotKey) [mHotKeys setObject:hotKey forKey:@(identifier)];
    }
    return YES;
}
- (void)unregisterHotKey:(PTHotKey *)hotKey {
    if (!mIsPaused) {
        if ([[self allHotKeys] containsObject:hotKey] && [hotKey carbonEventHotKeyRef]) {
            UnregisterEventHotKey([hotKey carbonEventHotKeyRef]);
            [mHotKeys removeObjectForKey:@([hotKey carbonHotKeyID])];
            [hotKey setCarbonHotKeyID:0]; [hotKey setCarbonEventHotKeyRef:NULL];
            [self _updateEventHandler];
        }
    } else {
        [mHotKeys removeObjectForKey:@([hotKey carbonHotKeyID])];
        [hotKey setCarbonHotKeyID:0]; [hotKey setCarbonEventHotKeyRef:NULL];
    }
}
- (NSArray *)allHotKeys { return [mHotKeys allValues]; }
- (PTHotKey *)hotKeyWithIdentifier:(id)identifier {
    NSEnumerator *enumerator = [[self allHotKeys] objectEnumerator];
    if (!identifier) return nil;
    PTHotKey *key;
    while ((key = [enumerator nextObject])) if ([[key identifier] isEqual:identifier]) return key;
    return nil;
}
- (PTHotKey *)_hotKeyForCarbonHotKey:(EventHotKeyRef)ref {
    NSEnumerator *enumerator = [mHotKeys objectEnumerator]; PTHotKey *key;
    while ((key = [enumerator nextObject])) if ([key carbonEventHotKeyRef] == ref) return key;
    return nil;
}
- (PTHotKey *)_hotKeyForCarbonHotKeyID:(EventHotKeyID)identifier { return [mHotKeys objectForKey:@(identifier.id)]; }
- (void)_updateEventHandler {
    if ([mHotKeys count] && !mEventHandlerInstalled) {
        EventTypeSpec types[] = {{0x6b657962, 5}, {0x6b657962, 6}};
        InstallEventHandler(GetEventDispatcherTarget(), hotKeyEventHandler, 2, types, NULL, &mEventHandler);
        mEventHandlerInstalled = YES;
    }
}
- (void)_hotKeyDown:(PTHotKey *)hotKey { [hotKey invoke]; }
- (void)_hotKeyUp:(PTHotKey *)hotKey { [hotKey uninvoke]; }
- (void)sendEvent:(NSEvent *)event {
    if ([event type] == 14) {
        if ([event subtype] == 6) {
            EventHotKeyRef ref = (EventHotKeyRef)[event data1];
            if (ref) [self _hotKeyDown:[self _hotKeyForCarbonHotKey:ref]];
        } else if ([event subtype] == 9) {
            EventHotKeyRef ref = (EventHotKeyRef)[event data1];
            if (ref) [self _hotKeyUp:[self _hotKeyForCarbonHotKey:ref]];
        }
    }
}
- (OSStatus)sendCarbonEvent:(EventRef)event {
    if (GetEventClass(event) != 0x6b657962) [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd object:self file:@"PTHotKeyCenter.m" lineNumber:241 description:@"Unknown event class"];
    EventHotKeyID identifier;
    OSStatus status = GetEventParameter(event, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(identifier), NULL, &identifier);
    if (status) return status;
    if (identifier.signature != 0x5054486b || identifier.id == 0) return eventNotHandledErr;
    PTHotKey *key = [self _hotKeyForCarbonHotKeyID:identifier];
    UInt32 kind = GetEventKind(event);
    if (kind == 5) [self _hotKeyDown:key];
    else if (kind == 6) [self _hotKeyUp:key];
    else return eventNotHandledErr;
    return noErr;
}
- (void)pause {
    if (!mIsPaused) {
        mIsPaused = YES;
        for (id identifier in mHotKeys) {
            PTHotKey *key = [mHotKeys objectForKey:identifier];
            UnregisterEventHotKey([key carbonEventHotKeyRef]); [key setCarbonEventHotKeyRef:NULL];
        }
        if (mEventHandler) { RemoveEventHandler(mEventHandler); mEventHandler = NULL; mEventHandlerInstalled = NO; }
    }
}
- (void)resume {
    if (mIsPaused) {
        mIsPaused = NO;
        for (id identifier in mHotKeys) {
            PTHotKey *key = [mHotKeys objectForKey:identifier]; EventHotKeyRef ref = NULL;
            EventHotKeyID hotKeyID = {0x5054486b, [key carbonHotKeyID]};
            RegisterEventHotKey((UInt32)[[key keyCombo] keyCode], (UInt32)[[key keyCombo] modifiers], hotKeyID, GetEventDispatcherTarget(), 0, &ref);
            [key setCarbonEventHotKeyRef:ref];
        }
        [self _updateEventHandler];
    }
}
- (BOOL)isPaused { return mIsPaused; }
@end

@implementation PTKeyCodeTranslator
+ (instancetype)currentTranslator {
    static PTKeyCodeTranslator *current;
    TISInputSourceRef layout = TISCopyCurrentKeyboardLayoutInputSource();
    if (!current || [current keyboardLayout] != layout) current = [[PTKeyCodeTranslator alloc] initWithKeyboardLayout:layout];
    CFRelease(layout); return current;
}
- (instancetype)initWithKeyboardLayout:(TISInputSourceRef)layout {
    if ((self = [super init])) {
        keyboardLayout = layout; CFRetain(keyboardLayout);
        uchrData = (const UCKeyboardLayout *)CFDataGetBytePtr(TISGetInputSourceProperty(keyboardLayout, kTISPropertyUnicodeKeyLayoutData));
    }
    return self;
}
- (void)dealloc { CFRelease(keyboardLayout); }
- (NSString *)translateKeyCode:(short)code {
    UniChar characters[4]; UniCharCount actualLength;
    UCKeyTranslate(uchrData, (UInt16)code, 3, 0, LMGetKbdType(), 0, &deadKeyState, 4, &actualLength, characters);
    return [NSString stringWithCharacters:characters length:1];
}
- (TISInputSourceRef)keyboardLayout { return keyboardLayout; }
- (NSString *)description {
    NSString *name = (__bridge NSString *)TISGetInputSourceProperty(keyboardLayout, kTISPropertyLocalizedName);
    return [NSString stringWithFormat:@"PTKeyCodeTranslator layout=%@ (%@)", name, @"uchr"];
}
@end
