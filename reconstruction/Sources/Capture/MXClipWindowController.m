#import "MXClipWindowController.h"
#import "ClipViewDependencies.h"
#import "MXClipScreenManager.h"
#import "../Editor/AnnotatedImageController.h"
#import "../MainApplication/AppDelegate.h"
#import "../Global/Global.h"
#import "../Dependencies/SnipUtil.h"
#import "../Dependencies/AppSandboxFileAccess.h"
#import "../Imaging/Imaging.h"
#import "../Preferences/AppPrefsWindowController.h"
#import <unistd.h>
#import "../Camera/NSValue+CGPoint.h"
extern void IShotFunction_100047ffc(NSString *);
extern NSScreen *IShotGlobal_1001dde80;
extern AnnotatedImageController *IShotGlobal_1001de160;
extern AppPrefsWindowController *IShotGlobal_1001de1a0;
extern NSCursor *IShotGlobal_1001dddf8;
extern NSArray *IShotGlobal_1001ddcd0;
extern NSMutableArray *IShotGlobal_1001de138,*IShotGlobal_1001de148,*IShotGlobal_1001de050,*IShotGlobal_1001dde28,*IShotGlobal_1001dde30;
extern NSMutableDictionary *IShotGlobal_1001de058,*IShotGlobal_1001ddff8;
extern NSView *IShotGlobal_1001dde40;
extern id IShotGlobal_1001dde48,IShotGlobal_1001ddf10,IShotGlobal_1001ddf20,IShotGlobal_1001ddf28,IShotGlobal_1001ddf40;
extern NSString *IShotGlobal_1001dde70,*IShotGlobal_1001ddfc0,*IShotGlobal_1001ddfc8,*IShotGlobal_1001ddd08,*IShotGlobal_1001ddd40,*IShotGlobal_1001ddd48;
extern int64_t IShotGlobal_1001ddd00;
extern int32_t IShotGlobal_1001ddd10,IShotGlobal_1001ddd38,IShotGlobal_1001de048;
extern double IShotGlobal_1001ddd18,IShotGlobal_1001ddd20,IShotGlobal_1001ddd28,IShotGlobal_1001ddd30,IShotGlobal_1001ddcf8;
extern BOOL IShotGlobal_1001dd139,IShotGlobal_1001ddcf0,IShotGlobal_1001ddd50,IShotGlobal_1001dde90,IShotGlobal_1001dde91,IShotGlobal_1001dde94,IShotGlobal_1001ddec0,IShotGlobal_1001dded8,IShotGlobal_1001dded9,IShotGlobal_1001ddfb8,IShotGlobal_1001de088,IShotGlobal_1001de0c0,IShotGlobal_1001de0c2,IShotGlobal_1001de0d1,IShotGlobal_1001de0d2,IShotGlobal_1001de0d4,IShotGlobal_1001de0d5,IShotGlobal_1001de0d6,IShotGlobal_1001de168,IShotGlobal_1001de180;
static BOOL IShotClip_1001f18b4;
static NSEvent *IShotClipLocal(MXClipWindowController *,NSEvent *);
static void IShotClipGlobal(MXClipWindowController *,NSEvent *);
static void IShotClipCapture_100018ef8(MXClipWindowController *,NSUserDefaults *);
// 0x10001984c. Rectangles below are corroborated with ARM64 d0-d5 argument registers.
@interface NSView (IShotCaptureImageDeclaration)
- (NSImage *)toImage;
@end
@interface NSObject (IShotPinCaptureDeclarations)
- (NSImage *)image;
- (void)setImage:(NSImage *)image;
- (int)imageScale;
- (NSImageView *)mapImageView;
- (void)clipWindowControllerDidCancel:(id)controller;
@end

@implementation MXClipWindowController
- (instancetype)initWithDelegate:(id)delegate { if((self=[super init])) self.delegate=delegate; return self; } // 0x100015600
- (void)windowDidLoad { [super windowDidLoad]; } // 0x10001566c
- (void)startAnnotation { // 0x1000156a0
    NSScreen *screen=NSScreen.currentScreenForMouseLocation; if(IShotGlobal_1001dde80) screen=IShotGlobal_1001dde80;
    if([self.screen isEqual:screen]) [self.clipView startAnnotation];
    else { [self.clipView setFullImage:nil]; self.window.backgroundColor=NSColor.clearColor; [[self.clipView sliderOfRadiusOfFrame] removeFromSuperview]; [self.clipView removeFromSuperview]; }
}
- (void)cancel { // 0x1000157f8
    [self endCapture]; if([self.delegate respondsToSelector:@selector(clipWindowControllerDidCancel:)]) [self.delegate clipWindowControllerDidCancel:self];
    IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set];
}
- (void)startCaptureWithScreen:(NSScreen *)screen { // 0x1000158a8
    self.screen=screen;
    self.window=[[MXClipWindow alloc] initWithContentRect:screen.frame styleMask:0x80 backing:2 defer:NO screen:screen];
    self.clipView=[[MXClipView alloc] initWithFrame:NSMakeRect(0,0,screen.frame.size.width,screen.frame.size.height) type:0];
    [self.clipView setDelegate:(id<MXClipViewDelegate>)self]; self.clipView.wantsLayer=YES; self.clipView.layer.backgroundColor=[NSColor colorWithWhite:0 alpha:0].CGColor; [self.clipView setHaveSetClearColor:NO];
    if(!IShotGlobal_1001ddfb8 && !IShotGlobal_1001de180) self.window.contentView=self.clipView;
    else dispatch_async(dispatch_get_main_queue(),^{ self.window.contentView=self.clipView; });
    [self.window setFrame:screen.frame display:YES animate:NO]; IShotGlobal_1001dde90=NO; IShotGlobal_1001de0d4=NO;
    [self.clipView CaptureFullScreen]; [self.clipView showClipViewWithFrame:NSMakeRect(0,0,screen.frame.size.width,screen.frame.size.height) withToolbar:nil];
    self.lastWindowRect=NSMakeRect(0,0,screen.frame.size.width,screen.frame.size.height);
    self.eventMonitor=[NSEvent addLocalMonitorForEventsMatchingMask:0x2058147e handler:^NSEvent *(NSEvent *event) { return IShotClipLocal(self,event); }];
    self.eventMonitorGlobal=[NSEvent addGlobalMonitorForEventsMatchingMask:0x40107e handler:^(NSEvent *event) { IShotClipGlobal(self,event); }];
}
- (void)endCapture { // 0x100017a00
    [NSCursor unhide]; [self.window resetCursorRects]; IShotGlobal_1001de048=0;
    IShotGlobal_1001dde94=NO; IShotGlobal_1001dde90=NO; IShotGlobal_1001dded8=NO; IShotGlobal_1001dded9=NO; IShotGlobal_1001dde91=NO; IShotGlobal_1001de0d4=NO;
    IShotGlobal_1001ddf28=nil; [IShotGlobal_1001dde30 removeAllObjects]; [IShotGlobal_1001dde28 removeAllObjects]; [IShotGlobal_1001ddff8 removeAllObjects];
    IShotGlobal_1001ddf10=nil; IShotGlobal_1001ddf40=nil; IShotGlobal_1001dde48=nil; IShotGlobal_1001ddf20=nil;
    if(@available(macOS 16.0,*)) self.window.level=-1;
    if(NSColorPanel.sharedColorPanel.visible) [NSColorPanel.sharedColorPanel close];
    if(self.window.visible) { [self.window orderOut:nil]; [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"closeClipToolbarWindow" object:nil userInfo:nil]; }
    [NSEvent removeMonitor:self.eventMonitor]; [NSEvent removeMonitor:self.eventMonitorGlobal]; self.eventMonitorGlobal=nil; self.eventMonitor=nil; self.clipView=nil;
    for(id controller in IShotGlobal_1001ddcd0) [[controller window] setBackgroundColor:NSColor.clearColor];
}
- (void)clipViewMouseDown:(NSEvent *)event { // 0x100017ddc
    if(![self.clipView haveSetClearColor]) { self.clipView.layer.backgroundColor=NSColor.clearColor.CGColor; [self.clipView setHaveSetClearColor:YES]; }
    NSPoint mouse=NSEvent.mouseLocation; pid_t pid=-1;
    for(NSDictionary *item in IShotGlobal_1001de148) {
        CGRect bounds; CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)item[(id)kCGWindowBounds],&bounds);
        NSRect rect=[SnipUtil cgWindowRectToScreenRect:bounds]; int32_t layer=0; CFNumberGetValue((__bridge CFNumberRef)item[(id)kCGWindowLayer],3,&layer);
        if(NSPointInRect(mouse,rect) && layer<1001) {
            NSScreen *screen=NSScreen.currentScreenForMouseLocation;
            if(![self.screen isEqual:screen]) [[MXClipScreenManager sharedInstance] changeKeyWindowWithScreen:screen]; else if(!self.window.keyWindow) [self.window makeKeyAndOrderFront:nil];
            IShotGlobal_1001ddd08=item[@"kCGWindowName"]; rect=[self.window convertRectFromScreen:rect]; self.lastWindowRect=rect;
            self.currentWindowNumber=[item[@"kCGWindowNumber"] integerValue]; IShotGlobal_1001ddd10=(int32_t)self.currentWindowNumber; IShotGlobal_1001ddd38=layer;
            IShotGlobal_1001ddd18=rect.origin.x; IShotGlobal_1001ddd20=rect.origin.y; IShotGlobal_1001ddd28=rect.size.width; IShotGlobal_1001ddd30=rect.size.height;
            pid=[item[@"kCGWindowOwnerPID"] intValue]; IShotGlobal_1001ddd40=[NSRunningApplication runningApplicationWithProcessIdentifier:pid].bundleIdentifier;
            if([IShotGlobal_1001ddd08 hasPrefix:@"Desktop Picture - "] && IShotGlobal_1001ddd38<0) { IShotGlobal_1001ddd18=0; IShotGlobal_1001ddd20=0; }
            break;
        }
    }
    IShotGlobal_1001ddd48=[NSRunningApplication runningApplicationWithProcessIdentifier:pid].bundleIdentifier;
    if(self.currentWindowNumber!=self.lastWindowNumber) {
        self.lastWindowNumber=self.currentWindowNumber;
        if([self.clipView clipState]==0) [self.clipView setFrameForContentView:self.lastWindowRect]; else [self.clipView setContentFrame:NSInsetRect(self.lastWindowRect,-6,-6)];
    }
}
- (void)clipViewMouseMoved:(NSEvent *)event { // 0x1000183dc
    NSPoint mouse=NSEvent.mouseLocation; pid_t pid=-1;
    for(NSDictionary *item in IShotGlobal_1001de148) {
        if(!item[(id)kCGWindowBounds]) continue;
        CGRect bounds; CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)item[(id)kCGWindowBounds],&bounds);
        NSRect rect=[SnipUtil cgWindowRectToScreenRect:bounds]; int32_t layer=0; CFNumberGetValue((__bridge CFNumberRef)item[(id)kCGWindowLayer],3,&layer);
        if(CGRectContainsPoint(rect,mouse)) {
            NSScreen *screen=NSScreen.currentScreenForMouseLocation;
            if(![self.screen isEqual:screen]) [[MXClipScreenManager sharedInstance] changeKeyWindowWithScreen:screen]; else if(!self.window.keyWindow) [self.window makeKeyAndOrderFront:nil];
            NSRect local=[self.window convertRectFromScreen:rect]; self.lastWindowRect=local; self.currentWindowNumber=[item[@"kCGWindowNumber"] integerValue];
            IShotGlobal_1001ddd10=(int32_t)self.currentWindowNumber; IShotGlobal_1001ddd18=local.origin.x; IShotGlobal_1001ddd20=local.origin.y; IShotGlobal_1001ddd28=local.size.width; IShotGlobal_1001ddd30=local.size.height;
            pid=[item[@"kCGWindowOwnerPID"] intValue]; IShotGlobal_1001ddd08=item[@"kCGWindowName"]; IShotGlobal_1001ddd38=layer;
        }
        if(layer>=0 && [SnipUtil isPoint:mouse inRect:rect] && layer<1001) {
            NSScreen *screen=NSScreen.currentScreenForMouseLocation;
            if(![self.screen isEqual:screen]) [[MXClipScreenManager sharedInstance] changeKeyWindowWithScreen:screen]; else if(!self.window.keyWindow) [self.window makeKeyAndOrderFront:nil];
            IShotGlobal_1001ddd08=item[@"kCGWindowName"]; NSRect local=[self.window convertRectFromScreen:rect]; self.lastWindowRect=local; self.currentWindowNumber=[item[@"kCGWindowNumber"] integerValue];
            IShotGlobal_1001ddd10=(int32_t)self.currentWindowNumber; IShotGlobal_1001ddd38=layer; IShotGlobal_1001ddd18=local.origin.x; IShotGlobal_1001ddd20=local.origin.y; IShotGlobal_1001ddd28=local.size.width; IShotGlobal_1001ddd30=local.size.height;
            pid=[item[@"kCGWindowOwnerPID"] intValue]; IShotGlobal_1001ddd40=[NSRunningApplication runningApplicationWithProcessIdentifier:pid].bundleIdentifier; break;
        }
    }
    IShotGlobal_1001ddd48=[NSRunningApplication runningApplicationWithProcessIdentifier:pid].bundleIdentifier;
    if(self.currentWindowNumber!=self.lastWindowNumber) { self.lastWindowNumber=self.currentWindowNumber; [self.clipView setContentFrame:NSInsetRect(NSMakeRect(IShotGlobal_1001ddd18,IShotGlobal_1001ddd20,IShotGlobal_1001ddd28,IShotGlobal_1001ddd30),-6,-6)]; [self.clipView selectedWindowChanged]; }
}
- (void)startScreenShots { [self clipScreen]; } // 0x100018b3c direct tail call
- (void)clipViewClipCurrentWindow:(id)sender {} // 0x100018b40 RET-only
- (void)clipViewClipFullScreen:(id)sender {} // 0x100018b44 RET-only
- (void)clipViewMouseDoubleClick:(id)sender {} // 0x100018b48 RET-only
- (void)clipViewCancleSelected:(id)sender { [self cancel]; } // 0x100018b4c direct tail call
- (void)clipScreen { // 0x100018b50
    if(!NSEqualRects(self.window.screen.frame,IShotGlobal_1001dde80.frame)) return;
    [[self.clipView tipView] removeFromSuperview]; [(NSView *)[self.clipView cropBorderView] removeFromSuperview]; [[self.clipView sliderOfRadiusOfFrame] removeFromSuperview]; [[self.clipView indicatorField] removeFromSuperview];
    [[self.clipView shapeLayer1] removeFromSuperlayer]; [[self.clipView shapeLayer2] removeFromSuperlayer]; [[self.clipView shapeLayer3] removeFromSuperlayer]; [[self.clipView scrollViewOfColorPicker] removeFromSuperview]; self.clipView.window.level=0;
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    dispatch_async(dispatch_get_global_queue(0,0),^{ IShotClipCapture_100018ef8(self,defaults); });
    if([defaults boolForKey:@"playSoundWhenScreenShots"] && ((!IShotGlobal_1001de0d5 && !IShotGlobal_1001ddd50) || IShotGlobal_1001de0d6 || IShotGlobal_1001ddec0)) IShotFunction_100047ffc(@"TelliShotHelperToPlayScreenShotAudio");
}
- (void)refreshMosaic { [self.clipView updateTrackingAreas]; self.clipView.needsDisplay=YES; } // 0x10001c828
- (void)refreshHighlight { [(NSView *)[self.clipView cropBorderView] updateTrackingAreas]; [(NSView *)[self.clipView cropBorderView] setNeedsDisplay:YES]; } // 0x10001c880
- (void)scrollScreenShot { [self.clipView scrollScreenShot]; } // 0x10001c910
- (void)disableTextView { [self.clipView disableTextView]; } // 0x10001c940
- (void)saveAsFile:(NSImage *)image { // 0x10001bf10 / 0x10001bfc4 / 0x10001c228
    dispatch_after(dispatch_time(0,10000000),dispatch_get_main_queue(),^{
        IShotGlobal_1001de168=YES;
        NSString *front=NSWorkspace.sharedWorkspace.frontmostApplication.bundleIdentifier;
        NSString *format=[NSUserDefaults.standardUserDefaults stringForKey:@"formatOfSavePhoto"];
        NSString *title=[NSBundle.mainBundle localizedStringForKey:@"Untitled" value:@"" table:nil];
        NSSavePanel *panel=NSSavePanel.savePanel; panel.contentView.window.level=1; panel.nameFieldStringValue=[NSString stringWithFormat:@"%@.%@",title,format];
        panel.allowsOtherFileTypes=YES; panel.extensionHidden=YES; panel.canCreateDirectories=YES;
        [panel beginWithCompletionHandler:^(NSModalResponse result) {
            if(result==1) {
                NSString *path=panel.URL.path,*extension=path.pathExtension;
                NSUInteger type=[extension isEqualToString:@"jpg"] ? 3 : [extension isEqualToString:@"tiff"] ? 0 : [extension isEqualToString:@"png"] ? 4 : [extension isEqualToString:@"webp"] ? 100000 : [extension isEqualToString:@"heic"] ? 100001 : 100002;
                [NSImage saveImage:image toFile:path withType:type];
            }
            IShotGlobal_1001de168=NO; [Global activateAppWithIdentifier:front];
        }];
    });
}
- (void)saveToFileOnlyForWhenPin:(NSImage *)image { // 0x10001c360 / 0x10001c810
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSString *format=[defaults stringForKey:@"formatOfSavePhoto"]; if(!format) format=@"jpg";
    NSDate *date=NSDate.date; NSDateFormatter *formatter=[[NSDateFormatter alloc] init]; formatter.dateFormat=@"yyyy-MM-dd_HH.mm.ss";
    NSString *name=[[[NSBundle.mainBundle localizedStringForKey:@"iShot" value:@"" table:nil] stringByAppendingString:@"_"] stringByAppendingString:[formatter stringFromDate:date]];
    NSString *path=[defaults stringForKey:@"pathofSaveScreenShotsPhoto"];
    if([path isEqualToString:@"NotSpecified"]) { [[AppDelegate alloc] saveImageOfNotSpecified:image]; return; }
    if(![NSFileManager.defaultManager fileExistsAtPath:path]) {
        path=[[AppDelegate appDelegate] getSavePathWithOpenPanel]; if([path isEqualToString:@""]) { [self cancel]; return; }
        [defaults setObject:path forKey:@"pathofSaveScreenShotsPhoto"]; [defaults synchronize];
    }
    NSUInteger type; NSString *extension;
    if([format isEqualToString:@"jpg"]) { type=3; extension=@"jpg"; }
    else if([format isEqualToString:@"png"]) { type=4; extension=@"png"; }
    else if([format isEqualToString:@"tiff"]) { type=0; extension=@"tiff"; }
    else if([format isEqualToString:@"webp"]) { type=100000; extension=@"webp"; }
    else if([format isEqualToString:@"heic"]) { type=100001; extension=@"heic"; }
    else { type=100002; extension=@"pdf"; }
    NSString *destination=[NSString stringWithFormat:@"%@/%@.%@",path,name,extension];
    [[AppSandboxFileAccess fileAccessWithMessage:@""] accessFilePath:path persistPermission:YES withBlock:^{ [NSImage saveImage:image toFile:destination withType:type]; }];
}
@end

#include "MXClipWindowController-events.inc"
#include "MXClipWindowController-preflight.inc"
#include "MXClipWindowController-render.inc"
