#import "SRCommon.h"
@interface SRModifierFlagsTransformer : NSValueTransformer
@property(nonatomic, readonly) BOOL usesPlainStrings;
- (instancetype)initWithPlainStrings:(BOOL)plain;
+ (instancetype)sharedTransformer;
+ (instancetype)sharedPlainTransformer;
@end
@interface SRKeyCodeTransformer : NSValueTransformer
@property(nonatomic, readonly) BOOL usesASCIICapableKeyboardInputSource;
@property(nonatomic, readonly) BOOL usesPlainStrings;
- (instancetype)initWithASCIICapableKeyboardInputSource:(BOOL)ascii plainStrings:(BOOL)plain;
+ (instancetype)sharedTransformer;
+ (instancetype)sharedASCIITransformer;
+ (instancetype)sharedPlainTransformer;
+ (instancetype)sharedPlainASCIITransformer;
+ (NSDictionary *)specialKeyCodesToUnicodeCharactersMapping;
+ (NSDictionary *)specialKeyCodesToPlainStringsMapping;
- (BOOL)isKeyCodeSpecial:(unsigned short)code;
- (NSString *)transformedValue:(id)value withModifierFlags:(NSNumber *)flags;
- (NSString *)transformedValue:(id)value withImplicitModifierFlags:(NSNumber *)implicitFlags explicitModifierFlags:(NSNumber *)explicitFlags;
- (NSString *)transformedSpecialKeyCode:(NSNumber *)code withExplicitModifierFlags:(NSNumber *)flags;
@end
@interface SRKeyEquivalentTransformer : NSValueTransformer
@end
@interface SRKeyEquivalentModifierMaskTransformer : NSValueTransformer
@end
