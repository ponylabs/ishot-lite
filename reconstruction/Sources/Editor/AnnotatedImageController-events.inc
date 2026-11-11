- (void)setTextColor:(NSColor *)color inView:(NSView *)view { // 0x100079f0c
    for (NSView *child in view.subviews) {
        if ([child isKindOfClass:NSTextField.class]) [(NSTextField *)child setTextColor:color];
        [self setTextColor:color inView:child];
    }
}
- (void)flagsChanged:(NSEvent *)event { // 0x10007cfd0
    NSString *modifier = [NSUserDefaults.standardUserDefaults stringForKey:@"doubleClickModifierKey"];
    NSUInteger flags = event.modifierFlags;
    if ([modifier isEqualToString:@"Command"]) {
        if ((flags & 0x1e0000) == 0) {
            if (IShotGlobal_1001f1a40 == YES) {
                double time = NSDate.date.timeIntervalSince1970 * 1000.0;
                if (time - IShotGlobal_1001f1a50 < 500.0) { IShotGlobal_1001de089 = YES; [self saveButtonClick:self]; }
                IShotGlobal_1001f1a40 = NO; IShotGlobal_1001f1a50 = time;
            }
        } else if ((flags & 0x1e0000) == 0x100000) IShotGlobal_1001f1a40 = YES;
    } else if ([modifier isEqualToString:@"Option"]) {
        if ((flags & 0x1e0000) == 0) {
            if (IShotGlobal_1001f1a41 == YES) {
                double time = NSDate.date.timeIntervalSince1970 * 1000.0;
                if (time - IShotGlobal_1001f1a58 < 500.0) { IShotGlobal_1001de089 = YES; [self saveButtonClick:self]; }
                IShotGlobal_1001f1a41 = NO; IShotGlobal_1001f1a58 = time;
            }
        } else if ((flags & 0x1e0000) == 0x80000) IShotGlobal_1001f1a41 = YES;
    } else if ([modifier isEqualToString:@"Control"]) {
        if ((flags & 0x1e0000) == 0) {
            if (IShotGlobal_1001f1a42 == YES) {
                double time = NSDate.date.timeIntervalSince1970 * 1000.0;
                if (time - IShotGlobal_1001f1a60 < 500.0) { IShotGlobal_1001de089 = YES; [self saveButtonClick:self]; }
                IShotGlobal_1001f1a42 = NO; IShotGlobal_1001f1a60 = time;
            }
        } else if ((flags & 0x1e0000) == 0x40000) IShotGlobal_1001f1a42 = YES;
    }
}
- (void)checkMouseIfOnTipsBox { // 0x10007d274; ARM64 d9/d8 at 0x10007d358
    CGEventRef event = CGEventCreate(NULL);
    CGPoint point = CGEventGetLocation(event);
    if (event) CFRelease(event);
    NSScreen *screen = NSScreen.currentScreenForMouseLocation;
    if (IShotGlobal_1001dde80) screen = IShotGlobal_1001dde80;
    point.x -= screen.frame.origin.x;
    point.y = NSScreen.deepestScreen.frame.size.height - screen.frame.origin.y - point.y;
    if (!NSPointInRect(point, self.openedBoxOfTips.frame)) [self disableTips];
}
- (void)scrollWheelFromTextView:(NSEvent *)event { // 0x100087174, block 0x10008722c
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 50000000), dispatch_get_main_queue(), ^{
        if (IShotGlobal_1001de0d7 || !IShotGlobal_1001de058.count || IShotFunction_10004d490(event)) return;
        if (([IShotGlobal_1001de058[@"type"] intValue] & 0xfffffffeU) != 6) return;
        NSTextView *text = IShotGlobal_1001de058[@"textView"];
        NSColor *color = text.textColor;
        float alpha = (float)color.alphaComponent;
        float delta = (float)event.deltaY;
        if (delta > 0.0f) alpha = (float)((double)alpha + 0.05);
        else if (delta < 0.0f) alpha = (float)((double)alpha - 0.05);
        // FMAX/FMIN, not the decompiler's omitted lower clamp. Preserve NaN propagation.
        alpha = isnan(alpha) ? alpha : fminf(fmaxf(alpha, 0.0f), 1.0f);
        color = [color colorWithAlphaComponent:(double)(alpha == 0.0f ? 0.01f : alpha)];
        text.textColor = color;
        text.insertionPointColor = [color colorWithAlphaComponent:1.0];
        self.sliderOfOpacity.intValue = (int)(alpha * 100.0f);
        self.displayOpacity.intValue = self.sliderOfOpacity.intValue;
        [IShotGlobal_1001de050 removeObject:IShotGlobal_1001de058];
        [IShotGlobal_1001de058 setObject:@(alpha) forKey:@"colorAlpha"];
        if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
        NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
        [settings setObject:@(alpha) forKey:@"colorAlpha"];
        [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
    });
}
- (void)adjustColorOpacityByScrollWheelEvent:(float)delta { // 0x100087f78
    int type = [IShotGlobal_1001de058[@"type"] intValue];
    if (type == 5) return;
    float alpha = IShotGlobal_1001de058[@"colorAlpha"] ? [IShotGlobal_1001de058[@"colorAlpha"] floatValue] : 1.0f;
    if (delta > 0.0f) alpha = (float)((double)alpha + 0.05);
    else if (delta < 0.0f) alpha = (float)((double)alpha - 0.05);
    alpha = isnan(alpha) ? alpha : fminf(fmaxf(alpha, 0.0f), 1.0f);
    [IShotGlobal_1001de050 removeObject:IShotGlobal_1001de058];
    [IShotGlobal_1001de058 setObject:[NSString stringWithFormat:@"%.2f", (double)alpha] forKey:@"colorAlpha"];
    if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
    self.displayOpacity.stringValue = [NSString stringWithFormat:@"%.f", (double)(alpha * 100.0f)];
    self.sliderOfOpacity.intValue = (int)(alpha * 100.0f);
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
    [settings setObject:@(alpha) forKey:@"colorAlpha"];
    [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
    if (type == 8) [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    else [(NSView *)annotatedImageView setNeedsDisplay:YES];
}
- (void)refreshAllSizeAndDrawRect:(NSString *)tool { // 0x10008446c
    NSColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:IShotGlobal_1001de0c8[tool][@"color"]];
    int size = [IShotGlobal_1001de0c8[tool][@"size"] intValue];
    self.displaySize.stringValue = [NSString stringWithFormat:@"%d", size];
    if ([tool isEqualToString:@"highlight"]) self.displaySize.stringValue = [NSString stringWithFormat:@"%.f", (double)size * 2.5];
    self.sliderOfSize.intValue = self.displaySize.stringValue.intValue;
    if (IShotGlobal_1001de058[@"type"]) {
        NSColor *oldColor = IShotGlobal_1001de058[@"color"];
        int oldSize = [IShotGlobal_1001de058[@"size"] intValue];
        if (![color isEqual:oldColor] || oldSize != size) {
            [IShotGlobal_1001de050 removeObject:IShotGlobal_1001de058];
            [IShotGlobal_1001de058 setObject:color forKey:@"color"];
            [IShotGlobal_1001de058 setObject:@(size) forKey:@"size"];
            unsigned type = [IShotGlobal_1001de058[@"type"] intValue];
            if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            if ((type & 0xfffffffeU) == 6) {
                NSTextView *text = IShotGlobal_1001de058[@"textView"];
                text.textColor = color;
                text.insertionPointColor = color;
                if (oldSize != size) [self adjustTextSizeOrFont];
            }
            if (type == 5 || type == 8) {
                NSDistributedNotificationCenter *center = NSDistributedNotificationCenter.defaultCenter;
                if (type == 8) [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
                [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
            } else [(NSView *)annotatedImageView setNeedsDisplay:YES];
        }
    }
    [self resetCursor];
}
- (void)refreshAllButtonState { // 0x100082834
    if ([IShotGlobal_1001de090 isEqualToString:@"square"]) self.squareButton.image = [NSImage imageNamed:@"square_on"];
    else if ([IShotGlobal_1001de090 isEqualToString:@"ellipse"]) self.ellipseButton.image = [NSImage imageNamed:@"ellipse_on"];
    else if ([IShotGlobal_1001de090 isEqualToString:@"line"]) self.lineButton.image = [NSImage imageNamed:@"line_on"];
    else if ([IShotGlobal_1001de090 isEqualToString:@"arrow"]) self.arrowButton.image = [NSImage imageNamed:@"arrow_on"];
    else if ([IShotGlobal_1001de090 isEqualToString:@"pencilPen"]) self.pencilPenButton.image = [NSImage imageNamed:@"pencilPen_on"];
    else if ([IShotGlobal_1001de090 isEqualToString:@"mosaic"]) self.mosaicButton.image = [NSImage imageNamed:@"mosaic_on"];
    else if ([IShotGlobal_1001de090 isEqualToString:@"text"]) self.textButton.image = [NSImage imageNamed:@"text_on"];
    else if ([IShotGlobal_1001de090 isEqualToString:@"note"]) self.noteButton.image = [NSImage imageNamed:@"note_on"];
    else if ([IShotGlobal_1001de090 isEqualToString:@"highlight"]) self.highlightButton.image = [NSImage imageNamed:@"highlight_on"];
    else if ([IShotGlobal_1001de090 isEqualToString:@"zoom"]) self.mosaicButton.image = [NSImage imageNamed:@"zoom_on"];
    BOOL dark = [self.window.effectiveAppearance.name isEqualToString:@"NSAppearanceNameDarkAqua"];
    if ([IShotGlobal_1001f1a38 isEqualToString:@"square"] && ![IShotGlobal_1001de090 isEqualToString:@"square"]) self.squareButton.image = [NSImage imageNamed:dark ? @"square_off" : @"squareDark_off"];
    else if ([IShotGlobal_1001f1a38 isEqualToString:@"ellipse"] && ![IShotGlobal_1001de090 isEqualToString:@"ellipse"]) self.ellipseButton.image = [NSImage imageNamed:dark ? @"ellipse_off" : @"ellipseDark_off"];
    else if ([IShotGlobal_1001f1a38 isEqualToString:@"line"] && ![IShotGlobal_1001de090 isEqualToString:@"line"]) self.lineButton.image = [NSImage imageNamed:dark ? @"line_off" : @"lineDark_off"];
    else if ([IShotGlobal_1001f1a38 isEqualToString:@"arrow"] && ![IShotGlobal_1001de090 isEqualToString:@"arrow"]) self.arrowButton.image = [NSImage imageNamed:dark ? @"arrow_off" : @"arrowDark_off"];
    else if ([IShotGlobal_1001f1a38 isEqualToString:@"pencilPen"] && ![IShotGlobal_1001de090 isEqualToString:@"pencilPen"]) self.pencilPenButton.image = [NSImage imageNamed:dark ? @"pencilPen_off" : @"pencilPenDark_off"];
    else if ([IShotGlobal_1001f1a38 isEqualToString:@"mosaic"] && ![IShotGlobal_1001de090 isEqualToString:@"mosaic"]) self.mosaicButton.image = [NSImage imageNamed:dark ? @"mosaic_off" : @"mosaicDark_off"];
    else if ([IShotGlobal_1001f1a38 isEqualToString:@"text"] && ![IShotGlobal_1001de090 isEqualToString:@"text"]) self.textButton.image = [NSImage imageNamed:dark ? @"text_off" : @"textDark_off"];
    else if ([IShotGlobal_1001f1a38 isEqualToString:@"note"] && ![IShotGlobal_1001de090 isEqualToString:@"note"]) self.noteButton.image = [NSImage imageNamed:dark ? @"note_off" : @"noteDark_off"];
    else if ([IShotGlobal_1001f1a38 isEqualToString:@"highlight"] && ![IShotGlobal_1001de090 isEqualToString:@"highlight"]) self.highlightButton.image = [NSImage imageNamed:dark ? @"highlight_off" : @"highlightDark_off"];
    else if ([IShotGlobal_1001f1a38 isEqualToString:@"zoom"] && ![IShotGlobal_1001de090 isEqualToString:@"zoom"] && IShotGlobal_1001de180) self.mosaicButton.image = [NSImage imageNamed:dark ? @"zoom_off" : @"zoomDark_off"];
}
- (void)OCRButtonClick:(id)sender { // Lite retains this button only when the original recording mode uses it for Save.
    if (IShotGlobal_1001de180) [self saveButtonClick:self]; }
- (void)mapButtonClick:(id)sender { // 0x1000837c0
    if (!IShotGlobal_1001de180) {
        IShotGlobal_1001de0d5 = YES;
        [self saveButtonClick:self];
        IShotGlobal_1001de0d6 = NO;
    } else {
        for (NSUInteger i = 0; i < IShotGlobal_1001de050.count; ++i) {
            NSDictionary *stroke = IShotGlobal_1001de050[i];
            if (([stroke[@"type"] integerValue] & ~1ULL) == 6) [stroke[@"scrollView"] removeFromSuperview];
        }
        if (([IShotGlobal_1001de058[@"type"] integerValue] & ~1ULL) == 6) [IShotGlobal_1001de058[@"scrollView"] removeFromSuperview];
        self.undoButton.enabled = NO;
        [IShotGlobal_1001de050 removeAllObjects];
        [IShotGlobal_1001de058 removeAllObjects];
        IShotGlobal_1001de048 = 0;
        NSDistributedNotificationCenter *center = NSDistributedNotificationCenter.defaultCenter;
        [(NSView *)annotatedImageView setNeedsDisplay:YES];
        [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
        [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    }
}
- (void)saveButtonClick:(id)sender { // 0x100083a78
    if ([IShotGlobal_1001de090 isEqualToString:@"text"] || [IShotGlobal_1001de090 isEqualToString:@"note"])
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"disableTextView" object:nil userInfo:nil];
    if (!IShotGlobal_1001de180) {
        IShotGlobal_1001dddf0 = NO;
        [self hiddenButton];
        IShotGlobal_1001de0d6 = YES;
        [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
        if (IShotGlobal_1001de099) {
            self.openedBoxOfTips.transparent = YES;
            self.openedBoxOfTips.hidden = YES;
            IShotGlobal_1001de099 = NO;
            [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
        }
        IShotGlobal_1001de0d0 = YES;
        IShotGlobal_1001de0d1 = NO;
        NSDistributedNotificationCenter *center = NSDistributedNotificationCenter.defaultCenter;
        if (!IShotGlobal_1001de0c0) {
            [IShotGlobal_1001de058 removeAllObjects];
            [(NSView *)annotatedImageView setNeedsDisplay:YES];
            [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
            [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
        }
        [center postNotificationName:@"StartScreenShots" object:nil userInfo:nil];
        [self.backgroundImageWindow close];
    } else {
        CGRect rect = [(NSView *)annotatedImageView frame];
        CGRect screen = self.window.screen.frame;
        rect.origin.x += screen.origin.x;
        rect.origin.y = NSScreen.deepestScreen.frame.size.height - screen.origin.y - rect.origin.y - rect.size.height;
        CGImageRef ref = IShotCGWindowListCreateImage(rect, 1, 0, 0);
        NSImage *image = [[NSImage alloc] initWithCGImage:ref size:rect.size];
        [[AppDelegate appDelegate] saveImageToFile:image];
        if (ref) CFRelease(ref);
    }
}
- (void)adjustColorAndSizeButton:(int)index { // 0x1000848fc
    IShotGlobal_1001de090 = @"";
    IShotGlobal_1001dd440 = index;
    switch (index) {
        case 0: [self squareButtonState]; IShotGlobal_1001de090 = @"square"; break;
        case 1: [self ellipseButtonState]; IShotGlobal_1001de090 = @"ellipse"; break;
        case 2: [self lineButtonState]; IShotGlobal_1001de090 = @"line"; break;
        case 3: [self arrowButtonState]; IShotGlobal_1001de090 = @"arrow"; break;
        case 4: [self pencilPenButtonState]; IShotGlobal_1001de090 = @"pencilPen"; break;
        case 5: [self mosaicButtonState]; break;
        case 6: [self textButtonState]; IShotGlobal_1001de090 = @"text"; break;
        case 7: [self noteButtonState]; IShotGlobal_1001de090 = @"note"; break;
        case 8: [self highlightButtonState]; IShotGlobal_1001de090 = @"highlight"; break;
    }
    NSData *userData = [NSUserDefaults.standardUserDefaults dictionaryForKey:@"DataOfUsers"][IShotGlobal_1001de090][@"userColor"];
    NSColor *userColor = userData ? [NSKeyedUnarchiver unarchiveObjectWithData:userData] : nil;
    if (!userColor) userColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"ColorPanel"]];
    self.userColorSingleBox.fillColor = userColor;
    NSColor *color;
    int size, opacity;
    if (!IShotGlobal_1001de058.count) {
        color = [NSKeyedUnarchiver unarchiveObjectWithData:IShotGlobal_1001de0c8[IShotGlobal_1001de090][@"color"]];
        size = [IShotGlobal_1001de0c8[IShotGlobal_1001de090][@"size"] intValue];
        if (!IShotGlobal_1001de0c8[IShotGlobal_1001de090][@"colorAlpha"]) opacity = [IShotGlobal_1001de090 isEqualToString:@"highlight"] ? 50 : 100;
        else opacity = (int)([IShotGlobal_1001de0c8[IShotGlobal_1001de090][@"colorAlpha"] floatValue] * 100.0f);
    } else {
        color = IShotGlobal_1001de058[@"color"];
        size = [IShotGlobal_1001de058[@"size"] intValue];
        if (!IShotGlobal_1001de058[@"colorAlpha"]) opacity = [IShotGlobal_1001de090 isEqualToString:@"highlight"] ? 50 : 100;
        else opacity = (int)([IShotGlobal_1001de058[@"colorAlpha"] floatValue] * 100.0f);
    }
    [self getActivedColorBox:color];
    if ([IShotGlobal_1001de090 isEqualToString:@"note"] || [IShotGlobal_1001de090 isEqualToString:@"text"]) {
        self.sliderOfSize.minValue = 10.0; self.sliderOfSize.maxValue = 100.0;
    } else {
        BOOL mosaic = [IShotGlobal_1001de090 isEqualToString:@"mosaic"];
        self.sliderOfSize.minValue = 1.0; self.sliderOfSize.maxValue = mosaic ? 10.0 : 40.0;
    }
    BOOL sizeEnabled = ![IShotGlobal_1001de090 isEqualToString:@"highlight"];
    self.textFieldOfSize.textColor = sizeEnabled ? NSColor.textColor : NSColor.grayColor;
    self.displaySize.textColor = sizeEnabled ? NSColor.textColor : NSColor.grayColor;
    self.sliderOfSize.enabled = sizeEnabled;
    BOOL opacityEnabled = ![IShotGlobal_1001de090 isEqualToString:@"mosaic"];
    self.textFieldOfOpacity.textColor = opacityEnabled ? NSColor.textColor : NSColor.grayColor;
    self.displayOpacity.textColor = opacityEnabled ? NSColor.textColor : NSColor.grayColor;
    self.sliderOfOpacity.enabled = opacityEnabled;
    self.displaySize.stringValue = [NSString stringWithFormat:@"%d", size];
    self.sliderOfSize.intValue = self.displaySize.stringValue.intValue;
    self.displayOpacity.intValue = opacity;
    self.sliderOfOpacity.intValue = opacity;
    if (![IShotGlobal_1001de090 isEqualToString:@"text"] && ![IShotGlobal_1001de090 isEqualToString:@"note"]) {
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"disableTextView" object:nil userInfo:nil];
        [(NSView *)annotatedImageView setNeedsDisplay:YES];
    }
    [self resetCursor];
}
- (void)costomHotKey { // 0x100086ebc
    if (IShotGlobal_1001de0c0) {
        id save = [NSUserDefaults.standardUserDefaults objectForKey:@"saveShortcut"];
        if (save) RegisterEventHotKey(IShotFunction_100048db8(save), 0, (EventHotKeyID){0x53686f74, 1}, GetApplicationEventTarget(), 0, &IShotGlobal_1001f1a70);
        id copy = [NSUserDefaults.standardUserDefaults objectForKey:@"copyToPasteShortcut"];
        if (copy) RegisterEventHotKey(IShotFunction_100048db8(copy), 0, (EventHotKeyID){0x53686f74, 2}, GetApplicationEventTarget(), 0, &IShotGlobal_1001f1a78);
        RegisterEventHotKey(1, 0x100, (EventHotKeyID){0x53686f74, 3}, GetApplicationEventTarget(), 0, &IShotGlobal_1001f1a80);
    }
    EventTypeSpec type = {0x6b657962, 5};
    InstallEventHandler(GetApplicationEventTarget(), IShotFunction_100087040, 1, &type, NULL, &IShotGlobal_1001f1a88);
}
- (void)draggedAllToolBar:(NSEvent *)event { // 0x10007cc7c
    if (event.type == 1) {
        CGRect frame = self.buttonBox.frame;
        IShotGlobal_1001f1ae8 = frame.origin.x; IShotGlobal_1001f1af0 = frame.origin.y;
        IShotGlobal_1001f1af8 = frame.size.width; IShotGlobal_1001f1b00 = frame.size.height;
        frame = self.colorBox.frame;
        IShotGlobal_1001f1ab8 = frame.origin.x; IShotGlobal_1001f1ac0 = frame.origin.y;
        frame = self.sanjiao.frame;
        IShotGlobal_1001f1ac8 = frame.origin.x; IShotGlobal_1001f1ad0 = frame.origin.y;
        CGPoint point = event.locationInWindow;
        IShotGlobal_1001f1aa8 = point.x; IShotGlobal_1001f1ab0 = point.y;
        if (IShotGlobal_1001de099) [self disableTips];
    } else {
        CGPoint point = event.locationInWindow;
        int x = (int)(point.x - IShotGlobal_1001f1aa8);
        int y = (int)(point.y - IShotGlobal_1001f1ab0);
        if (IShotGlobal_1001f1ae8 + (double)x < 0.0) x = (int)-IShotGlobal_1001f1ae8;
        if (IShotGlobal_1001f1af0 + (double)y < 50.0) y = (int)(50.0 - IShotGlobal_1001f1af0);
        if (IShotGlobal_1001f1ae8 + IShotGlobal_1001f1af8 + (double)x > self.window.frame.size.width)
            x = (int)(self.window.frame.size.width - (IShotGlobal_1001f1ae8 + IShotGlobal_1001f1af8));
        if (IShotGlobal_1001f1af0 + IShotGlobal_1001f1b00 + (double)y > self.window.frame.size.height)
            y = (int)(self.window.frame.size.height - (IShotGlobal_1001f1af0 + IShotGlobal_1001f1b00));
        [self.buttonBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1ae8 + x, IShotGlobal_1001f1af0 + y)];
        [self.colorBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1ab8 + x, IShotGlobal_1001f1ac0 + y)];
        [self.sanjiao setFrameOrigin:NSMakePoint(IShotGlobal_1001f1ac8 + x, IShotGlobal_1001f1ad0 + y)];
        IShotGlobal_1001f1a98 = IShotGlobal_1001f1ae8 + x;
        IShotGlobal_1001f1aa0 = IShotGlobal_1001f1af0 + y;
    }
}
- (void)mosaicButtonClick:(id)sender { // 0x100080134
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    if ([IShotGlobal_1001f1a38 isEqualToString:@"mosaic"]) return;
    [IShotGlobal_1001de058 removeAllObjects];
    [self adjustColorAndSizeButton:5];
    if (!IShotGlobal_1001de180) {
        if ([IShotGlobal_1001f1a38 isEqualToString:@"highlight"]) {
            NSDistributedNotificationCenter *center = NSDistributedNotificationCenter.defaultCenter;
            [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
            [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
        }
    } else {
        if (!IShotGlobal_1001de0b8) {
            CGRect rect = [(NSView *)annotatedImageView frame];
            rect.origin.x += self.window.screen.frame.origin.x;
            rect.origin.y += self.window.screen.frame.origin.y;
            IShotGlobal_1001de0b8 = [[ZoomWindow alloc] initWithContentRect:rect styleMask:0x80 backing:2 defer:NO screen:nil];
        }
        if (!IShotGlobal_1001de0c2) {
            IShotGlobal_1001dddf8 = nil;
            [NSCursor.arrowCursor set];
            [IShotGlobal_1001de0b8 orderFront:self];
        }
    }
}
- (void)scrollScreenshotButtonClick:(id)sender { // 0x10007f260; blocks 0x10007f7c4, 0x10007f80c
    if (IShotGlobal_1001de0c0) {
        [self hiddenButton];
        IShotGlobal_1001de184 = NO;
        IShotGlobal_1001dddf0 = NO;
        [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
        if (IShotGlobal_1001de099) {
            self.openedBoxOfTips.transparent = YES;
            self.openedBoxOfTips.hidden = YES;
            IShotGlobal_1001de099 = NO;
            [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
        }
        IShotGlobal_1001de0d0 = YES; IShotGlobal_1001de0d1 = YES; IShotGlobal_1001de0d2 = YES;
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"StartScreenShots" object:nil userInfo:nil];
        return;
    }
    [self.backgroundImageWindow orderOut:nil];
    [IShotGlobal_1001de0a8 setFireDate:NSDate.distantFuture];
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        IShotGlobal_1001de099 = NO;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100000000), dispatch_get_main_queue(), ^{
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"scrollScreenShot" object:nil userInfo:nil];
    });
    self.scrollScreenshotButton.hidden = YES; // Its second action was OCR, removed from Lite.
    self.colorBox.hidden = YES;
    self.sanjiao.hidden = YES;
    IShotGlobal_1001de0c0 = YES;
    CGRect frame = self.buttonBox.frame;
    IShotGlobal_1001f1a98 = frame.origin.x + frame.size.width * 0.5 - 70.0;
    [_buttonBox setFrameOrigin:NSMakePoint(IShotGlobal_1001f1a98, IShotGlobal_1001f1aa0)];
    self.buttonBox.layer.masksToBounds = YES;
    [self.buttonBox setFrameSize:NSMakeSize(138.0, 40.0)];
    [self.scrollScreenshotErrorWarnButton setFrameOrigin:NSMakePoint(self.buttonBox.frame.origin.x + 160.0, self.buttonBox.frame.origin.y + 5.0)];
    self.scrollScreenshotErrorWarnButton.hidden = NO;
}
- (void)observeValueForKeyPath:(NSString *)key ofObject:(id)object change:(NSDictionary *)change context:(void *)context { // 0x10007e914
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    if ([key isEqualToString:@"ellipseOfHighlight"] || [key isEqualToString:@"squareOfHighlight"] || [key isEqualToString:@"selectedGaussianBlured"] || [key isEqualToString:@"selectedMosaic"]) {
        if (IShotGlobal_1001f1a68 == YES) { IShotGlobal_1001f1a68 = NO; return; }
        IShotGlobal_1001f1a68 = YES;
        if ([key isEqualToString:@"ellipseOfHighlight"]) {
            [defaults setBool:NO forKey:@"squareOfHighlight"];
            [IShotGlobal_1001de058 setObject:@0 forKey:@"squareOfHighlight"];
        } else if ([key isEqualToString:@"squareOfHighlight"]) {
            [defaults setBool:NO forKey:@"ellipseOfHighlight"];
            [IShotGlobal_1001de058 setObject:@1 forKey:@"squareOfHighlight"];
        } else if ([key isEqualToString:@"selectedGaussianBlured"]) {
            [defaults setBool:NO forKey:@"selectedMosaic"];
            [IShotGlobal_1001de058 setObject:@0 forKey:@"selectedMosaic"];
        } else {
            [defaults setBool:NO forKey:@"selectedGaussianBlured"];
            [IShotGlobal_1001de058 setObject:@1 forKey:@"selectedMosaic"];
        }
        if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
        NSDistributedNotificationCenter *center = NSDistributedNotificationCenter.defaultCenter;
        [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
        [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
    } else if (IShotGlobal_1001de058[@"type"]) {
        NSUserDefaults *state = NSUserDefaults.standardUserDefaults;
        int type = [IShotGlobal_1001de058[@"type"] intValue];
        if (type == 0) {
            if ([key isEqualToString:@"filledOfSquare"]) {
                [IShotGlobal_1001de058 setObject:@([state boolForKey:@"filledOfSquare"]) forKey:@"filledOfSquare"];
                [(NSView *)annotatedImageView setNeedsDisplay:YES];
                if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            }
            if ([key isEqualToString:@"enableRoundOfSquare"]) {
                [IShotGlobal_1001de058 setObject:@([state boolForKey:@"enableRoundOfSquare"]) forKey:@"enableRoundOfSquare"];
                [(NSView *)annotatedImageView setNeedsDisplay:YES];
                if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            }
        } else if ([key isEqualToString:@"filledOfEllipse"] && type == 1) {
            [IShotGlobal_1001de058 setObject:@([state boolForKey:@"filledOfEllipse"]) forKey:@"filledOfEllipse"];
            [(NSView *)annotatedImageView setNeedsDisplay:YES];
            if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
        } else if ([key isEqualToString:@"normalTypeOfArrow"] && type == 3) {
            [IShotGlobal_1001de058 setObject:[state boolForKey:@"normalTypeOfArrow"] ? @"1" : @"0" forKey:@"normalTypeOfArrow"];
            if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            [(NSView *)annotatedImageView setNeedsDisplay:YES];
        } else if (type == 7) {
            if ([key isEqualToString:@"typeIndexOfNote"]) {
                [IShotGlobal_1001de058 setObject:[NSString stringWithFormat:@"%ld", [state integerForKey:@"typeIndexOfNote"]] forKey:@"typeIndexOfNote"];
                if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            }
            if ([key isEqualToString:@"colorIndexOfNote"]) {
                [IShotGlobal_1001de058 setObject:[NSString stringWithFormat:@"%ld", [state integerForKey:@"colorIndexOfNote"]] forKey:@"colorIndexOfNote"];
                if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            }
        } else if (type == 6) {
            if ([key isEqualToString:@"typeIndexOfText"]) {
                [IShotGlobal_1001de058 setObject:[NSString stringWithFormat:@"%ld", [state integerForKey:@"typeIndexOfText"]] forKey:@"typeIndexOfText"];
                if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            }
            if ([key isEqualToString:@"colorIndexOfText"]) {
                [IShotGlobal_1001de058 setObject:[NSString stringWithFormat:@"%ld", [state integerForKey:@"colorIndexOfText"]] forKey:@"colorIndexOfText"];
                if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            }
        }
        [self refreshAllButtonState];
    }
    if ([key isEqualToString:@"effectiveAppearance"]) [self updateToolbarBoxStyle];
    [defaults synchronize];
}
- (void)resetCursor { // 0x1000882c4
    NSColor *color = IShotGlobal_1001de058[@"color"];
    if (!color) color = [NSKeyedUnarchiver unarchiveObjectWithData:IShotGlobal_1001de0c8[IShotGlobal_1001de090][@"color"]];
    int size;
    if ([IShotGlobal_1001de090 isEqualToString:@"highlight"]) size = self.displaySize.stringValue.intValue;
    else {
        size = [IShotGlobal_1001de058[@"size"] intValue];
        if (!size) size = [IShotGlobal_1001de0c8[IShotGlobal_1001de090][@"size"] intValue];
    }
    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(32.0, 32.0)];
    [image lockFocus];
    [NSColor.blackColor set];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(16.0, 16.0) radius:2.5 startAngle:359.9 endAngle:0.0 clockwise:YES];
    path.lineWidth = 1.0;
    [path stroke];
    [color set];
    path = [NSBezierPath bezierPath];
    path.lineWidth = 3.0;
    [NSColor.whiteColor set];
    [path moveToPoint:NSMakePoint(0, 16)]; [path lineToPoint:NSMakePoint(13, 16)];
    [path moveToPoint:NSMakePoint(19, 16)]; [path lineToPoint:NSMakePoint(32, 16)];
    [path moveToPoint:NSMakePoint(16, 0)]; [path lineToPoint:NSMakePoint(16, 13)];
    [path moveToPoint:NSMakePoint(16, 19)]; [path lineToPoint:NSMakePoint(16, 32)];
    [path stroke];
    path = [NSBezierPath bezierPath];
    path.lineWidth = 2.0;
    [color set];
    [path moveToPoint:NSMakePoint(0.5, 16)]; [path lineToPoint:NSMakePoint(12.5, 16)];
    [path moveToPoint:NSMakePoint(19.5, 16)]; [path lineToPoint:NSMakePoint(31.5, 16)];
    [path moveToPoint:NSMakePoint(16, 0.5)]; [path lineToPoint:NSMakePoint(16, 12.5)];
    [path moveToPoint:NSMakePoint(16, 19.5)]; [path lineToPoint:NSMakePoint(16, 31.5)];
    [path stroke];
    CGContextRef context = (CGContextRef)NSGraphicsContext.currentContext.graphicsPort;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:NSColor.whiteColor forKey:NSForegroundColorAttributeName];
    [attributes setObject:[NSFont systemFontOfSize:7.0] forKey:NSFontAttributeName];
    NSString *text = [NSString stringWithFormat:@"%d", size];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[NSFont systemFontOfSize:7.0]}];
    CGPoint position = CGPointMake((14.5 - textSize.width) * 0.5 + 18.0, 0.5);
    CGContextSetShadowWithColor(context, CGSizeMake(0.7, 0), 0, NSColor.blackColor.CGColor); [text drawAtPoint:position withAttributes:attributes];
    CGContextSetShadowWithColor(context, CGSizeMake(-0.7, 0), 0, NSColor.blackColor.CGColor); [text drawAtPoint:position withAttributes:attributes];
    CGContextSetShadowWithColor(context, CGSizeMake(0, -0.7), 0, NSColor.blackColor.CGColor); [text drawAtPoint:position withAttributes:attributes];
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0.7), 0, NSColor.blackColor.CGColor); [text drawAtPoint:position withAttributes:attributes];
    CGContextSetShadowWithColor(context, CGSizeMake(0.5, 0.5), 0, NSColor.blackColor.CGColor); [text drawAtPoint:position withAttributes:attributes];
    CGContextSetShadowWithColor(context, CGSizeMake(0.5, -0.5), 0, NSColor.blackColor.CGColor); [text drawAtPoint:position withAttributes:attributes];
    CGContextSetShadowWithColor(context, CGSizeMake(-0.5, 0.5), 0, NSColor.blackColor.CGColor); [text drawAtPoint:position withAttributes:attributes];
    CGContextSetShadowWithColor(context, CGSizeMake(-0.5, -0.5), 0, NSColor.blackColor.CGColor); [text drawAtPoint:position withAttributes:attributes];
    CGContextSaveGState(context);
    [image unlockFocus];
    IShotGlobal_1001de0e0 = [[NSCursor alloc] initWithImage:image hotSpot:NSMakePoint(16.01, 16.01)];
}
- (void)scrollWheel:(NSEvent *)event { // 0x100087584
    IShotGlobal_1001de0d7 = YES;
    [IShotGlobal_1001de0d8 setFireDate:NSDate.distantFuture];
    IShotGlobal_1001de0d8 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollFinished) userInfo:nil repeats:NO];
    if (IShotFunction_10004d490(event)) return;
    if (IShotGlobal_1001de058[@"type"] && IShotGlobal_1001de048 > 0) [(NSView *)annotatedImageView reSetUndo];
    if ([IShotGlobal_1001de090 isEqualToString:@""]) return;
    int type = [IShotGlobal_1001de058[@"type"] intValue];
    BOOL onStroke = NO;
    if ([IShotGlobal_1001dde70 isEqualToString:@"WholeMove"] && ((uint32_t)type - 5U) > 2U) onStroke = [self isOnStrokesUnderMouse:event.locationInWindow];
    IShotGlobal_1001de098 = onStroke;
    if ([IShotGlobal_1001de090 isEqualToString:@"highlight"]) IShotGlobal_1001de098 = YES;
    BOOL onNoteCircle = type == 7 && [IShotGlobal_1001de058[@"mousePosition"] isEqualToString:@"onCycleOfNote"];
    if (!IShotGlobal_1001de098 && !onNoteCircle && ![IShotGlobal_1001dde70 isEqualToString:@"cursorCreateNew"]) return;
    if (event.phase == 1) IShotGlobal_1001f1a90 = @"";
    NSInteger size = [IShotGlobal_1001de058[@"size"] integerValue];
    if (size == 0) size = [IShotGlobal_1001de0c8[IShotGlobal_1001de090][@"size"] integerValue];
    if ([IShotGlobal_1001de090 isEqualToString:@"text"] || [IShotGlobal_1001de090 isEqualToString:@"note"]) {
        if (event.deltaY == 0.0) return;
        if (!onNoteCircle) {
            if (event.deltaY > 0.0) ++size; else if (event.deltaY < 0.0) --size;
            if (size > 99) size = 100;
            if (size < 9) size = 8;
            NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
            [settings setObject:@(size) forKey:@"size"];
            [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
            [IShotGlobal_1001de050 removeObject:IShotGlobal_1001de058];
            [IShotGlobal_1001de058 setObject:@(size) forKey:@"size"];
            if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            [self adjustTextSizeOrFont];
            [self resetCursor];
            IShotGlobal_1001dde70 = @"cursorCreateNew";
            IShotGlobal_1001dddf8 = IShotGlobal_1001de0e0;
            [IShotGlobal_1001de0e0 set];
        } else {
            uint32_t serial = [IShotGlobal_1001de058[@"serialNumber"] intValue];
            if (event.deltaY > 0.0) ++serial;
            else if (event.deltaY < 0.0) serial = ((int32_t)serial < 3 ? 2U : serial) - 1U;
            [IShotGlobal_1001de050 removeObject:IShotGlobal_1001de058];
            [IShotGlobal_1001de058 setObject:@((int32_t)serial) forKey:@"serialNumber"];
            if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            [(NSView *)annotatedImageView setNeedsDisplay:YES];
        }
    } else {
        if (event.deltaY == 0.0) return;
        if (!IShotGlobal_1001de098) {
            if (event.deltaY > 0.0) ++size; else if (event.deltaY < 0.0) --size;
            if ((NSUInteger)size - 1U >= 100U) return;
            if (![IShotGlobal_1001de090 isEqualToString:@"line"] && ![IShotGlobal_1001de090 isEqualToString:@"pencilPen"] && size >= 41) return;
            if ([IShotGlobal_1001de090 isEqualToString:@"mosaic"] && size >= 11) return;
            self.displaySize.stringValue = [NSString stringWithFormat:@"%ld", size];
            self.sliderOfSize.intValue = self.displaySize.stringValue.intValue;
            [IShotGlobal_1001de050 removeObject:IShotGlobal_1001de058];
            [IShotGlobal_1001de058 setObject:@(size) forKey:@"size"];
            if (IShotGlobal_1001de058[@"type"]) [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithDictionary:IShotGlobal_1001de0c8[IShotGlobal_1001de090]];
            [settings setObject:@(size) forKey:@"size"];
            [IShotGlobal_1001de0c8 setObject:settings forKey:IShotGlobal_1001de090];
            [self resetCursor];
            IShotGlobal_1001dde70 = @"cursorCreateNew";
            IShotGlobal_1001dddf8 = IShotGlobal_1001de0e0;
            [IShotGlobal_1001de0e0 set];
            if (![IShotGlobal_1001de090 isEqualToString:@"mosaic"] && ![IShotGlobal_1001de090 isEqualToString:@"highlight"]) [(NSView *)annotatedImageView setNeedsDisplay:YES];
            else {
                NSDistributedNotificationCenter *center = NSDistributedNotificationCenter.defaultCenter;
                [center postNotificationName:@"refreshHighlightDrawRect" object:nil userInfo:nil];
                [center postNotificationName:@"refreshMosaicDrawRect" object:nil userInfo:nil];
            }
        } else {
            id alpha = IShotGlobal_1001de058[@"colorAlpha"];
            NSString *value = alpha ? [NSString stringWithFormat:@"%.f", (double)([alpha floatValue] * 100.0f)] : @"100";
            self.displayOpacity.stringValue = value;
            self.sliderOfOpacity.intValue = value.intValue;
            [self adjustColorOpacityByScrollWheelEvent:(float)event.deltaY];
        }
    }
}
- (void)checkMouseOnWhichButton { // 0x10007d3a8; geometry registers independently checked
    CGPoint mouse = NSEvent.mouseLocation;
    mouse.x -= self.window.screen.frame.origin.x;
    mouse.y -= self.window.screen.frame.origin.y;
    if (!NSPointInRect(mouse, NSInsetRect(self.buttonBox.frame, 10.0, 10.0)) || !IShotGlobal_1001de088) return;
    if (!NSPointInRect(NSMakePoint(IShotGlobal_1001f1ad8, IShotGlobal_1001f1ae0), self.buttonBox.frame)) return;
    float toolbarX = (float)self.buttonBox.frame.origin.x;
    int index;
    for (index = 0; index < 16; ++index) {
        float left = toolbarX + (float)(index * 32) + 10.0f;
        if ((double)left < IShotGlobal_1001f1ad8 && IShotGlobal_1001f1ad8 < (double)(left + 30.0f)) break;
    }
    if (index == 16) return;
    if (IShotGlobal_1001de0c0) index += 12;
    if ((index==11 && !IShotGlobal_1001de180) || (index==13 && IShotGlobal_1001de0c0)) return; // Removed OCR tooltips.
    if (IShotGlobal_1001de099) {
        self.openedBoxOfTips.transparent = YES;
        self.openedBoxOfTips.hidden = YES;
        [IShotGlobal_1001de0a0 setFireDate:NSDate.distantFuture];
    }
    self.willOpenPopUpButton = nil;
    NSString *shortcut = @"";
    switch (index) {
        case 0: self.openedBoxOfTips = self.boxSquare; self.willOpenPopUpButton = self.popUpButtonSquare; shortcut = @"squareShortcut"; break;
        case 1: self.openedBoxOfTips = self.boxEllipse; self.willOpenPopUpButton = self.popUpButtonEllipse; shortcut = @"ellipseShortcut"; break;
        case 2: self.openedBoxOfTips = self.boxLine; self.willOpenPopUpButton = self.popUpButtonLine; shortcut = @"lineShortcut"; break;
        case 3: self.openedBoxOfTips = self.boxArrow; self.willOpenPopUpButton = self.popUpButtonArrow; shortcut = @"arrowShortcut"; break;
        case 4: self.openedBoxOfTips = self.boxPencil; self.willOpenPopUpButton = self.popUpButtonPencil; shortcut = @"pencilShortcut"; break;
        case 6: self.openedBoxOfTips = self.boxText; self.willOpenPopUpButton = self.popUpButtonText; shortcut = @"textShortcut"; break;
        case 7: self.openedBoxOfTips = self.boxNote; self.willOpenPopUpButton = self.popUpButtonNote; shortcut = @"noteShortcut"; break;
        case 8: self.openedBoxOfTips = self.boxHighlight; self.willOpenPopUpButton = self.popUpButtonHighlight; shortcut = @"highlightShortcut"; break;
        case 14: self.openedBoxOfTips = self.boxSave; self.willOpenPopUpButton = self.popUpButtonSave; shortcut = @"saveShortcut"; break;
        case 15: self.openedBoxOfTips = self.boxCopyToPaste; self.willOpenPopUpButton = self.popUpButtonCopyToPaste; shortcut = @"copyToPasteShortcut"; break;
        case 5:
            if (!IShotGlobal_1001de180) { self.openedBoxOfTips = self.boxMosaic; self.willOpenPopUpButton = self.popUpButtonMosaic; shortcut = @"mosaicShortcut"; }
            else { self.openedBoxOfTips = self.boxZoom; self.willOpenPopUpButton = self.popUpButtonZoom; shortcut = @"zoomShortcut"; }
            break;
        case 9:
            if (!IShotGlobal_1001de180) { self.openedBoxOfTips = self.boxMap; self.willOpenPopUpButton = self.popUpButtonMap; shortcut = @"mapShortcut"; }
            else { self.openedBoxOfTips = self.boxClear; self.willOpenPopUpButton = self.popUpButtonClear; shortcut = @"clearShortcut"; }
            break;
        case 10: self.openedBoxOfTips = self.boxUndo; break;
        case 11:
            if (IShotGlobal_1001de180) { self.openedBoxOfTips = self.boxSave; self.willOpenPopUpButton = self.popUpButtonSave; shortcut = @"saveShortcut"; }
            else { self.openedBoxOfTips = self.boxOCR; self.willOpenPopUpButton = self.popUpButtonOCR; shortcut = @"OCRShortcut"; }
            break;
        case 12: self.openedBoxOfTips = self.boxCancel; break;
        case 13:
            if (IShotGlobal_1001de0c0) { self.openedBoxOfTips = self.boxOCR; self.willOpenPopUpButton = self.popUpButtonOCR; shortcut = @"OCRShortcut"; }
            else { self.openedBoxOfTips = self.boxScrollScreenshot; self.willOpenPopUpButton = self.popUpButtonScrollScreenshot; shortcut = @"scrollScreenshotShortcut"; }
            break;
        default: break;
    }
    self.willOpenPopUpButton.autoenablesItems = NO;
    NSArray *items = self.willOpenPopUpButton.itemArray;
    for (NSUInteger i = 0; i < items.count; ++i) {
        NSMenuItem *item = items[i];
        NSString *title = item.title;
        item.enabled = YES;
        for (NSString *key in IShotGlobal_1001de130) {
            NSString *value = [NSUserDefaults.standardUserDefaults stringForKey:key];
            if (![key isEqualToString:shortcut] && [title isEqualToString:value]) item.enabled = NO;
        }
    }
    if (IShotGlobal_1001de0c0) index -= 11;
    IShotGlobal_1001f1ad8 = self.buttonBox.frame.origin.x + (double)(index * 35) + 17.0 - self.openedBoxOfTips.frame.size.width * 0.5;
    NSScreen *screen = NSScreen.currentScreenForMouseLocation;
    if (IShotGlobal_1001dde80) screen = IShotGlobal_1001dde80;
    if (IShotGlobal_1001f1ad8 + self.openedBoxOfTips.frame.size.width > screen.frame.size.width)
        IShotGlobal_1001f1ad8 = screen.frame.size.width - self.openedBoxOfTips.frame.size.width;
    if (IShotGlobal_1001f1ad8 < 0.0) IShotGlobal_1001f1ad8 = 0.0;
    IShotGlobal_1001f1ae0 = self.buttonBox.frame.origin.y + self.buttonBox.frame.size.height;
    self.openedBoxOfTips.alphaValue = 1.0;
    [self.openedBoxOfTips setFrameOrigin:NSMakePoint(IShotGlobal_1001f1ad8, IShotGlobal_1001f1ae0)];
    IShotGlobal_1001de099 = YES;
    self.openedBoxOfTips.transparent = NO;
    self.openedBoxOfTips.hidden = NO;
    IShotGlobal_1001de0a0 = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(disableTips) userInfo:nil repeats:NO];
}
- (void)mouseMoved:(NSEvent *)event { // 0x10007bdd8
    IShotGlobal_1001de098 = NO;
    if (!IShotGlobal_1001de088) return;
    ++IShotGlobal_1001f1a44;
    if (IShotGlobal_1001f1a44 * UINT32_C(0xcccccccd) + UINT32_C(0x19999999) > UINT32_C(0x33333332)) return;
    NSPoint p = event.locationInWindow;
    IShotGlobal_1001f1ad8 = p.x;
    IShotGlobal_1001f1ae0 = p.y;
    if (!IShotGlobal_1001de099) {
        if (NSPointInRect(p, NSInsetRect(self.buttonBox.frame, 10, 10))) {
            IShotGlobal_1001de0a8.fireDate = NSDate.distantFuture;
            float delay = [[NSUserDefaults.standardUserDefaults stringForKey:@"delayTimeOfPopupToolbar"] floatValue];
            IShotGlobal_1001de0a8 = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(checkMouseOnWhichButton) userInfo:nil repeats:NO];
        }
    } else if (!NSPointInRect(p, self.buttonBox.frame)) {
        if (!NSPointInRect(p, self.openedBoxOfTips.frame)) {
            if (!IShotGlobal_1001f1a48) [self disableTips];
        } else {
            IShotGlobal_1001f1a48 = NO;
            IShotGlobal_1001de0a0.fireDate = NSDate.distantFuture;
        }
    } else {
        IShotGlobal_1001f1a48 = NO;
        [self checkMouseOnWhichButton];
    }
    IShotGlobal_1001de0b0 = -1;
    if (NSPointInRect(p, self.buttonBox.frame)) {
        NSPoint local = NSMakePoint(p.x - self.buttonBox.frame.origin.x, p.y - self.buttonBox.frame.origin.y);
        if (NSPointInRect(local, self.squareButton.frame)) IShotGlobal_1001de0b0 = 0;
        else if (NSPointInRect(local, self.ellipseButton.frame)) IShotGlobal_1001de0b0 = 1;
        else if (NSPointInRect(local, self.lineButton.frame)) IShotGlobal_1001de0b0 = 2;
        else if (NSPointInRect(local, self.arrowButton.frame)) IShotGlobal_1001de0b0 = 3;
        else if (NSPointInRect(local, self.pencilPenButton.frame)) IShotGlobal_1001de0b0 = 4;
        else if (NSPointInRect(local, self.mosaicButton.frame)) IShotGlobal_1001de0b0 = 5;
        else if (NSPointInRect(local, self.textButton.frame)) IShotGlobal_1001de0b0 = 6;
        else if (NSPointInRect(local, self.noteButton.frame)) IShotGlobal_1001de0b0 = 7;
        else if (NSPointInRect(local, self.highlightButton.frame)) IShotGlobal_1001de0b0 = 8;
        else if (NSPointInRect(local, self.mapButton.frame)) IShotGlobal_1001de0b0 = 9;
        else if (NSPointInRect(local, self.undoButton.frame)) IShotGlobal_1001de0b0 = 10;
        else if (!self.OCRButton.hidden && NSPointInRect(local, self.OCRButton.frame)) IShotGlobal_1001de0b0 = 11;
        else if (NSPointInRect(local, self.cancelButton.frame)) IShotGlobal_1001de0b0 = 12;
        else if (NSPointInRect(local, self.scrollScreenshotButton.frame)) IShotGlobal_1001de0b0 = 13;
        else if (NSPointInRect(local, self.saveButton.frame)) IShotGlobal_1001de0b0 = 14;
        else if (NSPointInRect(local, self.pasteButton.frame)) IShotGlobal_1001de0b0 = 15;
    }
    if (IShotGlobal_1001de180 && IShotGlobal_1001de0b8.isVisible) {
        NSPoint q = NSMakePoint(p.x + [(NSView *)annotatedImageView frame].origin.x, p.y + [(NSView *)annotatedImageView frame].origin.y);
        if (NSPointInRect(q, self.buttonBox.frame) || NSPointInRect(q, self.colorBox.frame)) [IShotGlobal_1001de0b8 orderOut:self];
    }
    if (NSPointInRect(p, self.buttonBox.frame) && !NSPointInRect(p, NSInsetRect(self.buttonBox.frame, 10, 10)) && !IShotGlobal_1001de0c0) {
        IShotGlobal_1001de0c1 = YES;
        IShotGlobal_1001dde70 = @"AllToolBarMove";
        IShotGlobal_1001dddf8 = NSCursor.openHandCursor;
        [NSCursor.openHandCursor set];
    }
    if (!NSPointInRect(p, self.buttonBox.frame) && IShotGlobal_1001de0c1) {
        IShotGlobal_1001de0c1 = NO;
        if (([IShotGlobal_1001dde70 isEqualToString:@"cursorCreateNew"] && !NSPointInRect(p, [(NSView *)annotatedImageView frame])) || IShotGlobal_1001de0c0) {
            IShotGlobal_1001dddf8 = nil;
            [NSCursor.arrowCursor set];
        }
    }
    if (NSPointInRect(p, NSInsetRect(self.buttonBox.frame, 10, 10)) || NSPointInRect(p, self.colorBox.frame)) {
        IShotGlobal_1001dddf8 = nil;
        [NSCursor.arrowCursor set];
        IShotGlobal_1001de0c2 = YES;
    } else IShotGlobal_1001de0c2 = NO;
    IShotGlobal_1001de0c3 = NSPointInRect(p, self.buttonBox.frame) || NSPointInRect(p, self.colorBox.frame) || (IShotGlobal_1001de099 && NSPointInRect(p, self.openedBoxOfTips.frame));
}
- (BOOL)isOnStrokesUnderMouse:(CGPoint)p { // 0x100088b0c; floating registers checked against arm64 assembly
    NSDictionary *stroke = IShotGlobal_1001de058;
    NSInteger type = [stroke[@"type"] integerValue];
    float x1 = [stroke[@"X1"] floatValue], y1 = [stroke[@"Y1"] floatValue];
    float x2 = [stroke[@"X2"] floatValue], y2 = [stroke[@"Y2"] floatValue];
    int size = [stroke[@"size"] intValue], margin = size > 4 ? size : 4;
    CGPoint a = CGPointMake(x1, y1), b = CGPointMake(x2, y2);
    switch (type) {
        case 0: case 5: case 8: {
            CGRect r = CGRectMake(x1, y1, (float)(x2-x1), (float)(y2-y1));
            if ((type != 0 || ![stroke[@"filledOfSquare"] boolValue]) && NSPointInRect(p, CGRectInset(r, margin, margin))) return NO;
            if (!NSPointInRect(p, CGRectInset(r, -margin, -margin))) return NO;
            IShotGlobal_1001de058 = [NSMutableDictionary dictionaryWithDictionary:stroke];
            return YES;
        }
        case 1: {
            float dx = (float)(p.x - (double)((x1+x2)*0.5f));
            float dy = (float)(p.y - (double)((y1+y2)*0.5f));
            float rx = fabsf(x2-x1)*0.5f, ry = fabsf(y2-y1)*0.5f;
            float mx = rx+(float)margin, my = ry+(float)margin;
            dx *= dx; dy *= dy;
            float outer = dx/(mx*mx) + dy/(my*my);
            if (!(outer < 1.0f)) return NO;
            if (![stroke[@"filledOfEllipse"] boolValue]) {
                mx = rx-(float)margin; my = ry-(float)margin;
                float inner = dx/(mx*mx) + dy/(my*my);
                if (!(inner > 1.0f)) return NO;
            }
            IShotGlobal_1001de058 = [NSMutableDictionary dictionaryWithDictionary:stroke];
            return YES;
        }
        case 2:
            return [self point:a andPoint:b crossWithCyclePoint:p radius:(float)(size/2 > 4 ? size/2 : 4)];
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
            NSArray *points = stroke[@"allPoints"];
            float radius = (float)(size/2 > 4 ? size/2 : 4);
            for (NSUInteger i=0; i<points.count-1; ++i)
                if ([self point:[points[i] CGPointValue] andPoint:[points[i+1] CGPointValue] crossWithCyclePoint:p radius:radius]) return YES;
            return NO;
        }
        case 6: case 7: {
            CGRect r = [stroke[@"scrollView"] frame];
            double padding = size/15+2;
            r = CGRectMake(r.origin.x-padding-3.0,r.origin.y-3.0,r.size.width+padding*0.9+8.0,r.size.height+8.0);
            if (NSPointInRect(p, NSInsetRect(r,-8,-8))) {
                if (type == 6) dispatch_after(dispatch_time(DISPATCH_TIME_NOW,10000000),dispatch_get_main_queue(), ^{
                    if (NSPointInRect(p,NSInsetRect(r,-8,-8))) IShotGlobal_1001dde70 = @"WholeMove";
                    IShotGlobal_1001dddf8 = NSCursor.openHandCursor;
                    [NSCursor.openHandCursor set];
                });
                return YES;
            }
            if (type == 6) return NO;
            CGPoint center = [stroke[@"cyclePoint"] pointValue];
            double radius = (float)[[stroke[@"textView"] font] pointSize]/5.0f+11.0f;
            return NSPointInRect(p,CGRectMake(center.x-radius*0.8-1,center.y-radius*0.8-1,radius*1.6+2,radius*1.6+2));
        }
        default: return NO;
    }
}
