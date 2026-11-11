- (void)drawRect:(CGRect)dirtyRect { // 0x100031b84
    [super drawRect:dirtyRect];
    if (IShotGlobal_1001de0c0) return;
    if (IShotGlobal_1001dde68==1) {
        if (IShotGlobal_1001de138.count && [IShotGlobal_1001de138[0][@"screen"] isEqual:self.window.screen]) {
            for (NSInteger i=(NSInteger)IShotGlobal_1001de148.count-1;i>=0;i--) {
                NSDictionary *window=IShotGlobal_1001de148[i];
                for (NSUInteger j=0;j<IShotGlobal_1001de138.count;j++) {
                    NSDictionary *selected=IShotGlobal_1001de138[j]; CGRect rect=[selected[@"rect"] rectValue];
                    if ([window[@"kCGWindowNumber"] intValue]==[selected[@"windowId"] intValue]) {
                        [[NSColor colorWithDeviceRed:0x1.5959595959596p-3 green:0x1.5757575757575p-1 blue:1 alpha:.3] set];
                        [[NSBezierPath bezierPathWithRect:rect] fill]; break;
                    }
                }
            }
        }
    } else {
        [self drawAllMosaic]; int type=[IShotGlobal_1001de058[@"type"] intValue];
        if (type==4) {
            if ([IShotGlobal_1001de058[@"indexOfPencilMosaic"] intValue]>0) [Global drawPencilMosaic:IShotGlobal_1001de058 inRect:self.frame withActived:YES];
        } else if (type==5) [self drawCurrentMosaicStroke];
        [self drawAllBackgroundOfText];
        if (IShotGlobal_1001de178) {
            CGPoint point=NSPointFromString(IShotGlobal_1001de178[@"CursorPos"]),hotSpot=NSPointFromString(IShotGlobal_1001de178[@"HotSpot"]);
            NSImage *image=IShotGlobal_1001de178[@"CursorImage"];
            double offsetX=hotSpot.x+self.window.screen.frame.origin.x;
            double y=point.y-(hotSpot.y+self.window.screen.frame.origin.y);
            if (hotSpot.x==4 && hotSpot.y==2) y-=image.size.height/self.window.screen.backingScaleFactor+7;
            BOOL four=hotSpot.x==4 && hotSpot.y==4;
            if (four || ((hotSpot.x==12 || hotSpot.x==13) && hotSpot.y==8)) y-=image.size.height/self.window.screen.backingScaleFactor;
            if (@available(macOS 15.1,*)) { if (four) y-=3; }
            [image drawAtPoint:CGPointMake(point.x-offsetX,y) fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1];
        }
    }
}
