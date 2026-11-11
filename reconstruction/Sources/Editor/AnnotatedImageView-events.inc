- (void)textViewDidChange:(NSNotification *)notification { // 0x1000624fc
    NSTextView *changed = notification.object;
    if (changed.identifier) return;
    NSTextView *text = IShotGlobal_1001de058[@"textView"];
    if (!text || ![text isEqual:changed]) {
        NSMutableArray *seen = NSMutableArray.new;
        if (IShotGlobal_1001de048 < (int)IShotGlobal_1001de050.count) {
            for (NSInteger i=(NSInteger)IShotGlobal_1001de050.count-IShotGlobal_1001de048-1; i>=0; --i) {
                NSDictionary *stroke = IShotGlobal_1001de050[i];
                if (([stroke[@"type"] integerValue] & ~1UL) != 6) continue;
                NSString *key = [NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
                if ([seen containsObject:key]) continue;
                [seen addObject:key];
                if ([stroke[@"textView"] isEqual:changed]) {
                    IShotGlobal_1001dde94 = YES;
                    IShotGlobal_1001de058 = [NSMutableDictionary dictionaryWithDictionary:stroke];
                    [IShotGlobal_1001de160 adjustColorAndSizeButton:[IShotGlobal_1001de058[@"type"] intValue]];
                    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
                    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
                    self.needsDisplay = YES;
                    return;
                }
            }
        }
    }
    NSString *string = text.string;
    if (string) {
        NSFont *font = IShotFunction_10004cf0c(IShotGlobal_1001de058[@"fontName"],[IShotGlobal_1001de058[@"size"] intValue]);
        CGSize size = IShotFunction_100048504(string,font);
        NSScrollView *scroll = IShotGlobal_1001de058[@"scrollView"];
        CGRect frame = scroll.frame; frame.size = CGSizeMake(size.width+2,size.height); scroll.frame = frame;
        self.needsDisplay = YES;
    }
}
- (void)undoDraw { // 0x100065a64
    [IShotGlobal_1001de058 removeAllObjects];
    if (IShotGlobal_1001de048 < (int)IShotGlobal_1001de050.count) {
        ++IShotGlobal_1001de048;
        NSDictionary *stroke = IShotGlobal_1001de050[IShotGlobal_1001de050.count-IShotGlobal_1001de048];
        if (([stroke[@"type"] intValue] & ~1U) == 6) {
            NSString *key = [NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
            BOOL found = NO;
            for (NSInteger i=(NSInteger)IShotGlobal_1001de050.count-IShotGlobal_1001de048-1; i>=0; --i) {
                NSDictionary *previous = IShotGlobal_1001de050[i];
                if ([key isEqualToString:[NSString stringWithFormat:@"%@%@",previous[@"type"],previous[@"list"]]]) {
                    [previous[@"scrollView"] setFrameOrigin:[previous[@"ScrollViewOrigin"] pointValue]];
                    found = YES; break;
                }
            }
            if (!found) [stroke[@"scrollView"] setHidden:YES];
        }
        [self updateTrackingAreas];
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
        self.needsDisplay = YES;
    }
    if (IShotGlobal_1001de048 == (int)IShotGlobal_1001de050.count) [IShotGlobal_1001de160 disEnableUndoButton];
}
- (void)redoDraw { // 0x100065df8
    if (IShotGlobal_1001de048 < 1) return;
    if (IShotGlobal_1001de048 <= (int)IShotGlobal_1001de050.count) {
        NSDictionary *stroke = IShotGlobal_1001de050[IShotGlobal_1001de050.count-IShotGlobal_1001de048];
        if (([stroke[@"type"] intValue] & ~1U) == 6) {
            NSScrollView *scroll = stroke[@"scrollView"]; scroll.hidden = NO;
            [scroll setFrameOrigin:[stroke[@"ScrollViewOrigin"] pointValue]];
        }
    }
    --IShotGlobal_1001de048;
    [self updateTrackingAreas]; self.needsDisplay = YES;
    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
    [IShotGlobal_1001de160 enableUndoButton];
}
- (void)drawRect:(NSRect)dirtyRect { // 0x100066040
    [super drawRect:dirtyRect];
    [IShotGlobal_1001de060 removeAllObjects];
    [IShotGlobal_1001de060 addObject:[NSString stringWithFormat:@"%@%@",IShotGlobal_1001de058[@"type"],IShotGlobal_1001de058[@"list"]]];
    NSMutableArray *visible=NSMutableArray.new;
    if (IShotGlobal_1001de048 < (int)IShotGlobal_1001de050.count) {
        for (NSInteger i=(NSInteger)IShotGlobal_1001de050.count-IShotGlobal_1001de048-1;i>=0;--i) {
            NSDictionary *stroke=IShotGlobal_1001de050[i];
            NSString *key=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
            if (![IShotGlobal_1001de060 containsObject:key]) { [IShotGlobal_1001de060 addObject:key]; [visible addObject:stroke]; }
        }
    }
    for (NSInteger i=(NSInteger)visible.count-1;i>=0;--i) {
        NSDictionary *stroke=visible[i]; NSInteger type=[stroke[@"type"] integerValue];
        if (type==1) [self drawAllEllipse:stroke];
        else if (type==0) [self drawAllSquare:stroke];
        else if ((type & ~1UL)==2) [self drawAllLine:stroke];
        else if (type==7) [self drawAllNote:stroke withAlpha:0.5f];
        else if (type==6) [self drawAllText:stroke withAlpha:0.5f];
        else if (type==4 && ![stroke[@"indexOfPencilMosaic"] intValue]) [self drawAllPencilPen:stroke];
    }
    [visible removeAllObjects];
    NSInteger type=IShotGlobal_1001de058[@"type"] ? [IShotGlobal_1001de058[@"type"] integerValue] : -1;
    if (IShotGlobal_1001de068==2) {
        if (type==1) [self resizeEllipse]; else if (type==0) [self resizeSquare]; else if ((type & ~1UL)==2) [self resizeLine];
        return;
    }
    if (IShotGlobal_1001de068==0) {
        if (type==2) [self drawLineOfCurrentStroke:IShotGlobal_1001de058];
        else if (type==1) [self drawEllipseOfCurrentStroke:IShotGlobal_1001de058];
        else if (type==0) [self drawSquareOfCurrentStroke:IShotGlobal_1001de058];
        else if (currentFunction==3) [self drawLineOfCurrentStroke:IShotGlobal_1001de058];
        else if (type==7) [self drawAllNote:IShotGlobal_1001de058 withAlpha:1];
        else if (type==6) [self drawAllText:IShotGlobal_1001de058 withAlpha:1];
        else if (type==4 && ![IShotGlobal_1001de058[@"indexOfPencilMosaic"] intValue]) [self drawPencilPenOfCurrentStroke:IShotGlobal_1001de058];
    } else {
        if (type==1) [self moveEllipse:IShotGlobal_1001de058];
        else if (type==0) [self moveSquare:IShotGlobal_1001de058];
        else if ((type & ~1UL)==2) [self moveLine:IShotGlobal_1001de058];
        else if (type==7) [self drawAllNote:IShotGlobal_1001de058 withAlpha:1];
        else if (type==6) [self drawAllText:IShotGlobal_1001de058 withAlpha:1];
        else if (type==4 && ![IShotGlobal_1001de058[@"indexOfPencilMosaic"] intValue]) [self movePencilPen:IShotGlobal_1001de058];
    }
}
- (void)updateTrackingAreas { // 0x1000665c8, removal block 0x100066aac
    [self.trackingAreas enumerateObjectsUsingBlock:^(NSTrackingArea *area, NSUInteger index, BOOL *stop) { [self removeTrackingArea:area]; }];
    int type=IShotGlobal_1001de058[@"type"] ? [IShotGlobal_1001de058[@"type"] intValue] : -1;
    float x1=(float)([IShotGlobal_1001de058[@"X1"] floatValue]-self.frame.origin.x);
    float y1=(float)([IShotGlobal_1001de058[@"Y1"] floatValue]-self.frame.origin.y);
    float x2=(float)([IShotGlobal_1001de058[@"X2"] floatValue]-self.frame.origin.x);
    float y2=(float)([IShotGlobal_1001de058[@"Y2"] floatValue]-self.frame.origin.y);
    if ((uint32_t)type<2) {
        NSArray *rects=[self _calculateAllNeededHandleSquareRects:CGRectMake(x1,y1,(float)(x2-x1),(float)(y2-y1))];
        for (NSUInteger i=0;i<rects.count;++i) {
            NSTrackingArea *area=[[NSTrackingArea alloc] initWithRect:[rects[i] CGRectValue] options:0x41 owner:self userInfo:@{@"number":@((int)i)}];
            [self addTrackingArea:area];
        }
    } else if ((type & ~1U)==2) {
        [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:CGRectMake((float)(x1-5.0f),(float)(y1-5.0f),10,10) options:0x41 owner:self userInfo:@{@"number":@1}]];
        [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:CGRectMake((float)(x2-5.0f),(float)(y2-5.0f),10,10) options:0x41 owner:self userInfo:@{@"number":@2}]];
    }
}
- (void)mouseEntered:(NSEvent *)event { // 0x100066ab8
    if (IShotGlobal_1001f1a08) return;
    IShotGlobal_1001ddfd1=YES;
    if (IShotGlobal_1001de0c0 || !IShotGlobal_1001de088) { IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; return; }
    uint32_t type=[IShotGlobal_1001de058[@"type"] intValue];
    IShotGlobal_1001de078=[[(__bridge NSDictionary *)event.userData objectForKey:@"number"] integerValue];
    uint64_t n=IShotGlobal_1001de078;
    if (type<6 && ((1U<<type)&0x23)) {
        if ((n & ~4ULL)==3) { IShotGlobal_1001dde70=@"Resize_135"; IShotGlobal_1001dddf8=IShotGlobal_1001ddf88; }
        else if ((n & ~4ULL)==2) { IShotGlobal_1001dde70=@"Resize_90"; IShotGlobal_1001dddf8=NSCursor.resizeUpDownCursor; }
        else if ((n & ~4ULL)==1) { IShotGlobal_1001dde70=@"Resize_45"; IShotGlobal_1001dddf8=IShotGlobal_1001ddf90; }
        else if (n==8 || n==4) { IShotGlobal_1001dde70=@"Resize_0"; IShotGlobal_1001dddf8=NSCursor.resizeLeftRightCursor; }
        else if ((int64_t)n>=9) { IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor; }
        else return;
    } else if ((type & ~1U)==2 && n-1<=1) { IShotGlobal_1001dde70=@"Resize"; IShotGlobal_1001dddf8=IShotGlobal_1001ddf98; }
    else return;
    [IShotGlobal_1001dddf8 set];
}
- (void)mouseExited:(NSEvent *)event { // 0x100066dfc; delayed block 0x100066f7c
    if (IShotGlobal_1001f1a08) return;
    IShotGlobal_1001ddfd1=NO;
    if (IShotGlobal_1001de0c0 || !IShotGlobal_1001de088) { IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; return; }
    IShotGlobal_1001de078=[[(__bridge NSDictionary *)event.userData objectForKey:@"number"] integerValue];
    uint32_t type=[IShotGlobal_1001de058[@"type"] intValue];
    if ((type<4 || type==5) && (int64_t)IShotGlobal_1001de078>0) dispatch_after(dispatch_time(DISPATCH_TIME_NOW,100000000),dispatch_get_main_queue(),^{
        if ([IShotGlobal_1001dde70 hasPrefix:@"Resize"]) {
            IShotGlobal_1001dde70=@"WholeMove";
            IShotGlobal_1001dddf8=NSCursor.openHandCursor;
            [NSCursor.openHandCursor set];
        }
    });
}
- (void)setupNewStroke:(int)type AtOrigin:(CGPoint)origin { // 0x1000634cc
    NSDictionary *settings=IShotGlobal_1001de0c8[IShotGlobal_1001de090];
    [IShotGlobal_1001de058 setObject:@(IShotGlobal_1001de160.sliderOfOpacity.floatValue/100.0f) forKey:@"colorAlpha"];
    float size=[settings[@"size"] floatValue];
    NSColor *color=[NSKeyedUnarchiver unarchiveObjectWithData:settings[@"color"]];
    currentFunction=type;
    [IShotGlobal_1001de058 setObject:@([self getListNumberFromArrayOfStrokes:type]+1) forKey:@"list"];
    [IShotGlobal_1001de058 setObject:@(type) forKey:@"type"];
    [IShotGlobal_1001de058 setObject:color forKey:@"color"];
    [IShotGlobal_1001de058 setObject:@(size) forKey:@"size"];
    if ([IShotGlobal_1001de090 isEqualToString:@"arrow"])
        [IShotGlobal_1001de058 setObject:[NSUserDefaults.standardUserDefaults boolForKey:@"normalTypeOfArrow"]?@"1":@"0" forKey:@"normalTypeOfArrow"];
    if ([IShotGlobal_1001de090 isEqualToString:@"pencilPen"]) {
        [arrayOfPoints removeAllObjects];
        [arrayOfPoints addObject:[NSValue valueWithCGPoint:origin]];
        NSInteger index=[NSUserDefaults.standardUserDefaults integerForKey:@"indexOfPencilMosaic"];
        if (IShotGlobal_1001de180) index=0;
        [IShotGlobal_1001de058 setObject:@(index) forKey:@"indexOfPencilMosaic"];
        [IShotGlobal_1001de058 setObject:arrayOfPoints forKey:@"allPoints"];
    } else {
        BOOL square=[IShotGlobal_1001de090 isEqualToString:@"square"];
        BOOL ellipse=!square && [IShotGlobal_1001de090 isEqualToString:@"ellipse"];
        if (square) [IShotGlobal_1001de058 setObject:@([NSUserDefaults.standardUserDefaults boolForKey:@"enableRoundOfSquare"]) forKey:@"enableRoundOfSquare"];
        [IShotGlobal_1001de058 setObject:@(origin.x) forKey:@"X1"];
        [IShotGlobal_1001de058 setObject:@(origin.y) forKey:@"Y1"];
        if (square || ellipse) {
            NSString *key=square?@"filledOfSquare":@"filledOfEllipse";
            [IShotGlobal_1001de058 setObject:@([NSUserDefaults.standardUserDefaults boolForKey:key]) forKey:key];
        }
    }
    if ([IShotGlobal_1001de090 isEqualToString:@"mosaic"])
        [IShotGlobal_1001de058 setObject:@((int)([NSUserDefaults.standardUserDefaults boolForKey:@"selectedGaussianBlured"]^1)) forKey:@"selectedMosaic"];
    if ([IShotGlobal_1001de090 isEqualToString:@"highlight"])
        [IShotGlobal_1001de058 setObject:@((int)([NSUserDefaults.standardUserDefaults boolForKey:@"ellipseOfHighlight"]^1)) forKey:@"squareOfHighlight"];
    if ([IShotGlobal_1001de090 isEqualToString:@"note"]) {
        int serial=1;
        for (NSDictionary *stroke in IShotGlobal_1001de050) if ([stroke[@"type"] intValue]==7) {
            int previous=[stroke[@"serialNumber"] intValue]; if (serial<=previous) serial=previous+1;
        }
        [IShotGlobal_1001de058 setObject:@(serial) forKey:@"serialNumber"];
    }
}
- (void)mousedown:(NSEvent *)event { // 0x1000629dc
    if (IShotGlobal_1001de099 || IShotGlobal_1001de0c1) return;
    IShotGlobal_1001f1a08=0;
    CGPoint p=event.locationInWindow;
    currentFunction=UINT64_MAX; IShotGlobal_1001de068=-1;
    [arrayOfPoints removeAllObjects];
    if ([IShotGlobal_1001dde70 isEqualToString:@"WholeMove"]) {
        IShotGlobal_1001de06c=[IShotGlobal_1001de058[@"type"] intValue];
        if (![self getdicOfCurrentStrokeUnderMouse:p]) return;
        uint32_t type=[IShotGlobal_1001de058[@"type"] intValue];
        if (IShotGlobal_1001de06c!=type && (IShotGlobal_1001de06c & ~1U)==6 && IShotGlobal_1001dde94) {
            IShotGlobal_1001dde94=NO;
            [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"disableTextView" object:nil userInfo:nil];
        }
        if (IShotGlobal_1001de06c==8 || type==8) {
            [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
            [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
        }
        if (IShotGlobal_1001de06c==5 || type==5) [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
        [IShotGlobal_1001de160 adjustColorAndSizeButton:type];
        [IShotGlobal_1001de058 setObject:@(p.x) forKey:@"moveX"];
        [IShotGlobal_1001de058 setObject:@(p.y) forKey:@"moveY"];
        [IShotGlobal_1001de058 removeObjectForKey:@"moveToX"]; [IShotGlobal_1001de058 removeObjectForKey:@"moveToY"];
        IShotGlobal_1001de068=1;
        if ((type & ~1U)==6) {
            [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
            [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
            return;
        }
        self.needsDisplay=YES; return; // original leaves previous-type global unchanged on WholeMove
    }
    if ([IShotGlobal_1001dde70 hasPrefix:@"Resize"]) {
        IShotGlobal_1001de068=2;
        uint32_t type=[IShotGlobal_1001de058[@"type"] intValue];
        if ((type & ~1U)==2) {
            if (IShotGlobal_1001de070==1) p=CGPointMake([IShotGlobal_1001de058[@"X1"] floatValue],[IShotGlobal_1001de058[@"Y1"] floatValue]);
            else if (IShotGlobal_1001de070==2) p=CGPointMake([IShotGlobal_1001de058[@"X2"] floatValue],[IShotGlobal_1001de058[@"Y2"] floatValue]);
            if (type==3 && [IShotGlobal_1001de058[@"normalTypeOfArrow"] isEqualToString:@"1"]) {
                CGPoint c1=NSPointFromString(IShotGlobal_1001de058[@"controlPoint1"]),c2=NSPointFromString(IShotGlobal_1001de058[@"controlPoint2"]);
                if (IShotGlobal_1001de070==3) p=c1; else if (IShotGlobal_1001de070==4) p=c2;
                [IShotGlobal_1001de058 setObject:NSStringFromPoint(c1) forKey:@"controlPoint1"];
                [IShotGlobal_1001de058 setObject:NSStringFromPoint(c2) forKey:@"controlPoint2"];
            }
        }
        [IShotGlobal_1001de058 setObject:@(p.x) forKey:@"moveX"]; [IShotGlobal_1001de058 setObject:@(p.y) forKey:@"moveY"];
        [IShotGlobal_1001de058 removeObjectForKey:@"moveToX"]; [IShotGlobal_1001de058 removeObjectForKey:@"moveToY"];
    } else if ([IShotGlobal_1001dde70 isEqualToString:@"cursorCreateNew"]) {
        IShotGlobal_1001de068=0; [IShotGlobal_1001de058 removeAllObjects];
        [IShotGlobal_1001de160 enableUndoButton]; [IShotGlobal_1001de160 disEnableScrollScreenShotButton];
        NSString *tools[]={@"square",@"ellipse",@"line",@"arrow",@"pencilPen",@"mosaic",@"text",@"note",@"highlight"};
        int type=0; while (type<9 && ![IShotGlobal_1001de090 isEqualToString:tools[type]]) ++type;
        if (type==9) return;
        if (type==6 || type==7) [self reSetUndo];
        [self setupNewStroke:type AtOrigin:p];
        if (type==6 || type==7) {
            NSString *typeKey=type==6?@"typeIndexOfText":@"typeIndexOfNote", *colorKey=type==6?@"colorIndexOfText":@"colorIndexOfNote";
            [IShotGlobal_1001de058 setObject:@([NSUserDefaults.standardUserDefaults integerForKey:typeKey]) forKey:typeKey];
            [IShotGlobal_1001de058 setObject:@([NSUserDefaults.standardUserDefaults integerForKey:colorKey]) forKey:colorKey];
            [IShotGlobal_1001de058 setObject:[NSUserDefaults.standardUserDefaults objectForKey:type==6?@"fontNameOfText":@"fontNameOfNote"] forKey:@"fontName"];
            [self performSelector:@selector(drawRect) withObject:nil afterDelay:0.05]; return;
        }
    }
    uint32_t type=[IShotGlobal_1001de058[@"type"] intValue];
    if (IShotGlobal_1001de06c==8 || type==8) {
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
    }
    if (IShotGlobal_1001de06c==5 || type==5) [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
    IShotGlobal_1001de06c=type; self.needsDisplay=YES;
}
- (void)mouseDragged:(NSEvent *)event { // 0x100063d38
    if (IShotGlobal_1001de099 || IShotGlobal_1001de0c1) return;
    ++IShotGlobal_1001f1a08;
    CGPoint p=event.locationInWindow;
    if (IShotGlobal_1001de068==2) {
        uint32_t type=[IShotGlobal_1001de058[@"type"] intValue];
        BOOL modifier=IShotFunction_10004c448(@[@"Command",@"Option",@"Control",@"Shift"]);
        if (type<2) { if (modifier) p=[self getNewPointForSqureOrEllipse:p]; }
        else if (type==2 || (type==3 && [IShotGlobal_1001de058[@"normalTypeOfArrow"] isEqualToString:@"0"])) { if (modifier) p=[self getNewPointForArrowOrLine:p]; }
        [IShotGlobal_1001de058 setObject:@(p.x) forKey:@"moveToX"]; [IShotGlobal_1001de058 setObject:@(p.y) forKey:@"moveToY"];
        if (type==8 || type==5) { [IShotGlobal_1001de058 setObject:[NSValue valueWithRect:[self getNewRectOfResizeAllStroke]] forKey:@"Rect"]; return; }
    } else if (IShotGlobal_1001de068==1) {
        uint32_t type=[IShotGlobal_1001de058[@"type"] intValue];
        if (type==4 && [IShotGlobal_1001de058[@"indexOfPencilMosaic"] intValue]>0) return;
        float moveX=[IShotGlobal_1001de058[@"moveX"] floatValue],moveY=[IShotGlobal_1001de058[@"moveY"] floatValue];
        [IShotGlobal_1001de058 setObject:@(p.x) forKey:@"moveToX"]; [IShotGlobal_1001de058 setObject:@(p.y) forKey:@"moveToY"];
        if (type==8 || type==5) {
            float x1=[IShotGlobal_1001de058[@"X1"] floatValue],y1=[IShotGlobal_1001de058[@"Y1"] floatValue];
            float x2=[IShotGlobal_1001de058[@"X2"] floatValue],y2=[IShotGlobal_1001de058[@"Y2"] floatValue];
            float dx=0,dy=0;
            if (IShotGlobal_1001de058[@"moveToX"]) {
                dx=[IShotGlobal_1001de058[@"moveToX"] floatValue]-[IShotGlobal_1001de058[@"moveX"] floatValue];
                if (type==5) {
                    if ((float)(x1+dx)<self.frame.origin.x) dx=(float)(self.frame.origin.x-x1);
                    if (self.frame.origin.x+self.frame.size.width<(float)(x2+dx)) dx=(float)(self.frame.origin.x+self.frame.size.width-x2);
                }
                dy=[IShotGlobal_1001de058[@"moveToY"] floatValue]-[IShotGlobal_1001de058[@"moveY"] floatValue];
                if (type==5) {
                    if ((float)(y1+dy)<self.frame.origin.y) dy=(float)(self.frame.origin.y-y1);
                    if (self.frame.origin.y+self.frame.size.height<(float)(y2+dy)) dy=(float)(self.frame.origin.y+self.frame.size.height-y2);
                }
            }
            [IShotGlobal_1001de058 setObject:[NSValue valueWithRect:CGRectMake((float)(x1+dx),(float)(y1+dy),(float)(x2-x1),(float)(y2-y1))] forKey:@"Rect"];
            return;
        }
        if ((type & ~1U)==6) {
            float dx=(float)(p.x-moveX),dy=(float)(p.y-moveY);
            if ([IShotGlobal_1001de058[@"textMoving"] boolValue]) {
                NSScrollView *scroll=IShotGlobal_1001de058[@"scrollView"];
                CGRect start=[IShotGlobal_1001de058[@"startRect"] rectValue];
                [scroll setFrameOrigin:CGPointMake(start.origin.x+dx,start.origin.y+dy)];
                [IShotGlobal_1001de058 setObject:[NSValue valueWithPoint:scroll.frame.origin] forKey:@"ScrollViewOrigin"];
            } else {
                CGPoint start=[IShotGlobal_1001de058[@"startCyclePoint"] pointValue];
                [IShotGlobal_1001de058 setObject:[NSValue valueWithPoint:CGPointMake(start.x+dx,start.y+dy)] forKey:@"cyclePoint"];
            }
        }
    } else if (IShotGlobal_1001de068==0) {
        if (currentFunction-6<2) return;
        if (currentFunction==4) {
            CGPoint last=[arrayOfPoints.lastObject pointValue];
            if ([self distanceBetweenPoint:last and:p]>2.0) {
                [arrayOfPoints addObject:[NSValue valueWithCGPoint:p]];
                [IShotGlobal_1001de058 setObject:arrayOfPoints forKey:@"allPoints"];
            }
        } else {
            BOOL modifier=IShotFunction_10004c448(@[@"Command",@"Option",@"Control",@"Shift"]);
            if (currentFunction<4 && modifier) p=currentFunction<2 ? [self getNewPointForSqureOrEllipse:p] : [self getNewPointForArrowOrLine:p];
            [IShotGlobal_1001de058 setObject:@(p.x) forKey:@"X2"]; [IShotGlobal_1001de058 setObject:@(p.y) forKey:@"Y2"];
            if (currentFunction==3) {
                double x=[IShotGlobal_1001de058[@"X1"] floatValue],y=[IShotGlobal_1001de058[@"Y1"] floatValue];
                double dx=p.x-x,dy=p.y-y;
                [IShotGlobal_1001de058 setObject:NSStringFromPoint(CGPointMake(dx/3.0+x,dy/3.0+y)) forKey:@"controlPoint1"];
                [IShotGlobal_1001de058 setObject:NSStringFromPoint(CGPointMake((dx+dx)/3.0+x,(dy+dy)/3.0+y)) forKey:@"controlPoint2"];
            }
            if (currentFunction==8 || currentFunction==5) { [IShotGlobal_1001de058 setObject:[NSValue valueWithRect:[self getNewRectOfResizeAllStroke]] forKey:@"Rect"]; return; }
        }
    }
    if (![IShotGlobal_1001de058[@"indexOfPencilMosaic"] intValue]) self.needsDisplay=YES;
}
- (void)mouseup:(NSEvent *)event { // 0x1000649e8
    if (IShotGlobal_1001de099 || IShotGlobal_1001de0c1) return;
    CGPoint p=event.locationInWindow;
    if (IShotGlobal_1001de068==0) {
        if (currentFunction==4) {
            if (IShotGlobal_1001f1a08<6) [IShotGlobal_1001de058 removeAllObjects];
            else {
                [self reSetUndo]; [arrayOfPoints addObject:[NSValue valueWithCGPoint:p]];
                [IShotGlobal_1001de058 setObject:arrayOfPoints.copy forKey:@"allPoints"]; [arrayOfPoints removeAllObjects];
                if (![IShotGlobal_1001de058[@"indexOfPencilMosaic"] intValue]) [IShotGlobal_1001de050 addObject:IShotGlobal_1001de058.copy];
            }
        } else if (IShotGlobal_1001f1a08>5) {
            [self reSetUndo];
            if ((currentFunction & ~1ULL)==6) return;
            float x1=[IShotGlobal_1001de058[@"X1"] floatValue],y1=[IShotGlobal_1001de058[@"Y1"] floatValue];
            BOOL modifier=IShotFunction_10004c448(@[@"Command",@"Option",@"Control",@"Shift"]);
            if (currentFunction<4 && modifier) p=currentFunction<2 ? [self getNewPointForSqureOrEllipse:p] : [self getNewPointForArrowOrLine:p];
            float x2=p.x,y2=p.y;
            if ((currentFunction & ~1ULL)!=2) {
                if (x1>x2) {float t=x1;x1=x2;x2=t;}
                if (y1>y2) {float t=y1;y1=y2;y2=t;}
            }
            [IShotGlobal_1001de058 setObject:@(x1) forKey:@"X1"]; [IShotGlobal_1001de058 setObject:@(y1) forKey:@"Y1"];
            [IShotGlobal_1001de058 setObject:@(x2) forKey:@"X2"]; [IShotGlobal_1001de058 setObject:@(y2) forKey:@"Y2"];
            [IShotGlobal_1001de050 addObject:IShotGlobal_1001de058.copy];
        } else {
            if ((currentFunction & ~1ULL)!=6) [IShotGlobal_1001de058 removeAllObjects];
            if (currentFunction==8 || currentFunction==5) {
                [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
                [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
            }
        }
    } else if (IShotGlobal_1001de068==1 && IShotGlobal_1001f1a08>5) {
        [self reSetUndo];
        int type=[IShotGlobal_1001de058[@"type"] intValue];
        if (type==4 && [IShotGlobal_1001de058[@"indexOfPencilMosaic"] intValue]>0) return;
        float x1=[IShotGlobal_1001de058[@"X1"] floatValue],y1=[IShotGlobal_1001de058[@"Y1"] floatValue];
        float x2=[IShotGlobal_1001de058[@"X2"] floatValue],y2=[IShotGlobal_1001de058[@"Y2"] floatValue];
        float dx=(float)(p.x-[IShotGlobal_1001de058[@"moveX"] floatValue]),dy=(float)(p.y-[IShotGlobal_1001de058[@"moveY"] floatValue]);
        if (type==5) {
            if ((float)(x1+dx)<self.frame.origin.x) dx=(float)(self.frame.origin.x-x1);
            if (self.frame.origin.x+self.frame.size.width<(float)(x2+dx)) dx=(float)(self.frame.origin.x+self.frame.size.width-x2);
            if ((float)(y1+dy)<self.frame.origin.y) dy=(float)(self.frame.origin.y-y1);
            if (self.frame.origin.y+self.frame.size.height<(float)(y2+dy)) dy=(float)(self.frame.origin.y+self.frame.size.height-y2);
        }
        [IShotGlobal_1001de058 setObject:@((float)(x1+dx)) forKey:@"X1"]; [IShotGlobal_1001de058 setObject:@((float)(y1+dy)) forKey:@"Y1"];
        [IShotGlobal_1001de058 setObject:@((float)(x2+dx)) forKey:@"X2"]; [IShotGlobal_1001de058 setObject:@((float)(y2+dy)) forKey:@"Y2"];
        if (type==3 && [IShotGlobal_1001de058[@"normalTypeOfArrow"] isEqualToString:@"1"]) {
            CGPoint c1=NSPointFromString(IShotGlobal_1001de058[@"controlPoint1"]),c2=NSPointFromString(IShotGlobal_1001de058[@"controlPoint2"]);
            [IShotGlobal_1001de058 setObject:NSStringFromPoint(CGPointMake(c1.x+dx,c1.y+dy)) forKey:@"controlPoint1"];
            [IShotGlobal_1001de058 setObject:NSStringFromPoint(CGPointMake(c2.x+dx,c2.y+dy)) forKey:@"controlPoint2"];
        }
        if (type==4) {
            NSMutableArray *moved=[[NSMutableArray alloc] initWithCapacity:20]; NSArray *points=IShotGlobal_1001de058[@"allPoints"];
            for (NSUInteger i=0;i<points.count;++i) { CGPoint q=[points[i] CGPointValue]; [moved addObject:[NSValue valueWithPoint:CGPointMake(q.x+dx,q.y+dy)]]; }
            [IShotGlobal_1001de058 removeObjectForKey:@"moveToX"]; [IShotGlobal_1001de058 removeObjectForKey:@"moveToY"];
            [IShotGlobal_1001de058 setObject:moved forKey:@"allPoints"];
        } else { [IShotGlobal_1001de058 removeObjectForKey:@"moveToX"]; [IShotGlobal_1001de058 removeObjectForKey:@"moveToY"]; }
        [IShotGlobal_1001de050 addObject:IShotGlobal_1001de058.copy];
    } else if (IShotGlobal_1001de068==2 && IShotGlobal_1001f1a08>=6) {
        [self reSetUndo];
        uint32_t type=[IShotGlobal_1001de058[@"type"] intValue];
        float x2,y2;
        if ((type & ~1U)==2) {
            float x1=[IShotGlobal_1001de058[@"X1"] floatValue],y1=[IShotGlobal_1001de058[@"Y1"] floatValue];
            x2=[IShotGlobal_1001de058[@"X2"] floatValue]; y2=[IShotGlobal_1001de058[@"Y2"] floatValue];
            float dx=[IShotGlobal_1001de058[@"moveToX"] floatValue]-[IShotGlobal_1001de058[@"moveX"] floatValue];
            float dy=[IShotGlobal_1001de058[@"moveToY"] floatValue]-[IShotGlobal_1001de058[@"moveY"] floatValue];
            if (IShotGlobal_1001de070==2) {x2+=dx;y2+=dy;} else if (IShotGlobal_1001de070==1) {x1+=dx;y1+=dy;}
            [IShotGlobal_1001de058 setObject:@(x1) forKey:@"X1"]; [IShotGlobal_1001de058 setObject:@(y1) forKey:@"Y1"];
            if (type==3 && [IShotGlobal_1001de058[@"normalTypeOfArrow"] isEqualToString:@"1"]) {
                CGPoint c1=NSPointFromString(IShotGlobal_1001de058[@"controlPoint1"]),c2=NSPointFromString(IShotGlobal_1001de058[@"controlPoint2"]);
                if (IShotGlobal_1001de070==4) {c2.x+=dx;c2.y+=dy;} else if (IShotGlobal_1001de070==3) {c1.x+=dx;c1.y+=dy;}
                [IShotGlobal_1001de058 setObject:NSStringFromPoint(c1) forKey:@"controlPoint1"]; [IShotGlobal_1001de058 setObject:NSStringFromPoint(c2) forKey:@"controlPoint2"];
            } else if (IShotFunction_10004c448(@[@"Command",@"Option",@"Control",@"Shift"])) { CGPoint q=[self getNewPointForArrowOrLine:CGPointMake(x2,y2)];x2=q.x;y2=q.y; }
        } else {
            CGRect r=[self getNewRectOfResizeAllStroke];
            float x=(float)((r.origin.x+r.size.width*0.5)-(double)((float)r.size.width*0.5f));
            float y=(float)((r.origin.y+r.size.height*0.5)-(double)((float)r.size.height*0.5f));
            [IShotGlobal_1001de058 setObject:@(x) forKey:@"X1"]; [IShotGlobal_1001de058 setObject:@(y) forKey:@"Y1"];
            x2=(float)r.size.width+x; y2=(float)r.size.height+y;
        }
        [IShotGlobal_1001de058 setObject:@(x2) forKey:@"X2"]; [IShotGlobal_1001de058 setObject:@(y2) forKey:@"Y2"];
        [IShotGlobal_1001de058 removeObjectForKey:@"moveToX"]; [IShotGlobal_1001de058 removeObjectForKey:@"moveToY"];
        [IShotGlobal_1001de050 addObject:IShotGlobal_1001de058.copy];
    }
    IShotGlobal_1001f1a08=0;
    if (currentFunction!=5 && currentFunction!=8) { self.needsDisplay=YES; [self updateTrackingAreas]; }
}

- (BOOL)getdicOfCurrentStrokeUnderMouse:(CGPoint)p { // 0x10006a620; reverse traversal deduplicates type/list before testing
    NSMutableArray *seen=NSMutableArray.new;
    if (IShotGlobal_1001de048 >= (int)IShotGlobal_1001de050.count) return NO;
    for (NSInteger i=(NSInteger)IShotGlobal_1001de050.count-IShotGlobal_1001de048-1;i>=0;--i) {
        NSDictionary *stroke=IShotGlobal_1001de050[i];
        NSString *key=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
        if ([seen containsObject:key]) continue;
        [seen addObject:key];
        NSInteger type=[stroke[@"type"] integerValue];
        float x1=[stroke[@"X1"] floatValue],y1=[stroke[@"Y1"] floatValue],x2=[stroke[@"X2"] floatValue],y2=[stroke[@"Y2"] floatValue];
        int size=[stroke[@"size"] intValue],margin=(size+1)/2;
        if (margin<6) margin=5;
        CGPoint a=CGPointMake(x1,y1),b=CGPointMake(x2,y2);
        if (type==6 || type==7) {
            CGRect original=[stroke[@"scrollView"] frame]; double padding=size/15+2;
            CGRect r=CGRectMake(original.origin.x-padding-3,original.origin.y-3,original.size.width+padding*0.9+8,original.size.height+8);
            if (NSPointInRect(p,NSInsetRect(r,-9,-9))) {
                IShotGlobal_1001de058=[NSMutableDictionary dictionaryWithDictionary:stroke];
                [IShotGlobal_1001de058 setObject:@"1" forKey:@"textMoving"];
                [IShotGlobal_1001de058 setObject:[NSValue valueWithRect:original] forKey:@"startRect"];
                self.needsDisplay=YES; return YES;
            }
            if (type==7) {
                CGPoint c=[stroke[@"cyclePoint"] pointValue];
                double radius=[stroke[@"size"] floatValue]/5.0f+11.0f;
                if (NSPointInRect(p,CGRectMake(c.x-radius*0.8-1,c.y-radius*0.8-1,radius*1.6+2,radius*1.6+2))) {
                    IShotGlobal_1001de058=[NSMutableDictionary dictionaryWithDictionary:stroke];
                    [IShotGlobal_1001de058 setObject:@"0" forKey:@"textMoving"];
                    [IShotGlobal_1001de058 setObject:[NSValue valueWithPoint:c] forKey:@"startCyclePoint"];
                    self.needsDisplay=YES; return YES;
                }
            }
            continue;
        }
        BOOL hit=(^BOOL{
            switch(type) {
                case 0: case 5: case 8: {
                    CGRect r=CGRectMake(x1,y1,(float)(x2-x1),(float)(y2-y1));
                    if ((type!=0 || ![stroke[@"filledOfSquare"] boolValue]) && NSPointInRect(p,CGRectInset(r,margin,margin))) return NO;
                    return NSPointInRect(p,CGRectInset(r,-margin,-margin));
                }
                case 1: {
                    float dx=(float)(p.x-(double)((x1+x2)*0.5f)),dy=(float)(p.y-(double)((y1+y2)*0.5f));
                    float rx=fabsf(x2-x1)*0.5f,ry=fabsf(y2-y1)*0.5f; dx*=dx;dy*=dy;
                    if ([stroke[@"filledOfEllipse"] boolValue]) return dx/(rx*rx)+dy/(ry*ry)<1.0f;
                    float mx=rx+(float)margin,my=ry+(float)margin;
                    float outer=dx/(mx*mx)+dy/(my*my);
                    mx=rx-(float)margin;my=ry-(float)margin;
                    return outer<1.0f && dx/(mx*mx)+dy/(my*my)>1.0f;
                }
                case 2:return [self point:a andPoint:b crossWithCyclePoint:p radius:(float)((size/2>3?size/2:3)+1)];
        case 3: {
            if ([stroke[@"normalTypeOfArrow"] isEqualToString:@"1"]) {
                CGPoint c1 = NSPointFromString(stroke[@"controlPoint1"]), c2 = NSPointFromString(stroke[@"controlPoint2"]);
                uint32_t width = size > 3 ? (uint32_t)size : 3;
                NSBezierPath *path = NSBezierPath.bezierPath;
                [path moveToPoint:a];
                [path curveToPoint:b controlPoint1:c1 controlPoint2:c2];
                CGPoint previous = a;
                for (int i=0; i<100; ++i) {
                    CGPoint q = IShotFunction_10004cdb8(a,c1,c2,b,(double)i/100.0);
                    float radius = i ? (float)((double)(int32_t)width*0.5) : (float)(width>>1);
                    if ([self point:previous andPoint:q crossWithCyclePoint:p radius:radius]) return YES;
                    previous = q;
                }
                double dx = b.x-c2.x, dy = b.y-c2.y, width3 = (int32_t)(width+3);
                double length = hypot(dx,dy), nx = (dx/length)*width3, ny = (dy/length)*width3;
                double norm = sqrt(dy*dy+dx*dx), px = (-dy/norm)*width3, py = (dx/norm)*width3;
                return IShotFunction_10004ce78(p, CGPointMake(px+b.x,py+b.y), CGPointMake(b.x-px,b.y-py), CGPointMake(nx+nx+b.x,ny+ny+b.y));
            }
            if (![stroke[@"normalTypeOfArrow"] isEqualToString:@"0"]) return NO;
            double scale = [self distanceBetweenPoint:a and:b]/30.0;
            double angle = [self angleBetweenPoint:b and:a];
            double dx = p.x-a.x, dy = p.y-a.y;
            double along = dx*cos(angle)+dy*sin(angle), across = fabs(dy*cos(angle)-dx*sin(angle))-1.0;
            double thickness = (double)(int32_t)((uint32_t)size*3U+2U)/scale, shoulder = scale*(thickness*-1.1+30.0);
            if (along > 0.0 && along < shoulder) {
                double edge = [self angleBetweenPoint:CGPointMake(scale*(30.0-thickness), scale*(thickness*0.4)) and:CGPointMake(0,scale*0.05)];
                double test = [self angleBetweenPoint:CGPointMake(along,across) and:CGPointMake(0,scale*0.05)];
                return edge > test;
            }
            if (!(along < scale*30.0) || !(along > 0.0)) return NO;
            double edge = [self angleBetweenPoint:CGPointMake(shoulder,scale*(thickness*0.8)) and:CGPointMake(scale*30.0,0)];
            double test = [self angleBetweenPoint:CGPointMake(along,across) and:CGPointMake(scale*30.0,0)];
            return fabs(edge) < fabs(test);
        }
                case 4: {
                    NSArray *points=stroke[@"allPoints"]; int half=(size+1)/2;float radius=half>4?half:4;
                    for (NSUInteger n=0;n<points.count-1;++n) if ([self point:[points[n] CGPointValue] andPoint:[points[n+1] CGPointValue] crossWithCyclePoint:p radius:radius]) return YES;
                    return NO;
                }
                default:return NO;
            }
        })();
        if (hit) {IShotGlobal_1001de058=[NSMutableDictionary dictionaryWithDictionary:stroke];return YES;}
    }
    return NO;
}
