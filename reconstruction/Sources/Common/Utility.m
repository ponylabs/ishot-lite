#import "Utility.h"
#import <CommonCrypto/CommonDigest.h>
#include <string.h>
@implementation Utility
+ (NSString *)digestString:(NSString *)text { // 0x1000527f0
    const char *bytes=text.UTF8String;
    unsigned char digest[16];
    CC_MD5(bytes,(CC_LONG)strlen(bytes),digest);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",digest[0],digest[1],digest[2],digest[3],digest[4],digest[5],digest[6],digest[7],digest[8],digest[9],digest[10],digest[11],digest[12],digest[13],digest[14],digest[15]];
}
@end
