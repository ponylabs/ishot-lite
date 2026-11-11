// Include the actual recovered production code; rename only its entry symbol.
#define main recovered_helper_main
#import "../main.m"
#undef main
#import <objc/runtime.h>
#include <assert.h>

@interface MemoryDefaults : NSUserDefaults
@property(nonatomic, strong) NSMutableDictionary *values;
@end
@implementation MemoryDefaults
- (id)objectForKey:(NSString *)key { return self.values[key]; }
- (void)setObject:(id)value forKey:(NSString *)key { self.values[key] = value; }
- (void)removeObjectForKey:(NSString *)key { [self.values removeObjectForKey:key]; }
- (BOOL)boolForKey:(NSString *)key { return [self.values[key] boolValue]; }
- (NSInteger)integerForKey:(NSString *)key { return [self.values[key] integerValue]; }
- (NSString *)stringForKey:(NSString *)key { return self.values[key]; }
- (void)setBool:(BOOL)value forKey:(NSString *)key { self.values[key] = @(value); }
- (void)setInteger:(NSInteger)value forKey:(NSString *)key { self.values[key] = @(value); }
- (BOOL)synchronize { return YES; }
@end
@interface NotificationRecorder : NSObject
@property(nonatomic, strong) NSMutableArray *posts;
@property(nonatomic, strong) NSMutableArray *observers;
@end
@implementation NotificationRecorder
- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(NSString *)object suspensionBehavior:(NSNotificationSuspensionBehavior)behavior {
    [self.observers addObject:@{ @"observer":observer, @"selector":NSStringFromSelector(selector), @"name":name ?: NSNull.null, @"object":object ?: NSNull.null, @"behavior":@(behavior) }];
}
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)info deliverImmediately:(BOOL)immediate {
    [self.posts addObject:@{ @"name":name, @"object":object, @"info":info ?: NSNull.null, @"immediate":@(immediate) }];
}
@end
static MemoryDefaults *memoryDefaults;
static NotificationRecorder *notificationRecorder;
static id fakeDefaults(id self, SEL selector) { return memoryDefaults; }
static id fakeCenter(id self, SEL selector) { return notificationRecorder; }
static void unexpectedSideEffect(id self, SEL selector, ...) {
    fprintf(stderr, "FAIL: forbidden startup/side effect %s\n", sel_getName(selector));
    abort();
}
static void guard(Class cls, SEL selector) {
    Method method = class_getInstanceMethod(cls, selector);
    assert(method);
    method_setImplementation(method, (IMP)unexpectedSideEffect);
}
static NSString *resourceDirectory;
static NSString *nibPath;
int main(int argc, const char *argv[]) {
    @autoreleasepool {
        assert(argc == 2);
        resourceDirectory = [NSString stringWithUTF8String:argv[1]];
        nibPath = [resourceDirectory stringByAppendingPathComponent:@"Base.lproj/MainMenu.nib"];
        // These guards are local to this executable. None alter the production source.
        guard(AppDelegate.class, @selector(applicationDidFinishLaunching:));
        guard(NSTask.class, @selector(launch));
        guard(NSWorkspace.class, @selector(launchApplication:));
        guard(NSWorkspace.class, @selector(launchAppWithBundleIdentifier:options:additionalEventParamDescriptor:launchIdentifier:));
        guard(NSWorkspace.class, @selector(openURL:));
        guard(NSApplication.class, @selector(terminate:));
        [NSApplication sharedApplication];
        assert(NSApp.delegate == nil);
        NSNib *nib = [[NSNib alloc] initWithNibData:[NSData dataWithContentsOfFile:nibPath] bundle:NSBundle.mainBundle];
        assert(nib);
        NSArray *topLevel = nil;
        assert([nib instantiateWithOwner:NSApp topLevelObjects:&topLevel]);
        assert([NSApp.delegate isKindOfClass:AppDelegate.class]);
        AppDelegate *delegate = (AppDelegate *)NSApp.delegate;
        assert([AppDelegate appDelegate] == delegate);
        assert([topLevel containsObject:delegate]);
        assert(delegate.statusItem == nil && delegate.menuBarView == nil && delegate.statusItemMenu == nil);
        printf("PASS: original MainMenu.nib instantiated and NSApplication.delegate bound to recovered AppDelegate; didFinish not invoked\n");

        memoryDefaults = [[MemoryDefaults alloc] init];
        memoryDefaults.values = [@{ @"dicOfShortCutKey":@{ @"regionalScreenshotsRecorder":@{ @"modifierFlags":@(NSEventModifierFlagCommand), @"charactersIgnoringModifiers":@"a" } } } mutableCopy];
        groupDefaults = memoryDefaults;
        Method defaultsMethod = class_getClassMethod(NSUserDefaults.class, @selector(standardUserDefaults));
        IMP defaultsOriginal = method_setImplementation(defaultsMethod, (IMP)fakeDefaults);
        [delegate refreshStatusItemMenu];
        NSArray *actions = @[ @"OpenPreferences:", @"", @"regionalScreenshots:", @"mapFromPaste:", @"delayScreenShot:", @"screenShotWithShell:", @"recordScreenClicked:", @"startRecordAudio:", @"openPinLibraryWindow:", @"", @"SelectTheLastSavedFile:", @"", @"Quit:" ];
        assert(delegate.statusItemMenu.numberOfItems == (NSInteger)actions.count);
        for (NSUInteger i = 0; i < actions.count; i++) {
            NSMenuItem *item = [delegate.statusItemMenu itemAtIndex:i];
            if ([actions[i] length]) assert([NSStringFromSelector(item.action) isEqualToString:actions[i]]);
            else assert(item.isSeparatorItem);
        }
        assert([[delegate.statusItemMenu itemAtIndex:2].keyEquivalent isEqualToString:@"a"]);
        assert([delegate.statusItemMenu itemAtIndex:2].keyEquivalentModifierMask == NSEventModifierFlagCommand);
        [memoryDefaults setBool:YES forKey:@"iShotHavePurchased"];
        [delegate refreshStatusItemMenu];
        assert(delegate.statusItemMenu.numberOfItems == (NSInteger)actions.count);
        for (NSMenuItem *item in delegate.statusItemMenu.itemArray) {
            assert(item.action != @selector(gotoOMNIVideoPlay:));
            assert(item.action != @selector(gotoOMNIVideoConverter:));
        }
        method_setImplementation(defaultsMethod, defaultsOriginal);
        printf("PASS: real NSMenu order, separators, shortcut, and purchase-state independence\n");

        notificationRecorder = [[NotificationRecorder alloc] init];
        notificationRecorder.posts = [NSMutableArray array];
        notificationRecorder.observers = [NSMutableArray array];
        Method centerMethod = class_getClassMethod(NSDistributedNotificationCenter.class, @selector(defaultCenter));
        IMP centerOriginal = method_setImplementation(centerMethod, (IMP)fakeCenter);
        MenuView *view = [[MenuView alloc] initWithFrame:NSMakeRect(0, 0, 28, 24)];
        assert(view && NSEqualRects(view.appIconView.frame, NSMakeRect(3, 1, 20, 20)));
        assert([view.subviews containsObject:view.appIconView]);
        assert(notificationRecorder.observers.count == 1);
        NSDictionary *observer = notificationRecorder.observers[0];
        assert([observer[@"object"] isEqualToString:@"cn.better365.iShot"]);
        assert([observer[@"selector"] isEqualToString:@"telliShotHelperToDo:"]);
        assert(observer[@"name"] == NSNull.null);
        assert([observer[@"behavior"] integerValue] == NSNotificationSuspensionBehaviorDeliverImmediately);
        [delegate regionalScreenshots:nil];
        [delegate OpenPreferences:nil];
        assert(notificationRecorder.posts.count == 2);
        assert([notificationRecorder.posts[0][@"name"] isEqualToString:@"TelliShotToScreenShots"]);
        assert([notificationRecorder.posts[1][@"name"] isEqualToString:@"TelliShotToOpenPreferencesWindow"]);
        for (NSDictionary *post in notificationRecorder.posts) {
            assert([post[@"object"] isEqualToString:@"cn.better365.group"]);
            assert([post[@"immediate"] boolValue]);
            assert(post[@"info"] == NSNull.null);
        }
        method_setImplementation(centerMethod, centerOriginal);
        printf("PASS: real MenuView geometry and intercepted observer/action transport; no distributed messages emitted\n");
        NSApp.delegate = nil;
    }
    return 0;
}
