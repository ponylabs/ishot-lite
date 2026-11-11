#import <Cocoa/Cocoa.h>
@interface FFmpegCommandToolController : NSWindowController
@property(nonatomic,strong) NSTextField *windowTitle;
@property(nonatomic,strong) NSTask *ffmpegTask;
@property(nonatomic,strong) NSProgressIndicator *progressIndicator;
@property(nonatomic,strong) NSTextField *progressTextField;
@property(nonatomic,strong) NSTextField *leftTimeTextField;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *sourceFile;
@property(nonatomic,strong) NSString *targetFile;
- (instancetype)initFromXib;
- (void)ffmpegTranscodeFrom:(NSString *)source toFile:(NSString *)target withType:(NSString *)type;
- (void)executeFFMPEGTaskWithArgs:(NSArray *)args needCallback:(BOOL)callback;
- (void)notifiedForStdErrorOrtdOutput:(NSNotification *)notification;
- (int)getTotolTimeFrom:(NSString *)text;
- (void)notifiedForComplete:(id)notification;
- (void)commandToolfinished;
- (void)deleteFile:(NSString *)path;
@end
