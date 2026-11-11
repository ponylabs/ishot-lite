#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <ScreenCaptureKit/ScreenCaptureKit.h>
@interface SGCaptureSession : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, SCStreamDelegate, SCStreamOutput>
@property(nonatomic,strong) AVCaptureSession *captureSession;
@property(nonatomic,strong) AVAssetWriter *assetWriter;
@property(nonatomic,strong) AVAssetWriterInput *videoWriterInput, *audioWriterInput;
@property(nonatomic,strong) AVCaptureVideoDataOutput *videoOutput;
@property(nonatomic,strong) AVCaptureAudioDataOutput *audioOutput;
@property(nonatomic,strong) dispatch_queue_t audioOutputQueue,videoOutputQueue,writerQueue;
@property(nonatomic) BOOL canWrite,isCapture,isSuspend;
@property(nonatomic) int mChannelsPerFrame;
@property(nonatomic) CMTime lastVideo,lastAudio,timeOffset;
@property(nonatomic,copy) void (^complete)(void);
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSTask *ffmpegTask;
- (void)setAudioDevice;
- (void)beginRecordScreenWithRect:(NSRect)rect;
- (void)beginRecordScreenWithWindowID:(unsigned int)windowID;
- (void)initOutputQueue;
- (void)initCapture:(NSRect)rect;
- (void)startCaptureWindow:(long long)windowID;
- (void)addOutput;
- (void)initWrite:(NSRect)rect;
- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sample;
- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sample;
- (void)appendSampleBuffer:(CMSampleBufferRef)sample ofMediaType:(AVMediaType)type;
- (void)finishRecording;
- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset;
- (void)cancelCaptureSession;
- (void)endRecordingComplete:(void (^)(void))complete;
- (void)pauseAndResumeRecordingAction;
- (float)updateAudioLevels;
- (void)readyToMoveFile;
- (void)moveFileTo:(NSString *)path;
- (void)cancelRecordScreen;
- (void)setConvertMp4ToGifFinished;
- (void)changeMovToGif;
- (void)saveFileToPaste:(NSString *)path;
- (NSString *)captureTemporaryFilePath;
@end
