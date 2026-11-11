#pragma once
#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <ScreenCaptureKit/ScreenCaptureKit.h>
@interface AACAudioCapture : NSObject <AVCaptureAudioDataOutputSampleBufferDelegate, SCStreamDelegate, SCStreamOutput>
@property(nonatomic) int mChannelsPerFrame;
@property(atomic,strong) NSString *temporaryPath;
@property(atomic,strong) AVCaptureSession *captureSession;
@property(atomic,strong) AVCaptureAudioDataOutput *output;
@property(atomic,strong) AVAssetWriter *assetWriter;
@property(atomic,strong) AVAssetWriterInput *assetWriterInput;
@property(atomic,strong) AVCaptureAudioDataOutput *audioOutput;
+ (instancetype)sharedAudioCapture;
- (void)configureCaptureSession;
- (void)startRecord;
- (float)updateAudioLevels;
- (void)pauseRecord;
- (void)stopRecord;
- (void)cancelCaptureSession;
- (NSString *)getRecordTime;
- (void)cancelRecord;
- (void)writeSampleBuffer:(CMSampleBufferRef)sample;
- (void)saveAudioFile;
- (NSString *)fileName:(NSString *)extension;
- (void)deleteTempCache;
@end
