#import "AACAudioCapture.h"
#import "../MainApplication/AppDelegate.h"
extern int32_t IShotGlobal_1001ddf78;
static AACAudioCapture *IShotAACShared_1001f1990;
static BOOL IShotAACRecording_1001f1998, IShotAACPaused_1001f1999;
static int32_t IShotAACPreviousCount_1001f199c, IShotAACCount_1001f19a0;
@implementation AACAudioCapture
// 0x100054338. The original singleton is not protected by dispatch_once.
+ (instancetype)sharedAudioCapture {
    if (!IShotAACShared_1001f1990) IShotAACShared_1001f1990 = [[self alloc] init];
    return IShotAACShared_1001f1990;
}
- (instancetype)init { if ((self = [super init])) [self configureCaptureSession]; return self; } // 0x100054380
// 0x1000543ec; ASBD copy helper 0x100052a48 copies exactly 40 bytes.
- (void)configureCaptureSession {
    self.captureSession = [[AVCaptureSession alloc] init];
    NSString *selected = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedMicrophoneForRecordAudio"];
    BOOL system = [[NSUserDefaults standardUserDefaults] boolForKey:@"recordSystemAudioForRecordAudio"];
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]) {
        NSString *name = device.localizedName, *uid = device.uniqueID;
        AudioStreamBasicDescription format;
        memcpy(&format, CMAudioFormatDescriptionGetStreamBasicDescription([AVCaptureDevice deviceWithUniqueID:uid].activeFormat.formatDescription), 40);
        self.mChannelsPerFrame = 2;
        BOOL useDevice;
        if (!system) useDevice = [selected isEqualToString:name];
        else if ([selected isEqualToString:[[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil]]) useDevice = [uid isEqualToString:@"iShotAudioPlugin_UID"];
        else useDevice = [uid isEqualToString:@"iShotAudioAggregateDevice_UID"];
        if (useDevice) {
            self.mChannelsPerFrame = format.mChannelsPerFrame;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
            if ([self.captureSession canAddInput:input]) [self.captureSession addInput:input];
            break;
        }
    }
    NSData *layout = [NSData data];
    self.temporaryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[self fileName:@"m4a"]];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:@(0x61616320), AVFormatIDKey, @(self.mChannelsPerFrame), AVNumberOfChannelsKey, layout, AVChannelLayoutKey, @44100.0f, AVSampleRateKey, nil];
    self.assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:settings];
    self.assetWriterInput.expectsMediaDataInRealTime = YES;
    self.assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:self.temporaryPath] fileType:AVFileTypeAppleM4A error:NULL];
    [self.assetWriter addInput:self.assetWriterInput];
    self.audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("micOutputDispatchQueue", NULL);
    [self.audioOutput setSampleBufferDelegate:self queue:queue];
    [self.captureSession addOutput:self.audioOutput];
    [self.captureSession startRunning];
    if (@available(macOS 13.0, *)) {
        // 0x100054e58. SCStream is a local object; the shipped routine stores no stream property.
        [SCShareableContent getShareableContentWithCompletionHandler:^(SCShareableContent *content, NSError *error) {
            SCDisplay *display = content.displays.firstObject;
            SCContentFilter *filter = [[SCContentFilter alloc] initWithDisplay:display excludingWindows:@[]];
            SCStreamConfiguration *config = [[SCStreamConfiguration alloc] init];
            config.capturesAudio = YES;
            NSLog(@"----2");
            if (@available(macOS 15.0, *)) config.captureMicrophone = YES;
            config.excludesCurrentProcessAudio = NO;
            config.width = display.width;
            config.height = display.height;
            config.minimumFrameInterval = CMTimeMake(1, 60);
            config.queueDepth = 5;
            SCStream *stream = [[SCStream alloc] initWithFilter:filter configuration:config delegate:self];
            NSError *outputError = nil;
            if (@available(macOS 15.0, *)) [stream addStreamOutput:self type:2 sampleHandlerQueue:nil error:&outputError];
            [stream addStreamOutput:self type:0 sampleHandlerQueue:nil error:&outputError];
            [stream addStreamOutput:self type:1 sampleHandlerQueue:nil error:&outputError];
            [stream startCaptureWithCompletionHandler:^(NSError *error) {}]; // 0x100055114 RET-only
            if (outputError) NSLog(@"设置 stream 失败：%@", outputError);
        }];
    }
}
- (void)startRecord { // 0x100055128
    IShotGlobal_1001ddf78 = 0;
    [self deleteTempCache];
    [self.assetWriter startWriting];
    IShotAACRecording_1001f1998 = YES;
}
- (float)updateAudioLevels { // 0x100055194
    float level = -1000.0f;
    for (AVCaptureConnection *connection in self.audioOutput.connections)
        for (AVCaptureAudioChannel *channel in connection.audioChannels) {
            float candidate = channel.averagePowerLevel;
            level = candidate <= level ? level : candidate;
        }
    return level;
}
- (void)pauseRecord { IShotAACPaused_1001f1999 = !IShotAACPaused_1001f1999; } // 0x1000553b0
- (void)stopRecord { // 0x1000553c8, blocks 0x1000554c0 and 0x100055534
    IShotGlobal_1001ddf78 = 0;
    IShotAACRecording_1001f1998 = NO;
    if (self.assetWriter.status == 1) {
        [self.assetWriterInput markAsFinished];
        [self.assetWriter finishWritingWithCompletionHandler:^{ dispatch_async(dispatch_get_main_queue(), ^{ [self saveAudioFile]; }); }];
    }
}
- (void)cancelCaptureSession { // 0x10005553c
    for (AVCaptureInput *input in self.captureSession.inputs) [self.captureSession removeInput:input];
}
- (NSString *)getRecordTime { // 0x1000556ac
    if (self.assetWriter.status != 1) return @"00:00:00";
    if (IShotAACPreviousCount_1001f199c != IShotAACCount_1001f19a0) IShotGlobal_1001ddf78++;
    IShotAACPreviousCount_1001f199c = IShotAACCount_1001f19a0;
    int32_t count = IShotGlobal_1001ddf78;
    NSString *formatted = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)((count / 3600) % 60), (unsigned long)((count / 60) % 60), (unsigned long)(count % 60)];
    return [NSString stringWithFormat:@"%@", formatted];
}
- (void)cancelRecord { IShotGlobal_1001ddf78 = 0; [self deleteTempCache]; IShotAACRecording_1001f1998 = NO; } // 0x100055818
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sample fromConnection:(AVCaptureConnection *)connection { // 0x100055840
    if (self.audioOutput == output) [self writeSampleBuffer:sample]; else NSLog(@"Not Audio");
}
- (void)writeSampleBuffer:(CMSampleBufferRef)sample { // 0x1000558c8
    if (IShotAACPaused_1001f1999 || IShotAACRecording_1001f1998 != YES) return;
    if (!CMSampleBufferDataIsReady(sample)) { NSLog(@"sample buffer is not ready. Skipping sample"); return; }
    [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sample)];
    if ([self.assetWriterInput appendSampleBuffer:sample]) {
        if (IShotAACCount_1001f19a0 > 99999) IShotAACCount_1001f19a0 = 0;
        else IShotAACCount_1001f19a0++;
    } else NSLog(@"Can't append audio for some reason");
}
- (void)saveAudioFile { [[AppDelegate appDelegate] saveRecordAudioFileFromTempFile:self.temporaryPath]; } // 0x1000559d0
- (NSString *)fileName:(NSString *)extension { // 0x100055a5c
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd_HH.mm.ss";
    return [NSString stringWithFormat:@"iShot_%@.%@", [formatter stringFromDate:date], extension];
}
- (void)deleteTempCache { [[NSFileManager defaultManager] removeItemAtPath:self.temporaryPath error:NULL]; } // 0x100055b7c
- (void)stream:(SCStream *)stream didStopWithError:(NSError *)error {} // 0x100055c0c RET-only
- (void)stream:(SCStream *)stream didOutputSampleBuffer:(CMSampleBufferRef)sample ofType:(SCStreamOutputType)type { // 0x100055c10
    if (type == 2) NSLog(@"-----0"); else if (type == 1) NSLog(@"-----1");
}
@end
