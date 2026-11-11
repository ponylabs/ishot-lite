extern BOOL IShotGlobal_1001de0d0;
static void IShotClipRender_10001984c(MXClipWindowController *,NSUserDefaults *);
// Lite: preserve capture scheduling and geometry without receipt revalidation.
static void IShotClipCapture_100018ef8(MXClipWindowController *controller,NSUserDefaults *defaults) {
    if(!IShotGlobal_1001de0c0) dispatch_after(dispatch_time(0,100000000),dispatch_get_main_queue(),^{ IShotGlobal_1001de0d0=NO; });
    IShotClip_1001f18b4=[controller.clipView onlyClipCurrentWindow];
    dispatch_async(dispatch_get_main_queue(),^{ IShotClipRender_10001984c(controller,defaults); });
}
