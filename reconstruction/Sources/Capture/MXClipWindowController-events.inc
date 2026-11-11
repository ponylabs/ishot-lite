// 0x100016140 and nested blocks 0x100017370/0x100017388/0x1000173ac.
static NSEvent *IShotClipLocal(MXClipWindowController *controller,NSEvent *event) {
    MXClipView *view=controller.clipView;
    if(event.type==10) {
        NSUInteger flags=event.modifierFlags;
        if((CGEventSourceFlagsState(1)>0x20000000 || flags==0x100000) && event.keyCode==8) return nil;
        id responder=view.window.firstResponder;
        if(responder==[view indicatorFieldWidth] || responder==[view indicatorFieldHeight]) {
            unsigned short key=event.keyCode;
            if(key==36) { [view refreshIndicatorFieldSize]; return nil; }
            if(key!=51 && key!=53 && !(key>=123 && key<=126) && ![@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"] containsObject:event.characters]) { NSBeep(); return nil; }
            return event;
        }
        if(!IShotGlobal_1001de088) {
            unsigned short key=event.keyCode;
            if(key==15) {
                NSPasteboard *pasteboard=NSPasteboard.generalPasteboard; [pasteboard clearContents]; [pasteboard setString:IShotGlobal_1001ddfc8 forType:NSStringPboardType]; [controller cancel]; event=nil;
            } else if(key==4) {
                NSPasteboard *pasteboard=NSPasteboard.generalPasteboard; [pasteboard clearContents]; NSString *hex=IShotGlobal_1001ddfc0;
                if([NSUserDefaults.standardUserDefaults boolForKey:@"startsWith#ForHEXColor"]) hex=[@"#" stringByAppendingString:hex];
                [pasteboard setString:hex forType:NSStringPboardType]; [controller cancel]; event=nil;
            } else if(key==6) {
                NSString *custom=[NSUserDefaults.standardUserDefaults objectForKey:@"customizePickColorString"];
                if(custom && !(flags&0xe0000) && !(flags&0x100000) && IShotGlobal_1001ddfc8) {
                    NSArray *rgb=[IShotGlobal_1001ddfc8 componentsSeparatedByString:@","];
                    custom=[custom stringByReplacingOccurrencesOfString:@"_R" withString:rgb[0]];
                    custom=[custom stringByReplacingOccurrencesOfString:@"_G" withString:rgb[1]];
                    custom=[custom stringByReplacingOccurrencesOfString:@"_B" withString:rgb[2]];
                    NSPasteboard *pasteboard=NSPasteboard.generalPasteboard; [pasteboard clearContents]; [pasteboard setString:custom forType:NSStringPboardType]; [controller cancel];
                }
                event=nil;
            } else if(key==3) {
                if([controller.window.screen isEqual:NSScreen.currentScreenForMouseLocation]) { [view fullScreenCapture]; event=nil; }
            } else if(key==2) {
                if([controller.window.screen isEqual:NSScreen.currentScreenForMouseLocation]) { [view previousScreenshotAreaCapture]; event=nil; }
            } else {
                NSArray *digits=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
                NSUInteger index=NSNotFound;
                for(NSUInteger i=0;i<digits.count;i++) if([event.characters isEqualToString:digits[i]]) { index=i; break; }
                const uint64_t ratios[]={0,0x3ff0000000000000,0x3ff8000000000000,0x3ff5555555555555,0x3ff4000000000000,0x3ff6666666666666,0x3ffc71c71c71c71c,0x3fe2000000000000,0x3fe5555555555555,0x3fe8000000000000};
                if(index!=NSNotFound) memcpy(&IShotGlobal_1001ddcf8,&ratios[index],8);
            }
        }
        NSUInteger modifiers=flags&0x1e0000;
        if(modifiers==0x100000 || modifiers==0x120000) {
            if(event.keyCode==6 && view.canBecomeKeyView) [controller.window makeFirstResponder:view];
        } else if(modifiers==0) {
            if(event.keyCode==53) { dispatch_after(dispatch_time(0,50000000),dispatch_get_main_queue(),^{ [IShotGlobal_1001de160 cancelButtonClick:controller]; }); event=nil; }
            else if(IShotGlobal_1001dde94) { if(event.keyCode==51) IShotGlobal_1001ddd00=51; else if(event.keyCode==36) IShotGlobal_1001ddd00=36; }
        }
        if(IShotGlobal_1001ddfb8 && IShotGlobal_1001de050.count==0 && modifiers==0 && ![IShotGlobal_1001de058[@"textView"] acceptsFirstResponder] && event) { [view keyDown:event]; return nil; }
        if(event) [IShotGlobal_1001de160 keyDown:event];
        return event;
    }
    if(event.type==5) [IShotGlobal_1001de160 mouseMoved:event];
    else if(event.type==12) [IShotGlobal_1001de160 flagsChanged:event];
    else if(event.type==1) {
        if(!IShotGlobal_1001dded8 && !IShotGlobal_1001dded9) {
            id responder=view.window.firstResponder;
            if(responder==[view indicatorFieldWidth] || responder==[view indicatorFieldHeight]) { [view refreshIndicatorFieldSize]; return nil; }
        } else { [view.window makeFirstResponder:IShotGlobal_1001dded8 ? [view indicatorFieldWidth] : [view indicatorFieldHeight]]; return event; }
        if(IShotGlobal_1001de0c2) return event;
        if(![[view tipView] isHidden]) [[view tipView] setHidden:YES];
        if([IShotGlobal_1001dde70 isEqualToString:@"cursorInsertText"] && IShotGlobal_1001de088) return event;
        if(!IShotGlobal_1001dde80) IShotGlobal_1001dde80=NSScreen.currentScreenForMouseLocation;
        if([controller.window.screen isEqual:IShotGlobal_1001dde80]) [(MXClipView *)controller.window.contentView mousedown:event];
    } else if(event.type==22) {
        if(IShotGlobal_1001de088 && [controller.window.screen isEqual:IShotGlobal_1001de160.window.screen]) [IShotGlobal_1001de160 scrollWheelFromTextView:event];
    } else if(event.type==6) {
        IShotGlobal_1001ddcf0=YES;
        if(!IShotGlobal_1001de0c2 && [controller.window.screen isEqual:IShotGlobal_1001dde80]) [(MXClipView *)controller.window.contentView mousedragged:event];
    } else if(event.type==2) {
        dispatch_async(dispatch_get_global_queue(0,0),^{ usleep(100000); IShotGlobal_1001ddcf0=NO; });
        if(!IShotGlobal_1001de0c2 && !([IShotGlobal_1001dde70 isEqualToString:@"cursorInsertText"] && IShotGlobal_1001de088) && [controller.window.screen isEqual:IShotGlobal_1001dde80]) [(MXClipView *)controller.window.contentView mouseup:event];
    } else if(event.type==3 && [NSUserDefaults.standardUserDefaults boolForKey:@"RightClickToExitScreenshot"]) dispatch_after(dispatch_time(0,50000000),dispatch_get_main_queue(),^{ [IShotGlobal_1001de160 cancelButtonClick:controller]; });
    return event;
}
// 0x1000173c4 / 0x10001796c.
static void IShotClipGlobal(MXClipWindowController *controller,NSEvent *event) {
    MXClipView *view=controller.clipView;
    if(event.type==22) { if(!IShotGlobal_1001de0c2 && IShotGlobal_1001de0c0) [view scrollWheel:event]; }
    else if(event.type==12) [IShotGlobal_1001de160 flagsChanged:event];
    else if(event.type==1) {
        if(IShotGlobal_1001de0c2) return;
        if(![[view tipView] isHidden]) [[view tipView] setHidden:YES];
        if(!IShotGlobal_1001dde80) IShotGlobal_1001dde80=NSScreen.currentScreenForMouseLocation;
        if([controller.window.screen isEqual:IShotGlobal_1001dde80]) {
            if(!IShotGlobal_1001de088) { [(MXClipView *)controller.window.contentView mousedown:event]; [controller.window orderFront:controller]; [NSApp activateIgnoringOtherApps:YES]; }
            else if(IShotGlobal_1001de0c0) [(MXClipView *)controller.window.contentView mousedown:event];
        }
    } else if(event.type==6) {
        if(!IShotGlobal_1001de0c2 && [controller.window.screen isEqual:IShotGlobal_1001dde80] && !IShotGlobal_1001de088) [(MXClipView *)controller.window.contentView mousedragged:event];
    } else if(event.type==2) {
        if(!IShotGlobal_1001de0c2 && [controller.window.screen isEqual:IShotGlobal_1001dde80] && (!IShotGlobal_1001de088 || IShotGlobal_1001de0c0)) [(MXClipView *)controller.window.contentView mouseup:event];
    } else if(event.type==5) {
        if([controller.window.screen isEqual:NSScreen.currentScreenForMouseLocation]) { if(!IShotGlobal_1001de088) [controller.window.contentView mouseMoved:event]; else [IShotGlobal_1001de160 mouseMoved:event]; }
    } else if(event.type==4 && !IShotGlobal_1001de0c2 && [NSUserDefaults.standardUserDefaults boolForKey:@"RightClickToExitScreenshot"]) {
        dispatch_after(dispatch_time(0,50000000),dispatch_get_main_queue(),^{ if([controller.window.screen isEqual:NSScreen.currentScreenForMouseLocation]) [controller cancel]; });
    }
}
