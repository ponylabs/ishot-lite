// Integration harness: links the real recovered application objects, never the
// original executable. Nib paths/connections come from the decoded archive table.
#import <Cocoa/Cocoa.h>
#import "../Sources/Preferences/AppPrefsWindowController.h"
#import <objc/runtime.h>
#import <objc/message.h>
static NSUInteger failures, actionChecks, outletChecks;
static NSMutableArray *distributedPosts;
extern BOOL IShotFunction_10004abbc(void);
static void RecordDistributedPost(id center, SEL selector, NSString *name, NSString *object, NSDictionary *info, BOOL immediate) {
    [distributedPosts addObject:@{@"name":name ?: @"", @"object":object ?: @"", @"immediate":@(immediate)}];
}
static void Failure(NSString *message) { failures++; fprintf(stderr,"FAIL %s\n",message.UTF8String); }
static Class RuntimeClass(NSString *name) {
    // CameraWindow's archived File's Owner name differs from its actual caller
    // at 0x100004ba8: CameraWindowController loads CameraWindow with owner:self.
    if([name isEqual:@"CameraPreview"]) name=@"CameraWindowController";
    if([name isEqual:@"NSWindowTemplate"]) name=@"NSWindow";
    return NSClassFromString(name);
}
static void WalkActions(id object, NSHashTable *seen) {
    if([object isKindOfClass:NSControl.class] && [(NSControl *)object action]==NSSelectorFromString(@"rateOnAppStore:")) Failure(@"Removed rating button remains attached");
    if(!object || [seen containsObject:object]) return;
    [seen addObject:object];
    if([object isKindOfClass:NSControl.class] || [object isKindOfClass:NSMenuItem.class]) {
        id target=[object target]; SEL action=[object action];
        // A nil target is a responder-chain action and cannot be resolved until
        // its window is active; never invoke actions during validation.
        BOOL submenuDispatch=[object isKindOfClass:NSMenuItem.class] && [object submenu] && [target isKindOfClass:NSMenu.class] && [NSStringFromSelector(action) isEqual:@"submenuAction:"];
        // AppKit assigns this internal sentinel to submenu headers; it is not
        // an archived controller action and NSMenu does not advertise the SEL.
        if(target && action && !submenuDispatch) {
            actionChecks++;
            if(![target respondsToSelector:action]) Failure([NSString stringWithFormat:@"%@ target %@ lacks %@",object,[target class],NSStringFromSelector(action)]);
        }
    }
    if([object isKindOfClass:NSWindow.class]) { [object orderOut:nil]; WalkActions([object contentView],seen); }
    if([object isKindOfClass:NSView.class]) for(id child in [object subviews]) WalkActions(child,seen);
    if([object isKindOfClass:NSMenu.class]) for(id item in [object itemArray]) WalkActions(item,seen);
    if([object isKindOfClass:NSMenuItem.class]) WalkActions([object submenu],seen);
    if([object isKindOfClass:NSPopUpButton.class]) WalkActions([object menu],seen);
}
int main(int argc,const char **argv) { @autoreleasepool {
    if(argc<3) { fprintf(stderr,"usage: MainAppValidation project-root resources-root [nib-path-substring] [--audit-only]\n"); return 2; }
    NSString *root=@(argv[1]), *resources=@(argv[2]);
    BOOL auditOnly=NO; NSString *filter=nil;
    for(int i=3;i<argc;i++) if(!strcmp(argv[i],"--audit-only")) auditOnly=YES; else filter=@(argv[i]);
    distributedPosts=[NSMutableArray new];
    // Test-process isolation only: nib awakening can enter framework callbacks.
    // Record external notifications instead of affecting another running app.
    method_setImplementation(class_getInstanceMethod(NSDistributedNotificationCenter.class,
        @selector(postNotificationName:object:userInfo:deliverImmediately:)),(IMP)RecordDistributedPost);
    [NSApplication sharedApplication]; [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
    // Same registerDefaults source as applicationWillFinishLaunching: 0x1000a71e0.
    NSMutableDictionary *defaults=[[NSDictionary dictionaryWithContentsOfFile:[resources stringByAppendingPathComponent:@"DefaultPreferences.plist"]] mutableCopy];
    if(!defaults) { Failure(@"DefaultPreferences.plist missing"); return 1; }
    [defaults removeObjectForKey:@"dicOfShortCutKeyOver15"];
    [NSUserDefaults.standardUserDefaults registerDefaults:defaults];
    // Select the real existing no-camera branch (CameraWindowController 0x100004f88).
    NSMutableDictionary *arguments=[[NSUserDefaults.standardUserDefaults volatileDomainForName:NSArgumentDomain] mutableCopy];
    arguments[@"selectedCameraOfRecordScreen"]=@"None";
    arguments[@"selectedMicrophoneForRecordAudio"]=@"None";
    arguments[@"formatOfRecording"]=@"wav";
    [NSUserDefaults.standardUserDefaults setVolatileDomain:arguments forName:NSArgumentDomain];
    NSData *data=[NSData dataWithContentsOfFile:[root stringByAppendingPathComponent:@"reconstruction/build/lite-nib-dependencies.json"]];
    NSArray *manifest=data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] : nil;
    if(![manifest isKindOfClass:NSArray.class] || !manifest.count) { Failure(@"decoded nib manifest missing or empty"); return 1; }
    NSMutableArray *retained=[NSMutableArray new], *nibResults=[NSMutableArray new]; NSUInteger audited=0,loaded=0,skipped=0;
    for(NSDictionary *nib in manifest) {
        NSString *relative=nib[@"path"];
        if(![relative isKindOfClass:NSString.class] || !relative.length || relative.isAbsolutePath ||
           [relative.pathComponents containsObject:@".."] || ![relative.pathExtension isEqual:@"nib"]) {
            Failure(@"nib manifest must contain resource-relative nib paths"); continue;
        }
        if ([@[@"BuyFromAppStore.nib", @"OCRAndTranslate.nib"] containsObject:relative.lastPathComponent]) {
            if ([NSFileManager.defaultManager fileExistsAtPath:[resources stringByAppendingPathComponent:relative]]) Failure(@"Retired nib remains packaged");
            continue;
        }
        if(filter && ![relative containsString:filter]) continue;
        audited++;
        for(NSString *name in nib[@"custom_classes"]) if(!RuntimeClass(name)) Failure([NSString stringWithFormat:@"%@ missing class %@",relative,name]);
        NSString *ownerName=nil;
        for(NSDictionary *connection in nib[@"connections"]) {
            NSDictionary *source=connection[@"source"], *destination=connection[@"destination"];
            if([source[@"object"] integerValue]==2) ownerName=source[@"class"];
            if([connection[@"kind"] isEqual:@"NSNibControlConnector"] && [destination isKindOfClass:NSDictionary.class]) {
                NSString *name=destination[@"class"];
                Class target=RuntimeClass(name);
                SEL selector=NSSelectorFromString(connection[@"label"]);
                if(target && ![target instancesRespondToSelector:selector]) Failure([NSString stringWithFormat:@"%@ archive action %@ absent on %@",relative,connection[@"label"],name]);
            }
        }
        if(auditOnly) continue;
        // 0x100006930 only writes a device property when this exact driver
        // exists. WAV init creates a delay effect unit; it does not capture.
        if([relative.lastPathComponent isEqual:@"RecordAudio.nib"] && IShotFunction_10004abbc()) {
            skipped++; [nibResults addObject:@{@"path":relative,@"status":@"audit-only",@"reason":@"installed audio driver volume side effect"}];
            fprintf(stdout,"AUDIT-ONLY %s (installed driver volume side effect)\n",relative.UTF8String); continue;
        }
        @try {
            Class ownerClass=RuntimeClass(ownerName); id owner;
            if(ownerClass==NSApplication.class) owner=NSApp;
            else if([ownerClass isSubclassOfClass:NSWindowController.class]) owner=[[ownerClass alloc] initWithWindow:nil];
            else if([ownerClass isSubclassOfClass:NSViewController.class]) owner=[[ownerClass alloc] initWithNibName:nil bundle:nil];
            else owner=[[ownerClass alloc] init];
            if(!owner) { Failure([NSString stringWithFormat:@"%@ missing owner %@",relative,ownerName]); continue; }
            NSNib *archive=[[NSNib alloc] initWithNibData:[NSData dataWithContentsOfFile:[resources stringByAppendingPathComponent:relative]] bundle:NSBundle.mainBundle];
            NSArray *top=nil;
            if(![archive instantiateWithOwner:owner topLevelObjects:&top]) { Failure([NSString stringWithFormat:@"%@ instantiate returned NO",relative]); continue; }
            [retained addObject:owner]; if(top) [retained addObjectsFromArray:top];
            if([NSStringFromClass([owner class]) isEqual:@"AppPrefsWindowController"]) {
                NSTabView *tabs=[owner valueForKey:@"tabView"];
                NSTabViewItem *general=tabs.tabViewItems[6];
                [owner windowDidLoad];
                if(tabs.tabViewItems.count!=7 || tabs.tabViewItems.lastObject!=general) Failure(@"Lite sidebar/page order must preserve General after removing five sections");
                NSArray *entries=[[owner valueForKey:@"leftMenuHandler"] valueForKey:@"dataList"];
                if(entries.count!=7 || ![entries.lastObject[@"image"] isEqual:@"General1"]) Failure(@"Lite sidebar entries");
                if([owner valueForKey:@"freeAppsVC"]) Failure(@"Removed Free Apps catalog must not initialize");
                [owner switchTabWithIndex:6];
                if(tabs.selectedTabViewItem!=general) Failure(@"General tab selection");
                if([owner respondsToSelector:NSSelectorFromString(@"buyButton")]) Failure(@"Lite purchase button must be absent");
                if(![[[owner valueForKey:@"version"] stringValue] hasPrefix:@"iShot Lite"]) Failure(@"Lite version label");
                if(![[[owner valueForKey:@"window"] title] isEqual:@"iShot Lite"]) Failure(@"Lite preferences window title");
            }
            for(NSDictionary *connection in nib[@"connections"]) {
                if(![connection[@"kind"] isEqual:@"NSNibOutletConnector"] || [connection[@"source"][@"object"] integerValue]!=2) continue;
                NSString *label=connection[@"label"];
                id value=[owner valueForKey:label]; outletChecks++;
                if(!value) Failure([NSString stringWithFormat:@"%@ owner outlet %@ nil",relative,label]);
            }
            NSHashTable *seen=[NSHashTable hashTableWithOptions:NSPointerFunctionsObjectPointerPersonality];
            for(id object in top) WalkActions(object,seen);
            loaded++; [nibResults addObject:@{@"path":relative,@"status":@"loaded"}]; fprintf(stdout,"LOADED %s\n",relative.UTF8String);
        } @catch(NSException *exception) { [nibResults addObject:@{@"path":relative,@"status":@"exception",@"exception":exception.description}]; Failure([NSString stringWithFormat:@"%@ %@: %@",relative,exception.name,exception.reason]); }
    }
    if(!audited) Failure(@"No nibs selected for validation");
    fprintf(stdout,"RESULT audited=%lu loaded=%lu auditOnly=%lu outlets=%lu actions=%lu failures=%lu\n",audited,loaded,skipped,outletChecks,actionChecks,failures);
    NSDictionary *report=@{@"audited":@(audited),@"loaded":@(loaded),@"auditOnly":@(skipped),@"ownerOutlets":@(outletChecks),@"actionChecks":@(actionChecks),@"failures":@(failures),@"nibs":nibResults,@"interceptedDistributedNotifications":distributedPosts,@"isolation":@"Outgoing four-argument distributed notifications are intercepted only in the validation process; no purchase or capture action invoked. Camera=None, microphone=None, format=wav are volatile test preferences."};
    [[NSJSONSerialization dataWithJSONObject:report options:NSJSONWritingPrettyPrinted error:NULL] writeToFile:[root stringByAppendingPathComponent:@"reconstruction/build/nib-validation.json"] atomically:YES];
    // No run loop: no async capture or purchase action is dispatched by this harness.
    return failures ? 1:0;
} }
