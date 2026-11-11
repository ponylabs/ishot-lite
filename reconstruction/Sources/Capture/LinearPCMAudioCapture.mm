#import "LinearPCMAudioCapture.h"
#import "../MainApplication/AppDelegate.h"
#import <unistd.h>
// Constructor/destructor/prepare: 0x1000b7228, 0x1000b72a4, 0x1000b72e0.
struct IShotAudioBuffers {
    AudioStreamBasicDescription format;
    char *data;
    AudioBufferList *list;
    uint32_t buffers, capacity, frames;
    IShotAudioBuffers(const AudioStreamBasicDescription &f, uint32_t n) : format(f), data(NULL), list(NULL), buffers(0), capacity(0), frames(n) {
        buffers = f.mFormatID == kAudioFormatLinearPCM && (f.mFormatFlags & 0x20) ? f.mChannelsPerFrame : 1;
        list = reinterpret_cast<AudioBufferList *>(new unsigned char[(buffers << 4) | 8]);
    }
    ~IShotAudioBuffers() { if (data) delete[] data; if (list) delete[] reinterpret_cast<unsigned char *>(list); }
    void prepare(uint32_t n, bool forceNull) {
        uint32_t channels = format.mFormatID == kAudioFormatLinearPCM && (format.mFormatFlags & 0x20) ? 1 : format.mChannelsPerFrame;
        uint32_t size = format.mBytesPerFrame * n;
        if (data && !forceNull && capacity * buffers < size * buffers) throw int(-10874);
        list->mNumberBuffers = buffers;
        for (uint32_t i = 0; i < buffers; ++i) list->mBuffers[i] = {channels, size, data && !forceNull ? data + capacity * i : NULL};
    }
};
static_assert(sizeof(IShotAudioBuffers) == 72, "original helper allocation");
// Original __common zero-initialized state. This family is private to LinearPCM.
static AVCaptureSession *IShotPCM_1001de230;
static AVCaptureAudioDataOutput *IShotPCM_1001de238;
static AudioUnit IShotPCM_1001de240;
static ExtAudioFileRef IShotPCM_1001de248;
static AudioStreamBasicDescription IShotPCM_1001de250;
static AudioBufferList *IShotPCM_1001de278;
static IShotAudioBuffers *IShotPCM_1001de280;
static double IShotPCM_1001de288;
static BOOL IShotPCM_1001de290, IShotPCM_1001f1bd4;
static int32_t IShotPCM_1001f1bd8, IShotPCM_1001f1bdc, IShotPCM_1001f1be0;
// 0x1000b43e8 copies buffer descriptors, not audio samples.
static OSStatus IShotPCMInput(void *ref, AudioUnitRenderActionFlags *flags, const AudioTimeStamp *time, UInt32 bus, UInt32 frames, AudioBufferList *output) {
    AudioBufferList *input = [(__bridge LinearPCMAudioCapture *)ref currentInputAudioBufferList];
    if (input->mNumberBuffers != output->mNumberBuffers) return -206;
    for (UInt32 i = 0; i < input->mNumberBuffers; ++i) output->mBuffers[i] = input->mBuffers[i];
    return noErr;
}
@implementation LinearPCMAudioCapture
- (instancetype)init { if ((self = [super init])) [self configureEffectAudioUnit]; return self; } // 0x1000b3e00
- (void)configureCaptureSession { // 0x1000b3e6c; float narrowing corroborated at 0x1000b3f7c.
    AVCaptureDevice *device = [self getSelectedAudioDevice];
    if (!device) return;
    IShotPCM_1001de230 = [[AVCaptureSession alloc] init];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if ([IShotPCM_1001de230 canAddInput:input]) [IShotPCM_1001de230 addInput:input];
    IShotPCM_1001de238 = [AVCaptureAudioDataOutput new];
    UInt32 channels = 0; float rate = 0;
    if (device.isConnected) {
        AudioStreamBasicDescription source = *CMAudioFormatDescriptionGetStreamBasicDescription(device.activeFormat.formatDescription);
        channels = source.mChannelsPerFrame; rate = (float)source.mSampleRate;
    }
    AudioStreamBasicDescription format = {fmin((double)rate,48000.0), kAudioFormatLinearPCM, 0x29, 4, 1, 4, MIN(channels,2u), 32, 0};
    NSLog(@"%d %d", format.mChannelsPerFrame, channels);
    IShotPCM_1001de238.audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:@(format.mFormatID), AVFormatIDKey, @((float)format.mSampleRate), AVSampleRateKey, @((NSUInteger)format.mChannelsPerFrame), AVNumberOfChannelsKey, @(format.mBitsPerChannel), AVLinearPCMBitDepthKey, @(format.mFormatFlags & 1), AVLinearPCMIsFloatKey, @((format.mFormatFlags >> 5) & 1), AVLinearPCMIsNonInterleaved, @((format.mFormatFlags >> 1) & 1), AVLinearPCMIsBigEndianKey, nil];
    if ([IShotPCM_1001de230 canAddOutput:IShotPCM_1001de238]) [IShotPCM_1001de230 addOutput:IShotPCM_1001de238];
    [IShotPCM_1001de230 startRunning];
}
- (void)configureEffectAudioUnit { // 0x1000b42a8
    AudioComponentDescription description = {0x61756678,0x64656c79,0x6170706c,0,0};
    OSStatus status = AudioComponentInstanceNew(AudioComponentFindNext(NULL,&description), &IShotPCM_1001de240);
    if (!status) {
        AURenderCallbackStruct callback = {IShotPCMInput, (__bridge void *)self};
        status = AudioUnitSetProperty(IShotPCM_1001de240,23,1,0,&callback,16);
        if (!status) return;
    }
    if (IShotPCM_1001de240) { AudioComponentInstanceDispose(IShotPCM_1001de240); IShotPCM_1001de240 = NULL; }
    [[NSAlert alertWithError:[NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil]] runModal];
}
- (AVCaptureDevice *)getSelectedAudioDevice { // 0x1000b4450
    NSString *selected = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedMicrophoneForRecordAudio"];
    BOOL system = [[NSUserDefaults standardUserDefaults] boolForKey:@"recordSystemAudioForRecordAudio"];
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]) {
        NSString *name = device.localizedName, *uid = device.uniqueID;
        BOOL match = !system ? [selected isEqualToString:name] : [selected isEqualToString:[[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil]] ? [uid isEqualToString:@"iShotAudioPlugin_UID"] : [uid isEqualToString:@"iShotAudioAggregateDevice_UID"];
        if (match) return [AVCaptureDevice deviceWithUniqueID:uid];
    }
    return nil;
}
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sample fromConnection:(AVCaptureConnection *)connection { // 0x1000b47c8
    BOOL wasRecording = self.isRecording;
    if (IShotPCM_1001f1bd4 & 1) return;
    CMAudioFormatDescriptionRef description = CMSampleBufferGetFormatDescription(sample);
    const AudioStreamBasicDescription *format = CMAudioFormatDescriptionGetStreamBasicDescription(description);
    if (format->mFormatID != kAudioFormatLinearPCM) { NSLog(@"Bad format or bogus ASBD!"); return; }
    if (format->mChannelsPerFrame != IShotPCM_1001de250.mChannelsPerFrame || format->mSampleRate != IShotPCM_1001de250.mSampleRate) {
        IShotPCM_1001de250 = *format;
        if (!IShotPCM_1001de290) IShotPCM_1001de290 = YES;
        else {
            AudioUnitUninitialize(IShotPCM_1001de240);
            if (IShotPCM_1001de248) {
                self.recording = NO;
                OSStatus status = ExtAudioFileDispose(IShotPCM_1001de248); IShotPCM_1001de248 = NULL;
                NSLog(@"Recording Stopped - Audio Format Changed (%ld)", (long)status);
            }
            if (IShotPCM_1001de280) delete IShotPCM_1001de280;
            IShotPCM_1001de280 = NULL;
        }
        OSStatus status = AudioUnitSetProperty(IShotPCM_1001de240,8,1,0,&IShotPCM_1001de250,40);
        if (!status) status = AudioUnitSetProperty(IShotPCM_1001de240,8,2,0,&IShotPCM_1001de250,40);
        if (!status) status = AudioUnitInitialize(IShotPCM_1001de240);
        if (status) { NSLog(@"Failed to set up audio units (%ld)",(long)status); IShotPCM_1001de290 = NO; memset(&IShotPCM_1001de250,0,40); }
    }
    if (wasRecording && !IShotPCM_1001de248) {
        UInt32 channels = IShotPCM_1001de250.mChannelsPerFrame;
        AudioStreamBasicDescription fileFormat = {IShotPCM_1001de250.mSampleRate,kAudioFormatLinearPCM,0x0e,channels*2,1,channels*2,channels,16,0};
        const AudioChannelLayout *layout = CMAudioFormatDescriptionGetChannelLayout(description,NULL);
        OSStatus status = ExtAudioFileCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:self.temporaryPath],0x41494646,&fileFormat,layout,1,&IShotPCM_1001de248);
        if (!status) status = ExtAudioFileSetProperty(IShotPCM_1001de248,0x63666d74,40,&IShotPCM_1001de250);
        if (status) {
            if (IShotPCM_1001de248) ExtAudioFileDispose(IShotPCM_1001de248);
            IShotPCM_1001de248 = NULL; NSLog(@"Failed to setup audio file! (%ld)",(long)status);
        }
    } else if (!wasRecording && IShotPCM_1001de248) {
        OSStatus status = ExtAudioFileDispose(IShotPCM_1001de248); IShotPCM_1001de248 = NULL;
        NSLog(@"Recording Stopped (%ld)",(long)status);
    }
    CMItemCount frames = CMSampleBufferGetNumSamples(sample);
    IShotPCM_1001de288 += (double)frames;
    AudioTimeStamp timestamp = {}; timestamp.mSampleTime = IShotPCM_1001de288; timestamp.mFlags = 1;
    AudioUnitRenderActionFlags flags = 0;
    if (!IShotPCM_1001de280) IShotPCM_1001de280 = new IShotAudioBuffers(IShotPCM_1001de250,(UInt32)frames);
    IShotPCM_1001de280->prepare((UInt32)frames,false);
    UInt32 size = (IShotPCM_1001de250.mChannelsPerFrame << 4) | 8;
    IShotPCM_1001de278 = (AudioBufferList *)calloc(1,size);
    if (IShotPCM_1001de278) IShotPCM_1001de278->mNumberBuffers = IShotPCM_1001de250.mChannelsPerFrame;
    CMBlockBufferRef block = NULL; size_t needed;
    OSStatus status = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sample,&needed,IShotPCM_1001de278,size,kCFAllocatorSystemDefault,kCFAllocatorSystemDefault,1,&block);
    if (status) { NSLog(@"CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer failed! (%ld)",(long)status); return; }
    AudioUnitSetParameter(IShotPCM_1001de240,2,0,0,0.0f,0);
    AudioUnitSetParameter(IShotPCM_1001de240,1,0,0,0.0f,0);
    status = AudioUnitRender(IShotPCM_1001de240,&flags,&timestamp,0,(UInt32)frames,IShotPCM_1001de280->list);
    if (status) NSLog(@"AudioUnitRender failed! (%ld)",(long)status);
    if (block) CFRelease(block);
    free(IShotPCM_1001de278); IShotPCM_1001de278 = NULL;
    if (!status && IShotPCM_1001de248) {
        status = ExtAudioFileWriteAsync(IShotPCM_1001de248,(UInt32)frames,IShotPCM_1001de280->list);
        if (!status) IShotPCM_1001f1bd8 = IShotPCM_1001f1bd8 < 100000 ? IShotPCM_1001f1bd8 + 1 : 0;
        else NSLog(@"ExtAudioFileWriteAsync failed! (%ld)",(long)status);
    }
}
- (AudioBufferList *)currentInputAudioBufferList { return IShotPCM_1001de278; } // 0x1000b4cdc
- (float)updateAudioLevels { // 0x1000b4ce8
    float level = -1000.0f;
    for (AVCaptureConnection *connection in IShotPCM_1001de238.connections)
        for (AVCaptureAudioChannel *channel in connection.audioChannels) { float candidate = channel.averagePowerLevel; level = candidate <= level ? level : candidate; }
    return level;
}
- (void)startRecord { // 0x1000b4ee4
    self.isMP3 = [[[NSUserDefaults standardUserDefaults] stringForKey:@"formatOfRecording"] isEqualToString:@"mp3"];
    dispatch_queue_t queue = dispatch_queue_create("AudioDataOutputQueue",NULL);
    [IShotPCM_1001de238 setSampleBufferDelegate:self queue:queue];
    self.temporaryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[self fileName:@"aif"]];
    IShotPCM_1001f1bdc = 0; self.recording = YES;
}
- (void)pauseRecord { IShotPCM_1001f1bd4 = !IShotPCM_1001f1bd4; } // 0x1000b5088
- (void)stopRecord { IShotPCM_1001f1bdc = 0; self.recording = NO; [self dealloc2]; if (!self.isMP3) [self saveAudioFile]; } // 0x1000b50a0
- (void)cancelCaptureSession { for (AVCaptureInput *input in IShotPCM_1001de230.inputs) [IShotPCM_1001de230 removeInput:input]; } // 0x1000b50f0
- (NSString *)getRecordTime { // 0x1000b5208
    if (!recording) return @"00:00:00";
    if (IShotPCM_1001f1be0 != IShotPCM_1001f1bd8) ++IShotPCM_1001f1bdc;
    IShotPCM_1001f1be0 = IShotPCM_1001f1bd8;
    int32_t count = IShotPCM_1001f1bdc;
    NSString *value = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)((count/3600)%60),(unsigned long)((count/60)%60),(unsigned long)(count%60)];
    return [NSString stringWithFormat:@"%@",value];
}
- (void)cancelRecord { self.recording = NO; while (IShotPCM_1001de248) usleep(100000); [IShotPCM_1001de230 stopRunning]; [self dealloc2]; } // 0x1000b534c
- (void)dealloc2 { // 0x1000b539c; block 0x1000b53e8 does not clear the disposed pointers.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,1000000000),dispatch_get_main_queue(),^{ if (IShotPCM_1001de248) ExtAudioFileDispose(IShotPCM_1001de248); if (IShotPCM_1001de278) free(IShotPCM_1001de278); });
}
- (void)saveAudioFile { [[AppDelegate appDelegate] saveRecordAudioFileFromTempFile:self.temporaryPath]; } // 0x1000b541c
- (NSString *)fileName:(NSString *)extension { NSDate *date = [NSDate date]; NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; formatter.dateFormat = @"yyyy-MM-dd_HH.mm.ss"; return [NSString stringWithFormat:@"iShot_%@.%@",[formatter stringFromDate:date],extension]; } // 0x1000b54a8
- (NSString *)mp3Path { return [[self.temporaryPath stringByDeletingPathExtension] stringByAppendingFormat:@".mp3"]; } // 0x1000b55c8
- (void)deleteMp3Cache { [self deleteFileWithPath:self.mp3Path]; } // 0x1000b5658
- (void)deleteTempCache { [self deleteFileWithPath:self.temporaryPath]; } // 0x1000b56a8
- (void)deleteFileWithPath:(NSString *)path { [[NSFileManager defaultManager] removeItemAtPath:path error:NULL]; } // 0x1000b56f8
- (BOOL)isRecording { return recording & 1; } // 0x1000b5778
- (void)setRecording:(BOOL)value { recording = value; } // 0x1000b5784
@end
