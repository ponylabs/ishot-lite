// Synthetic sample timestamps and state transitions. Never starts capture or file conversion.
#import "../SGCaptureSession.m"
NSScreen *IShotGlobal_1001ddd60;
AppPrefsWindowController *IShotGlobal_1001de1a0;
int32_t IShotGlobal_1001ddf78;
BOOL IShotGlobal_1001de2a1;
void IShotFunction_100047ffc(NSString *name) { assert(!"unexpected helper notification"); }
@implementation AppDelegate
+ (instancetype)appDelegate { return nil; }
@end
@implementation AppSandboxFileAccess
+ (instancetype)fileAccessWithMessage:(NSString *)message { assert(!"unexpected file access"); return nil; }
@end
@interface SampleSink : NSObject
@property(nonatomic) CMTime timestamp;
@property(nonatomic) NSUInteger count;
@end
@implementation SampleSink
- (BOOL)isReadyForMoreMediaData { return YES; }
- (BOOL)appendSampleBuffer:(CMSampleBufferRef)sample { self.timestamp=CMSampleBufferGetPresentationTimeStamp(sample); self.count++; return YES; }
@end
static CMSampleBufferRef makeSample(void) {
    AudioStreamBasicDescription format={48000,kAudioFormatLinearPCM,0x0c,4,1,4,1,32,0};
    CMAudioFormatDescriptionRef description=NULL;
    assert(CMAudioFormatDescriptionCreate(NULL,&format,0,NULL,0,NULL,NULL,&description)==0);
    CMBlockBufferRef data=NULL; assert(CMBlockBufferCreateWithMemoryBlock(NULL,NULL,4,NULL,NULL,0,4,0,&data)==0);
    CMSampleTimingInfo timing={CMTimeMake(1,48000),CMTimeMake(100,48000),CMTimeMake(100,48000)};
    size_t bytes=4; CMSampleBufferRef sample=NULL;
    assert(CMSampleBufferCreateReady(NULL,data,description,1,1,&timing,1,&bytes,&sample)==0);
    CFRelease(data); CFRelease(description); return sample;
}
int main(void) {
    @autoreleasepool {
        SGCaptureSession *session=[[SGCaptureSession alloc] init];
        CMSampleBufferRef original=makeSample();
        CMSampleBufferRef shifted=[session adjustTime:original by:CMTimeMake(10,48000)];
        // adjustTime:by: consumes original; only the returned sample is released below.
        assert(CMSampleBufferGetPresentationTimeStamp(shifted).value==90);
        assert(CMSampleBufferGetDecodeTimeStamp(shifted).value==90);
        assert(CMSampleBufferGetDuration(shifted).value==1); CFRelease(shifted);
        [session initOutputQueue]; session.isCapture=YES; [session pauseAndResumeRecordingAction];
        assert(!session.isCapture && session.isSuspend); [session pauseAndResumeRecordingAction]; assert(session.isCapture && session.isSuspend);
        SampleSink *sink=[SampleSink new]; session.videoWriterInput=(id)sink;
        session.canWrite=NO; session.lastVideo=CMTimeMake(90,48000); IShotSG_1001f1bfa=NO; IShotSG_1001f1bf8=YES;
        CMSampleBufferRef sample=makeSample(); [session appendVideoSampleBuffer:sample]; CFRelease(sample);
        dispatch_sync(session.writerQueue,^{});
        assert(sink.count==1 && sink.timestamp.value==90);
        assert(session.timeOffset.value==10 && session.lastVideo.value==91 && !session.isSuspend);
        assert(isnan([session updateAudioLevels]));
        NSLog(@"SGCaptureSessionTests passed");
    }
    return 0;
}
