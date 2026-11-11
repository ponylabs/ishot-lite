// -mouseup: 0x100029d2c; floating-point operands checked against arm64 assembly.
- (void)mouseup:(NSEvent *)event {
 if(IShotGlobal_1001de183){
  IShotGlobal_1001de183=NO;NSRect r=self.contentRect;r.origin.x+=self.window.screen.frame.origin.x;r.origin.y=((NSScreen.deepestScreen.frame.size.height-self.window.screen.frame.origin.y)-self.contentRect.origin.y)-self.contentRect.size.height;
  [Global startOCRAtScreenRect:r];IShotMXKeyPost(@"cancelScreenShot");
  if(!IShotGlobal_1001de184){[NSUserDefaults.standardUserDefaults setObject:NSStringFromRect(r) forKey:@"fixedRectOfOCR"];[NSUserDefaults.standardUserDefaults synchronize];}return;
 }
 if(IShotGlobal_1001de0c0){
  float timestamp=(float)(event.timestamp*1000.);if(timestamp-IShotGlobal_1001dde98<10.f)return;IShotGlobal_1001dde98=timestamp;
  NSPoint p=event.locationInWindow;p.x-=self.window.screen.frame.origin.x;p.y-=self.window.screen.frame.origin.y;
  if(NSPointInRect(p,self.autoScrollScreenShotButton.frame)){
   BOOL old=IShotGlobal_1001dddf0;IShotGlobal_1001dddf0^=1;self.autoScrollScreenShotButton.title=IShotMXKeyLocalized(old?@"AutoScroll":@"StopScroll");
   NSMutableAttributedString *title=[[NSMutableAttributedString alloc]initWithAttributedString:self.autoScrollScreenShotButton.attributedTitle];[title addAttribute:NSForegroundColorAttributeName value:NSColor.whiteColor range:NSMakeRange(0,title.length)];self.autoScrollScreenShotButton.attributedTitle=title;
  }[NSApp activateIgnoringOtherApps:YES];return;
 }
 if(IShotGlobal_1001dde68==1){
  if(IShotGlobal_1001de138.count&&![IShotGlobal_1001de138[0][@"screen"]isEqual:self.window.screen])return;
  BOOL removed=NO;for(NSUInteger i=0;i<IShotGlobal_1001de140.count;i++){NSDictionary *window=IShotGlobal_1001de140[i];if([window[@"windowId"]unsignedIntValue]==IShotGlobal_1001ddd10){[IShotGlobal_1001de140 removeObject:window];removed=YES;break;}}
  if(!removed){NSScreen *screen=[NSScreen currentScreenForMouseLocation];for(NSDictionary *window in IShotGlobal_1001de148){
   if([window[@"kCGWindowNumber"]unsignedIntValue]!=IShotGlobal_1001ddd10)continue;
   CGRect cg;CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)window[@"kCGWindowBounds"],&cg);NSRect rect=[SnipUtil cgWindowRectToScreenRect:cg];rect.origin.x-=screen.frame.origin.x;rect.origin.y-=screen.frame.origin.y;
   NSImage *image=window[@"KCGWindowImage"];
   if(!image){if([window[@"kCGWindowName"]isEqualToString:@"Menubar"]&&[window[@"kCGWindowLayer"]intValue]==24){
    int width=[window[@"kCGWindowBounds"][@"Width"]intValue],height=[window[@"kCGWindowBounds"][@"Height"]intValue];double scale=self.window.screen.backingScaleFactor;CGImageRef full=[self.fullImage CGImageForProposedRect:NULL context:nil hints:nil];
    if(full){CGImageRef crop=CGImageCreateWithImageInRect(full,CGRectMake(0,0,(double)((float)width*(float)scale),(double)((float)height*(float)scale)));image=[[NSImage alloc]initWithCGImage:crop size:NSMakeSize(width,height)];if(crop)CFRelease(crop);}
   }else image=[Global screenShotFromWindowID:[window[@"kCGWindowNumber"]unsignedIntValue]];}
   NSDictionary *entry=image?@{@"windowId":@(IShotGlobal_1001ddd10),@"rect":[NSValue valueWithCGRect:rect],@"screen":self.window.screen,@"KCGWindowImage":image,@"kCGWindowName":window[@"kCGWindowName"]}:@{@"windowId":@(IShotGlobal_1001ddd10),@"rect":[NSValue valueWithCGRect:rect],@"screen":self.window.screen,@"kCGWindowName":window[@"kCGWindowName"]};
   [IShotGlobal_1001de140 addObject:entry];break;
  }}
  [IShotGlobal_1001de138 removeAllObjects];for(NSUInteger i=0;i<IShotGlobal_1001de148.count;i++){NSDictionary *window=IShotGlobal_1001de148[i];for(NSDictionary *selected in IShotGlobal_1001de140)if([window[@"kCGWindowNumber"]intValue]==[selected[@"windowId"]intValue])[IShotGlobal_1001de138 addObject:selected];}
  if(!self.colorPickerImageView.hidden){self.scrollViewOfColorPicker.hidden=YES;self.imageViewOfCursor.hidden=YES;self.shapeLayer3.hidden=YES;IShotGlobal_1001dddf8=nil;[NSCursor.arrowCursor push];}self.needsDisplay=YES;return;
 }
 self.dragMode=0;self.scrollViewOfColorPicker.hidden=YES;self.shapeLayer3.hidden=YES;self.imageViewOfCursor.hidden=YES;
 if(IShotGlobal_1001de099||IShotGlobal_1001dde91||IShotGlobal_1001dde92)return;IShotGlobal_1001dde93=NO;
 if(self.isCanDrawSelectFunction){IShotGlobal_1001f18d0=0;[IShotGlobal_1001de160 handleMouseEvent:event];int type=[IShotGlobal_1001de058[@"type"]intValue];
  if(type==4){if([IShotGlobal_1001dde70 isEqualToString:@"cursorCreateNew"]&&[IShotGlobal_1001de058[@"indexOfPencilMosaic"]intValue]>0){IShotGlobal_1001de058[@"imageOfMosaic"]=IShotFunction_10004cfe4(self.mosaicLayer);[IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];self.mosaicLayer.contents=nil;self.needsDisplay=YES;}}
  else if(type==8||type==5){[self updateTrackingAreas];self.needsDisplay=YES;}return;
 }
 if(!IShotGlobal_1001dde95&&IShotGlobal_1001de088)return;
 if(self.onlyClipCurrentWindow){self.cropBorderView.onlyClipCurrentWindow=YES;[self addSubview:self.cropBorderView];if(!IShotGlobal_1001ddd50)IShotGlobal_1001ddd50=[IShotGlobal_1001ddd08 isEqualToString:@"mappingWindowByiShot"];}
 if(self.contentRect.size.height==0.||self.contentRect.size.width==0.||(NSEqualRects(self.contentRect,self.window.frame)&&self.onlyClipCurrentWindow))self.contentRect=NSMakeRect(IShotGlobal_1001ddd18,IShotGlobal_1001ddd20,IShotGlobal_1001ddd28,IShotGlobal_1001ddd30);
 if(!(self.contentRect.size.height>=1.)||!(self.contentRect.size.width>=1.)){IShotMXKeyPost(@"cancelScreenShot");return;}
 if(([IShotGlobal_1001ddd08 hasPrefix:@"Desktop Picture - "]||[IShotGlobal_1001ddd08 hasPrefix:@"Wallpaper-"] )&&IShotGlobal_1001ddd38<0)self.onlyClipCurrentWindow=NO;
 self.scrollViewOfColorPicker.hidden=YES;self.imageViewOfCursor.hidden=YES;NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;int shadow=0;if([defaults boolForKey:@"needShadowOfnotSingleWindow"])shadow=[[defaults stringForKey:@"sizeOfShadow"]intValue];
 double inset=self.onlyClipCurrentWindow&&shadow>=1&&!IShotGlobal_1001ddd50?(double)(-6-shadow):-6.;NSRect border=NSInsetRect(self.contentRect,inset,inset);self.cropBorderView.frame=border;self.contentFrame=self.cropBorderView.frame;[self _resetIndicatorField];[self reFreshShapeLayer1];if(IShotGlobal_1001de181)[self reFreshShapeLayer2];
 if(IShotGlobal_1001dde95){IShotGlobal_1001dde95=NO;[IShotGlobal_1001de160 setAnnotatedImageViewFrame:self.contentRect];
  NSRect previous=NSMakeRect(border.origin.x+self.window.screen.frame.origin.x+6.,((NSScreen.deepestScreen.frame.size.height-self.window.screen.frame.origin.y)-border.origin.y)-border.size.height+6.,border.size.width-12.,border.size.height-12.);
  IShotGlobal_1001ddea0=previous.origin.x;IShotGlobal_1001ddea8=previous.origin.y;IShotGlobal_1001ddeb0=previous.size.width;IShotGlobal_1001ddeb8=previous.size.height;
  [NSUserDefaults.standardUserDefaults setObject:NSStringFromRect(previous) forKey:@"preRectOfScreenShots"];[NSUserDefaults.standardUserDefaults setBool:NO forKey:@"isClipWindowPreviousScreenShots"];[NSUserDefaults.standardUserDefaults synchronize];IShotMXKeyPost(@"unhiddenButtonOfClipToolbarWindow");
 }else if(!IShotGlobal_1001de088){
  if(!self.onlyClipCurrentWindow)[self addSubview:self.cropBorderView];IShotGlobal_1001de090=@"";
  NSRect previous=self.contentRect;previous.origin.x+=self.window.screen.frame.origin.x;previous.origin.y=((NSScreen.deepestScreen.frame.size.height-self.window.screen.frame.origin.y)-self.contentRect.origin.y)-self.contentRect.size.height;
  BOOL only=self.onlyClipCurrentWindow;[NSUserDefaults.standardUserDefaults setBool:only forKey:@"isClipWindowPreviousScreenShots"];if(only)previous=NSInsetRect(previous,shadow,shadow);
  IShotGlobal_1001ddea0=previous.origin.x;IShotGlobal_1001ddea8=previous.origin.y;IShotGlobal_1001ddeb0=previous.size.width;IShotGlobal_1001ddeb8=previous.size.height;
  if(previous.size.width!=0.)[NSUserDefaults.standardUserDefaults setObject:NSStringFromRect(previous) forKey:@"preRectOfScreenShots"];[NSUserDefaults.standardUserDefaults synchronize];
  self.cropBorderView.needsDisplay=YES;[self changFullImageToMosaicImage];[IShotGlobal_1001de160 setAnnotatedImageViewFrame:self.contentRect];[IShotGlobal_1001de160 openWindow];[IShotGlobal_1001de160 handleMouseEvent:event];
  if([NSUserDefaults.standardUserDefaults boolForKey:@"DoNotRemindAboutScrollScreenshot"]&&self.onlyClipCurrentWindow)IShotGlobal_1001de160.scrollScreenshotButton.enabled=NO;
  if(self.onlyClipCurrentWindow&&!NSContainsRect(self.contentRect,self.window.screen.frame))self.window.backgroundColor=NSColor.clearColor;
  if(IShotGlobal_1001de148.count)[IShotGlobal_1001de148 removeAllObjects];if(NSScreen.screens.count>1)IShotMXKeyPost(@"startAnnotation");
 }
 IShotGlobal_1001f18d0=0;self.clipState=3;
}
