- (void)flagsChanged:(NSEvent *)event { // 0x10002e578
    NSUInteger flags=event.modifierFlags;
    if (IShotGlobal_1001de138.count==0 && IShotGlobal_1001dde68==1 && !(flags&NSEventModifierFlagShift)) {
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"cancelScreenShot" object:nil userInfo:nil]; return;
    }
    if (IShotGlobal_1001de138.count!=0 && IShotGlobal_1001dde68==1 && !(flags&NSEventModifierFlagShift)) {
        if (IShotGlobal_1001de140.count) [IShotGlobal_1001de140 removeAllObjects];
        if (IShotGlobal_1001de148.count) [IShotGlobal_1001de148 removeAllObjects];
        IShotGlobal_1001dde68=2; self.cropBorderView.onlyClipCurrentWindow=YES; self.multiWindowScreenshots=YES; self.dragMode=0;
        double shadow=[[NSUserDefaults.standardUserDefaults stringForKey:@"sizeOfShadow"] intValue];
        int minX=10000,minY=10000,maxX=-10000,maxY=-10000;
        for (NSDictionary *window in IShotGlobal_1001de138) {
            CGRect rect=[window[@"rect"] rectValue];
            int left=(int)(rect.origin.x-shadow),bottom=(int)(rect.origin.y-shadow);
            int right=(int)(rect.origin.x+rect.size.width+shadow),top=(int)(rect.origin.y+rect.size.height+shadow);
            if (left<=minX) minX=left; if (bottom<=minY) minY=bottom;
            if (right>maxX) maxX=right; if (top>maxY) maxY=top;
        }
        CGRect frame=NSInsetRect(CGRectMake(minX,minY,(int)((uint32_t)maxX-(uint32_t)minX),(int)((uint32_t)maxY-(uint32_t)minY)),-6,-6);
        CGRect previous=NSInsetRect(frame,shadow,shadow);
        IShotGlobal_1001ddea0=previous.origin.x; IShotGlobal_1001ddea8=previous.origin.y;
        IShotGlobal_1001ddeb0=previous.size.width; IShotGlobal_1001ddeb8=previous.size.height;
        self.cropBorderView.frame=frame; self.contentFrame=frame; [self reFreshShapeLayer1]; [self addSubview:self.cropBorderView];
        IShotGlobal_1001de090=@""; [IShotGlobal_1001de160 setAnnotatedImageViewFrame:self.contentRect]; [IShotGlobal_1001de160 openWindow];
        self.cropBorderView.needsDisplay=YES; self.clipState=3; [self changFullImageToMosaicImage]; [self _resetIndicatorField];
        self.window.backgroundColor=NSColor.clearColor;
        if (NSScreen.screens.count>1) [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"startAnnotation" object:nil userInfo:nil];
        [self.window makeKeyAndOrderFront:nil];
        if ([NSUserDefaults.standardUserDefaults boolForKey:@"DoNotRemindAboutScrollScreenshot"]) IShotGlobal_1001de160.scrollScreenshotButton.enabled=NO;
    }
}
