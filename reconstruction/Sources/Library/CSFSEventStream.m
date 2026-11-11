#import "PinLibrary.h"
extern PinLibraryController *IShotGlobal_1001de188;
static void IShotFunction_1000a6e9c(ConstFSEventStreamRef stream, void *context, size_t count, void *paths, const FSEventStreamEventFlags flags[], const FSEventStreamEventId ids[]) {
    for (size_t i = 0; i < count; i++) {
        if (flags[i] & 0x100) [IShotGlobal_1001de188 refreshCollectionView];
        if (flags[i] & 0x800) [IShotGlobal_1001de188 refreshCollectionView];
        if (flags[i] & 0x1000) [IShotGlobal_1001de188 refreshCollectionView];
    }
    [(__bridge CSFSEventStream *)context updateEventID];
}
@implementation CSFSEventStream
- (void)startEventStream:(NSArray *)paths { [self stopEventStream]; [self fsEventsSetUp:paths]; } // 0x1000a6d08
- (void)stopEventStream { // 0x1000a6d48
    if (self.syncEventStream) {
        FSEventStreamStop(self.syncEventStream);
        FSEventStreamInvalidate(self.syncEventStream);
        FSEventStreamRelease(self.syncEventStream);
        self.syncEventStream = NULL;
    }
}
- (void)fsEventsSetUp:(NSArray *)paths { // 0x1000a6da4
    if (self.syncEventStream) {
        FSEventStreamStop(self.syncEventStream);
        FSEventStreamInvalidate(self.syncEventStream);
        FSEventStreamRelease(self.syncEventStream);
        self.syncEventStream = NULL;
    }
    FSEventStreamContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    self.syncEventStream = FSEventStreamCreate(NULL, IShotFunction_1000a6e9c, &context, (__bridge CFArrayRef)paths, self.syncEventID, 1.0, 0x31);
    FSEventStreamScheduleWithRunLoop(self.syncEventStream, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    FSEventStreamStart(self.syncEventStream);
}
- (void)updateEventID { [self setSyncEventID:FSEventStreamGetLatestEventId(self.syncEventStream)]; } // 0x1000a6f34
- (void)setSyncEventID:(long long)value { [NSUserDefaults.standardUserDefaults setInteger:value forKey:@"Cloud_SyncEventID"]; } // 0x1000a6f60
- (long long)syncEventID { // 0x1000a6fa8
    long long value = [NSUserDefaults.standardUserDefaults integerForKey:@"Cloud_SyncEventID"];
    return value == 0 ? -1 : value;
}
- (BOOL)validateIsPictureName:(NSString *)name { return [@[@"png", @"PNG", @"jpg", @"JPG", @"jpeg", @"JPEG", @"jfif", @"JFIF", @"bmp", @"BMP", @"gif", @"GIF"] containsObject:name]; } // 0x1000a6ff8
+ (instancetype)sharedManager { // 0x1000a7114, global block 0x1000a7154
    static CSFSEventStream *IShotGlobal_1001f1b70;
    static dispatch_once_t IShotGlobal_1001f1b78;
    dispatch_once(&IShotGlobal_1001f1b78, ^{ IShotGlobal_1001f1b70 = [[CSFSEventStream alloc] init]; });
    return IShotGlobal_1001f1b70;
}
@end
