#import <Foundation/Foundation.h>

@interface AESEncryptUtil : NSObject
+ (NSString *)encyptPKCS5:(NSString *)text WithKey:(NSString *)key;
+ (NSString *)decryptPKCS5:(NSString *)text WithKey:(NSString *)key;
+ (NSString *)dictionaryToJson:(id)object;
+ (id)dictionaryWithJsonString:(NSString *)text;
@end
