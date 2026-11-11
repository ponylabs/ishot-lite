#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "LaunchAtLoginController.h"

// 0x100048840, notification object verified in CFString table.
void IShotFunction_100048840(NSString *name) {
    [NSDistributedNotificationCenter.defaultCenter postNotificationName:name object:@"cn.better365.group" userInfo:nil deliverImmediately:YES];
}
// 0x100047f3c; global block 0x1001a8e90 invokes 0x10004805c.
void IShotFunction_100047f3c(void) {
    [LaunchAtLoginController shared];
    if ([NSBundle.mainBundle.bundlePath containsString:@"/Library/Developer/Xcode/DerivedData/"]) IShotFunction_100047ffc(@"TelliShotHelperToQuit");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 200000000), dispatch_get_main_queue(), ^{
        NSString *path = [NSBundle.mainBundle.bundlePath stringByAppendingString:@"/Contents/Library/LoginItems/iShotHelper.app"];
        BOOL exists = [NSFileManager.defaultManager fileExistsAtPath:path];
        NSWorkspace *workspace = NSWorkspace.sharedWorkspace;
        if (exists) [workspace launchApplication:path];
        else [workspace launchAppWithBundleIdentifier:@"cn.better365.iShotHelper" options:0 additionalEventParamDescriptor:nil launchIdentifier:NULL];
    });
}
// 0x1000489a8. Callback 0x100048a48 is a single RET, not missing logic.
int IShotFunction_1000489a8(void) {
    if (@available(macOS 10.14, *)) {
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]) {
            case 0: [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {}]; return 0;
            case 3: return 1;
            default: return -1;
        }
    }
    return 1;
}
// 0x100049a04.
void IShotFunction_100049a04(void) {
    NSTask *task = [NSTask new];
    task.launchPath = @"/usr/bin/open";
    task.arguments = @[@"-n", NSBundle.mainBundle.bundlePath];
    [task launch];
    exit(0);
}
// 0x10004a980; assembly starts the suffix at 2 and re-reads each candidate extension.
NSString *IShotFunction_10004a980(NSString *path) {
    NSString *base = path.stringByDeletingPathExtension;
    NSFileManager *manager = NSFileManager.defaultManager;
    unsigned int index = 2;
    while ([manager fileExistsAtPath:path]) {
        path = [NSString stringWithFormat:@"%@ %d.%@", base, index, path.pathExtension];
        index++;
    }
    return path;
}
// 0x10004ab58.
NSString *IShotFunction_10004ab58(id dictionary) {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
