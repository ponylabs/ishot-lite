#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface PTKeyCombo : NSObject <NSCopying> {
    NSInteger mKeyCode;
    NSUInteger mModifiers;
}
+ (instancetype)clearKeyCombo;
+ (instancetype)keyComboWithKeyCode:(NSInteger)code modifiers:(NSUInteger)modifiers;
- (instancetype)initWithKeyCode:(NSInteger)code modifiers:(NSUInteger)modifiers;
- (instancetype)initWithPlistRepresentation:(NSDictionary *)plist;
- (NSDictionary *)plistRepresentation;
- (NSInteger)keyCode;
- (NSUInteger)modifiers;
- (BOOL)isValidHotKeyCombo;
- (BOOL)isClearCombo;
@end

@interface PTHotKey : NSObject
@property(nonatomic, strong) id identifier;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) PTKeyCombo *keyCombo;
@property(nonatomic, strong) id target;
@property(nonatomic, strong) id object;
@property(nonatomic) SEL action;
@property(nonatomic) SEL keyUpAction;
@property(nonatomic) UInt32 carbonHotKeyID;
@property(nonatomic) EventHotKeyRef carbonEventHotKeyRef;
- (instancetype)initWithIdentifier:(id)identifier keyCombo:(PTKeyCombo *)combo;
- (instancetype)initWithIdentifier:(id)identifier keyCombo:(PTKeyCombo *)combo withObject:(id)object;
- (void)invoke;
- (void)uninvoke;
+ (instancetype)hotKeyWithIdentifier:(id)identifier keyCombo:(NSDictionary *)combo target:(id)target action:(SEL)action;
+ (instancetype)hotKeyWithIdentifier:(id)identifier keyCombo:(NSDictionary *)combo target:(id)target action:(SEL)action withObject:(id)object;
+ (instancetype)hotKeyWithIdentifier:(id)identifier keyCombo:(NSDictionary *)combo target:(id)target action:(SEL)action keyUpAction:(SEL)up;
@end

@interface PTHotKeyCenter : NSObject {
    NSMutableDictionary *mHotKeys;
    BOOL mEventHandlerInstalled;
    UInt32 mHotKeyCount;
    BOOL mIsPaused;
    EventHandlerRef mEventHandler;
}
+ (instancetype)sharedCenter;
- (BOOL)registerHotKey:(PTHotKey *)hotKey;
- (void)unregisterHotKey:(PTHotKey *)hotKey;
- (NSArray *)allHotKeys;
- (PTHotKey *)hotKeyWithIdentifier:(id)identifier;
- (PTHotKey *)_hotKeyForCarbonHotKey:(EventHotKeyRef)ref;
- (PTHotKey *)_hotKeyForCarbonHotKeyID:(EventHotKeyID)identifier;
- (void)_updateEventHandler;
- (void)_hotKeyDown:(PTHotKey *)hotKey;
- (void)_hotKeyUp:(PTHotKey *)hotKey;
- (void)sendEvent:(NSEvent *)event;
- (OSStatus)sendCarbonEvent:(EventRef)event;
- (void)pause;
- (void)resume;
- (BOOL)isPaused;
@end

@interface PTKeyCodeTranslator : NSObject {
    TISInputSourceRef keyboardLayout;
    const UCKeyboardLayout *uchrData;
    UInt32 keyTranslateState;
    UInt32 deadKeyState;
}
+ (instancetype)currentTranslator;
- (instancetype)initWithKeyboardLayout:(TISInputSourceRef)layout;
- (NSString *)translateKeyCode:(short)code;
- (TISInputSourceRef)keyboardLayout;
@end
