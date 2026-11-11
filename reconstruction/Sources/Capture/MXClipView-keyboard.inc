// -[MXClipView keyDown:] 0x10002eb38. No superclass dispatch in original.
- (void)keyDown:(NSEvent *)event {
 NSUInteger flags=event.modifierFlags;if(!IShotGlobal_1001de088)return;unsigned key=event.keyCode;
 if(key==0x33 && IShotGlobal_1001de058.count){
  NSString *identity=[NSString stringWithFormat:@"%@%@",IShotGlobal_1001de058[@"type"],IShotGlobal_1001de058[@"list"]];
  for(NSDictionary *stroke in [NSArray arrayWithArray:IShotGlobal_1001de050])if([[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]]isEqualToString:identity])[IShotGlobal_1001de050 removeObject:stroke];
  unsigned type=[IShotGlobal_1001de058[@"type"]intValue];if((type&~1u)==6)[IShotGlobal_1001de058[@"scrollView"]removeFromSuperview];
  int pencil=[IShotGlobal_1001de058[@"indexOfPencilMosaic"]intValue];[IShotGlobal_1001de058 removeAllObjects];
  if(type==8){IShotMXKeyPost(@"refreshHighlightDrawRect");IShotMXKeyPost(@"refreshMosaicDrawRect");}
  else if(type==5||pencil){self.needsDisplay=YES;[self updateTrackingAreas];}else IShotMXKeyPost(@"refreshOthersDrawRect");
  IShotGlobal_1001dddf8=nil;[[NSCursor arrowCursor]set];
 }
 if(IShotGlobal_1001de050.count==(NSInteger)IShotGlobal_1001de048)[IShotGlobal_1001de160 disEnableUndoButton];
 if((flags&0xe0000)==0x20000){if((flags&0x100000)&&key==6){[IShotGlobal_1001de160 redoButton:self];self.needsDisplay=YES;}}
 else if((flags&0xe0000)==0){
  if((flags&0x100000)&&key==6){[IShotGlobal_1001de160 undoButton:self];self.needsDisplay=YES;}
  else if((flags&0x100000)&&key==1){[IShotGlobal_1001de160 saveAsFile];return;}
  else if((flags&0x100000)&&key==8){IShotGlobal_1001ddec0=YES;[IShotGlobal_1001de160 copyToPasteButtonClick:self];return;}
 }
 if(flags&0x1e0000)return;
 NSString *characters=event.characters;if(key==0x4c||key==0x24)characters=@"↩";else if(key==0x31)characters=@"ㄩ";
 NSString *upper=characters.uppercaseString;
 for(NSString *shortcut in IShotGlobal_1001de130){
  if(![upper isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:shortcut]])continue;
  BOOL annotation=NO;
  if([shortcut isEqualToString:@"squareShortcut"]&&!IShotGlobal_1001de0c0){[IShotGlobal_1001de160 squareButtonClick:self];annotation=YES;}
  else if([shortcut isEqualToString:@"ellipseShortcut"]&&!IShotGlobal_1001de0c0){[IShotGlobal_1001de160 ellipseButtonClick:self];annotation=YES;}
  else if([shortcut isEqualToString:@"lineShortcut"]&&!IShotGlobal_1001de0c0){[IShotGlobal_1001de160 lineButtonClick:self];annotation=YES;}
  else if([shortcut isEqualToString:@"arrowShortcut"]&&!IShotGlobal_1001de0c0){[IShotGlobal_1001de160 arrowButtonClick:self];annotation=YES;}
  else if([shortcut isEqualToString:@"pencilShortcut"]&&!IShotGlobal_1001de0c0){[IShotGlobal_1001de160 pencilButtonClick:self];annotation=YES;}
  else if([shortcut isEqualToString:@"mosaicShortcut"]&&!IShotGlobal_1001de0c0&&!IShotGlobal_1001de180){[IShotGlobal_1001de160 mosaicButtonClick:self];annotation=YES;}
  else if([shortcut isEqualToString:@"textShortcut"]&&!IShotGlobal_1001de0c0){[IShotGlobal_1001de160 textButtonClick:self];annotation=YES;}
  else if([shortcut isEqualToString:@"noteShortcut"]&&!IShotGlobal_1001de0c0){[IShotGlobal_1001de160 noteButtonClick:self];self.cropBorderView.isCanMove=NO;break;}
  else if([shortcut isEqualToString:@"highlightShortcut"]&&!IShotGlobal_1001de0c0){[IShotGlobal_1001de160 highlightButtonClick:self];annotation=YES;}
  else if([shortcut isEqualToString:@"mapShortcut"]&&!IShotGlobal_1001de0c0&&!IShotGlobal_1001de180)[IShotGlobal_1001de160 mapButtonClick:self];
  else if([shortcut isEqualToString:@"OCRShortcut"]&&!IShotGlobal_1001de0c0&&!IShotGlobal_1001de180)[IShotGlobal_1001de160 OCRButtonClick:self];
  else if([shortcut isEqualToString:@"scrollScreenshotShortcut"]&&!IShotGlobal_1001de0c0&&!self.onlyClipCurrentWindow&&IShotGlobal_1001de160.scrollScreenshotButton.enabled)[IShotGlobal_1001de160 scrollScreenshotButtonClick:self];
  else if([shortcut isEqualToString:@"saveShortcut"])[IShotGlobal_1001de160 saveButtonClick:self];
  else if([shortcut isEqualToString:@"copyToPasteShortcut"])[IShotGlobal_1001de160 copyToPasteButtonClick:self];
  else if([shortcut isEqualToString:@"zoomShortcut"])[IShotGlobal_1001de160 zoomButtonClick:self];
  else if([shortcut isEqualToString:@"clearShortcut"])[IShotGlobal_1001de160 clearButtonClick:self];
  if(annotation){self.cropBorderView.isCanMove=NO;if([IShotGlobal_1001dde70 isEqualToString:@"WholeMove"])[self changeCursorToCreateNew];}break;
 }
 int handle=self.cropBorderView.whichInResizeRect;
 if([IShotGlobal_1001dde70 hasPrefix:@"Resize"]&&handle>=1&&handle<=8){
  CGEventRef cursorEvent=CGEventCreate(NULL);CGPoint cursor=CGEventGetLocation(cursorEvent);if(cursorEvent)CFRelease(cursorEvent);
  CGRect old=_cropBorderView.frame,newRect=NSZeroRect;NSScreen *screen=[NSScreen currentScreenForMouseLocation];
  if(key==0x7b||key==0x7c){double delta=key==0x7b?-1.:1.;
   if(handle==1||handle==7||handle==8){CGWarpMouseCursorPosition(CGPointMake(old.origin.x+screen.frame.origin.x+6.+delta,cursor.y));newRect=old;newRect.origin.x+=delta;newRect.size.width-=delta;IShotGlobal_1001f18cc=YES;}
   else if(handle==2||handle==6){cursor.x+=delta;CGWarpMouseCursorPosition(cursor);IShotGlobal_1001f18cd=YES;[self refreshColorPickerImageView];}
   else if(handle>=3&&handle<=5){CGWarpMouseCursorPosition(CGPointMake(old.origin.x+old.size.width+screen.frame.origin.x-6.+delta,cursor.y));newRect=old;newRect.size.width+=delta;IShotGlobal_1001f18cc=YES;}
  }else if(key==0x7d||key==0x7e){BOOL down=key==0x7d;
   if(handle==4||handle==8){cursor.y+=down?1.:-1.;CGWarpMouseCursorPosition(cursor);IShotGlobal_1001f18cd=YES;[self refreshColorPickerImageView];}
   else if(handle>=1&&handle<=3){int32_t y=(int32_t)(([NSScreen deepestScreen].frame.size.height-old.origin.y)-screen.frame.origin.y);CGWarpMouseCursorPosition(CGPointMake(cursor.x,(double)(int32_t)((uint32_t)y-(down?5u:7u))));newRect=old;newRect.origin.y+=down?-1.:1.;newRect.size.height+=down?1.:-1.;IShotGlobal_1001f18cc=YES;}
   else if(handle>=5&&handle<=7){int32_t y=(int32_t)(([NSScreen deepestScreen].frame.size.height-(old.origin.y+old.size.height))-screen.frame.origin.y);CGWarpMouseCursorPosition(CGPointMake(cursor.x,(double)(int32_t)((uint32_t)y+(down?7u:5u))));newRect=old;newRect.size.height+=down?-1.:1.;IShotGlobal_1001f18cc=YES;}
  }
  self.colorPickerImageView.tag=handle;
  if(!IShotGlobal_1001dde95&&IShotGlobal_1001f18cc==1){IShotGlobal_1001dde95=YES;IShotMXKeyPost(@"hiddenButtonOfClipToolbarWindow");}
  [self.window disableCursorRects];
  if(IShotGlobal_1001f18cc==1&&!NSEqualRects(newRect,NSZeroRect)){
   [self _resetFramesToThisOne:newRect];[self setFrameForContentView:NSInsetRect(newRect,6,6)];[self refreshColorPickerImageView];[self reFreshShapeLayer1];[self reFreshShapeLayer2];[IShotGlobal_1001de160 setAnnotatedImageViewFrame:self.contentRect];self.contentFrame=_cropBorderView.frame;
  }
 }
 if(![IShotGlobal_1001dde70 hasPrefix:@"WholeMove"]||handle!=-1||self.onlyClipCurrentWindow||![IShotGlobal_1001de090 isEqualToString:@""])return;
 CGEventRef cursorEvent=CGEventCreate(NULL);CGPoint cursor=CGEventGetLocation(cursorEvent);if(cursorEvent)CFRelease(cursorEvent);
 CGRect newRect=_cropBorderView.frame;
 switch(key){case 0x7b:cursor.x-=1.;newRect.origin.x-=1.;break;case 0x7c:cursor.x+=1.;newRect.origin.x+=1.;break;case 0x7d:cursor.y+=1.;newRect.origin.y-=1.;break;case 0x7e:cursor.y-=1.;newRect.origin.y+=1.;break;default:newRect=NSZeroRect;goto noWholeMoveWarp;}
 CGWarpMouseCursorPosition(cursor);IShotGlobal_1001f18ce=YES;
 noWholeMoveWarp:
 if(!IShotGlobal_1001dde95){if(IShotGlobal_1001f18ce!=1)return;IShotGlobal_1001dde95=YES;IShotMXKeyPost(@"hiddenButtonOfClipToolbarWindow");}
 if(IShotGlobal_1001f18ce==1){[self _resetFramesToThisOne:newRect];[self setFrameForContentView:NSInsetRect(newRect,6,6)];self.scrollViewOfColorPicker.hidden=YES;[self reFreshShapeLayer1];[self reFreshShapeLayer2];[IShotGlobal_1001de160 setAnnotatedImageViewFrame:self.contentRect];self.contentFrame=_cropBorderView.frame;}
}
// -[MXClipView mouseMoved:] 0x10002cccc, delayed block 0x10002e4f4.
- (void)mouseMoved:(NSEvent *)event {
 if(IShotGlobal_1001de0c0){
  if(IShotGlobal_1001f18c0&1)return;CGPoint mouse=event.locationInWindow;
  self.window.ignoresMouseEvents=!(NSPointInRect(mouse,self.autoScrollScreenShotButton.frame)||NSPointInRect(mouse,self.indicatorField.frame));return;
 }
 if(IShotGlobal_1001de138.count&&![IShotGlobal_1001de138[0][@"screen"]isEqual:self.window.screen])return;
 NSScreen *screen=[NSScreen currentScreenForMouseLocation];CGEventRef cursorEvent=CGEventCreate(NULL);CGPoint mouse=CGEventGetLocation(cursorEvent);if(!cursorEvent)return;CFRelease(cursorEvent);
 double originX=screen.frame.origin.x,deepHeight=[NSScreen deepestScreen].frame.size.height,originY=screen.frame.origin.y;
 if(IShotGlobal_1001dddf8)[self.window disableCursorRects];
 mouse.y=deepHeight-mouse.y;
 if((IShotGlobal_1001f18cc&1)||(IShotGlobal_1001f18cd&1)||IShotGlobal_1001f18ce==1){
  IShotGlobal_1001f18cc=NO;IShotGlobal_1001f18cd=NO;IShotGlobal_1001f18ce=NO;
  if(IShotGlobal_1001dde95){IShotGlobal_1001dde95=NO;IShotMXKeyPost(@"unhiddenButtonOfClipToolbarWindow");}self.scrollViewOfColorPicker.hidden=YES;
 }
 mouse.x-=originX;mouse.y-=originY;
 if(self.clipState==0&&!IShotGlobal_1001de088){
  if([(id)self.delegate respondsToSelector:@selector(clipViewMouseMoved:)])[(id)self.delegate clipViewMouseMoved:event];
  if(!IShotGlobal_1001de138.count)IShotGlobal_1001dddf8=IShotNullCursor_1001ddfa8;
  if(IShotGlobal_1001dde68==1)return;
  if([self.window.screen isEqual:screen]){
   int32_t height=(int32_t)screen.frame.size.height;
   int32_t left=(int32_t)((mouse.x-120.)-10.),x=left<0?(int32_t)(mouse.x+10.):left;
   int32_t above=(int32_t)(mouse.y+10.),y=(int32_t)((mouse.y-120.)-10.);
   if((int32_t)((uint32_t)above+120u)<=height)y=above;
   if(!self.colorPickerImageView){
    self.colorPickerImageView=[[ColorPickerImageView alloc]initWithFrame:NSMakeRect(0,0,120,120)];self.colorPickerImageView.image=self.fullImage;
    [self.colorPickerImageView mouseMoved:event];self.scrollViewOfColorPicker=[[NSScrollView alloc]initWithFrame:NSMakeRect(x,y,120,120)];
    [self.scrollViewOfColorPicker addSubview:self.colorPickerImageView];[self addSubview:self.scrollViewOfColorPicker];self.scrollViewOfColorPicker.hidden=YES;self.imageViewOfCursor.hidden=YES;
   }else{
    [self.colorPickerImageView mouseMoved:event];[self.scrollViewOfColorPicker setFrameOrigin:NSMakePoint(x,y)];[_imageViewOfCursor setFrameOrigin:NSMakePoint(mouse.x-15.,mouse.y-16.)];[self reFreshShapeLayer3:mouse];
    if(self.scrollViewOfColorPicker.hidden){
     for(id controller in [MXClipScreenManager sharedInstance].clipWindowControllerArray)if(![[controller window].screen isEqual:screen]){
      [controller clipView].scrollViewOfColorPicker.hidden=YES;[controller clipView].imageViewOfCursor.hidden=YES;[controller clipView].shapeLayer3.hidden=YES;
     }
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW,50000000),dispatch_get_main_queue(),^{self.scrollViewOfColorPicker.hidden=NO;self.imageViewOfCursor.hidden=NO;self.shapeLayer3.hidden=NO;});
    }
   }
  }
 }
 BOOL nearTip=NSPointInRect(mouse,NSInsetRect(self.tipView.frame,-20.,-20.));
 if(!IShotGlobal_1001de088)self.tipView.hidden=nearTip;
 else if(nearTip)self.tipView.hidden=YES;
 else{
  NSString *hoverKey=@"Stop move the mouse on the button for more than 0.5 seconds to enter the setting options.response time can be set in preferences";
  NSString *windowKey=@"Window screenshot mode cannot take scroll screenshots";
  if(IShotGlobal_1001de0b0==-1){
   if([self.textFieldOfTipView.stringValue isEqualToString:IShotMXKeyLocalized(hoverKey)]||[self.textFieldOfTipView.stringValue isEqualToString:IShotMXKeyLocalized(@"Tap the Control key to hide or show the toolbar")]||[self.textFieldOfTipView.stringValue isEqualToString:IShotMXKeyLocalized(windowKey)]){self.textFieldOfTipView.stringValue=@"";self.tipView.hidden=YES;}
  }else{
   NSString *text=nil;
   if(IShotGlobal_1001de0b0==13&&self.onlyClipCurrentWindow&&!IShotGlobal_1001de0c0)text=IShotMXKeyLocalized(windowKey);
   else if(self.tipView.hidden&&!(IShotGlobal_1001de099&1))text=IShotMXKeyLocalized(hoverKey);
   if(text)IShotMXMouseTip(self,text);
  }
  [[NSCursor currentSystemCursor]hotSpot];
  NSString *tipKey=nil;
  if(self.cropBorderView.isInResizeRect&&!self.onlyClipCurrentWindow){
   unsigned handle=self.cropBorderView.whichInResizeRect;
   if(handle<8&&((1u<<handle)&0xaa))tipKey=@"You can adjust the size by modifying the length and width in the prompt bar\n\nPress up, down, left and right direction keys to adjust the size by one pixel";
   else if((handle&~4u)==2)tipKey=@"You can adjust the size by modifying the length and width in the prompt bar\n\nPress up, down direction keys to adjust the size by one pixel";
   else if(handle==8||handle==4)tipKey=@"You can adjust the size by modifying the length and width in the prompt bar\n\nPress left and right direction keys to adjust the size by one pixel";
  }else{
   unsigned type=[IShotGlobal_1001de058[@"type"]intValue];
   if([IShotGlobal_1001dde70 isEqualToString:@"cursorCreateNew"]){tipKey=[IShotGlobal_1001de090 isEqualToString:@"highlight"]?@"The up and down scroll wheel can adjust the opacity of the highlight":@"The up and down scroll wheel can adjust size";}
   else if(([IShotGlobal_1001dde70 isEqualToString:@"WholeMove"]||[IShotGlobal_1001dde70 isEqualToString:@"AboveText"])&&IShotGlobal_1001de090.length>=2){
    if(((type-5u)>3&&IShotGlobal_1001ddfd0)||[IShotGlobal_1001dde70 isEqualToString:@"AboveText"])tipKey=@"The up and down scroll wheel can adjust the opacity of the active element";
    else if(type==7&&IShotGlobal_1001ddfd0){
     CGPoint cycle=[IShotGlobal_1001de058[@"cyclePoint"]pointValue];NSFont *font=[IShotGlobal_1001de058[@"textView"]font];double size=(double)((float)font.pointSize/5.f+11.f);
     CGRect hit=CGRectMake((cycle.x-size*.8)-1.,(cycle.y-size*.8)-1.,size*1.6+2.,size*1.6+2.);
     if(NSPointInRect(mouse,hit)){tipKey=@"The upper and lower rollers can adjust the number of step marking";IShotMXMouseTip(self,IShotMXKeyLocalized(tipKey));[IShotGlobal_1001de058 setObject:@"onCycleOfNote" forKey:@"mousePosition"];goto tipDone;}
    }
   }else if([IShotGlobal_1001dde70 isEqualToString:@"cursorInsertText"])tipKey=@"The up and down scroll wheel can adjust the opacity of the text";
   else if([IShotGlobal_1001dde70 isEqualToString:@"WholeMove"]&&!self.onlyClipCurrentWindow)tipKey=@"You can adjust the size by modifying the length and width in the prompt bar\n\nPress the up, down, left, and right arrow keys to adjust the marquee area pixel by pixel";
  }
  if(tipKey)IShotMXMouseTip(self,IShotMXKeyLocalized(tipKey));else self.tipView.hidden=YES;
 }
 tipDone:
 if(IShotGlobal_1001de088&&!IShotGlobal_1001de0c0){
  [self.cropBorderView mouseMoved:event];
  if(![IShotGlobal_1001ddde8 isEqualToString:IShotGlobal_1001ddec8]||![IShotGlobal_1001dde78 isEqualToString:IShotGlobal_1001dded0])self.needsDisplay=YES;
  IShotGlobal_1001ddec8=IShotGlobal_1001ddde8;IShotGlobal_1001dded0=IShotGlobal_1001dde78;IShotGlobal_1001dded8=NO;IShotGlobal_1001dded9=NO;IShotGlobal_1001dde91=NO;
  if(NSPointInRect(mouse,self.indicatorField.frame)){
   IShotGlobal_1001dde91=YES;IShotGlobal_1001dddf8=nil;
   CGRect width=self.indicatorFieldWidth.frame;width.origin.x+=self.indicatorField.frame.origin.x;width.origin.y+=self.indicatorField.frame.origin.y;
   CGRect height=self.indicatorFieldHeight.frame;height.origin.x+=self.indicatorField.frame.origin.x;height.origin.y+=self.indicatorField.frame.origin.y;
   if(NSPointInRect(mouse,width))IShotGlobal_1001dded8=YES;else if(NSPointInRect(mouse,height))IShotGlobal_1001dded9=YES;else[[NSCursor arrowCursor]set];
  }
 }
 [super mouseMoved:event];
}
