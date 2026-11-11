#import "FFmpegCommandToolController.h"
#import "../MainApplication/AppDelegate.h"
#include <time.h>
#include <unistd.h>
@interface SGCaptureSession : NSObject
- (void)setConvertMp4ToGifFinished;
@end
extern SGCaptureSession *IShotGlobal_1001dddb0;
extern int32_t IShotGlobal_1001ddf78;
static NSPipe *IShotGlobal_1001f18e0, *IShotGlobal_1001f18e8;
static NSFileHandle *IShotGlobal_1001f18f0, *IShotGlobal_1001f18f8;
static time_t IShotGlobal_1001f1900;
static float IShotGlobal_1001f1908;
@implementation FFmpegCommandToolController
- (instancetype)initFromXib { // 0x100040664
    self = [super init];
    if (self) [NSBundle.mainBundle loadNibNamed:@"FFmpegCommandTool" owner:self topLevelObjects:NULL];
    return self;
}
- (void)awakeFromNib { self.window.level = 1; self.window.movableByWindowBackground = YES; } // 0x1000406e0
- (void)windowDidLoad { [super windowDidLoad]; } // 0x10004073c
- (void)ffmpegTranscodeFrom:(NSString *)source toFile:(NSString *)target withType:(NSString *)type { // 0x100040770
    self.sourceFile = source; self.targetFile = target; self.type = type;
    if ([type isEqualToString:@"MP3"]) [self executeFFMPEGTaskWithArgs:@[@"-i",source,target] needCallback:YES];
    else if ([type isEqualToString:@"Gif"]) {
        NSString *name = [NSProcessInfo.processInfo.globallyUniqueString stringByAppendingPathExtension:@"png"];
        NSString *palette = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{ // 0x1000409d0
            [self executeFFMPEGTaskWithArgs:@[@"-i",source,@"-y",@"-vf",@"scale=-2:-1:flags=lanczos,palettegen",palette] needCallback:NO];
            NSFileManager *manager = NSFileManager.defaultManager;
            while (![manager fileExistsAtPath:palette]) sleep(1);
            [self executeFFMPEGTaskWithArgs:@[@"-i",source,@"-i",palette,@"-y",@"-lavfi",@"scale=-2:-1:flags=lanczos [x]; [x][1:v] paletteuse",@"-f",@"gif",target] needCallback:YES];
        });
    }
}
- (void)executeFFMPEGTaskWithArgs:(NSArray *)args needCallback:(BOOL)callback { // 0x100040bc0
    NSString *executable = [NSBundle.mainBundle.resourcePath stringByAppendingString:@"/ARM/ffmpeg"];
    NSString *libraries = [NSBundle.mainBundle.resourcePath stringByAppendingString:@"/ARM"];
    setenv("DYLD_LIBRARY_PATH", libraries.UTF8String, 1);
    self.ffmpegTask = [NSTask new];
    self.ffmpegTask.launchPath = executable;
    self.ffmpegTask.arguments = args;
    IShotGlobal_1001f18e0 = [NSPipe new];
    IShotGlobal_1001f18e8 = [NSPipe new];
    IShotGlobal_1001f18f0 = IShotGlobal_1001f18e0.fileHandleForReading;
    self.ffmpegTask.standardOutput = IShotGlobal_1001f18e0;
    self.ffmpegTask.standardError = IShotGlobal_1001f18e8;
    self.ffmpegTask.standardInput = NSPipe.pipe;
    [self.ffmpegTask launch];
    dispatch_async(dispatch_get_main_queue(), ^{ // 0x100040ebc
        if (callback) {
            self.progressIndicator.doubleValue = 0;
            [IShotGlobal_1001f18f0 readInBackgroundAndNotify];
            IShotGlobal_1001f18f8 = IShotGlobal_1001f18e8.fileHandleForReading;
            NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
            if (![center doesContain:self.ffmpegTask]) {
                [center addObserver:self selector:@selector(notifiedForStdErrorOrtdOutput:) name:NSFileHandleReadCompletionNotification object:IShotGlobal_1001f18f0];
                [center addObserver:self selector:@selector(notifiedForStdErrorOrtdOutput:) name:NSFileHandleReadCompletionNotification object:IShotGlobal_1001f18f8];
                [center addObserver:self selector:@selector(notifiedForComplete:) name:NSTaskDidTerminateNotification object:self.ffmpegTask];
            }
            [IShotGlobal_1001f18f8 readInBackgroundAndNotify];
            IShotGlobal_1001f1900 = time(NULL);
        }
    });
}
- (void)notifiedForStdErrorOrtdOutput:(NSNotification *)notification { // 0x100041050
    dispatch_async(dispatch_get_main_queue(), ^{ // 0x1000410f0
        NSData *data = [notification.userInfo valueForKey:NSFileHandleNotificationDataItem];
        if (data.length) {
            NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            for (NSString *line in [output componentsSeparatedByCharactersInSet:NSCharacterSet.newlineCharacterSet]) {
                if ([line hasPrefix:@"  Duration: "] && ![line hasPrefix:@"  Duration: N/A"] && line.length > 20) IShotGlobal_1001f1908 = (float)([self getTotolTimeFrom:[line substringWithRange:NSMakeRange(12,8)]] + 1);
                if ([line hasPrefix:@"      encoder         :"] || [line hasPrefix:@"  Stream #0:0: Video: "] || [line hasPrefix:@"  Stream #0:0: Audio: "]) {
                    [self.progressIndicator stopAnimation:nil];
                    self.progressIndicator.indeterminate = NO;
                    IShotGlobal_1001f1900 = time(NULL);
                    if (IShotGlobal_1001f1908 == 0) IShotGlobal_1001f1908 = (float)IShotGlobal_1001ddf78 + 1.0f;
                }
                if (([line hasPrefix:@"size="] || [line hasPrefix:@"frame="]) && [line containsString:@"time="] && [line containsString:@"speed="]) {
                    int seconds = [self getTotolTimeFrom:[[line componentsSeparatedByString:@"time="][1] substringToIndex:8]];
                    if (seconds < 1) self.progressTextField.intValue = 0;
                    else {
                        int percent = (int)((double)(((float)seconds / IShotGlobal_1001f1908) * 100.0f) + 0.5);
                        self.progressIndicator.doubleValue = percent;
                        self.progressTextField.intValue = percent;
                        float elapsed = (float)(time(NULL) - IShotGlobal_1001f1900);
                        int left = (int)((elapsed / (float)percent) * 100.0f - elapsed);
                        NSString *minutes = [NSString stringWithFormat:@"%d", (left / 60) % 60];
                        NSString *secondsText = [NSString stringWithFormat:@"%d", left % 60];
                        NSString *text;
                        if ([minutes isEqualToString:@"0"]) text = [NSString stringWithFormat:@"%@%@",secondsText,[NSBundle.mainBundle localizedStringForKey:@" Second " value:@"" table:nil]];
                        else text = [NSString stringWithFormat:@"%@%@%@%@",minutes,[NSBundle.mainBundle localizedStringForKey:@" Minute " value:@"" table:nil],secondsText,[NSBundle.mainBundle localizedStringForKey:@" Second " value:@"" table:nil]];
                        self.leftTimeTextField.stringValue = text;
                    }
                }
                if ([line hasPrefix:@"video:"] && [line containsString:@"streams:"] && [line containsString:@"headers:"] && [line containsString:@"muxing overhead:"]) [self commandToolfinished];
            }
        }
        if (self.ffmpegTask) [IShotGlobal_1001f18f8 readInBackgroundAndNotify];
    });
}
- (int)getTotolTimeFrom:(NSString *)text { // 0x10004180c
    NSArray *parts = [text componentsSeparatedByString:@":"];
    return [parts[0] intValue] * 3600 + [parts[1] intValue] * 60 + [parts[2] intValue];
}
- (void)notifiedForComplete:(id)notification {} // 0x1000418d8: RET
- (void)commandToolfinished { // 0x1000418dc
    [NSNotificationCenter.defaultCenter removeObserver:self.ffmpegTask];
    [NSNotificationCenter.defaultCenter removeObserver:IShotGlobal_1001f18f0];
    [NSNotificationCenter.defaultCenter removeObserver:IShotGlobal_1001f18f8];
    self.ffmpegTask = nil;
    IShotGlobal_1001f18f0 = nil; IShotGlobal_1001f18f8 = nil;
    [self.window close];
    [self deleteFile:self.sourceFile];
    if ([self.type isEqualToString:@"MP3"]) [[AppDelegate appDelegate] saveRecordAudioFileFromTempFile:self.targetFile];
    else if ([self.type isEqualToString:@"Gif"]) [IShotGlobal_1001dddb0 setConvertMp4ToGifFinished];
}
- (void)deleteFile:(NSString *)path { [NSFileManager.defaultManager removeItemAtPath:path error:NULL]; } // 0x100041ad4
@end
