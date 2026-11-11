- (void)changFullImageToMosaicImage { // 0x100026fd8; blocks 0x1000275a4, 0x100027858
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    double shadow=0;
    if ([defaults boolForKey:@"needShadowOfnotSingleWindow"]) shadow=[[defaults stringForKey:@"sizeOfShadow"] intValue];
    if (IShotGlobal_1001de138.count==0 && !IShotGlobal_1001ddd50 && self.onlyClipCurrentWindow) {
        for (NSDictionary *window in IShotGlobal_1001de148) {
            unsigned int windowID=[window[@"kCGWindowNumber"] intValue]; NSString *name=window[@"kCGWindowName"];
            if (windowID==IShotGlobal_1001ddd10) {
                NSImage *image=window[@"KCGWindowImage"];
                if (!image) {
                    NSString *windowName=window[@"kCGWindowName"]; int layer=[window[@"kCGWindowLayer"] intValue];
                    if ([windowName isEqualToString:@"Menubar"] && layer==24) {
                        NSDictionary *bounds=window[@"kCGWindowBounds"]; int width=[bounds[@"Width"] intValue],height=[bounds[@"Height"] intValue];
                        float scale=(float)self.window.screen.backingScaleFactor;
                        CGImageRef full=[self.fullImage CGImageForProposedRect:NULL context:nil hints:nil];
                        if (full) {
                            CGImageRef cropped=CGImageCreateWithImageInRect(full,CGRectMake(0,0,(double)((float)width*scale),(double)((float)height*scale)));
                            image=[[NSImage alloc] initWithCGImage:cropped size:CGSizeMake(width,height)]; if (cropped) CFRelease(cropped);
                        }
                    } else image=[Global screenShotFromWindowID:windowID];
                }
                if (image) [IShotGlobal_1001de138 addObject:@{@"windowId":@(IShotGlobal_1001ddd10),@"rect":[NSValue valueWithCGRect:NSInsetRect(self.contentRect,shadow,shadow)],@"screen":self.window.screen,@"KCGWindowImage":image,@"kCGWindowName":name}];
                break;
            }
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,20000000),dispatch_get_main_queue(),^{
        NSScreen *screen=IShotGlobal_1001dde80; if (!screen) screen=[NSScreen currentScreenForMouseLocation];
        double scale=screen.backingScaleFactor;
        if (IShotGlobal_1001de138.count) {
            // Original performs these frame reads before constructing the screen-sized bitmap.
            (void)NSScreen.deepestScreen.frame; (void)screen.frame; (void)screen.frame; (void)screen.frame;
            double width=screen.frame.size.width,height=screen.frame.size.height;
            NSImage *image=[[NSImage alloc] initWithSize:CGSizeMake(width,height)];
            [image lockFocus]; [NSGraphicsContext saveGraphicsState]; [NSColor.whiteColor set]; NSRectFill(CGRectMake(0,0,width,height));
            for (NSInteger i=(NSInteger)IShotGlobal_1001de138.count-1;i>=0;i--) {
                NSDictionary *window=IShotGlobal_1001de138[i]; CGRect rect=[window[@"rect"] rectValue];
                [(NSImage *)window[@"KCGWindowImage"] drawInRect:rect];
            }
            [NSGraphicsContext restoreGraphicsState]; [image unlockFocus]; self.fullImage=image;
        }
        float inverse=(float)(1.0/scale);
        dispatch_async(dispatch_get_global_queue(0,0),^{
            NSImage *image=[NSImage resizeImage:self.fullImage value:inverse*.5f];
            IShotGlobal_1001dde88=[NSMutableArray new];
            for (NSUInteger level=1;level!=11;level++) {
                CGImageRef mosaic=[MJMosaicUtil createMosaicImageFromCGImage:image blockLevel:level];
                if (mosaic) [IShotGlobal_1001dde88 addObject:(__bridge id)mosaic];
            }
            double radius=1;
            for (int i=0;i<10;i++) {
                CGImageRef blurred=[MJMosaicUtil blurSourceImage:image Radius:radius*1.5-1.5];
                if (blurred) [IShotGlobal_1001dde88 addObject:(__bridge id)blurred]; radius+=1;
            }
        });
    });
}
