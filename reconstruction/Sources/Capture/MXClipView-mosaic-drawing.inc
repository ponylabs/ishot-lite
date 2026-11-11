- (void)drawAllMosaic { // 0x100032188
    NSMutableArray *visited=[NSMutableArray new];
    if (IShotGlobal_1001de058.count) [visited addObject:[NSString stringWithFormat:@"%@%@",IShotGlobal_1001de058[@"type"],IShotGlobal_1001de058[@"list"]]];
    if (IShotGlobal_1001de048<(int)IShotGlobal_1001de050.count && IShotGlobal_1001de050.count!=(NSInteger)IShotGlobal_1001de048) {
        for (NSInteger i=IShotGlobal_1001de050.count-(NSInteger)IShotGlobal_1001de048-1;i!=-1;i--) {
            NSDictionary *stroke=IShotGlobal_1001de050[i]; NSString *name=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
            if ([visited containsObject:name]) continue; [visited addObject:name];
            NSInteger type=[stroke[@"type"] integerValue];
            if (type==4) {
                if ([stroke[@"indexOfPencilMosaic"] intValue]>0) {
                    NSImage *image=stroke[@"imageOfMosaic"];
                    [image drawInRect:CGRectMake(-self.frame.origin.x,-self.frame.origin.y,image.size.width,image.size.height)];
                }
            } else if (type==5) {
                CGRect rect=IShotMXNormalizeMosaicRect([stroke[@"Rect"] rectValue]);
                [NSColor.clearColor set]; NSBezierPath *path=[NSBezierPath bezierPathWithRect:rect]; path.lineWidth=1; [path stroke];
                [stroke[@"mosaicImage"] drawInRect:rect fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1];
                if ([IShotGlobal_1001dde78 isEqualToString:name] && !IShotGlobal_1001de0d0) IShotMXDrawDashedRect(rect);
            }
        }
    }
}
- (void)drawAllBackgroundOfText { // 0x1000326dc
    NSMutableArray *visited=[NSMutableArray new];
    [visited addObject:[NSString stringWithFormat:@"%@%@",IShotGlobal_1001de058[@"type"],IShotGlobal_1001de058[@"list"]]];
    if (IShotGlobal_1001de048<(int)IShotGlobal_1001de050.count && IShotGlobal_1001de050.count!=(NSInteger)IShotGlobal_1001de048) {
        for (NSInteger i=IShotGlobal_1001de050.count-(NSInteger)IShotGlobal_1001de048-1;i!=-1;i--) {
            NSDictionary *stroke=IShotGlobal_1001de050[i]; NSString *name=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
            if ([visited containsObject:name]) continue; [visited addObject:name];
            if ([stroke[@"type"] integerValue]==6) {
                NSScrollView *scroll=stroke[@"scrollView"];
                if ([IShotGlobal_1001ddde8 isEqualToString:name] && !IShotGlobal_1001de0d0) {
                    NSTextView *text=stroke[@"textView"]; float fontSize=(float)text.font.pointSize; double pad=(int)(fontSize/15.f+2.f);
                    CGRect rect=CGRectMake(scroll.frame.origin.x-pad-3,scroll.frame.origin.y-3,scroll.frame.size.width+pad*.9+8,scroll.frame.size.height+8);
                    IShotMXDrawDashedRect(rect);
                }
            }
        }
    }
}
- (void)drawCurrentMosaicStroke { // 0x100032ad8
    CGRect original=[IShotGlobal_1001de058[@"Rect"] rectValue];
    if ((float)fabs(original.size.width)==0) return;
    CGRect rect=IShotMXNormalizeMosaicRect(original);
    int size=[IShotGlobal_1001de058[@"size"] intValue];
    NSScreen *screen=[NSScreen currentScreenForMouseLocation];
    int selected=[IShotGlobal_1001de058[@"selectedMosaic"] intValue];
    CGImageRef source; double x,baseHeight;
    if (selected) {
        source=(__bridge CGImageRef)IShotGlobal_1001dde88[(int)((uint32_t)size-1)];
        x=rect.origin.x+size; baseHeight=screen.frame.size.height+size;
    } else {
        source=(__bridge CGImageRef)IShotGlobal_1001dde88[(int)((uint32_t)size+9)];
        x=rect.origin.x; baseHeight=screen.frame.size.height;
    }
    float scale=(float)IShotGlobal_1001dde80.backingScaleFactor;
    double factor=(double)(scale+scale);
    CGImageRef cropped=CGImageCreateWithImageInRect(source,CGRectMake(x/factor,(baseHeight-rect.origin.y)/factor,rect.size.width/factor,-rect.size.height/factor));
    if (cropped) {
        NSImage *image=[MJMosaicUtil createNSImageFromCGImageRef:cropped]; CFRelease(cropped);
        if (image) {
            [image drawInRect:rect fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1];
            if ([IShotGlobal_1001de050 containsObject:IShotGlobal_1001de058]) {
                [IShotGlobal_1001de050 removeObject:IShotGlobal_1001de058];
                [IShotGlobal_1001de058 setObject:image forKey:@"mosaicImage"];
                [IShotGlobal_1001de050 addObject:[IShotGlobal_1001de058 copy]];
            } else [IShotGlobal_1001de058 setObject:image forKey:@"mosaicImage"];
        }
    }
    IShotMXDrawDashedRect(rect);
    NSColor *color=[NSColor colorWithDeviceRed:0 green:0x1.0505050505050p-1 blue:0x1.ababababababbp-1 alpha:.85];
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    if (context) {
        NSArray *handles=[self _calculateAllNeededHandleSquareRects:rect];
        for (NSInteger i=1;i!=9;i++) {
            CGRect handle=[handles[i] CGRectValue];
            CGContextSetRGBFillColor(context,color.redComponent,color.greenComponent,color.blueComponent,.85); CGContextFillEllipseInRect(context,handle);
            CGContextSetRGBFillColor(context,1,1,1,.95); CGContextFillEllipseInRect(context,CGRectInset(handle,1,1));
        }
    }
}
