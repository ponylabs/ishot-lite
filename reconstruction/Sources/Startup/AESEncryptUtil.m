#import "AESEncryptUtil.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation AESEncryptUtil

// REA arm64 0x100012bf8. Preserve the spelling and AES-128/ECB/PKCS7 options.
+ (NSString *)encyptPKCS5:(NSString *)text WithKey:(NSString *)key {
    NSData *input = [text dataUsingEncoding:NSUTF8StringEncoding];
    size_t capacity = (input.length + 16) & ~(size_t)15;
    void *output = malloc(capacity);
    bzero(output, capacity);
    size_t written = 0;
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES,
                                    kCCOptionPKCS7Padding | kCCOptionECBMode,
                                    key.UTF8String, 16, NULL, input.bytes, input.length,
                                    output, capacity, &written);
    NSString *result = nil;
    if (status == kCCSuccess) {
        result = [[NSData dataWithBytes:output length:written] base64EncodedStringWithOptions:0];
    }
    free(output);
    return result;
}

// REA arm64 0x100012d44.
+ (NSString *)decryptPKCS5:(NSString *)text WithKey:(NSString *)key {
    NSData *input = [[NSData alloc] initWithBase64EncodedString:text options:0];
    size_t capacity = (input.length + 16) & ~(size_t)15;
    void *output = malloc(capacity);
    bzero(output, capacity);
    size_t written = 0;
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmAES,
                                    kCCOptionPKCS7Padding | kCCOptionECBMode,
                                    key.UTF8String, 16, NULL, input.bytes, input.length,
                                    output, capacity, &written);
    NSString *result = nil;
    if (status == kCCSuccess) {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:output length:written]
                                     encoding:NSUTF8StringEncoding];
    }
    free(output);
    return result;
}

// REA arm64 0x100012eb4: options=1, not sorted-keys JSON.
+ (NSString *)dictionaryToJson:(id)object {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

// REA arm64 0x100012f20; NSLog literal verified at CFString 0x1001abcc0.
+ (id)dictionaryWithJsonString:(NSString *)text {
    if (text == nil) return nil;
    NSString *trimmed = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    trimmed = [trimmed stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:[trimmed dataUsingEncoding:NSUTF8StringEncoding]
                                              options:NSJSONReadingFragmentsAllowed error:&error];
    if (result == nil && error != nil) NSLog(@"json解析失败：%@", error);
    return result;
}
@end
