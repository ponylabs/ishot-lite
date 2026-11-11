#import "AppSandboxFileAccess.h"
@implementation AppSandboxFileAccessPersist
- (NSData *)bookmarkDataForURL:(NSURL *)url {
    NSMutableDictionary *bookmarks=[NSMutableDictionary dictionaryWithDictionary:[NSUserDefaults.standardUserDefaults dictionaryForKey:@"cachedBookmarks"]];
    NSData *data=bookmarks[url.path];
    while(!data && ![url.path isEqualToString:@"/"]) { url=url.URLByDeletingLastPathComponent; data=bookmarks[url.path]; }
    return data;
}
- (void)setBookmarkData:(NSData *)data forURL:(NSURL *)url {
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSMutableDictionary *bookmarks=[NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:@"cachedBookmarks"]];
    NSString *path=url.path;
    for(NSString *key in bookmarks.allKeys) {
        if([key hasPrefix:path] && (key.length==path.length || [path isEqual:@"/"] || [key characterAtIndex:path.length]=='/')) [bookmarks removeObjectForKey:key];
    }
    [bookmarks setObject:data forKey:path]; [defaults setObject:bookmarks forKey:@"cachedBookmarks"]; [defaults synchronize];
}
- (void)clearBookmarkDataForURL:(NSURL *)url {
    NSUserDefaults *defaults=NSUserDefaults.standardUserDefaults;
    NSMutableDictionary *bookmarks=[NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:@"cachedBookmarks"]];
    [bookmarks removeObjectForKey:url.path]; [defaults setObject:bookmarks forKey:@"cachedBookmarks"];
}
+ (NSString *)keyForBookmarkDataForURL:(NSURL *)url { return url.absoluteString; }
@end
@implementation AppSandboxFileAccessOpenSavePanelDelegate
- (instancetype)initWithFileURL:(NSURL *)url { if((self=[super init])) self.pathComponents=url.pathComponents; return self; }
- (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url {
    NSArray *original=self.pathComponents,*candidate=url.pathComponents;
    if(original.count<candidate.count) return NO;
    for(NSUInteger i=0;i<candidate.count;i++) if(![candidate[i] isEqualToString:original[i]]) return NO;
    return YES;
}
@end
@implementation AppSandboxFileAccess
@synthesize bookmarkPersistanceDelegate=_bookmarkPersistanceDelegate;
+ (instancetype)fileAccessWithMessage:(NSString *)message { return [[AppSandboxFileAccess alloc] initWithMessage:message]; }
- (instancetype)initWithMessage:(NSString *)message {
    if((self=[super init])) {
        NSString *name=[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if(!name) name=[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
        self.title=[NSBundle.mainBundle localizedStringForKey:@"AllowAccess" value:@"" table:nil];
        self.message=[NSString stringWithFormat:message,name];
        self.prompt=[NSBundle.mainBundle localizedStringForKey:@"Authorization" value:@"" table:nil];
        self.defaultDelegate=[AppSandboxFileAccessPersist new]; self.bookmarkPersistanceDelegate=_defaultDelegate;
    } return self;
}
- (void)setBookmarkPersistanceDelegate:(id<AppSandboxFileAccessProtocol>)delegate { _bookmarkPersistanceDelegate=delegate ?: self.defaultDelegate; }
- (NSURL *)askPermissionForURL:(NSURL *)url {
    __block NSURL *result=nil;
    AppSandboxFileAccessOpenSavePanelDelegate *delegate=[[AppSandboxFileAccessOpenSavePanelDelegate alloc] initWithFileURL:url];
    NSFileManager *manager=NSFileManager.defaultManager; NSString *path=url.path;
    while(path.length>1 && ![manager fileExistsAtPath:path isDirectory:NULL]) path=path.stringByDeletingLastPathComponent;
    NSURL *directory=[NSURL fileURLWithPath:path];
    void (^show)(void)=^{
        NSOpenPanel *panel=NSOpenPanel.openPanel;
        panel.canCreateDirectories=NO; panel.canChooseFiles=YES; panel.canChooseDirectories=YES; panel.allowsMultipleSelection=NO;
        panel.prompt=self.prompt; panel.title=self.title; panel.showsHiddenFiles=NO; panel.extensionHidden=NO;
        panel.directoryURL=directory; panel.delegate=delegate;
        if(![self.message isEqualToString:@""]) {
            NSTextField *label=[[NSTextField alloc] initWithFrame:NSMakeRect(0,0,100,100)];
            label.stringValue=self.message; label.bezeled=NO; label.drawsBackground=NO; label.editable=NO; label.selectable=NO;
            label.font=[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:label.cell.controlSize]];
            NSSize size=[label.cell cellSizeForBounds:NSMakeRect(0,0,800,100)]; label.frame=NSMakeRect(0,0,size.width,size.height);
            panel.accessoryView=label;
        }
        if([panel respondsToSelector:@selector(isAccessoryViewDisclosed)]) panel.accessoryViewDisclosed=YES;
        [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
        if([panel runModal]==NSModalResponseOK) {
            result=panel.URL;
            NSData *data=[result bookmarkDataWithOptions:0x800 includingResourceValuesForKeys:nil relativeToURL:nil error:NULL];
            if(data) [self.bookmarkPersistanceDelegate setBookmarkData:data forURL:result];
        }
    };
    if(NSThread.isMainThread) show(); else dispatch_sync(dispatch_get_main_queue(),show);
    return result;
}
- (NSData *)persistPermissionPath:(NSString *)path { return [self persistPermissionURL:[NSURL fileURLWithPath:path]]; }
- (NSData *)persistPermissionURL:(NSURL *)url {
    NSData *data=[url bookmarkDataWithOptions:0x800 includingResourceValuesForKeys:nil relativeToURL:nil error:NULL];
    if(data) [self.bookmarkPersistanceDelegate setBookmarkData:data forURL:url]; return data;
}
- (BOOL)accessFilePath:(NSString *)path withBlock:(void (^)(void))block persistPermission:(BOOL)persist { return [self accessFilePath:path persistPermission:persist withBlock:block]; }
- (BOOL)accessFileURL:(NSURL *)url withBlock:(void (^)(void))block persistPermission:(BOOL)persist { return [self accessFileURL:url persistPermission:persist withBlock:block]; }
- (BOOL)accessFilePath:(NSString *)path persistPermission:(BOOL)persist withBlock:(void (^)(void))block { return [self accessFileURL:[NSURL fileURLWithPath:path] persistPermission:persist withBlock:block]; }
- (BOOL)accessFileURL:(NSURL *)url persistPermission:(BOOL)persist withBlock:(void (^)(void))block {
    // 0x1000b8c38 starts access and invokes the no-argument block; no balancing stop exists in the original assembly.
    return [self requestAccessPermissionsForFileURL:url persistPermission:persist withBlock:^(NSURL *resolved,NSData *data) { [resolved startAccessingSecurityScopedResource]; block(); }];
}
- (BOOL)requestAccessPermissionsForFilePath:(NSString *)path persistPermission:(BOOL)persist withBlock:(void (^)(NSURL *,NSData *))block { return [self requestAccessPermissionsForFileURL:[NSURL fileURLWithPath:path] persistPermission:persist withBlock:block]; }
- (BOOL)requestAccessPermissionsForFileURL:(NSURL *)url persistPermission:(BOOL)persist withBlock:(void (^)(NSURL *,NSData *))block {
    NSURL *normalized=url.URLByStandardizingPath.URLByResolvingSymlinksInPath;
    NSData *data=[self.bookmarkPersistanceDelegate bookmarkDataForURL:normalized]; NSURL *resolved=nil;
    if(data) {
        BOOL stale;
        resolved=[NSURL URLByResolvingBookmarkData:data options:0x500 relativeToURL:nil bookmarkDataIsStale:&stale error:NULL];
        if(stale) { [self.bookmarkPersistanceDelegate clearBookmarkDataForURL:normalized]; if(resolved) data=[self persistPermissionURL:resolved]; else data=nil; if(!data) resolved=nil; }
    }
    if(!resolved) { resolved=[self askPermissionForURL:normalized]; if(!resolved) return NO; if(persist && !data) data=[self persistPermissionURL:resolved]; }
    if(block) block(resolved,data); return YES;
}
@end
