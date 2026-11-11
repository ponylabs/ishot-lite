#import "SRCommon.h"
@class SRValidator;
@protocol SRValidatorDelegate <NSObject>
@optional
- (BOOL)shortcutValidator:(SRValidator *)validator isKeyCode:(unsigned short)code andFlagsTaken:(NSUInteger)flags reason:(NSString **)reason;
- (BOOL)shortcutValidatorShouldCheckSystemShortcuts:(SRValidator *)validator;
- (BOOL)shortcutValidatorShouldCheckMenu:(SRValidator *)validator;
- (BOOL)shortcutValidatorShouldUseASCIIStringForKeyCodes:(SRValidator *)validator;
@end
@interface SRValidator : NSObject
@property(nonatomic, unsafe_unretained) id<SRValidatorDelegate> delegate;
- (instancetype)initWithDelegate:(id<SRValidatorDelegate>)delegate;
- (BOOL)isKeyCode:(unsigned short)code andFlagsTaken:(NSUInteger)flags error:(NSError **)error;
- (BOOL)isKeyCode:(unsigned short)code andFlagTakenInDelegate:(NSUInteger)flags error:(NSError **)error;
- (BOOL)isKeyCode:(unsigned short)code andFlagsTakenInSystemShortcuts:(NSUInteger)flags error:(NSError **)error;
- (BOOL)isKeyCode:(unsigned short)code andFlags:(NSUInteger)flags takenInMenu:(NSMenu *)menu error:(NSError **)error;
@end
@interface NSMenuItem (SRValidator)
- (NSString *)SR_path;
@end
