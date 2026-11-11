// Test-only startup interception; product startup and capture scheduling are real.
#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>
#import "../Sources/Startup/MainEntry.h"
#include <assert.h>
static NSUserDefaults *standardFixture, *sharedFixture;
static int enteredApplication;
static NSUserDefaults *TestStandardDefaults(id cls, SEL selector) { return standardFixture; }
static IMP originalInit;
static id TestInitSuite(id object,SEL selector,NSString *name) NS_RETURNS_RETAINED;
static id TestInitSuite(id object,SEL selector,NSString *name) {
    if([name isEqualToString:@"4K6FWZU8C4.group.cn.better365"]) return sharedFixture;
    return ((id(*)(id,SEL,id))originalInit)(object,selector,name);
}
static int LiteTestApplicationMain(int argc,const char *argv[]) {
    assert(IShotGlobal_1001ddfd8 && !IShotGlobal_1001dd139);
    enteredApplication++; return 73;
}
#define NSApplicationMain LiteTestApplicationMain
#import "../Sources/Startup/MainEntry.m"
#undef NSApplicationMain

@interface ClipFixture : NSObject
- (BOOL)onlyClipCurrentWindow;
@end
@implementation ClipFixture
- (BOOL)onlyClipCurrentWindow { return YES; }
@end
@interface MXClipWindowController : NSObject
@property ClipFixture *clipView;
@end
@implementation MXClipWindowController @end
BOOL IShotGlobal_1001de0d0,IShotGlobal_1001de0c0;
static BOOL IShotClip_1001f18b4;
static BOOL rendered;
#import "../Sources/Capture/MXClipWindowController-preflight.inc"
static void IShotClipRender_10001984c(MXClipWindowController *controller,NSUserDefaults *defaults) {
    assert(controller.clipView && defaults==standardFixture);
    rendered=YES;
}
int main(void) {@autoreleasepool {
    NSString *standardName=[@"local.ishotlite.test." stringByAppendingString:NSUUID.UUID.UUIDString];
    NSString *sharedName=[standardName stringByAppendingString:@".shared"];
    standardFixture=[[NSUserDefaults alloc] initWithSuiteName:standardName];
    sharedFixture=[[NSUserDefaults alloc] initWithSuiteName:sharedName];
    [standardFixture setObject:@[@"en"] forKey:@"AppleLanguages"];
    Method standard=class_getClassMethod(NSUserDefaults.class,@selector(standardUserDefaults));
    IMP originalStandard=method_setImplementation(standard,(IMP)TestStandardDefaults);
    Method initialize=class_getInstanceMethod(NSUserDefaults.class,@selector(initWithSuiteName:));
    originalInit=method_setImplementation(initialize,(IMP)TestInitSuite);
    NSArray *receipts=@[NSNull.null,@"expired-receipt",@"malformed-receipt"];
    for(id receipt in receipts) {
        if(receipt==NSNull.null) [standardFixture removeObjectForKey:@"receipt"];
        else [standardFixture setObject:receipt forKey:@"receipt"];
        [standardFixture setObject:@{@"FirstInstallTime":@1} forKey:@"InstallTimeInfo"];
        [sharedFixture setInteger:1 forKey:@"AppStoreiShotInstallTime"];
        IShotGlobal_1001ddfd8=NO; IShotGlobal_1001dd139=YES;
        assert(IShotRecoveredEntry(0,NULL)==73);
        assert([sharedFixture boolForKey:@"iShotHavePurchased"]);
        assert(![standardFixture objectForKey:@"InstallTimeInfo"]);
        id after=[standardFixture objectForKey:@"receipt"];
        assert(receipt==NSNull.null ? after==nil : [after isEqual:receipt]);
        MXClipWindowController *controller=[MXClipWindowController new];controller.clipView=[ClipFixture new];
        rendered=NO;IShotClipCapture_100018ef8(controller,standardFixture);
        NSDate *deadline=[NSDate dateWithTimeIntervalSinceNow:1];
        while(!rendered && deadline.timeIntervalSinceNow>0) [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
        assert(rendered && IShotClip_1001f18b4 && !IShotGlobal_1001dd139);
    }
    assert(enteredApplication==3);
    method_setImplementation(standard,originalStandard);method_setImplementation(initialize,originalInit);
    [standardFixture removePersistentDomainForName:standardName];[sharedFixture removePersistentDomainForName:sharedName];
    puts("PASS Lite access: absent/expired/malformed receipts, old installation, repeated startup and capture; receipt preserved");
}}
