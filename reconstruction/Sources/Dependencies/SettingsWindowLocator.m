#import "SettingsWindowLocator.h"
@implementation SettingsWindowLocator
+ (BOOL)isSystemSettingsFrontmost { return [NSWorkspace.sharedWorkspace.frontmostApplication.bundleIdentifier isEqualToString:@"com.apple.systempreferences"]; }
+ (IShotSettingsWindow)frontmostWindow {
    IShotSettingsWindow result={0,CGRectZero,CGRectZero};
    if(![self isSystemSettingsFrontmost]) return result;
    NSRunningApplication *settings=nil;
    for(NSRunningApplication *app in [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.systempreferences"]) if(app.activationPolicy==0) {settings=app;break;}
    if(!settings) return result;
    NSArray *windows=CFBridgingRelease(CGWindowListCopyWindowInfo(0x11,0)); NSMutableArray *candidates=[NSMutableArray array];
    for(NSDictionary *window in windows) {
        int pid=[window[(__bridge NSString *)kCGWindowOwnerPID] intValue];
        if(pid==settings.processIdentifier && [window[(__bridge NSString *)kCGWindowLayer] integerValue]==0) {
            NSDictionary *bounds=window[(__bridge NSString *)kCGWindowBounds];
            CGRect cg=CGRectMake([bounds[@"X"] doubleValue],[bounds[@"Y"] doubleValue],[bounds[@"Width"] doubleValue],[bounds[@"Height"] doubleValue]);
            CGRect frame,visible;[self appKitGeometryFromCGFrame:cg outFrame:&frame outVisibleFrame:&visible];
            if(frame.size.width>=320 && frame.size.height>=240) {IShotSettingsWindow candidate={pid,frame,visible};[candidates addObject:[NSValue valueWithBytes:&candidate objCType:@encode(IShotSettingsWindow)]];}
        }
    }
    for(NSValue *value in candidates) {IShotSettingsWindow candidate;[value getValue:&candidate];if(result.frame.size.width*result.frame.size.height<candidate.frame.size.width*candidate.frame.size.height) result=candidate;}
    return result;
}
+ (void)appKitGeometryFromCGFrame:(CGRect)cg outFrame:(CGRect *)frame outVisibleFrame:(CGRect *)visible {
    NSMutableArray *screens=[NSMutableArray array];
    for(NSScreen *screen in NSScreen.screens) {
        NSNumber *number=screen.deviceDescription[@"NSScreenNumber"];
        if(number) { CGRect bounds=CGDisplayBounds(number.unsignedIntValue);[screens addObject:@{@"frame":[NSValue valueWithRect:screen.frame],@"visibleFrame":[NSValue valueWithRect:screen.visibleFrame],@"cgBounds":[NSValue valueWithRect:bounds]}]; }
    }
    double largest=0;CGRect bestCG=CGRectZero,bestFrame=CGRectZero,bestVisible=CGRectZero;
    for(NSDictionary *screen in screens) {
        CGRect bounds=[screen[@"cgBounds"] rectValue];CGRect intersection=CGRectIntersection(cg,bounds);double area=intersection.size.width*intersection.size.height;
        if(largest<area) {largest=area;bestCG=bounds;bestFrame=[screen[@"frame"] rectValue];bestVisible=[screen[@"visibleFrame"] rectValue];}
    }
    if(largest!=0) { if(frame) *frame=CGRectMake((cg.origin.x-CGRectGetMinX(bestCG))+CGRectGetMinX(bestFrame),(CGRectGetMaxY(bestFrame)-(cg.origin.y-CGRectGetMinY(bestCG)))-cg.size.height,cg.size.width,cg.size.height);if(visible)*visible=bestVisible; }
    else { NSScreen *screen=NSScreen.mainScreen;CGRect fallback=screen ? screen.visibleFrame : CGRectZero;if(frame)*frame=cg;if(visible)*visible=fallback; }
}
@end
