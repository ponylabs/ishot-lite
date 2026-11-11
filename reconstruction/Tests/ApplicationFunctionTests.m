#import <Cocoa/Cocoa.h>
extern NSString *IShotFunction_10004a980(NSString *path);
extern NSString *IShotFunction_10004ab58(id dictionary);
int main(void) {
    @autoreleasepool {
        NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:NSUUID.UUID.UUIDString];
        NSFileManager *manager = NSFileManager.defaultManager;
        NSCAssert([manager createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:NULL], @"create fixture");
        NSString *path = [directory stringByAppendingPathComponent:@"capture.png"];
        NSCAssert([IShotFunction_10004a980(path) isEqual:path], @"unused path stays unchanged");
        NSCAssert([NSData.data writeToFile:path atomically:YES], @"create collision");
        NSCAssert([NSData.data writeToFile:[directory stringByAppendingPathComponent:@"capture 2.png"] atomically:YES], @"create suffix collision");
        NSCAssert([IShotFunction_10004a980(path) isEqual:[directory stringByAppendingPathComponent:@"capture 3.png"]], @"suffix begins at 2 and skips existing paths");
        NSString *noExtension = [directory stringByAppendingPathComponent:@"capture"];
        NSCAssert([NSData.data writeToFile:noExtension atomically:YES], @"extensionless fixture");
        NSCAssert([IShotFunction_10004a980(noExtension) isEqual:[directory stringByAppendingPathComponent:@"capture 2."]], @"original keeps trailing dot");
        NSDictionary *object = @{@"keyCode": @12, @"modifierFlags": @524288, @"unicode": @"截图"};
        NSString *json = IShotFunction_10004ab58(object);
        NSDictionary *decoded = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        NSCAssert([decoded isEqual:object], @"JSON preserves values");
        NSCAssert([manager removeItemAtPath:directory error:NULL], @"remove fixtures");
        puts("Application function tests: filename collisions and JSON passed; no launch, permissions, notifications or user defaults exercised.");
    }
    return 0;
}
