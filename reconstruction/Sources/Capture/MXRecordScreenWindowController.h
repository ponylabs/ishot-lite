#pragma once
#import <Cocoa/Cocoa.h>
#import "RecordScreenClipView.h"
@class RecordScreenClipView, SGVideoControlsViewController;
@interface MXRecordScreenWindowController : NSWindowController <RecordScreenClipViewDelegate>
@property(nonatomic,weak) id delegate;
@property(nonatomic,strong) NSScreen *screen;
@property(nonatomic,strong) RecordScreenClipView *recordScreenClipView;
@property(nonatomic,strong) NSTask *ffmpegTask;
@property(nonatomic,strong) SGVideoControlsViewController *videoControlsViewController;
@property(nonatomic,strong) id eventMonitor, eventMonitorGlobal;
@property(nonatomic,strong) NSMutableArray *shadeWindows;
@property(nonatomic,strong) NSScreen *selectedScreen;
@property(nonatomic) CGRect currentWindowRect, lastWindowRect, selectedRegion;
@property(nonatomic,strong) NSString *recordFileName;
- (instancetype)initWithDelegate:(id)delegate;
- (void)startRecorderScreen:(NSScreen *)screen;
- (void)removeEventMonitor;
- (void)cleanup;
- (void)clipViewMouseMoved:(id)sender;
- (void)recordViewDidShowToolBar:(id)sender;
- (void)startRecording:(id)sender;
- (void)recordToolbarViewControllerCanceSGote:(id)sender;
- (void)handleControllerEndCaptureNotification:(id)sender;
- (void)handleControllerPauseAndResumeNotification:(id)sender;
- (void)recordScreenWindowControllerDidCancel:(id)sender;
- (void)openCamera:(id)sender;
- (void)closeCamera:(id)sender;
@end
