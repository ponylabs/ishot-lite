#define ISHOT_HELPER_NO_MAIN 1
#import "../main.m"
#include <assert.h>

// No NSApplication, defaults suite, shell, notifications, or launch paths execute.
int main(void) {
    @autoreleasepool {
        assert(dictionaryFromJSON(nil) == nil);
        assert(dictionaryFromJSON(@"not JSON") == nil);
        NSMutableDictionary *decoded = dictionaryFromJSON(@"{\"regionalScreenshotsRecorder\":{\"modifierFlags\":1048576,\"charactersIgnoringModifiers\":\"a\"}}");
        assert([decoded isKindOfClass:NSMutableDictionary.class]);
        assert([decoded[@"regionalScreenshotsRecorder"] isKindOfClass:NSMutableDictionary.class]);
        assert([decoded[@"regionalScreenshotsRecorder"][@"modifierFlags"] unsignedIntegerValue] == 1048576);
        assert([decoded[@"regionalScreenshotsRecorder"][@"charactersIgnoringModifiers"] isEqualToString:@"a"]);
        decoded[@"regionalScreenshotsRecorder"][@"charactersIgnoringModifiers"] = @"b";
        assert([decoded[@"regionalScreenshotsRecorder"][@"charactersIgnoringModifiers"] isEqualToString:@"b"]);
    }
    return 0;
}
