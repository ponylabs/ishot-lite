+ (void)saveKeyEventInfo:(NSEvent *)event { // 0x10000fdc4
    NSTimeInterval now=NSDate.date.timeIntervalSince1970;
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSMutableArray *items=[NSMutableArray arrayWithArray:[defaults objectForKey:@"keyboardInfoArr"]];
    NSString *timestamp=[NSString stringWithFormat:@"%.3f",now];
    uint32_t keyCode=event.keyCode, flags=(uint32_t)event.modifierFlags;
    if ([defaults boolForKey:@"onlyShowShortcutsOfKeyEvent"] && !(flags & 0x1e0000)) return;
    SRRecorderControlWithTagid *recorder=[[SRRecorderControlWithTagid alloc] init];
    recorder.objectValue=@{@"keyCode":@(keyCode),@"modifierFlags":@256};
    NSString *text=recorder.stringValue;
    if ([text isEqualToString:@""]) return;
    if ([defaults boolForKey:@"notShowRepeatKeysOfKeyEvent"] && [items.lastObject[@"String"] isEqualToString:text]) [items removeLastObject];
    NSArray *modifiers=@[@"⇪",@"Fn",@"⇧",@"⌃",@"⌘",@"⌥"];
    int count=0;
    for (NSUInteger i=0;i<items.count;i++) if (![modifiers containsObject:items[i][@"String"]]) count++;
    if ([defaults floatForKey:@"maxKeysOfKeyEvent"]-1.0f < (float)count) {
        NSArray *copy=[items copy];
        for (NSUInteger i=0;i<copy.count;i++) if (![modifiers containsObject:copy[i][@"String"]]) [items removeObject:copy[i]];
    }
    [items addObject:@{@"Timestamp":timestamp,@"String":text,@"KeyCode":@(keyCode)}];
    if (items) [defaults setObject:items forKey:@"keyboardInfoArr"];
}
+ (void)saveFlagsChangedEventInfo:(NSEvent *)event { // 0x1000106e8
    NSTimeInterval now=NSDate.date.timeIntervalSince1970;
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSMutableArray *items=[NSMutableArray arrayWithArray:[defaults objectForKey:@"keyboardInfoArr"]];
    NSString *timestamp=[NSString stringWithFormat:@"%.3f",now];
    uint32_t flags=(uint32_t)event.modifierFlags, key=event.keyCode;
    NSArray *copy=[items copy];
    if (flags&0x10000) {
        [items addObject:@{@"Timestamp":timestamp,@"String":@"⇪"}];
    } else if ((flags&0x800000) && key==63) {
        [items addObject:@{@"Timestamp":timestamp,@"String":@"Fn",@"KeyCode":@63}];
    } else {
        NSString *text=nil;
        if ((flags&0x20000) && (key&0xfffffffb)==56) text=@"⇧";
        else if ((flags&0x40000) && key==59) text=@"⌃";
        else if ((flags&0x100000) && (key&0xfffe)==54) text=@"⌘";
        else if ((flags&0x80000) && (key==61 || key==58)) text=@"⌥";
        if (text) {
            for (NSDictionary *item in copy) if ([item[@"String"] isEqualToString:text]) [items removeObject:item];
            [items addObject:@{@"Timestamp":timestamp,@"String":text,@"KeyCode":@(key)}];
        }
    }
    if (items) [defaults setObject:items forKey:@"keyboardInfoArr"];
}
