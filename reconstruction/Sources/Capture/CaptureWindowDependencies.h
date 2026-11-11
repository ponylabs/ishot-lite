#pragma once
#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
// Declaration-only interfaces from the original runtime metadata.
#import "RecordScreenClipView.h"
@interface SnipUtil : NSObject
+ (BOOL)isPoint:(CGPoint)arg0 inRect:(CGRect)arg1; // 0x1000572fc
+ (double)pointDistance:(CGPoint)arg0 toPoint:(CGPoint)arg1; // 0x100057300
+ (CGRect)uniformRect:(CGRect)arg0; // 0x100057318
+ (CGRect)rectToZero:(CGRect)arg0; // 0x100057344
+ (CGRect)cgWindowRectToScreenRect:(CGRect)arg0; // 0x100057350
@end
#import "KeyboardEventView.h"
#import "RecordScreenClipWindow.h"
#import "SGVideoControlsViewController.h"
#import "SGCaptureSession.h"
