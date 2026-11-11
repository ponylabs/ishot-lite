#import "SGCaptureSession.h"
#import "../MainApplication/AppDelegate.h"
#import "../Preferences/AppPrefsWindowController.h"
#import "../Dependencies/AppSandboxFileAccess.h"
#import <unistd.h>
extern NSScreen *IShotGlobal_1001ddd60;
extern AppPrefsWindowController *IShotGlobal_1001de1a0;
extern int32_t IShotGlobal_1001ddf78;
extern BOOL IShotGlobal_1001de2a1;
extern void IShotFunction_100047ffc(NSString *);
static BOOL IShotSG_1001f1bf8,IShotSG_1001f1bf9,IShotSG_1001f1bfa;
// 0x10004ca64 deliberately parses the last format's description instead of the active ASBD.
static int IShotSGChannels(AVCaptureDevice *device) {
    NSString *description = [NSString stringWithFormat:@"%@",device.formats.lastObject.formatDescription];
    int channels=0;
    for (NSString *line in [description componentsSeparatedByString:@"\n"])
        if ([line containsString:@"mChannelsPerFrame: "]) channels=[[[line componentsSeparatedByString:@"mChannelsPerFrame: "] objectAtIndex:1] intValue];
    return channels;
}
@implementation SGCaptureSession
- (instancetype)init { return [super init]; } // 0x1000b9004
- (void)setAudioDevice { // 0x1000b9038
    NSArray *devices=[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    NSString *selected=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedMicrophoneOfRecordScreen"];
    BOOL system=[[NSUserDefaults standardUserDefaults] boolForKey:@"recordSystemSoundOfRecordScreen"];
    self.captureSession=[[AVCaptureSession alloc] init];
    for (AVCaptureDevice *device in devices) {
        NSString *name=device.localizedName,*uid=device.uniqueID;
        BOOL match=!system ? [selected isEqualToString:name] : [selected isEqualToString:[[NSBundle mainBundle] localizedStringForKey:@"None" value:@"" table:nil]] ? [uid isEqualToString:@"iShotAudioPlugin_UID"] : [uid isEqualToString:@"iShotAudioAggregateDevice_UID"];
        if (match) {
            self.mChannelsPerFrame=IShotSGChannels(device);
            AVCaptureDeviceInput *input=[AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
            if ([self.captureSession canAddInput:input]) [self.captureSession addInput:input];
            break;
        }
    }
    self.audioOutput=[[AVCaptureAudioDataOutput alloc] init];
    dispatch_queue_t queue=dispatch_queue_create("micOutputDispatchQueue",NULL);
    [self.audioOutput setSampleBufferDelegate:self queue:queue]; [self.captureSession addOutput:self.audioOutput];
    IShotSG_1001f1bf8=NO; self.isSuspend=YES; [self.captureSession startRunning];
}
- (void)beginRecordScreenWithRect:(NSRect)rect { // 0x1000b9470; global block 0x1000b956c.
    [self initOutputQueue]; [self initCapture:rect]; [self addOutput]; self.canWrite=YES; self.isCapture=YES; self.isSuspend=NO; [self initWrite:rect];
    dispatch_async(dispatch_get_global_queue(0,0),^{ usleep(200000); IShotSG_1001f1bf8=YES; });
    [self.captureSession startRunning]; IShotSG_1001f1bf9=NO; IShotGlobal_1001ddf78=0;
}
- (void)beginRecordScreenWithWindowID:(unsigned int)windowID { // 0x1000b9594; no initWrite call in original.
    [self initOutputQueue]; [self startCaptureWindow:windowID]; [self addOutput]; self.canWrite=YES; self.isCapture=YES; self.isSuspend=NO;
    dispatch_async(dispatch_get_global_queue(0,0),^{ usleep(200000); IShotSG_1001f1bf8=YES; });
    [self.captureSession startRunning]; IShotSG_1001f1bf9=NO; IShotGlobal_1001ddf78=0;
}
- (void)initOutputQueue { // 0x1000b9678
    self.audioOutputQueue=dispatch_queue_create("audioOutputQueue.com",NULL); self.videoOutputQueue=dispatch_queue_create("videoOutputQueue.com",NULL); self.writerQueue=dispatch_queue_create("writerQueue",NULL);
}
- (void)initCapture:(NSRect)rect { // 0x1000b9708
    self.captureSession.sessionPreset=AVCaptureSessionPresetHigh;
    AVCaptureScreenInput *input=[[AVCaptureScreenInput alloc] initWithDisplayID:[[IShotGlobal_1001ddd60.deviceDescription valueForKey:@"NSScreenNumber"] unsignedIntValue]];
    input.cropRect=rect; input.scaleFactor=2.0;
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    if ([defaults boolForKey:@"showMouseClickOfRecordScreen"]) input.capturesMouseClicks=YES;
    input.capturesCursor=[defaults boolForKey:@"showCursorOfRecordScreen"];
    int rate=[[defaults stringForKey:@"frameRateOfRecordScreen"] intValue];
    if ([[defaults objectForKey:@"formatOfRecordScreen"] isEqualToString:@"gif"]) rate=[[defaults stringForKey:@"frameRateOfRecordScreenGIF"] intValue];
    input.minFrameDuration=CMTimeMake(1,rate);
    if ([self.captureSession canAddInput:input]) [self.captureSession addInput:input];
}
- (void)startCaptureWindow:(long long)windowID { // 0x1000b9974 / 0x1000b99fc / 0x1000b9be4
    if (@available(macOS 12.3,*)) [SCShareableContent getShareableContentExcludingDesktopWindows:NO onScreenWindowsOnly:NO completionHandler:^(SCShareableContent *content,NSError *error) {
        if (error) { NSLog(@"%s get shareableContent error","-[SGCaptureSession startCaptureWindow:]_block_invoke"); return; }
        for (SCWindow *window in content.windows) if ((unsigned long long)windowID == window.windowID) {
            SCContentFilter *filter=[[SCContentFilter alloc] initWithDesktopIndependentWindow:window];
            SCStreamConfiguration *configuration=[[SCStreamConfiguration alloc] init];
            SCStream *stream=[[SCStream alloc] initWithFilter:filter configuration:configuration delegate:self];
            dispatch_queue_t queue=dispatch_queue_create("queue_name",NULL); NSError *outputError=nil;
            [stream addStreamOutput:self type:0 sampleHandlerQueue:queue error:&outputError];
            if (!outputError) [stream startCaptureWithCompletionHandler:^(NSError *error) { if (error) NSLog(@"start capture error : %@",error); }];
            break;
        }
    }];
}
- (void)stream:(SCStream *)stream didStopWithError:(NSError *)error {} // 0x1000b9c10 RET-only
- (void)stream:(SCStream *)stream didOutputSampleBuffer:(CMSampleBufferRef)sample ofType:(SCStreamOutputType)type { [self appendVideoSampleBuffer:sample]; } // 0x1000b9c14
- (void)addOutput { // 0x1000b9c1c
    self.videoOutput=[[AVCaptureVideoDataOutput alloc] init]; self.videoOutput.videoSettings=@{(id)kCVPixelBufferPixelFormatTypeKey:@(0x34323076)};
    [self.videoOutput setSampleBufferDelegate:self queue:self.videoOutputQueue];
    self.audioOutput=[[AVCaptureAudioDataOutput alloc] init]; [self.audioOutput setSampleBufferDelegate:self queue:self.audioOutputQueue];
    if ([self.captureSession canAddOutput:self.videoOutput]) [self.captureSession addOutput:self.videoOutput];
    if ([self.captureSession canAddOutput:self.audioOutput]) [self.captureSession addOutput:self.audioOutput];
}
- (void)initWrite:(NSRect)rect { // 0x1000b9ed0
    self.fileName=[NSTemporaryDirectory() stringByAppendingString:[self captureTemporaryFilePath]];
    self.assetWriter=[AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:self.fileName] fileType:AVFileTypeMPEG4 error:NULL];
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSInteger resolution=[defaults integerForKey:@"resolutionOfRecordScreen"];
    float scale=resolution==2 ? 1.0f : (float)IShotGlobal_1001ddd60.backingScaleFactor, gifScale=1.0f;
    if ([[defaults objectForKey:@"formatOfRecordScreen"] isEqualToString:@"gif"]) {
        float candidate=[defaults floatForKey:@"sizeScaleOfGif"]/100.0f;
        scale=1.0f; gifScale=(double)candidate<0.2 ? 1.0f : candidate; if (candidate>1.0f) gifScale=1.0f;
    }
    NSInteger rate=[defaults integerForKey:@"frameRateOfRecordScreen"];
    float factor=(float)rate/25.0f; if (!resolution) factor*=3.0f;
    double width=rect.size.width*(double)scale;
    NSDictionary *compression=@{AVVideoAverageBitRateKey:@((NSInteger)(factor*(float)(NSInteger)(rect.size.height*width*(double)scale))), AVVideoProfileLevelKey:AVVideoProfileLevelH264MainAutoLevel};
    NSDictionary *video=@{AVVideoCodecKey:AVVideoCodecTypeH264,AVVideoScalingModeKey:AVVideoScalingModeResizeAspect,AVVideoWidthKey:@(width*(double)gifScale),AVVideoHeightKey:@(rect.size.height*(double)scale*(double)gifScale),AVVideoCompressionPropertiesKey:compression};
    if ([self.assetWriter canApplyOutputSettings:video forMediaType:AVMediaTypeVideo]) { self.videoWriterInput=[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:video]; self.videoWriterInput.expectsMediaDataInRealTime=YES; }
    if ([self.assetWriter canAddInput:self.videoWriterInput]) [self.assetWriter addInput:self.videoWriterInput];
    NSDictionary *audio=@{AVFormatIDKey:@(0x61616320),AVEncoderBitRatePerChannelKey:@128000,AVSampleRateKey:@44100.0,AVNumberOfChannelsKey:@(self.mChannelsPerFrame),AVChannelLayoutKey:[NSData data]};
    if ([self.assetWriter canApplyOutputSettings:audio forMediaType:AVMediaTypeAudio]) { self.audioWriterInput=[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audio]; self.audioWriterInput.expectsMediaDataInRealTime=YES; }
    IShotSG_1001f1bfa=YES;
    if (self.audioWriterInput && [self.assetWriter canAddInput:self.audioWriterInput]) [self.assetWriter addInput:self.audioWriterInput]; else IShotSG_1001f1bfa=NO;
}
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sample fromConnection:(AVCaptureConnection *)connection { // 0x1000ba6cc
    if ([self.videoOutput connectionWithMediaType:AVMediaTypeVideo]==connection) [self appendVideoSampleBuffer:sample];
    else if ([self.audioOutput connectionWithMediaType:AVMediaTypeAudio]==connection) [self appendAudioSampleBuffer:sample];
}
- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sample { [self appendSampleBuffer:sample ofMediaType:AVMediaTypeVideo]; } // 0x1000ba7b0
- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sample { [self appendSampleBuffer:sample ofMediaType:AVMediaTypeAudio]; } // 0x1000ba7c0
- (void)appendSampleBuffer:(CMSampleBufferRef)sample ofMediaType:(AVMediaType)type { // 0x1000ba7d0 / 0x1000ba8ec
    if (!sample || IShotSG_1001f1bf8 != YES) return;
    __block CMSampleBufferRef copy;
    CMSampleBufferCreateCopy(kCFAllocatorDefault,sample,&copy);
    dispatch_async(self.writerQueue,^{
        if (!self.isCapture) { if (copy) CFRelease(copy); return; }
        if (self.isSuspend) {
            if (type==AVMediaTypeVideo && IShotSG_1001f1bfa==YES) { if(copy) CFRelease(copy); return; }
            self.isSuspend=NO;
            CMTime now=CMSampleBufferGetPresentationTimeStamp(copy),last=IShotSG_1001f1bfa==YES ? self.lastAudio : self.lastVideo;
            if (last.flags&1) self.timeOffset=CMTimeSubtract(now,last);
            if (IShotSG_1001f1bfa==YES) self->_lastAudio.flags=0;
            self->_lastVideo.flags=0;
        }
        if (self.timeOffset.value>0) copy=[self adjustTime:copy by:self.timeOffset];
        CMTime now=CMSampleBufferGetPresentationTimeStamp(copy), duration=CMSampleBufferGetDuration(copy);
        if (duration.value>0) now=CMTimeAdd(now,duration);
        if (type==AVMediaTypeVideo || IShotSG_1001f1bfa==NO) self->_lastVideo=now; else self->_lastAudio=now;
        if (self.canWrite && type==AVMediaTypeVideo && CMSampleBufferGetPresentationTimeStamp(copy).value>0) {
            self.canWrite=NO; [self.assetWriter startWriting]; [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(copy)];
        }
        AVAssetWriterInput *input=type==AVMediaTypeVideo ? self.videoWriterInput : self.audioWriterInput;
        if (!(IShotSG_1001f1bfa&1)) input=self.videoWriterInput;
        if (!input.readyForMoreMediaData) NSLog(@"%@ input not ready for more media data, dropping buffer",type);
        else if (![input appendSampleBuffer:copy]) NSLog(@"input failure with error %@:",self.assetWriter.error);
        if(copy) CFRelease(copy);
    });
}
- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset { // 0x1000bb06c; consumes the passed reference.
    CMItemCount count; CMSampleBufferGetSampleTimingInfoArray(sample,0,NULL,&count);
    CMSampleTimingInfo *timing=malloc(count*72); CMSampleBufferGetSampleTimingInfoArray(sample,count,timing,&count);
    for (CMItemCount i=0;i<count;i++) { timing[i].decodeTimeStamp=CMTimeSubtract(timing[i].decodeTimeStamp,offset); timing[i].presentationTimeStamp=CMTimeSubtract(timing[i].presentationTimeStamp,offset); }
    CMSampleBufferRef result; CMSampleBufferCreateCopyWithNewTiming(NULL,sample,count,timing,&result);
    if(sample) CFRelease(sample); free(timing); return result;
}
- (void)finishRecording { // 0x1000bade4 / 0x1000baf04 / 0x1000bb020 / 0x1000bb028
    if (self.assetWriter && self.assetWriter.status==1) {
        [self.assetWriter finishWritingWithCompletionHandler:^{
            NSError *error=self.assetWriter.error;
            if (!error) { self.canWrite=YES; if(self.fileName) dispatch_after(dispatch_time(0,500000000),dispatch_get_main_queue(),^{ [self readyToMoveFile]; }); }
            else NSLog(@"AssetWriterFinishError:%@",error);
            [self cancelCaptureSession]; self.assetWriter=nil;
        }]; return;
    }
    IShotGlobal_1001ddf78=0; self.fileName=@"";
    dispatch_async(dispatch_get_main_queue(),^{ [NSNotificationCenter.defaultCenter postNotificationName:@"RecordScreenWindowControllerDidCancel" object:nil]; }); self.assetWriter=nil;
}
- (void)cancelCaptureSession { for(AVCaptureInput *input in self.captureSession.inputs) [self.captureSession removeInput:input]; } // 0x1000bb1b4
- (void)endRecordingComplete:(void (^)(void))complete { self.complete=complete; IShotSG_1001f1bf8=NO; [self.captureSession stopRunning]; [self finishRecording]; } // 0x1000bb2ec
- (void)pauseAndResumeRecordingAction { if(self.isCapture) { self.isCapture=NO; self.isSuspend=YES; } else self.isCapture=YES; } // 0x1000bb338
- (float)updateAudioLevels { // 0x1000bb384; original returns NaN for zero usable channels.
    float total=0; NSInteger count=0;
    for(AVCaptureConnection *connection in self.audioOutput.connections) for(AVCaptureAudioChannel *channel in connection.audioChannels) { float level=channel.averagePowerLevel; if(fabsf(level)<200.0f) { total+=level; ++count; } }
    return total/(float)count;
}
- (void)readyToMoveFile { // 0x1000bb570 and blocks 0x1000bbd50, 0x1000bbda0, 0x1000bbf24, 0x1000bbf54.
    if ([self.fileName isEqualToString:@""]) return;
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    __block NSString *path=[NSUserDefaults.standardUserDefaults stringForKey:@"pathofSaveVideo"];
    NSInteger method=[NSUserDefaults.standardUserDefaults integerForKey:@"saveMethodOfRecordScreen"];
    NSString *format=[defaults objectForKey:@"formatOfRecordScreen"];
    if ([path isEqualToString:@"NotSpecified"] && method!=1) {
        NSSavePanel *panel=NSSavePanel.savePanel; panel.contentView.window.level=-1;
        dispatch_after(dispatch_time(0,100000000),dispatch_get_main_queue(),^{ panel.contentView.window.level=1; });
        panel.allowsOtherFileTypes=YES; panel.allowedFileTypes=@[format]; panel.extensionHidden=YES; panel.canCreateDirectories=YES;
        [panel beginWithCompletionHandler:^(NSModalResponse result) {
            if(result==1) {
                NSString *destination=panel.URL.path;
                if (![format isEqualToString:@"mp4"] && [format isEqualToString:@"gif"]) {
                    IShotGlobal_1001de2a1=YES;
                    dispatch_async(dispatch_get_global_queue(0,0),^{ [self changeMovToGif]; IShotGlobal_1001de2a1=NO; [self moveFileTo:destination]; });
                } else [self moveFileTo:destination];
            } else { [NSFileManager.defaultManager removeItemAtPath:self.fileName error:NULL]; [self cancelRecordScreen]; }
        }];
    } else {
        if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
            NSAlert *alert=[[NSAlert alloc] init];
            alert.messageText=[NSBundle.mainBundle localizedStringForKey:@"The save path you set does not exist. Please reset the save path." value:@"" table:nil];
            [alert addButtonWithTitle:[NSBundle.mainBundle localizedStringForKey:@"OK" value:@"" table:nil]]; [alert runModal];
            path=[[AppDelegate appDelegate] getSavePathWithOpenPanel];
            if ([path isEqualToString:@""]) { [self cancelRecordScreen]; return; }
            [defaults setObject:path forKey:@"pathofSaveVideo"]; [defaults synchronize];
            if(IShotGlobal_1001de1a0) {
                NSString *name=[[NSFileManager.defaultManager displayNameAtPath:path] lastPathComponent];
                [IShotGlobal_1001de1a0.buttonOfSaveVideoPath.menu.itemArray[0] setTitle:name];
                [IShotGlobal_1001de1a0.buttonOfSaveVideoPath selectItemAtIndex:0];
            }
        }
        if ([format isEqualToString:@"gif"]) {
            IShotGlobal_1001de2a1=YES;
            dispatch_async(dispatch_get_global_queue(0,0),^{
                [self changeMovToGif]; IShotGlobal_1001de2a1=NO;
                if(method==1) { [self saveFileToPaste:self.fileName]; [self cancelRecordScreen]; return; }
                NSString *destination=[NSString stringWithFormat:@"%@/%@",path,self.fileName.lastPathComponent];
                if ([[AppSandboxFileAccess fileAccessWithMessage:@""] accessFilePath:path persistPermission:YES withBlock:^{}]) [self moveFileTo:destination];
                else { [NSFileManager.defaultManager removeItemAtPath:self.fileName error:NULL]; [self cancelRecordScreen]; }
            });
        } else if(method==1) { [self saveFileToPaste:self.fileName]; [self cancelRecordScreen]; }
        else {
            NSString *destination=[NSString stringWithFormat:@"%@/%@",path,self.fileName.lastPathComponent];
            if ([[AppSandboxFileAccess fileAccessWithMessage:@""] accessFilePath:path persistPermission:YES withBlock:^{}]) [self moveFileTo:destination];
            else { [NSFileManager.defaultManager removeItemAtPath:self.fileName error:NULL]; [self cancelRecordScreen]; }
        }
    }
}
- (void)moveFileTo:(NSString *)path { // 0x1000bc158 / 0x1000bc4dc
    NSFileManager *manager=NSFileManager.defaultManager;
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        NSError *error=nil;
        if (![NSFileManager.defaultManager removeItemAtPath:path error:&error]) NSLog(@"Error deleting existing movie %@",error.localizedDescription);
    }
    if(path && self.fileName) {
        NSInteger method=[NSUserDefaults.standardUserDefaults integerForKey:@"saveMethodOfRecordScreen"];
        if ((method & ~2L)==0) {
            NSError *error=nil; BOOL moved=[manager moveItemAtPath:self.fileName toPath:path error:&error];
            if(error) NSLog(@"iShot Err:%@",error);
            if(!moved) {
                NSString *source=self.fileName;
                dispatch_after(dispatch_time(0,100000000),dispatch_get_main_queue(),^{
                    NSAlert *alert=[[NSAlert alloc] init];
                    alert.messageText=[NSBundle.mainBundle localizedStringForKey:@"Failure due to unknown reason, cache directory will be opened for you" value:@"" table:nil];
                    [alert addButtonWithTitle:[NSBundle.mainBundle localizedStringForKey:@"OK" value:@"" table:nil]]; [alert runModal];
                    if (![NSWorkspace.sharedWorkspace selectFile:source inFileViewerRootedAtPath:source.stringByDeletingLastPathComponent]) [NSWorkspace.sharedWorkspace openURL:[NSURL fileURLWithPath:source.stringByDeletingLastPathComponent]];
                });
            } else {
                [NSUserDefaults.standardUserDefaults setObject:path forKey:@"LastSavedFile"];
                NSInteger action=[NSUserDefaults.standardUserDefaults integerForKey:@"actionWhenFinishedOfRecordScreen"];
                if(action==2) [NSWorkspace.sharedWorkspace selectFile:path inFileViewerRootedAtPath:path.stringByDeletingLastPathComponent];
                else if(action==1) [NSWorkspace.sharedWorkspace openFile:path];
                else if(action==0) IShotFunction_100047ffc([@"TelliShotHelperToUserNotification:" stringByAppendingString:path]);
                if(method==2) [self saveFileToPaste:path];
            }
        }
    }
    [self cancelRecordScreen];
}
- (void)cancelRecordScreen { // 0x1000bc69c / 0x1000bc6e8
    IShotGlobal_1001ddf78=0; self.fileName=@"";
    dispatch_async(dispatch_get_main_queue(),^{ [NSNotificationCenter.defaultCenter postNotificationName:@"RecordScreenWindowControllerDidCancel" object:nil]; });
}
- (void)setConvertMp4ToGifFinished { IShotSG_1001f1bf9=YES; } // 0x1000bc72c
- (void)changeMovToGif { // 0x1000bc73c / 0x1000bc888
    dispatch_async(dispatch_get_main_queue(),^{
        NSString *destination=[self.fileName stringByReplacingOccurrencesOfString:@"mp4" withString:@"gif"];
        [[AppDelegate appDelegate] ffmpegTranscodeFrom:self.fileName toFile:destination withType:@"Gif"];
    });
    if (!(IShotSG_1001f1bf9&1)) do { [NSThread sleepForTimeInterval:0.1]; } while(IShotSG_1001f1bf9!=YES);
    [NSFileManager.defaultManager removeItemAtPath:self.fileName error:NULL];
    self.fileName=[self.fileName stringByReplacingOccurrencesOfString:@"mp4" withString:@"gif"];
}
- (void)saveFileToPaste:(NSString *)path { // 0x1000bc940
    NSURL *url=[NSURL fileURLWithPath:path]; NSPasteboard *pasteboard=NSPasteboard.generalPasteboard; [pasteboard clearContents];
    if (![pasteboard writeObjects:@[url]]) NSBeep();
    else if ([NSUserDefaults.standardUserDefaults integerForKey:@"saveMethodOfRecordScreen"]==1) IShotFunction_100047ffc(@"TelliShotHelperToPlayScreenShotAudio");
}
- (NSString *)captureTemporaryFilePath { // 0x1000bca64
    NSDate *date=NSDate.date; NSDateFormatter *formatter=[[NSDateFormatter alloc] init]; formatter.dateFormat=@"yyyy-MM-dd_HH.mm.ss";
    return [NSString stringWithFormat:@"%@_%@.%@",@"iShot",[formatter stringFromDate:date],@"mp4"];
}
@end
