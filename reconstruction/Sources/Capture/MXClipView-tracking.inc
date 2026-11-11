- (void)updateTrackingAreas { // 0x100025a78; removal block 0x1000265b0
    if (!IShotGlobal_1001de088) return;
    [self.trackingAreas enumerateObjectsUsingBlock:^(NSTrackingArea *area,NSUInteger index,BOOL *stop) { [self removeTrackingArea:area]; }];
    if (self.trackingArea) [self removeTrackingArea:self.trackingArea];
    if (IShotGlobal_1001de0d0) return;
    self.trackingArea=[[NSTrackingArea alloc] initWithRect:self.bounds options:0x82 owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];
    int selectedType=[IShotGlobal_1001de058[@"type"] intValue];
    if (selectedType==8 || selectedType==5) {
        float x1=[IShotGlobal_1001de058[@"X1"] floatValue],y1=[IShotGlobal_1001de058[@"Y1"] floatValue];
        float x2=[IShotGlobal_1001de058[@"X2"] floatValue],y2=[IShotGlobal_1001de058[@"Y2"] floatValue];
        NSArray *rectangles=[self _calculateAllNeededHandleSquareRects:CGRectMake(x1,y1,(double)(x2-x1),(double)(y2-y1))];
        for (NSUInteger i=0;i<rectangles.count;i++) {
            CGRect rect=[rectangles[i] CGRectValue];
            [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:rect options:0x41 owner:self userInfo:@{@"number":@((int)i)}]];
        }
    }
    NSString *selected=[NSString stringWithFormat:@"%@%@",IShotGlobal_1001de058[@"type"],IShotGlobal_1001de058[@"list"]];
    NSMutableArray *visited=[NSMutableArray new]; [visited addObject:selected];
    if (IShotGlobal_1001de048<(int)IShotGlobal_1001de050.count && IShotGlobal_1001de050.count!=(NSInteger)IShotGlobal_1001de048) {
        for (NSInteger i=IShotGlobal_1001de050.count-(NSInteger)IShotGlobal_1001de048-1;i!=-1;i--) {
            NSDictionary *stroke=IShotGlobal_1001de050[i];
            NSString *name=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
            if ([visited containsObject:name]) continue;
            [visited addObject:name]; NSUInteger type=[stroke[@"type"] integerValue];
            if (type==8 || type==5) {
                float x1=[stroke[@"X1"] floatValue],y1=[stroke[@"Y1"] floatValue];
                float x2=[stroke[@"X2"] floatValue],y2=[stroke[@"Y2"] floatValue];
                CGRect rect=CGRectMake(x1,y1,(double)(x2-x1),(double)(y2-y1));
                int pad=[stroke[@"size"] intValue]/2; if (pad<5) pad=4;
                [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:NSInsetRect(rect,-pad,-pad) options:0x41 owner:self userInfo:@{@"number":@100,@"type":@(type),@"name":name}]];
                [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:NSInsetRect(rect,pad,pad) options:0x41 owner:self userInfo:@{@"number":@99,@"type":@(type),@"name":name}]];
            } else if (type==6) {
                NSScrollView *scroll=stroke[@"scrollView"]; NSTextView *text=stroke[@"textView"];
                float fontSize=(float)text.font.pointSize; double pad=(int)(fontSize/15.f+2.f);
                CGRect rect=CGRectMake(scroll.frame.origin.x-pad-3,scroll.frame.origin.y-3,scroll.frame.size.width+pad*.9+8,scroll.frame.size.height+8);
                rect=NSInsetRect(rect,-5,-5);
                [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:rect options:0x41 owner:self userInfo:@{@"number":@100,@"type":@6,@"name":name,@"rect":[NSValue valueWithRect:rect]}]];
            }
        }
    }
}
- (void)mouseEntered:(NSEvent *)event { // 0x1000265bc
    IShotGlobal_1001ddfd1=YES; IShotGlobal_1001dde78=nil; IShotGlobal_1001ddde8=nil;
    if (IShotGlobal_1001f18d0) return;
    int selectedType=[IShotGlobal_1001de058[@"type"] intValue];
    NSDictionary *data=(__bridge NSDictionary *)event.userData;
    IShotGlobal_1001de078=[data[@"number"] integerValue];
    if (selectedType==8 || selectedType==5) {
        uint64_t number=IShotGlobal_1001de078 & ~4ULL;
        if (number==3) { IShotGlobal_1001dde70=@"Resize_135"; IShotGlobal_1001dddf8=IShotGlobal_1001ddf88; [IShotGlobal_1001ddf88 set]; }
        else if (number==2) { IShotGlobal_1001dde70=@"Resize_90"; IShotGlobal_1001dddf8=NSCursor.resizeUpDownCursor; [NSCursor.resizeUpDownCursor set]; }
        else if (number==1) { IShotGlobal_1001dde70=@"Resize_45"; IShotGlobal_1001dddf8=IShotGlobal_1001ddf90; [IShotGlobal_1001ddf90 set]; }
        else if (IShotGlobal_1001de078==8 || IShotGlobal_1001de078==4) { IShotGlobal_1001dde70=@"Resize_0"; IShotGlobal_1001dddf8=NSCursor.resizeLeftRightCursor; [NSCursor.resizeLeftRightCursor set]; }
        else if (IShotGlobal_1001de078-9<=10) { IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor; [NSCursor.openHandCursor set]; }
    }
    if (IShotGlobal_1001de078==99) {
        IShotGlobal_1001dde70=@"cursorCreateNew"; IShotGlobal_1001dddf8=IShotGlobal_1001de0e0; [IShotGlobal_1001de0e0 set]; return;
    }
    if (IShotGlobal_1001de078!=100) return;
    int type=[data[@"type"] intValue];
    if (type==5) { IShotGlobal_1001dde78=data[@"name"]; self.needsDisplay=YES; }
    else if (type==6) { IShotGlobal_1001ddde8=data[@"name"]; self.needsDisplay=YES; }
    IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor; [NSCursor.openHandCursor set];
}
- (void)mouseExited:(NSEvent *)event { // 0x10002699c
    IShotGlobal_1001ddfd1=NO;
    if (IShotGlobal_1001f18d0) return;
    NSDictionary *data=(__bridge NSDictionary *)event.userData;
    IShotGlobal_1001de078=[data[@"number"] integerValue];
    if (IShotGlobal_1001de078==99 || IShotGlobal_1001de078==999) {
        IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor; [NSCursor.openHandCursor set];
    } else {
        if (IShotGlobal_1001de078==100) {
            int type=[data[@"type"] intValue];
            if (type==6) {
                IShotGlobal_1001ddde8=data[@"name"]; NSValue *value=data[@"rect"];
                if (value && !CGRectContainsPoint(value.rectValue,event.locationInWindow)) { IShotGlobal_1001ddde8=nil; self.needsDisplay=YES; }
            } else if (type==5) { IShotGlobal_1001dde78=nil; self.needsDisplay=YES; }
        }
        IShotGlobal_1001dde70=@"cursorCreateNew"; IShotGlobal_1001dddf8=IShotGlobal_1001de0e0; [IShotGlobal_1001de0e0 set];
    }
}
