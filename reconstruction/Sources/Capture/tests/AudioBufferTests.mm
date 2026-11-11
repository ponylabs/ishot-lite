// Bounded synthetic test of recovered buffer layout/state; no device/session initialization.
#import <objc/runtime.h>
#import "../LinearPCMAudioCapture.mm"
@implementation AppDelegate
+ (instancetype)appDelegate { return nil; }
@end
int main(void) {
    @autoreleasepool {
        AudioStreamBasicDescription format = {48000,kAudioFormatLinearPCM,0x29,4,1,4,2,32,0};
        IShotAudioBuffers buffer(format,128);
        assert(buffer.buffers == 2 && buffer.capacity == 0 && buffer.frames == 128);
        buffer.prepare(128,false);
        assert(buffer.list->mNumberBuffers == 2);
        for (unsigned i=0;i<2;++i) assert(buffer.list->mBuffers[i].mNumberChannels == 1 && buffer.list->mBuffers[i].mDataByteSize == 512 && buffer.list->mBuffers[i].mData == NULL);
        buffer.capacity=512; buffer.data=new char[1024]; buffer.prepare(64,false);
        assert(buffer.list->mBuffers[1].mData == buffer.data+512 && buffer.list->mBuffers[1].mDataByteSize == 256);
        bool threw=false; try { buffer.prepare(129,false); } catch(int status) { threw=status == -10874; } assert(threw);
        buffer.prepare(129,true); assert(buffer.list->mBuffers[1].mData == NULL);
        LinearPCMAudioCapture *capture=(LinearPCMAudioCapture *)class_createInstance(LinearPCMAudioCapture.class,0);
        assert([capture.getRecordTime isEqualToString:@"00:00:00"]);
        capture.recording=YES; IShotPCM_1001f1bd8=120;
        assert([capture.getRecordTime isEqualToString:@"00:00:01"]);
        assert([capture.getRecordTime isEqualToString:@"00:00:01"]);
        IShotPCM_1001f1bd8=122; assert([capture.getRecordTime isEqualToString:@"00:00:02"]);
        capture.temporaryPath=@"/tmp/example.aif"; assert([capture.mp3Path isEqualToString:@"/tmp/example.mp3"]);
        capture.recording=NO;
        NSLog(@"AudioBufferTests passed");
    }
    return 0;
}
