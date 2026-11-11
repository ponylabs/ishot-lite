#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface LinearPCMAudioCapture : NSObject <AVCaptureAudioDataOutputSampleBufferDelegate> {
    BOOL recording;
}
@property(getter=isRecording) BOOL recording;
@property(atomic,strong) NSString *temporaryPath;
@property(nonatomic) BOOL isMP3;
- (void)configureCaptureSession;
- (void)configureEffectAudioUnit;
- (AVCaptureDevice *)getSelectedAudioDevice;
- (AudioBufferList *)currentInputAudioBufferList;
- (float)updateAudioLevels;
- (void)startRecord;
- (void)pauseRecord;
- (void)stopRecord;
- (void)cancelCaptureSession;
- (NSString *)getRecordTime;
- (void)cancelRecord;
- (void)dealloc2;
- (void)saveAudioFile;
- (NSString *)fileName:(NSString *)extension;
- (NSString *)mp3Path;
- (void)deleteMp3Cache;
- (void)deleteTempCache;
- (void)deleteFileWithPath:(NSString *)path;
@end
