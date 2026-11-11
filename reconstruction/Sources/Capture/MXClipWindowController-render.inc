static void IShotClipRender_10001984c(MXClipWindowController *controller,NSUserDefaults *defaults) {
    int radius=(int)[controller.clipView radiusOfFrame]; NSImage *image=nil;
    NSRect rect=NSZeroRect;
    if(IShotGlobal_1001de0c0) {
        [controller.clipView setHidden:YES]; [controller.clipView redrawScrollView];
        if(IShotGlobal_1001de0d2) image=[IShotGlobal_1001dde40 toImage];
        else {
            IShotGlobal_1001dde40.layer.cornerRadius=radius;
            NSImage *source=[IShotGlobal_1001dde40 toImage];
            NSUserDefaults *preferences=NSUserDefaults.standardUserDefaults;
            int shadow=[preferences boolForKey:@"needShadow"] ? [[preferences stringForKey:@"sizeOfShadow"] intValue] : 0;
            NSColor *color=[NSColor.shadowColor colorWithAlphaComponent:0.3];
            NSData *archived=[NSUserDefaults.standardUserDefaults objectForKey:@"colorOfShadow"]; if(archived) color=[NSKeyedUnarchiver unarchiveObjectWithData:archived];
            double doubled=(double)(shadow<<1);
            image=[[NSImage alloc] initWithSize:NSMakeSize(source.size.width+doubled,source.size.height+doubled)];
            [image lockFocus]; [NSGraphicsContext saveGraphicsState]; NSGraphicsContext.currentContext.imageInterpolation=1; NSGraphicsContext.currentContext.shouldAntialias=NO;
            CGContextSetShadowWithColor(NSGraphicsContext.currentContext.CGContext,CGSizeZero,shadow*1.1,color.CGColor);
            [source drawInRect:NSMakeRect(shadow,shadow,image.size.width-doubled,image.size.height-doubled)];
            [NSGraphicsContext restoreGraphicsState]; [image unlockFocus];
        }
    } else {
        rect=[controller.clipView contentFrame]; if(NSEqualRects(rect,NSZeroRect)) return;
        if(IShotClip_1001f18b4==YES) {
            int size=[[defaults stringForKey:@"sizeOfShadow"] intValue];
            if([defaults boolForKey:@"needShadowOfnotSingleWindow"] && ![defaults boolForKey:@"needShadow"]) rect=NSInsetRect(rect,size,size);
            else if(![defaults boolForKey:@"needShadowOfnotSingleWindow"] && [defaults boolForKey:@"needShadow"]) rect=NSInsetRect(rect,-size,-size);
        } else { [defaults setObject:NSStringFromRect(rect) forKey:@"previousScreenshotArea"]; [defaults synchronize]; }
        NSMutableArray *windows=[[NSMutableArray alloc] initWithArray:IShotGlobal_1001de138];
        if(IShotGlobal_1001ddd50) {
            for(id pinned in IShotGlobal_1001ddcd0) if([[pinned window] windowNumber]==IShotGlobal_1001ddd10) {
                NSImage *source=[pinned image]; if(!source) return;
                NSRect content=NSInsetRect(rect,6,6); NSView *border=(NSView *)[controller.clipView cropBorderView]; NSRect bounds=NSMakeRect(0,0,border.frame.size.width,border.frame.size.height);
                NSBitmapImageRep *rep=[border bitmapImageRepForCachingDisplayInRect:bounds]; [border cacheDisplayInRect:bounds toBitmapImageRep:rep]; NSImage *borderImage=[[NSImage alloc] init]; [borderImage addRepresentation:rep];
                rep=[controller.clipView bitmapImageRepForCachingDisplayInRect:content]; [controller.clipView cacheDisplayInRect:content toBitmapImageRep:rep]; NSImage *clipImage=[[NSImage alloc] init]; [clipImage addRepresentation:rep];
                [IShotGlobal_1001de160.buttonBox setHidden:YES]; NSView *annotation=IShotGlobal_1001de160.window.contentView;
                rep=[annotation bitmapImageRepForCachingDisplayInRect:content]; [annotation cacheDisplayInRect:content toBitmapImageRep:rep]; NSImage *annotationImage=[[NSImage alloc] init]; [annotationImage addRepresentation:rep];
                image=[[NSImage alloc] initWithSize:source.size]; [image lockFocus]; [NSGraphicsContext saveGraphicsState]; NSGraphicsContext.currentContext.imageInterpolation=1; NSGraphicsContext.currentContext.shouldAntialias=NO;
                [source drawInRect:NSMakeRect(0,0,source.size.width,source.size.height)]; [clipImage drawInRect:NSMakeRect(0,0,source.size.width,source.size.height)]; [borderImage drawInRect:NSMakeRect(-6,-6,source.size.width+12,source.size.height+12)]; [annotationImage drawInRect:NSMakeRect(0,0,source.size.width,source.size.height)]; [NSGraphicsContext restoreGraphicsState]; [image unlockFocus];
                if(IShotGlobal_1001de0d5) { [Global pinToScreenWithImage:image rect:NSMakeRect(rect.origin.x+IShotGlobal_1001dde80.frame.origin.x,rect.origin.y+IShotGlobal_1001dde80.frame.origin.y,rect.size.width,rect.size.height)]; [controller cancel]; return; }
                if(IShotGlobal_1001ddd50 && IShotGlobal_1001ddec0 && IShotGlobal_1001de0d1) { IShotFunction_100047ffc([@"TelliShotHelperToUserNotification:" stringByAppendingString:@""]); [NSImage saveImageToPaste:image]; [controller cancel]; return; }
                if(IShotGlobal_1001ddd50 && IShotGlobal_1001de0d1) {
                    for(id target in IShotGlobal_1001ddcd0) if([[target window] windowNumber]==IShotGlobal_1001ddd10) {
                        image=[NSImage addRoundImgae:image withRadius:(float)[NSUserDefaults.standardUserDefaults integerForKey:@"sizeOfPinFillet"]]; [target setImage:image];
                        NSSize size=NSMakeSize(image.size.width*(double)[target imageScale]/100.0,image.size.height*(double)[target imageScale]/100.0);
                        [[target mapImageView] setImage:[NSImage resizeImage:image size:size]]; break;
                    }
                    [controller cancel]; return;
                }
                goto output;
            }
            return;
        }
        NSColor *color=[NSColor.shadowColor colorWithAlphaComponent:0.3]; int shadow=0;
        if([defaults boolForKey:@"needShadow"]) { shadow=[[defaults stringForKey:@"sizeOfShadow"] intValue]; NSData *archived=[NSUserDefaults.standardUserDefaults objectForKey:@"colorOfShadow"]; if(archived) color=[NSKeyedUnarchiver unarchiveObjectWithData:archived]; }
        if(!(IShotClip_1001f18b4&1)) {
            NSImage *background=[[NSImage alloc] initWithSize:NSMakeSize(rect.size.width-12,rect.size.height-12)];
            [NSGraphicsContext saveGraphicsState]; [background lockFocus];
            double r=IShotGlobal_1001de0d5 ? 0 : radius;
            [[NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0,0,background.size.width,background.size.height) xRadius:r yRadius:r] addClip];
            [[controller.clipView fullImage] drawInRect:NSMakeRect(-6-rect.origin.x,-6-rect.origin.y,controller.window.frame.size.width,controller.window.frame.size.height)]; [background unlockFocus];
            [windows addObject:@{@"rect":[NSValue valueWithCGRect:NSMakeRect(shadow,shadow,rect.size.width-12,rect.size.height-12)],@"KCGWindowImage":background}];
            if(!IShotGlobal_1001de0d5) rect=NSInsetRect(rect,-shadow,-shadow);
        }
        double x=6,y=6,delta=-12;
        if(IShotGlobal_1001de0d5 && IShotClip_1001f18b4==YES) { x=-6-shadow; y=-6-shadow; delta=shadow; }
        NSRect borderRect=NSMakeRect(x,y,rect.size.width+delta,rect.size.height+delta); NSView *border=(NSView *)[controller.clipView cropBorderView];
        NSBitmapImageRep *rep=[border bitmapImageRepForCachingDisplayInRect:borderRect]; [border cacheDisplayInRect:borderRect toBitmapImageRep:rep]; NSImage *borderImage=[[NSImage alloc] init]; [borderImage addRepresentation:rep];
        NSRect content=NSInsetRect(rect,6,6);
        rep=[controller.clipView bitmapImageRepForCachingDisplayInRect:content]; [controller.clipView cacheDisplayInRect:content toBitmapImageRep:rep]; NSImage *clipImage=[[NSImage alloc] init]; [clipImage addRepresentation:rep];
        [IShotGlobal_1001de160.buttonBox setHidden:YES]; NSView *annotation=IShotGlobal_1001de160.window.contentView;
        rep=[annotation bitmapImageRepForCachingDisplayInRect:content]; [annotation cacheDisplayInRect:content toBitmapImageRep:rep]; NSImage *annotationImage=[[NSImage alloc] init]; [annotationImage addRepresentation:rep];
        image=[[NSImage alloc] initWithSize:NSMakeSize(rect.size.width-12,rect.size.height-12)]; [image lockFocus]; [NSGraphicsContext saveGraphicsState]; NSGraphicsContext.currentContext.imageInterpolation=1; NSGraphicsContext.currentContext.shouldAntialias=NO;
        CGContextRef context=NSGraphicsContext.currentContext.CGContext;
        if(IShotClip_1001f18b4==YES) {
            for(NSInteger i=(NSInteger)windows.count-1;i>=0;i--) {
                NSDictionary *item=windows[i]; NSRect windowRect=[item[@"rect"] rectValue]; BOOL pin=[item[@"kCGWindowName"] isEqualToString:@"mappingWindowByiShot"];
                if(!pin && !(IShotGlobal_1001de0d5&1)) { if(shadow>0) CGContextSetShadowWithColor(context,CGSizeZero,shadow*1.1,color.CGColor); }
                else CGContextSetShadowWithColor(context,CGSizeZero,shadow*1.1,NSColor.clearColor.CGColor);
                windowRect.origin.x=windowRect.origin.x-rect.origin.x-6; windowRect.origin.y=windowRect.origin.y-rect.origin.y-6;
                if(pin) windowRect=NSInsetRect(windowRect,-6,-6);
                [(NSImage *)item[@"KCGWindowImage"] drawInRect:windowRect];
            }
            if(shadow>0) CGContextSetShadowWithColor(context,CGSizeZero,shadow*1.1,NSColor.clearColor.CGColor);
            [clipImage drawInRect:NSMakeRect(0,0,image.size.width,image.size.height)];
            if(IShotGlobal_1001de0d5) [borderImage drawInRect:NSMakeRect(-12-shadow,-12-shadow,image.size.width+shadow+12,image.size.height+shadow+12)];
            else [borderImage drawInRect:NSMakeRect(0,0,image.size.width,image.size.height)];
            [annotationImage drawInRect:NSMakeRect(0,0,image.size.width,image.size.height)];
        } else {
            if(shadow>0 && !IShotGlobal_1001de0d5) CGContextSetShadowWithColor(context,CGSizeZero,shadow*1.1,color.CGColor);
            NSDictionary *item=windows[0]; NSRect area=[item[@"rect"] rectValue]; if(IShotGlobal_1001de0d5) { area.origin.x-=shadow; area.origin.y-=shadow; }
            [(NSImage *)item[@"KCGWindowImage"] drawInRect:area];
            if(shadow>0) CGContextSetShadowWithColor(context,CGSizeZero,shadow*1.1,NSColor.clearColor.CGColor);
            [clipImage drawInRect:NSMakeRect(0,0,image.size.width,image.size.height)];
            double inset=IShotGlobal_1001de0d5 ? 0 : shadow;
            [borderImage drawInRect:NSMakeRect(inset,inset,image.size.width,image.size.height)];
            [annotationImage drawInRect:NSMakeRect(0,0,image.size.width,image.size.height)];
        }
        [NSGraphicsContext restoreGraphicsState]; [image unlockFocus];
        if(IShotGlobal_1001de0d5) {
            [controller cancel];
            dispatch_async(dispatch_get_main_queue(),^{ // 0x10001bd50
                [[AppDelegate appDelegate] savePinImageToTempDirectory:image];
                NSInteger action=[defaults integerForKey:@"whenPinAction"];
                if(action==2 || action==3) [NSImage saveImageToPaste:image];
                if(action==1 || action==3) [controller saveToFileOnlyForWhenPin:image];
                [Global pinToScreenWithImage:image rect:NSMakeRect(rect.origin.x+IShotGlobal_1001dde80.frame.origin.x,rect.origin.y+IShotGlobal_1001dde80.frame.origin.y,rect.size.width,rect.size.height)];
            }); return;
        }
    }
output:
    if(!image) { [controller cancel]; return; }
    if(IShotGlobal_1001de0d2) [Global startOCRFromImage:image];
    else if(IShotGlobal_1001de0d1) {
        if(!IShotGlobal_1001de0d4) { IShotFunction_100047ffc([@"TelliShotHelperToUserNotification:" stringByAppendingString:@""]); [NSImage saveImageToPaste:image]; }
        else { IShotGlobal_1001de0d4=NO; [controller saveAsFile:image]; }
    } else {
        if([defaults boolForKey:@"alsoSaveToPaste"] && !IShotGlobal_1001dde90) [NSImage saveImageToPaste:image];
        if(IShotGlobal_1001dde90 && [defaults integerForKey:@"doubleLeftButtonAction"]==5) [NSImage saveImageToPaste:image];
        NSString *format=[defaults stringForKey:@"formatOfSavePhoto"]; if(!format) format=@"jpg";
        NSDate *date=NSDate.date; NSDateFormatter *formatter=[[NSDateFormatter alloc] init]; formatter.dateFormat=@"yyyy-MM-dd_HH.mm.ss";
        NSString *name=[[[NSBundle.mainBundle localizedStringForKey:@"iShot" value:@"" table:nil] stringByAppendingString:@"_"] stringByAppendingString:[formatter stringFromDate:date]];
        NSString *path=[defaults stringForKey:@"pathofSaveScreenShotsPhoto"];
        if([path isEqualToString:@"NotSpecified"]) {
            [controller cancel]; dispatch_async(dispatch_get_main_queue(),^{ [[AppDelegate appDelegate] saveImageOfNotSpecified:image]; });
        } else {
            if(![NSFileManager.defaultManager fileExistsAtPath:path]) {
                NSAlert *alert=[[NSAlert alloc] init]; alert.messageText=[NSBundle.mainBundle localizedStringForKey:@"The save path you set does not exist. Please reset the save path." value:@"" table:nil]; [alert addButtonWithTitle:[NSBundle.mainBundle localizedStringForKey:@"OK" value:@"" table:nil]]; [alert runModal];
                path=[[AppDelegate appDelegate] getSavePathWithOpenPanel]; if([path isEqualToString:@""]) { [controller cancel]; return; }
                [defaults setObject:path forKey:@"pathofSaveScreenShotsPhoto"]; [defaults synchronize];
                if(IShotGlobal_1001de1a0) { [IShotGlobal_1001de1a0.buttonOfSaveImagePath.menu.itemArray[0] setTitle:[NSFileManager.defaultManager displayNameAtPath:path].lastPathComponent]; [IShotGlobal_1001de1a0.buttonOfSaveImagePath selectItemAtIndex:0]; }
            }
            NSUInteger type; NSString *extension;
            if([format isEqualToString:@"jpg"]) { type=3; extension=@"jpg"; } else if([format isEqualToString:@"png"]) { type=4; extension=@"png"; } else if([format isEqualToString:@"tiff"]) { type=0; extension=@"tiff"; } else if([format isEqualToString:@"webp"]) { type=100000; extension=@"webp"; } else if([format isEqualToString:@"heic"]) { type=100001; extension=@"heic"; } else { type=100002; extension=@"pdf"; }
            NSString *destination=[NSString stringWithFormat:@"%@/%@.%@",path,name,extension];
            [[AppSandboxFileAccess fileAccessWithMessage:@""] accessFilePath:path persistPermission:YES withBlock:^{ [NSImage saveImage:image toFile:destination withType:type]; }];
        }
    }
    dispatch_after(dispatch_time(0,10000000),dispatch_get_main_queue(),^{ [controller cancel]; });
}
