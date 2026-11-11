#import <AppKit/AppKit.h>
#import <objc/runtime.h>
#import "../Sources/Startup/AESEncryptUtil.h"
#import "../Sources/Startup/LCFreePlanManager.h"
#include <assert.h>

static NSDictionary<NSString *, NSArray *> *runningFixture;
static NSArray *fixtureApplications(id self, SEL selector, NSString *identifier) {
    (void)self; (void)selector;
    return runningFixture[identifier] ?: @[];
}

int main(void) {
    @autoreleasepool {
        NSString *key = @"0123456789abcdef";
        // Independently calculated using OpenSSL AES-128-ECB with PKCS7 padding.
        NSString *cipher = @"xrI043WEAx+uTjTqutlBSUJu6iOseEnimy8sg5zFzIQ=";
        assert([[AESEncryptUtil encyptPKCS5:@"Strict recovery 中文" WithKey:key] isEqual:cipher]);
        assert([[AESEncryptUtil decryptPKCS5:cipher WithKey:key] isEqual:@"Strict recovery 中文"]);
        assert([AESEncryptUtil dictionaryWithJsonString:nil] == nil);
        assert([[AESEncryptUtil dictionaryWithJsonString:@" \n{\"answer\":42}\n "] isEqual:@{@"answer":@42}]);
        assert([[AESEncryptUtil dictionaryWithJsonString:@"42"] isEqual:@42]);
        assert(([[AESEncryptUtil dictionaryWithJsonString:@"[1,2]"] isEqual:@[@1,@2]]));
        assert([AESEncryptUtil dictionaryWithJsonString:@"{"] == nil);
        NSString *json = [AESEncryptUtil dictionaryToJson:@{@"answer":@42}];
        assert([json containsString:@"\n"]);
        assert([[AESEncryptUtil dictionaryWithJsonString:json] isEqual:@{@"answer":@42}]);

        // Replace the OS lookup only inside this test process; production is unchanged.
        Method method = class_getClassMethod(NSRunningApplication.class, @selector(runningApplicationsWithBundleIdentifier:));
        IMP original = method_setImplementation(method, (IMP)fixtureApplications);
        NSArray *ids = [LCFreePlanManager requiredBundleIdentifiers];
        assert(ids.count == 4);
        runningFixture = @{};
        assert(![LCFreePlanManager isEnabled]);
        runningFixture = @{ids[0]: @[@1,@2,@3]};
        assert(![LCFreePlanManager isEnabled]);
        runningFixture = @{ids[0]: @[@1], ids[3]: @[@1]};
        assert([LCFreePlanManager isEnabled]);
        runningFixture = @{@"unrelated.example": @[@1,@2]};
        assert(![LCFreePlanManager isEnabled]);
        method_setImplementation(method, original);
        puts("StartupTests: PASS (crypto vector, JSON semantics, distinct-process threshold)");
    }
    return 0;
}
