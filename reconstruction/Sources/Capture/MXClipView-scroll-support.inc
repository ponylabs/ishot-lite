extern CGImageRef IShotCGWindowListCreateImage(CGRect, CGWindowListOption, CGWindowID, CGWindowImageOption) __asm__("_CGWindowListCreateImage");
// Retained zero-fill locations, shared by the original MXClipView methods.
BOOL IShotGlobal_1001f18c0,IShotGlobal_1001f18c1,IShotGlobal_1001f18c2,IShotGlobal_1001f18c3,IShotGlobal_1001f18c4,IShotGlobal_1001f18c5,IShotGlobal_1001f18c6,IShotGlobal_1001f18c7;
int32_t IShotGlobal_1001f18c8;
extern BOOL IShotGlobal_1001dddf0,IShotGlobal_1001de088,IShotGlobal_1001de0c0,IShotGlobal_1001dde24,IShotGlobal_1001ddf58,IShotGlobal_1001ddf60;
extern NSCursor *IShotGlobal_1001dddf8;
extern double IShotGlobal_1001dde00,IShotGlobal_1001dde08,IShotGlobal_1001dde10,IShotGlobal_1001dde18,IShotGlobal_1001ddee8,IShotGlobal_1001ddef0,IShotGlobal_1001ddef8,IShotGlobal_1001ddf00;
extern float IShotGlobal_1001dde20,IShotGlobal_1001ddf48;
extern uint32_t IShotGlobal_1001ddd10;
extern int32_t IShotGlobal_1001dde58,IShotGlobal_1001dde5c,IShotGlobal_1001dde60,IShotGlobal_1001dde64,IShotGlobal_1001ddf08,IShotGlobal_1001ddf0c,IShotGlobal_1001ddf30,IShotGlobal_1001ddf34,IShotGlobal_1001ddf38,IShotGlobal_1001ddf3c,IShotGlobal_1001ddf4c,IShotGlobal_1001ddf5c;
extern NSMutableArray *IShotGlobal_1001dde28,*IShotGlobal_1001dde30;
extern NSArray *IShotGlobal_1001dde48,*IShotGlobal_1001dde50,*IShotGlobal_1001ddf20,*IShotGlobal_1001ddf28;
extern NSImageView *IShotGlobal_1001dde38,*IShotGlobal_1001ddf40;
extern NSView *IShotGlobal_1001dde40;
extern NSImage *IShotGlobal_1001ddf10,*IShotGlobal_1001ddf18,*IShotGlobal_1001ddf50;
extern NSTimer *IShotGlobal_1001ddee0;
extern NSString *IShotGlobal_1001ddd48;
extern NSSize IShotFunction_1000483f0(NSString *,int);
// 0x10002540c
static void IShotScrollWindowNotice(void) {
    NSAlert *alert=[[NSAlert alloc] init]; alert.messageText=@"";
    alert.informativeText=[NSBundle.mainBundle localizedStringForKey:@"Window screenshot cannot use the scrolling screenshot function. Please click on the \"Precautions for Scroll Screenshot\" button." value:@"" table:nil];
    [alert addButtonWithTitle:[NSBundle.mainBundle localizedStringForKey:@"Precautions for Scroll Screenshot" value:@"" table:nil]];
    [alert addButtonWithTitle:[NSBundle.mainBundle localizedStringForKey:@"OK" value:@"" table:nil]];
    alert.showsSuppressionButton=YES; [NSApp activateIgnoringOtherApps:YES];
    if([alert runModal]==1000) [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.better365.cn/ishot_scrollscreenshot.html"]];
    if(alert.suppressionButton.state==1) { [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"DoNotRemindAboutScrollScreenshot"]; [NSUserDefaults.standardUserDefaults synchronize]; }
}
// 0x100025660 / 0x100025778. This is called only by the original scroll action.
static void IShotAutoScrollLoop(void) {
    while(IShotGlobal_1001de088) {
        if(IShotGlobal_1001dddf0) {
            float delta=-5;
            if(IShotGlobal_1001f18c8<20) { delta=-1; IShotGlobal_1001f18c8+=2; } else IShotGlobal_1001f18c8=21;
            dispatch_async(dispatch_get_global_queue(0,0),^{ CGEventRef event=CGEventCreateScrollWheelEvent(NULL,0,1,(int)delta); CGEventPost(0,event); if(event) CFRelease(event); });
        }
        [NSThread sleepForTimeInterval:0.016];
    }
    IShotGlobal_1001dddf0=NO;
}
