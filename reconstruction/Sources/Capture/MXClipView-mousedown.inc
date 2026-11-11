// -mousedown: 0x100027990; REA clip-mousedown-assembly.json.
- (void)mousedown:(NSEvent *)event {
 dispatch_async(dispatch_get_global_queue(0,0), ^{[NSCursor unhide];IShotGlobal_1001dddf8=nil;});
 if(IShotGlobal_1001de0c0){[NSApp activateIgnoringOtherApps:YES];return;}
 if(IShotGlobal_1001de0c1){[IShotGlobal_1001de160 draggedAllToolBar:event];return;}
 if(IShotGlobal_1001de099||IShotGlobal_1001dde91||IShotGlobal_1001dde92)return;
 if(!self.tipView.hidden)self.tipView.hidden=YES;
 if(IShotGlobal_1001ddcf1)[[NSDistributedNotificationCenter defaultCenter]postNotificationName:IShotMXDecodeNotification(@"1n1aTAlailhwtDeTperloHoonSoldeg0i0") object:IShotMXDecodeNotification(@"1t1hci_5e3tert6b_nS0o0") userInfo:nil deliverImmediately:YES];
 if((event.modifierFlags&0x20000)&&IShotGlobal_1001dde68==0&&self.onlyClipCurrentWindow&&!IShotGlobal_1001de088){
  if([(id)self.delegate respondsToSelector:@selector(clipViewMouseDown:)])[(id)self.delegate clipViewMouseDown:event];
  IShotGlobal_1001dde68=1;self.clipState=0;return;
 }
 if(IShotGlobal_1001dde68==1){self.clipState=0;return;}
 IShotGlobal_1001dde93=NO;NSPoint original=event.locationInWindow;IShotGlobal_1001f18d0=0;
 if(event.clickCount==2&&NSPointInRect(original,self.cropBorderView.frame)&&!IShotGlobal_1001de180){
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW,10000000),dispatch_get_main_queue(),^{
   switch([[NSUserDefaults standardUserDefaults]integerForKey:@"doubleLeftButtonAction"]){
    case 1:[IShotGlobal_1001de160 mapButtonClick:self];break;
    case 2:[IShotGlobal_1001de160 OCRButtonClick:self];break;
    case 3:case 5:IShotGlobal_1001dde90=YES;[IShotGlobal_1001de160 saveButtonClick:self];break;
    case 4:[IShotGlobal_1001de160 copyToPasteButtonClick:self];break;
   }
  });
 }
 NSPoint point=[self convertPoint:event.locationInWindow fromView:nil];if(NSEqualPoints(point,NSZeroPoint))point=original;
 int type=[IShotGlobal_1001de058[@"type"]intValue];
 if(type==4)self.needsDisplay=YES;
 if((type==6||type==7)&&![IShotGlobal_1001dde70 isEqualToString:@"WholeMove"]&&NSPointInRect(point,self.cropBorderView.frame)){
  IShotGlobal_1001dde94=NO;[self.window makeFirstResponder:self];
  NSRect frame=[IShotGlobal_1001de058[@"scrollView"]frame];float fingerprint=(float)(frame.origin.x*(frame.origin.y+frame.size.height));
  NSPoint cycle=[IShotGlobal_1001de058[@"cyclePoint"]pointValue];BOOL found=NO;
  for(NSDictionary *stroke in [IShotGlobal_1001de050 reverseObjectEnumerator]){
   int priorType=[stroke[@"type"]intValue];if(priorType!=6&&priorType!=7)continue;
   // The original rereads the selected dictionary here, not the enumerated stroke.
   NSRect other=[IShotGlobal_1001de058[@"scrollView"]frame];NSPoint otherCycle=[IShotGlobal_1001de058[@"cyclePoint"]pointValue];
   if(fingerprint==(float)(other.origin.x*(other.origin.y+other.size.height))&&cycle.x==otherCycle.x&&cycle.y==otherCycle.y){found=YES;break;}
  }
  if(!found)[IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
  [IShotGlobal_1001de058 removeAllObjects];[self updateTrackingAreas];IShotGlobal_1001ddde8=nil;self.needsDisplay=YES;return;
 }
 if(IShotGlobal_1001de0c0)return;
 if(self.clipState==0){self.lastDate=[NSDate date];self.clipState=1;NSPoint p=[self fetchLocationFromScreen:[NSEvent mouseLocation]];self.rectBeginPoint=NSMakePoint((int)p.x,(int)p.y);}
 if(self.clipState==1&&!IShotGlobal_1001de088&&[(id)self.delegate respondsToSelector:@selector(clipViewMouseDown:)])[(id)self.delegate clipViewMouseDown:event];
 self.isCanDrawSelectFunction=NO;
 if(self.cropBorderView.isCanMove){self.dragMode=2;IShotGlobal_1001dde93=YES;(void)self.onlyClipCurrentWindow;}
 else if(NSPointInRect(point,self.contentView.frame)&&!self.cropBorderView.isInResizeRect){
  if(IShotGlobal_1001de090.length>1&&IShotGlobal_1001de088)self.isCanDrawSelectFunction=YES;
  else{self.dragMode=2;IShotGlobal_1001dde93=YES;(void)self.onlyClipCurrentWindow;}
 }else if(NSPointInRect(point,self.cropBorderView.frame)&&!IShotGlobal_1001de0c0){self.dragMode=1;self.lastContentRectBeforeResize=self.contentRect;}
 else self.dragMode=0;
 if(!self.isCanDrawSelectFunction){self.startPoint=point;[super mouseDown:event];[self.cropBorderView mouseDown:event];return;}
 [IShotGlobal_1001de160 handleMouseEvent:event];if([IShotGlobal_1001dde70 isEqualToString:@"WholeMove"])return;
 type=[IShotGlobal_1001de058[@"type"]intValue];
 if(type==6||type==7){
  int size=[IShotGlobal_1001de058[@"size"]intValue];NSColor *color=[IShotGlobal_1001de058[@"color"]colorWithAlphaComponent:(double)[IShotGlobal_1001de058[@"colorAlpha"]floatValue]];
  NSFont *font=IShotFunction_10004cf0c(IShotGlobal_1001de058[@"fontName"],size);NSSize textSize=IShotFunction_100048504(@" ",font);
  NSTextView *text=[[NSTextView alloc]initWithFrame:NSMakeRect(-4,0,30000,30000)];text.richText=NO;text.textColor=color;text.backgroundColor=NSColor.clearColor;text.font=font;text.insertionPointColor=color;
  double y;if([IShotGlobal_1001de090 isEqualToString:@"text"])y=original.y+textSize.height*(-.5);
  else{y=original.y+textSize.height*.25+18.;if(!(textSize.height+y<self.contentRect.origin.y+self.contentRect.size.height))y=((original.y-textSize.height*.25)-18.)-textSize.height;textSize.width-=(double)(size/7);}
  NSScrollView *scroll=[[NSScrollView alloc]initWithFrame:NSMakeRect(original.x-1,y,textSize.width+3,textSize.height)];scroll.backgroundColor=NSColor.clearColor;scroll.hasVerticalScroller=YES;scroll.hasHorizontalScroller=NO;scroll.autohidesScrollers=YES;scroll.autoresizingMask=0x12;scroll.drawsBackground=NO;[scroll addSubview:text];[self addSubview:scroll];
  IShotGlobal_1001de058[@"ScrollViewOrigin"]=[NSValue valueWithPoint:scroll.frame.origin];if(type==7)IShotGlobal_1001de058[@"cyclePoint"]=[NSValue valueWithPoint:original];
  IShotGlobal_1001de058[@"textView"]=text;IShotGlobal_1001de058[@"scrollView"]=scroll;IShotGlobal_1001dde94=YES;[self performSelector:@selector(makeForcusLater) withObject:nil afterDelay:.1];[IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];return;
 }
 if(type!=4||![IShotGlobal_1001dde70 isEqualToString:@"cursorCreateNew"])return;
 int index=[IShotGlobal_1001de058[@"indexOfPencilMosaic"]intValue];if(index<1)return;
 NSScreen *screen=[NSScreen currentScreenForMouseLocation];CGImageRef cg=(__bridge CGImageRef)IShotGlobal_1001de060[index==1?13:3];NSImage *image=[[NSImage alloc]initWithCGImage:cg size:screen.frame.size];
 if(!self.mosaicLayer){self.mosaicLayer=[CALayer layer];self.mosaicLayer.frame=self.frame;[self.layer addSublayer:self.mosaicLayer];self.mosaicShapeLayer=[CAShapeLayer layer];self.mosaicShapeLayer.frame=self.frame;self.mosaicShapeLayer.lineCap=kCALineCapRound;self.mosaicShapeLayer.lineJoin=kCALineJoinRound;self.mosaicShapeLayer.strokeColor=NSColor.blueColor.CGColor;self.mosaicShapeLayer.fillColor=NULL;self.mosaicLayer.mask=self.mosaicShapeLayer;}
 self.mosaicPath=CGPathCreateMutable();self.mosaicLayer.contents=image;self.mosaicShapeLayer.lineWidth=[IShotGlobal_1001de058[@"size"]intValue];CGPathMoveToPoint((CGMutablePathRef)self.mosaicPath,NULL,original.x,original.y);CGMutablePathRef copy=CGPathCreateMutableCopy(self.mosaicPath);self.mosaicShapeLayer.path=copy;CGPathRelease(copy);
}
- (void)rightMouseUp:(NSEvent *)event {if(!IShotGlobal_1001dde92)[super rightMouseUp:event];}
