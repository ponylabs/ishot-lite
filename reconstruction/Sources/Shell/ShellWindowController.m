#import "ShellControllers.h"
#import "../Common/Utility.h"
#import "../MainApplication/AppDelegate.h"
#include <math.h>
static NSDictionary *IShotGlobal_1001de008;
static NSString *IShotGlobal_1001de010;
static NSImage *IShotGlobal_1001de018;
static int32_t IShotGlobal_1001de020;
static NSRect IShotGlobal_1001de028;
extern BOOL IShotGlobal_1001dd139;
extern CGImageRef IShotCGWindowListCreateImage(CGRect,CGWindowListOption,CGWindowID,CGWindowImageOption) __asm__("_CGWindowListCreateImage");
@implementation ShellWindowController
@synthesize imageView=_imageView;
- (instancetype)initWithData:(id)data { // 0x100060094
    self=[super init];
    if (self) {
        IShotGlobal_1001de008=data;
        [NSBundle.mainBundle loadNibNamed:@"ShellWindow" owner:self topLevelObjects:NULL];
        self.window.level=101; self.window.movableByWindowBackground=YES;
        self.window.backgroundColor=NSColor.clearColor; self.window.ignoresMouseEvents=NO;
        self.window.styleMask&=~(NSUInteger)8;
        self.imageView=[[NSImageView alloc] init]; self.imageView.autoresizingMask=0x12;
        [self.window.contentView addSubview:self.imageView]; [self refreshData];
    }
    return self;
}
- (void)sentShellData:(id)data { IShotGlobal_1001de008=data; [self refreshData]; } // 0x1000602d8
- (void)refreshData { // 0x100060308
    NSString *name=IShotGlobal_1001de008[@"Name"];
    IShotGlobal_1001de010=[Utility digestString:name];
    IShotGlobal_1001de018=[NSImage imageNamed:[name stringByAppendingString:@"Shell"]];
    NSDictionary *saved=[NSUserDefaults.standardUserDefaults objectForKey:@"dataDicOfPinShell"][IShotGlobal_1001de010];
    if (saved[@"Scale"]) IShotGlobal_1001de020=[saved[@"Scale"] intValue];
    if (IShotGlobal_1001de020<30) IShotGlobal_1001de020=[IShotGlobal_1001de008[@"OriginalScale"] intValue];
    IShotGlobal_1001de028=NSRectFromString(IShotGlobal_1001de008[@"OutsideRect"]);
    NSRect frame=self.window.frame;
    double scale=IShotGlobal_1001de020,width=IShotGlobal_1001de028.size.width,height=IShotGlobal_1001de028.size.height;
    [self.window setFrame:NSMakeRect((float)((frame.origin.x+frame.size.width*.5)-(width*.5*scale)/100.0),(float)((frame.origin.y+frame.size.height*.5)-(height*.5*scale)/100.0),width*scale/100.0,height*scale/100.0) display:NO];
    [NSUserDefaults.standardUserDefaults setObject:@(IShotGlobal_1001de020) forKey:@"scaleOfPinShell"];
    self.imageView.frame=NSMakeRect(0,0,self.window.frame.size.width,self.window.frame.size.height);
    self.imageView.image=IShotGlobal_1001de018;
}
- (void)screenshotbuttonClick:(id)sender { // 0x1000606d0; FP geometry verified against REA assembly
    NSRect frame=self.window.frame;
    NSString *name=IShotGlobal_1001de008[@"Name"];
    double offset=([IShotGlobal_1001de008[@"Offset"] floatValue]*(float)IShotGlobal_1001de020)/100.f;
    NSRect inset=NSInsetRect(frame,offset,offset);
    CGRect capture=CGRectMake(inset.origin.x,(NSScreen.deepestScreen.frame.size.height-inset.origin.y)-inset.size.height,inset.size.width,inset.size.height);
    CGImageRef cg=IShotCGWindowListCreateImage(capture,4,(CGWindowID)self.window.windowNumber,0);
    NSImage *image=[[NSImage alloc] initWithCGImage:cg size:inset.size];
    if (cg) CGImageRelease(cg);
    NSImage *clipped=[[NSImage alloc] initWithSize:inset.size];
    [clipped lockFocus];
    int radius=[IShotGlobal_1001de008[@"Radius"] intValue];
    NSBezierPath *path=[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0,0,clipped.size.width,clipped.size.height) xRadius:radius yRadius:radius];
    [NSGraphicsContext saveGraphicsState]; [path addClip];
    [image drawInRect:NSMakeRect(0,0,inset.size.width,inset.size.height)];
    [clipped unlockFocus]; // The original has no matching restore here.
    NSImage *shell=[NSImage imageNamed:[name stringByAppendingString:@"Shell"]];
    NSImage *result=[[NSImage alloc] initWithSize:frame.size];
    [result lockFocus]; [NSGraphicsContext saveGraphicsState];
    [clipped drawInRect:NSMakeRect(offset,offset,inset.size.width,inset.size.height)];
    [shell drawInRect:NSMakeRect(0,0,frame.size.width,frame.size.height)];
    [NSGraphicsContext restoreGraphicsState]; [result unlockFocus];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,100000000),dispatch_get_main_queue(), ^{ [self.window close]; }); // 0x100060cac
    [[AppDelegate appDelegate] saveScreenWithShell:result];
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSMutableDictionary *data=[NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"dataDicOfPinShell"]];
    NSMutableDictionary *item=[NSMutableDictionary dictionaryWithDictionary:data[IShotGlobal_1001de010]];
    item[@"Scale"]=@(IShotGlobal_1001de020); data[IShotGlobal_1001de010]=item;
    [defaults setObject:data forKey:@"dataDicOfPinShell"]; [NSUserDefaults.standardUserDefaults synchronize];
}
- (void)helpButtonCLick:(id)sender { [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot/screenshotwithshell.html"]]; } // 0x100060ce0
- (void)magnifyWithEvent:(NSEvent *)event { // 0x100060d48
    float magnitude=(float)event.magnification;
    if (magnitude==0) return;
    int sign=magnitude>0?1:-1;
    magnitude=fabsf(magnitude*500.f);
    int step=magnitude<6?1:(magnitude<10?2:(magnitude<30?3:4));
    IShotGlobal_1001de020+=sign*step; [self resize:IShotGlobal_1001de020];
}
- (void)scrollWheel:(NSEvent *)event { // 0x100060df4
    int raw=(int)CGEventGetDoubleValueField(event.CGEvent,96);
    float delta=(float)event.deltaY;
    if (delta==0) return;
    int sign=delta>0?1:-1;
    uint32_t magnitude=raw<0?0u-(uint32_t)raw:(uint32_t)raw;
    int step=magnitude<=5?1:(magnitude<10?2:(magnitude<=29?5:(magnitude<80?10:30)));
    IShotGlobal_1001de020+=sign*step; [self resize:IShotGlobal_1001de020];
}
- (void)mouseDown:(NSEvent *)event { if (event.clickCount==2) [self.window close]; } // 0x100060edc
- (void)keyDown:(NSEvent *)event { if (event.keyCode==53) [self.window close]; } // 0x100060f30
- (void)resize:(int)value { // 0x100060f84; argument unused in original
    CGEventRef event=CGEventCreate(NULL); CGPoint point=CGEventGetLocation(event); if (event) CFRelease(event);
    double y=NSScreen.deepestScreen.frame.size.height-point.y;
    if (IShotGlobal_1001de020>100) IShotGlobal_1001de020=100;
    else if (IShotGlobal_1001de020<30) IShotGlobal_1001de020=30;
    int width=(int)(IShotGlobal_1001de028.size.width*IShotGlobal_1001de020/100.0);
    int height=(int)(IShotGlobal_1001de028.size.height*IShotGlobal_1001de020/100.0);
    NSRect frame=self.window.frame;
    double oldScale=(int)((frame.size.width/IShotGlobal_1001de028.size.width)*100.0+.5);
    int x=(int)point.x-(int)(((point.x-frame.origin.x)/oldScale)*IShotGlobal_1001de020);
    int newY=(int)y-(int)(((y-frame.origin.y)/oldScale)*IShotGlobal_1001de020);
    [self.window setFrame:NSMakeRect(x,newY,width,height) display:NO];
    [NSUserDefaults.standardUserDefaults setObject:@(IShotGlobal_1001de020) forKey:@"scaleOfPinShell"];
}
@end
