#import "RecoveredCursors.h"
#import "CameraView.h"
NSCursor *IShotGlobal_1001ddf98;
NSCursor *IShotOpenHandCursor_1001ddfa0;
NSCursor *IShotNullCursor_1001ddfa8;

// 0x100049f5c; literal at 0x1001af000. No fallback path is invented when
// the installed OS lacks these historical HIServices cursor resources.
uint64_t IShotInitializeCursors_100049f5c(void) {
    NSString *root = @"/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/HIServices.framework/Versions/A/Resources/cursors";
    NSString *path = [root stringByAppendingPathComponent:@"resizenorthwestsoutheast"];
    NSImage *image = [[NSImage alloc] initByReferencingFile:[path stringByAppendingPathComponent:@"cursor.pdf"]];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"info.plist"]];
    IShotGlobal_1001ddf88 = [[NSCursor alloc] initWithImage:image hotSpot:NSMakePoint([[info valueForKey:@"hotx"] doubleValue], [[info valueForKey:@"hoty"] doubleValue])];
    path = [root stringByAppendingPathComponent:@"resizenortheastsouthwest"];
    image = [[NSImage alloc] initByReferencingFile:[path stringByAppendingPathComponent:@"cursor.pdf"]];
    info = [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"info.plist"]];
    IShotGlobal_1001ddf90 = [[NSCursor alloc] initWithImage:image hotSpot:NSMakePoint([[info valueForKey:@"hotx"] doubleValue], [[info valueForKey:@"hoty"] doubleValue])];
    path = [root stringByAppendingPathComponent:@"move"];
    image = [[NSImage alloc] initByReferencingFile:[path stringByAppendingPathComponent:@"cursor.pdf"]];
    info = [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"info.plist"]];
    IShotGlobal_1001ddf98 = [[NSCursor alloc] initWithImage:image hotSpot:NSMakePoint([[info valueForKey:@"hotx"] doubleValue], [[info valueForKey:@"hoty"] doubleValue])];
    path = [root stringByAppendingPathComponent:@"openhand"];
    image = [[NSImage alloc] initByReferencingFile:[path stringByAppendingPathComponent:@"cursor.pdf"]];
    info = [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"info.plist"]];
    IShotOpenHandCursor_1001ddfa0 = [[NSCursor alloc] initWithImage:image hotSpot:NSMakePoint([[info valueForKey:@"hotx"] doubleValue] - 0.01, [[info valueForKey:@"hoty"] doubleValue] - 0.01)];
    IShotNullCursor_1001ddfa8 = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"null"] hotSpot:NSZeroPoint];
    return 0;
}
