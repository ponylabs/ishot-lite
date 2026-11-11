- (void)startAutoScroll:(id)sender { // 0x10002491c
    if(!AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)@{(__bridge id)kAXTrustedCheckOptionPrompt:@NO})) {
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"cancelScreenShot" object:nil userInfo:nil]; [Global popupRequestPrivacyAccessibilityWithQuit:NO];
    } else {
        IShotGlobal_1001f18c0=YES;
        self.autoScrollScreenShotButton.title=[NSBundle.mainBundle localizedStringForKey:@"StopScroll" value:@"" table:nil];
        NSMutableAttributedString *title=[[NSMutableAttributedString alloc] initWithAttributedString:self.autoScrollScreenShotButton.attributedTitle];
        [title addAttribute:NSForegroundColorAttributeName value:NSColor.whiteColor range:NSMakeRange(0,title.length)]; self.autoScrollScreenShotButton.attributedTitle=title;
        IShotGlobal_1001dddf0=YES; self.window.ignoresMouseEvents=YES;
    }
}
- (void)scrollWheel:(NSEvent *)event { // 0x1000347d4
    NSScreen *screen=NSScreen.currentScreenForMouseLocation;
    if(IShotGlobal_1001de0c0 && NSEqualRects(self.window.screen.frame,screen.frame)) {
        float delta=(float)event.deltaY;
        if(self.autoScrollScreenShotButton.enabled && !(IShotGlobal_1001dddf0&1) && fabsf(delta)!=0.5f) { self.autoScrollScreenShotButton.enabled=NO; [self.autoScrollScreenShotButton removeFromSuperview]; }
        IShotGlobal_1001dde20+=delta;
        if(delta<0) {
            [self screenShotsAtScrollScreenshots];
            if(IShotGlobal_1001ddee0) { [IShotGlobal_1001ddee0 invalidate]; IShotGlobal_1001ddee0=nil; }
            IShotGlobal_1001ddee0=[NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(scrollFinished) userInfo:nil repeats:NO];
        }
    }
    [IShotGlobal_1001de160 handleMouseEvent:event];
}
- (void)redrawScrollView { // 0x1000365dc / 0x100036854
    int scale=(int)[(NSScreen *)NSScreen.currentScreenForMouseLocation backingScaleFactor];
    float width=(float)IShotGlobal_1001dde10, height=(float)(IShotGlobal_1001ddf10.size.height/(double)scale),total=height;
    for(NSInteger i=(NSInteger)IShotGlobal_1001dde28.count-1;i>=0;i--) total+=[IShotGlobal_1001dde28[i] floatValue]/(float)scale;
    float footer=0;
    if(IShotGlobal_1001ddf40) { footer=(float)(IShotGlobal_1001ddf40.image.size.height/(double)scale); total+=footer; }
    IShotGlobal_1001dde38.frame=NSMakeRect(0,(total-height)-footer,width,height);
    if(footer>0) IShotGlobal_1001ddf40.frame=NSMakeRect(0,total-footer,width,footer);
    IShotGlobal_1001dde40.frame=NSMakeRect(0,0,width,total);
    double y=0;
    for(NSUInteger i=0;i<IShotGlobal_1001dde30.count;i++) {
        NSView *view=IShotGlobal_1001dde30[i];
        view.frame=NSMakeRect(0,i==0?0:y,width,i==0?IShotGlobal_1001dde18-(scale ? IShotGlobal_1001ddf0c/scale:0):height);
        y+=scale ? [IShotGlobal_1001dde28[i] intValue]/scale:0;
    }
    dispatch_async(dispatch_get_main_queue(),^{
        [IShotGlobal_1001dde30 removeAllObjects]; [IShotGlobal_1001dde28 removeAllObjects]; IShotGlobal_1001dde38=nil; IShotGlobal_1001ddf40=nil; IShotGlobal_1001dde40=nil; IShotGlobal_1001dde50=nil;
    });
}
- (void)scrollScreenShot { // 0x100024bac
    if(self.onlyClipCurrentWindow) {
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"cancelScreenShot" object:nil userInfo:nil];
        dispatch_after(dispatch_time(0,100000000),dispatch_get_main_queue(),^{ IShotScrollWindowNotice(); });
        return;
    }
    NSScreen *screen=NSScreen.currentScreenForMouseLocation;
    if(!NSEqualRects(self.window.screen.frame,screen.frame)) return;
    self.window.ignoresMouseEvents=YES; self.window.backgroundColor=NSColor.clearColor;
    [(NSView *)self.cropBorderView setNeedsDisplay:YES]; self.needsDisplay=YES;
    IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set];
    if(self.onlyClipCurrentWindow) {
        NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
        int shadow=[defaults boolForKey:@"needShadowOfnotSingleWindow"] ? [[defaults stringForKey:@"sizeOfShadow"] intValue] : 0;
        self.contentRect=NSInsetRect(self.contentRect,shadow,shadow); [self _resetIndicatorField]; [self reFreshShapeLayer1];
    }
    IShotGlobal_1001dde00=(double)(float)(screen.frame.origin.x+self.contentRect.origin.x);
    IShotGlobal_1001dde08=(double)(float)(NSScreen.deepestScreen.frame.size.height-screen.frame.origin.y-self.contentRect.origin.y-self.contentRect.size.height);
    IShotGlobal_1001dde10=(double)(float)self.contentRect.size.width; IShotGlobal_1001dde18=(double)(float)self.contentRect.size.height;
    IShotGlobal_1001dde20=0;
    IShotGlobal_1001f18c1=NO; IShotGlobal_1001f18c2=NO; IShotGlobal_1001f18c3=NO; IShotGlobal_1001f18c4=NO; IShotGlobal_1001f18c5=NO; IShotGlobal_1001dde24=NO; IShotGlobal_1001f18c6=YES;
    IShotGlobal_1001dde28=[NSMutableArray new]; IShotGlobal_1001dde30=[NSMutableArray new];
    IShotGlobal_1001dde38=[[NSImageView alloc] init]; IShotGlobal_1001dde40=[[NSScrollView alloc] init];
    [IShotGlobal_1001dde40 addSubview:IShotGlobal_1001dde38]; [self addSubview:IShotGlobal_1001dde40];
    IShotGlobal_1001dde48=nil; IShotGlobal_1001f18c7=NO; IShotGlobal_1001dde50=nil;
    IShotGlobal_1001dde58=0; IShotGlobal_1001dde5c=0; IShotGlobal_1001dde60=0; IShotGlobal_1001dde64=0;
    [self screenShotsAtScrollScreenshots]; IShotGlobal_1001f18c7=YES;
    NSString *title=[NSBundle.mainBundle localizedStringForKey:@"AutoScroll" value:@"" table:nil];
    float width=(float)(IShotFunction_1000483f0(title,13).width+30);
    NSRect border=[(NSView *)self.cropBorderView frame];
    self.autoScrollScreenShotButton=[[NSButton alloc] initWithFrame:NSMakeRect(border.origin.x+border.size.width*0.5+(double)(width*-0.5f),border.origin.y+border.size.height*0.5-11,width,22)];
    self.autoScrollScreenShotButton.title=title; self.autoScrollScreenShotButton.bezelStyle=1; self.autoScrollScreenShotButton.bordered=NO; self.autoScrollScreenShotButton.wantsLayer=YES;
    self.autoScrollScreenShotButton.layer.backgroundColor=[NSColor colorWithRed:36.0/255.0 green:36.0/255.0 blue:56.0/255.0 alpha:1].CGColor;
    self.autoScrollScreenShotButton.layer.masksToBounds=YES; self.autoScrollScreenShotButton.layer.cornerRadius=6; self.autoScrollScreenShotButton.action=@selector(startAutoScroll:);
    NSMutableAttributedString *attributedTitle=[[NSMutableAttributedString alloc] initWithAttributedString:self.autoScrollScreenShotButton.attributedTitle];
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:NSColor.whiteColor range:NSMakeRange(0,attributedTitle.length)]; self.autoScrollScreenShotButton.attributedTitle=attributedTitle;
    [self addSubview:self.autoScrollScreenShotButton]; IShotGlobal_1001dddf0=NO;
    dispatch_async(dispatch_get_global_queue(0,0),^{ IShotAutoScrollLoop(); });
}
- (void)drawScrollView { // 0x100035f08; geometry verified at 0x100035f60..0x100036580
    NSScreen *screen=NSScreen.currentScreenForMouseLocation;
    int scale=(int)screen.backingScaleFactor;
    BOOL left=!((float)(self.contentRect.origin.x+self.contentRect.size.width*0.5)<(float)(screen.frame.size.width*0.5));
    IShotGlobal_1001ddf58=left; IShotGlobal_1001ddf60=NO;
    float x=0,width=0; double y=0,height=0;
    for(int divisor=1;divisor<=4;divisor*=2) {
        IShotGlobal_1001ddf5c=divisor; IShotGlobal_1001ddf60=NO;
        y=self.contentRect.origin.y; width=(float)(IShotGlobal_1001dde10/(double)divisor); height=IShotGlobal_1001ddf10.size.height/(double)divisor;
        if(left) { x=(float)(self.contentRect.origin.x-width-10); if(!(x<0)) break; }
        else { x=(float)(self.contentRect.origin.x+self.contentRect.size.width+10); if(!(screen.frame.size.width<(double)(x+width))) break; }
    }
    height/=(double)scale;
    if(left ? x<0 : screen.frame.size.width<(double)(x+width)) {
        IShotGlobal_1001ddf60=YES; IShotGlobal_1001ddf5c=4;
        width=(float)(IShotGlobal_1001dde10*0.25); height=(IShotGlobal_1001ddf10.size.height/(double)IShotGlobal_1001ddf5c)/(double)scale;
        if(!left) x=(float)(self.contentRect.origin.x+self.contentRect.size.width-width-4);
        y=self.contentRect.origin.y+10;
    }
    float base=(float)height; if(width==0 || base==0) return;
    float total=base;
    for(NSInteger i=(NSInteger)IShotGlobal_1001dde28.count-1;i>=0;i--) total+=([IShotGlobal_1001dde28[i] floatValue]/(float)IShotGlobal_1001ddf5c)/(float)scale;
    float footer=0;
    if(IShotGlobal_1001ddf40) { footer=(float)((IShotGlobal_1001ddf40.image.size.height/(double)IShotGlobal_1001ddf5c)/(double)scale); total+=footer; }
    float fit=(float)((double)total/(screen.frame.size.height-self.contentRect.origin.y-25)); if(fit<=1) fit=1;
    IShotGlobal_1001dde38.image=IShotGlobal_1001ddf10; width/=fit;
    if(IShotGlobal_1001ddf58) x=(float)(self.contentRect.origin.x-width-10);
    if(IShotGlobal_1001ddf60) x=(float)(self.contentRect.origin.x+self.contentRect.size.width-width-10);
    IShotGlobal_1001dde38.frame=NSMakeRect(0,((total-base)-footer)/fit,width,base/fit);
    if(footer>0) IShotGlobal_1001ddf40.frame=NSMakeRect(0,(total-footer)/fit,width,footer/fit);
    IShotGlobal_1001dde40.frame=NSMakeRect(x,(float)y,width,total/fit);
    double rowY=0;
    for(NSUInteger i=0;i<IShotGlobal_1001dde30.count;i++) {
        NSView *row=IShotGlobal_1001dde30[i];
        double rowHeight=i==0 ? ((IShotGlobal_1001dde18-(scale?IShotGlobal_1001ddf0c/scale:0))/(double)IShotGlobal_1001ddf5c)/(double)fit : base/fit;
        row.frame=NSMakeRect(0,rowY,width,rowHeight);
        int increment=IShotGlobal_1001ddf5c?[IShotGlobal_1001dde28[i] intValue]/IShotGlobal_1001ddf5c:0; increment=scale?increment/scale:0;
        rowY+=(double)((float)increment/fit);
    }
}
- (void)screenShotsAtScrollScreenshots { // 0x1000349f4
    int scale=(int)[(NSScreen *)NSScreen.currentScreenForMouseLocation backingScaleFactor];
    if(IShotGlobal_1001f18c2==YES && !IShotGlobal_1001dde24 && (IShotGlobal_1001f18c3&1)) {
        IShotGlobal_1001dde24=YES;
        int top=scale?IShotGlobal_1001ddf08/scale:0,bottom=scale?IShotGlobal_1001ddf0c/scale:0;
        IShotGlobal_1001ddef0=IShotGlobal_1001dde08+top; IShotGlobal_1001ddf00=(IShotGlobal_1001dde18-top)-bottom;
        IShotGlobal_1001ddee8=IShotGlobal_1001dde00; IShotGlobal_1001ddef8=IShotGlobal_1001dde10;
    }
    NSRect area=IShotGlobal_1001dde24?NSMakeRect(IShotGlobal_1001ddee8,IShotGlobal_1001ddef0,IShotGlobal_1001ddef8,IShotGlobal_1001ddf00):NSMakeRect(IShotGlobal_1001dde00,IShotGlobal_1001dde08,IShotGlobal_1001dde10,IShotGlobal_1001dde18);
    CGImageRef image=IShotCGWindowListCreateImage(area,IShotGlobal_1001f18c1?4:8,IShotGlobal_1001f18c1?(CGWindowID)self.window.windowNumber:IShotGlobal_1001ddd10,0);
    if(!IShotGlobal_1001f18c1 && !IShotGlobal_1001dde24) {
        IShotGlobal_1001f18c1=[Global checkIfSameColorFromImageRef:image];
        if(IShotGlobal_1001f18c1) { if(image) CFRelease(image); image=IShotCGWindowListCreateImage(area,4,(CGWindowID)self.window.windowNumber,0); }
    }
    if(!image) return;
    NSInteger height=(NSInteger)CGImageGetHeight(image); NSUInteger width=CGImageGetWidth(image);
    NSMutableArray *rows=[NSMutableArray new];
    CFDataRef data=CGDataProviderCopyData(CGImageGetDataProvider(image)); if(!data) { CFRelease(image); return; }
    NSInteger padding=height?((NSInteger)CFDataGetLength(data)-height*(NSInteger)width*4)/height:0;
    NSInteger stride=((NSInteger)width+padding/4)*4; const uint8_t *bytes=CFDataGetBytePtr(data);
    for(NSInteger y=0;y<height;y++) { NSMutableArray *row=[NSMutableArray new]; NSData *pixels=[NSData dataWithBytes:bytes+y*stride length:width*4]; if(pixels) [row addObject:pixels]; if(row) [rows addObject:row]; }
    if((IShotGlobal_1001f18c7&1) && (IShotGlobal_1001dde50.count==0 || [rows isEqualToArray:IShotGlobal_1001dde50])) {
        if(IShotGlobal_1001dde50.count==0) IShotGlobal_1001dde50=rows;
        CFRelease(image); CFRelease(data); return;
    }
    NSMutableArray *columns=nil;
    if(!(IShotGlobal_1001f18c4==YES && IShotGlobal_1001f18c5==YES && IShotGlobal_1001f18c2==YES && (IShotGlobal_1001f18c3&1))) {
        columns=[NSMutableArray new];
        for(NSUInteger x=0;x<width;x++) {
            NSMutableArray *column=[NSMutableArray new];
            for(NSInteger y=0;y<height;y++) { const uint8_t *pixel=bytes+y*stride+x*4; [column addObject:@((int)((double)pixel[2]*0.3+(double)pixel[1]*0.59+(double)pixel[0]*0.11))]; }
            [columns addObject:column];
        }
    }
    BOOL anchor=IShotGlobal_1001f18c6;
    if(!(IShotGlobal_1001f18c7&1)) {
        IShotGlobal_1001ddf10=[[NSImage alloc] initWithCGImage:image size:NSMakeSize(CGImageGetWidth(image),CGImageGetHeight(image))];
        IShotGlobal_1001dde48=rows; IShotGlobal_1001ddf18=IShotGlobal_1001ddf10; IShotGlobal_1001ddf20=rows; IShotGlobal_1001ddf28=columns; [self drawScrollView]; anchor=IShotGlobal_1001f18c6;
    } else if(rows.count) {
        if([IShotGlobal_1001ddf28 isEqual:columns]) { CFRelease(image); CFRelease(data); return; }
        if(IShotGlobal_1001f18c4!=YES || !(IShotGlobal_1001f18c5&1)) {
            NSUInteger left=0; while(left<columns.count && [Global sameArrColumn:IShotGlobal_1001ddf28[left] to:columns[left]]) left++;
            IShotGlobal_1001ddf30=(int)left;
            int count=(int)columns.count,right=0;
            while(right<count && [Global sameArrColumn:IShotGlobal_1001ddf28[(NSUInteger)(count-right-1)] to:columns[(NSUInteger)(count-right-1)]]) right++;
            IShotGlobal_1001ddf34=right;
            if(width!=(NSInteger)IShotGlobal_1001ddf30 && !(IShotGlobal_1001f18c4&1)) IShotGlobal_1001f18c4=YES;
            if(width!=(NSUInteger)right && !(IShotGlobal_1001f18c5&1)) IShotGlobal_1001f18c5=YES;
        }
        if(!(IShotGlobal_1001f18c2&1)) {
            NSUInteger top=0; while(top<rows.count && [Global sameArr:rows[top] to:IShotGlobal_1001dde48[top]]) top++;
            int value=(int)top; IShotGlobal_1001dde5c=IShotGlobal_1001ddf08==value?IShotGlobal_1001dde5c+1:0;
            IShotGlobal_1001ddf08=value;
            if(value==0) IShotGlobal_1001f18c2=YES;
            else if(IShotGlobal_1001f18c2!=YES && IShotGlobal_1001dde5c<2) {
                value-=[Global getSameColorValueInArrColumn:columns[(NSInteger)IShotGlobal_1001ddf30+1] from:value withUp:YES];
                IShotGlobal_1001dde60=IShotGlobal_1001ddf38==value?IShotGlobal_1001dde60+1:0; IShotGlobal_1001ddf38=value;
                if(value==0) { IShotGlobal_1001ddf08=0; IShotGlobal_1001f18c2=YES; }
            }
        }
        if(IShotGlobal_1001dde5c>1 && !(IShotGlobal_1001f18c2&1)) { if(IShotGlobal_1001ddf08>0) IShotGlobal_1001ddf08++; IShotGlobal_1001f18c2=YES; }
        if(IShotGlobal_1001dde60>2 && !(IShotGlobal_1001f18c2&1) && ![IShotGlobal_1001ddd48 isEqualToString:@"com.tencent.qq"]) { IShotGlobal_1001ddf08=IShotGlobal_1001ddf38; if(IShotGlobal_1001ddf38>0) IShotGlobal_1001ddf08++; IShotGlobal_1001f18c2=YES; }
        if(!(IShotGlobal_1001f18c3&1) && IShotGlobal_1001dde50.count) {
            NSUInteger row=rows.count; int last=-1,value=(int)rows.count-1;
            for(;;) { row--; if(row==0) { value=(int)rows.count-1; break; } BOOL same=[Global sameArr:rows[row] to:IShotGlobal_1001dde48[row]]; value=++last; if(!(same&1)) break; }
            IShotGlobal_1001dde58=IShotGlobal_1001ddf0c==value?IShotGlobal_1001dde58+1:0; IShotGlobal_1001ddf0c=value;
            if(value==0) IShotGlobal_1001f18c3=YES;
            else if(IShotGlobal_1001f18c3!=YES && IShotGlobal_1001dde58<2) {
                value-=[Global getSameColorValueInArrColumn:columns[(NSInteger)IShotGlobal_1001ddf30+1] from:value withUp:NO];
                IShotGlobal_1001dde64=IShotGlobal_1001ddf3c==value?IShotGlobal_1001dde64+1:0; IShotGlobal_1001ddf3c=value;
                if(value==0) { IShotGlobal_1001ddf0c=0; IShotGlobal_1001f18c3=YES; }
            }
        }
        if(IShotGlobal_1001dde58>1 && !(IShotGlobal_1001f18c3&1)) {
            IShotGlobal_1001f18c3=YES;
            if(IShotGlobal_1001ddf0c>0) { IShotGlobal_1001ddf40=[[NSImageView alloc] init]; IShotGlobal_1001ddf40.image=[NSImage cutImageToRect:IShotGlobal_1001ddf18 Rect:NSMakeRect(0,IShotGlobal_1001ddf18.size.height-IShotGlobal_1001ddf0c,IShotGlobal_1001ddf18.size.width,IShotGlobal_1001ddf0c)]; [IShotGlobal_1001dde40 addSubview:IShotGlobal_1001ddf40]; }
        }
        if(IShotGlobal_1001dde64>1 && !(IShotGlobal_1001f18c3&1)) {
            IShotGlobal_1001ddf0c=IShotGlobal_1001ddf3c; IShotGlobal_1001f18c3=YES;
            if(IShotGlobal_1001ddf3c>0) { IShotGlobal_1001ddf40=[[NSImageView alloc] init]; IShotGlobal_1001ddf40.image=[NSImage cutImageToRect:IShotGlobal_1001ddf18 Rect:NSMakeRect(0,IShotGlobal_1001ddf18.size.height-IShotGlobal_1001ddf0c,IShotGlobal_1001ddf18.size.width,IShotGlobal_1001ddf0c)]; [IShotGlobal_1001dde40 addSubview:IShotGlobal_1001ddf40]; }
        }
        int offset=(IShotGlobal_1001f18c2==NO?IShotGlobal_1001ddf08*scale:0)+scale;
        NSUInteger start=(NSUInteger)(int64_t)offset;
        if(IShotGlobal_1001dde50.count==rows.count) for(NSUInteger i=start;i<rows.count;i++) if(![Global sameArr:rows[i] to:IShotGlobal_1001dde50[i]]) { start=i; break; }
        IShotGlobal_1001dde50=rows;
        int match=-1,delta=0; BOOL found=NO; anchor=NO;
        if((NSUInteger)(int64_t)(int)start<rows.count-3) {
            for(NSUInteger i=(NSUInteger)(int64_t)(int)start;i<rows.count-3;i++) {
                NSArray *previous=rows[i],*candidate=rows[i+1],*next=rows[i+2];
                if([Global sameArr:previous to:candidate] || [Global sameArr:next to:candidate] || ![Global notOnlyWhiteColorInQQOrWeChat:candidate]) continue;
                int rowIndex=(int)(i+1); anchor=rowIndex!=-1;
                if(anchor && IShotGlobal_1001f18c6) {
                    NSMutableArray *repetitions=[NSMutableArray new];
                    for(NSUInteger k=(NSUInteger)(int64_t)((int)i+4);k<rows.count;k++) if([Global sameArr:rows[k] to:candidate]) [repetitions addObject:@((int)k)];
                    int distance=0; NSArray *disambiguator=nil;
                    if(repetitions.count && rows.count>1) {
                        for(NSUInteger distanceIndex=1;distanceIndex<rows.count;distanceIndex++) {
                            int pos=rowIndex+(int)distanceIndex; if((NSUInteger)(int64_t)pos>=rows.count) break;
                            NSArray *row=rows[(NSUInteger)(int64_t)pos]; BOOL repeated=NO;
                            for(NSNumber *repeat in repetitions) {
                                NSUInteger other=repeat.integerValue+distanceIndex;
                                if(other>=rows.count) break;
                                if([Global sameArr:rows[other] to:row]) { repeated=YES; break; }
                            }
                            if(!repeated) { distance=(int)distanceIndex; disambiguator=row; break; }
                        }
                    }
                    NSUInteger old=start;
                    while(old<IShotGlobal_1001ddf20.count && ![Global sameArr:IShotGlobal_1001ddf20[old] to:candidate]) old++;
                    if(old<IShotGlobal_1001ddf20.count) {
                        if(distance==0 || ((NSUInteger)(int64_t)(distance+(int)old)<IShotGlobal_1001ddf20.count-1 && [Global sameArr:IShotGlobal_1001ddf20[(NSUInteger)(int64_t)(distance+(int)old)] to:disambiguator])) { found=YES; match=(int)old; }
                    }
                    delta=match-rowIndex;
                } else if(anchor && !IShotGlobal_1001f18c6) { IShotGlobal_1001dde20=-1; found=YES; match=-1; delta=10; }
                break;
            }
        }
        if(found && match!=0 && delta>0 && IShotGlobal_1001dde20<0 && delta<height) {
            IShotGlobal_1001ddf48=IShotGlobal_1001dde20; IShotGlobal_1001dde20=0;
            IShotGlobal_1001ddf10=[[NSImage alloc] initWithCGImage:image size:NSMakeSize(CGImageGetWidth(image),CGImageGetHeight(image))];
            if(!IShotGlobal_1001ddf10 || IShotGlobal_1001ddf10.size.width==0 || IShotGlobal_1001ddf10.size.height==0) return; // original early-return resource lifetime
            double imageHeight=IShotGlobal_1001ddf10.size.height; float last=[IShotGlobal_1001dde28.lastObject floatValue];
            if(IShotGlobal_1001dde30.count==0) {
                NSImageView *row=[[NSImageView alloc] init]; row.image=[NSImage cutImageToRect:IShotGlobal_1001ddf18 Rect:NSMakeRect(0,0,IShotGlobal_1001ddf18.size.width,IShotGlobal_1001ddf18.size.height-IShotGlobal_1001ddf0c)];
                [IShotGlobal_1001dde40 addSubview:row]; [IShotGlobal_1001dde30 addObject:row]; [IShotGlobal_1001dde28 addObject:@(delta)]; IShotGlobal_1001ddf4c=delta;
            } else {
                float combined=last+(float)delta;
                if((float)imageHeight*0.95<=combined) {
                    IShotGlobal_1001ddf4c=0; NSImageView *row=[[NSImageView alloc] init]; row.image=IShotGlobal_1001ddf18;
                    [IShotGlobal_1001dde40 addSubview:row]; [IShotGlobal_1001dde30 addObject:row]; [IShotGlobal_1001dde28 addObject:@(delta)]; IShotGlobal_1001ddf50=IShotGlobal_1001ddf18;
                } else { [IShotGlobal_1001dde28 removeLastObject]; [IShotGlobal_1001dde28 addObject:@(combined)]; IShotGlobal_1001ddf4c=(int)combined; }
            }
            [self drawScrollView]; IShotGlobal_1001ddf18=IShotGlobal_1001ddf10; IShotGlobal_1001ddf20=rows;
        }
    }
    IShotGlobal_1001f18c6=anchor; CFRelease(image); CFRelease(data);
}
