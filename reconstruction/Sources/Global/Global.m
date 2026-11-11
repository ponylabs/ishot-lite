#import "Global.h"
#import "PrimaryDependencies.h"
#import "../Preferences/SRRecorderControlWithTagid.h"
extern BOOL IShotGlobal_1001dd139, IShotGlobal_1001de184, IShotGlobal_1001de168;
extern void IShotFunction_100047ffc(NSString *);
#import "../Imaging/Imaging.h"
#import <ScreenCaptureKit/ScreenCaptureKit.h>
#include <math.h>
extern int _CGSDefaultConnection(void);
extern int CGSSetConnectionProperty(int connection, int target, CFStringRef key, CFTypeRef value);
extern NSString *IShotGlobal_1001ddd48;
extern int32_t IShotGlobal_1001ddf30, IShotGlobal_1001ddf34;
extern CGImageRef IShotCGWindowListCreateImage(CGRect, CGWindowListOption, CGWindowID, CGWindowImageOption) __asm__("_CGWindowListCreateImage");
extern CGImageRef IShotCGWindowListCreateImageFromArray(CGRect, CFArrayRef, CGWindowImageOption) __asm__("_CGWindowListCreateImageFromArray");
@implementation Global
+ (void)popupRequestScreenCaptureAccess { // 0x100010eec; block 0x100010f88
    if (@available(macOS 10.15, *)) {
        if (@available(macOS 11.0, *)) CGRequestScreenCaptureAccess();
        else {
            CGImageRef image=IShotCGWindowListCreateImage(CGRectMake(0,0,1,1),1,0,0);
            CFRelease(image);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"]];
        });
    }
}
+ (void)popupRequestPrivacyAccessibilityWithQuit:(BOOL)quit { // 0x100010ff0
    extern void IShotFunction_100047ffc(NSString *);
    NSAlert *alert=[[NSAlert alloc] init];
    alert.messageText=NSLocalizedString(@"iShot needs privacy authorization in the auxiliary function. \nIf it has been authorized, this window still pops up, please check again and restart the computer.",@"");
    [alert addButtonWithTitle:NSLocalizedString(@"Agree",@"")];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel",@"")];
    if ([alert runModal]==1000) {
        [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"]];
        if (quit) { IShotFunction_100047ffc(@"TelliShotHelperToQuit"); [NSApp terminate:self]; }
    }
}
+ (void)screenCaptureOverMacOS15:(unsigned int)windowID withSize:(CGSize)size { // 0x1000119b4
    extern NSMutableDictionary *IShotGlobal_1001ddff8;
    if (@available(macOS 15.0, *)) {
        [SCShareableContent getShareableContentExcludingDesktopWindows:YES onScreenWindowsOnly:YES completionHandler:^(SCShareableContent *content,NSError *error) { // 0x100011a4c
            if (!error) {
                NSEnumerator *enumerator=content.windows.objectEnumerator;
                SCWindow *window;
                while ((window=enumerator.nextObject)) {
                    if (window.windowID!=windowID) continue;
                    SCContentFilter *filter=[[SCContentFilter alloc] initWithDesktopIndependentWindow:window];
                    int scale=(int)filter.pointPixelScale;
                    SCStreamConfiguration *configuration=[[SCStreamConfiguration alloc] init];
                    configuration.ignoreShadowsSingleWindow=YES;
                    configuration.width=(NSInteger)(size.width*(double)scale);
                    configuration.height=(NSInteger)(size.height*(double)scale);
                    configuration.includeChildWindows=NO;
                    configuration.showsCursor=NO;
                    [SCScreenshotManager captureImageWithFilter:filter configuration:configuration completionHandler:^(CGImageRef image,NSError *captureError) { // 0x100011c60 ignores captureError
                        [IShotGlobal_1001ddff8 setObject:image?(__bridge id)image:@"" forKey:@(windowID)];
                    }];
                    return;
                }
            }
            [IShotGlobal_1001ddff8 setObject:@"" forKey:@(windowID)];
        }];
    }
}
+ (void)hideCursor { // 0x10000cd0c
    CFStringRef key = CFStringCreateWithCString(NULL, "SetsCursorInBackground", kCFStringEncodingUTF8);
    int connection = _CGSDefaultConnection();
    CGSSetConnectionProperty(connection, connection, key, kCFBooleanTrue);
    CFRelease(key);
    CGDisplayHideCursor(CGMainDisplayID());
}
+ (void)showCursor { CGDisplayShowCursor(CGMainDisplayID()); } // 0x10000cd68
+ (BOOL)notOnlyWhiteColorInQQOrWeChat:(NSArray *)array { // 0x10000cd7c
    if (![IShotGlobal_1001ddd48 isEqualToString:@"com.tencent.qq"] && ![IShotGlobal_1001ddd48 isEqualToString:@"com.tencent.xinWeChat"]) return YES;
    NSData *data = array[0];
    if (data.length == 0) return NO;
    uint8_t bytes[data.length];
    [data getBytes:bytes length:data.length];
    for (NSUInteger i = 0; i < data.length; i += 4) {
        int gray = (int)(bytes[i+2] * 0.3 + bytes[i+1] * 0.59 + bytes[i] * 0.11);
        if (gray < 210) return YES;
    }
    return NO;
}
+ (BOOL)sameArrColumn:(NSArray *)a to:(NSArray *)b { // 0x10000cf24
    if (a.count != b.count || a.count == 0 || b.count == 0) return NO;
    if ([a isEqualToArray:b]) return YES;
    for (NSUInteger i = 0; i < a.count; i++) {
        if (i > b.count - 1) return YES;
        int x = [a[i] intValue], y = [b[i] intValue];
        if (x > y + 3 || x < y - 3) return NO;
    }
    return YES;
}
+ (int)getSameColorValueInArrColumn:(NSArray *)array from:(int)index withUp:(BOOL)up { // 0x10000d078
    int count = 0;
    if (up) {
        int value = [array[(NSInteger)(index-1)] intValue];
        for (NSInteger i = index-1; i >= 0; i--) {
            int candidate = [array[i] intValue];
            if (value > candidate+3 || value < candidate-3) break;
            count++;
        }
    } else {
        int value = [array[array.count-(NSInteger)index] intValue];
        int start = (int)array.count-index;
        for (NSUInteger i = (NSUInteger)(NSInteger)start; i < array.count; i++) {
            int candidate = [array[i] intValue];
            if (value > candidate+3 || value < candidate-3) break;
            count++;
        }
    }
    return count;
}
+ (BOOL)sameArr:(NSArray *)a to:(NSArray *)b { // 0x10000d214
    if (a.count != b.count || a.count == 0 || b.count == 0) return NO;
    if ([a isEqualToArray:b]) return YES;
    NSData *x = a[0], *y = b[0];
    if (x.length == 0 || y.length == 0) return NO;
    uint8_t xb[x.length], yb[y.length];
    [x getBytes:xb length:x.length]; [y getBytes:yb length:y.length];
    for (NSUInteger i = (NSInteger)IShotGlobal_1001ddf30 * 4 + 80; i < x.length - (NSInteger)IShotGlobal_1001ddf34 * 4 - 80; i += 4) {
        int gx = (int)(xb[i+2]*0.3 + xb[i+1]*0.59 + xb[i]*0.11);
        int gy = (int)(yb[i+2]*0.3 + yb[i+1]*0.59 + yb[i]*0.11);
        if (gx > gy+6 || gy > gx+6) return NO;
    }
    return YES;
}
+ (double)_calcuateDistanceOfTwoPoints:(CGPoint)a :(CGPoint)b { // 0x10000d4f4
    double x=a.x-b.x, y=a.y-b.y;
    return sqrt(x*x+y*y);
}
+ (BOOL)checkIfSameColorFromImageRef:(CGImageRef)image { // 0x10000da78
    int width = (int)CGImageGetWidth(image), height = (int)CGImageGetHeight(image);
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(image));
    if (!data) return YES;
    NSInteger padding = height ? (CFDataGetLength(data) - width*height*4) / height : 0;
    NSInteger stride = width + padding / 4;
    const int32_t *pixels = (const int32_t *)CFDataGetBytePtr(data);
    int32_t last = -1;
    BOOL same = YES;
    for (int y=0; y<height; y+=5) {
        for (int x=0; x<width; x+=5) {
            int32_t value = pixels[y*stride+x];
            if (last != -1 && last != value) { same=NO; goto finish; }
            last=value;
        }
    }
finish:
    CFRelease(data);
    return same;
}
+ (CGRect)calcuateRealRectFromIMageRef:(CGImageRef)image withOriginalRect:(CGRect)rect { // 0x10000d510
    int width = (int)CGImageGetWidth(image), height = (int)CGImageGetHeight(image);
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(image));
    NSInteger padding = height ? (CFDataGetLength(data) - width*height*4) / height : 0;
    NSInteger stride = width + padding / 4;
    const uint32_t *pixels = (const uint32_t *)CFDataGetBytePtr(data);
    float scale = (float)((double)width / rect.size.width);
    float total=0, transparent=0, minX=10000, minY=10000, maxX=-10000, maxY=-10000;
    BOOL same=YES, allNonOpaque=YES;
    uint32_t first=0;
    for (int y=0; y<height; y=(int)(scale+scale+(float)y)) {
        for (int x=0; x<width; x=(int)(scale+scale+(float)x)) {
            uint32_t value=pixels[y*stride+x];
            total += 1.0f;
            if (x==0 && y==0) first=value;
            else same = same && value==first;
            allNonOpaque = allNonOpaque && (value>>24)<255;
            if ((value>>24)>168) {
                if ((float)x<minX) minX=(float)x;
                if (maxX<(float)x) maxX=(float)x;
                if ((float)y<minY) minY=(float)y;
                if (maxY<(float)y) maxY=(float)y;
            } else transparent += 1.0f;
        }
    }
    if (data) CFRelease(data);
    if (0.99 < transparent/total || (same && allNonOpaque)) return CGRectZero;
    int left=(int)((double)(minX/scale)+0.5-2.0), top=(int)((double)(minY/scale)+0.5-2.0);
    int right=(int)((double)(maxX/scale)+0.5+2.0), bottom=(int)((double)(maxY/scale)+0.5+2.0);
    return CGRectMake((int)(rect.origin.x+left),(int)(rect.origin.y+top),(int)fabsf((float)left-(float)right),(int)fabsf((float)top-(float)bottom));
}
+ (CGRect)calcuateRealRectFromNSImage:(NSImage *)image withOriginalRect:(CGRect)rect { // 0x10000d7e4
    CGImageRef cg = [image CGImageForProposedRect:NULL context:nil hints:nil];
    int width = (int)CGImageGetWidth(cg), height = (int)CGImageGetHeight(cg);
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(cg));
    NSInteger padding = height ? (CFDataGetLength(data) - width*height*4) / height : 0;
    NSInteger stride = width + padding / 4;
    const uint32_t *pixels = (const uint32_t *)CFDataGetBytePtr(data);
    float scale = (float)((double)width / rect.size.width);
    float total=0, transparent=0, minX=10000, minY=10000, maxX=-10000, maxY=-10000;
    for (int y=0; y<height; y=(int)(scale+scale+(float)y)) {
        for (int x=0; x<width; x=(int)(scale+scale+(float)x)) {
            total += 1.0f;
            if ((pixels[y*stride+x]>>24)>168) {
                if ((float)x<minX) minX=(float)x;
                if (maxX<(float)x) maxX=(float)x;
                if ((float)y<minY) minY=(float)y;
                if (maxY<(float)y) maxY=(float)y;
            } else transparent += 1.0f;
        }
    }
    if (data) CFRelease(data);
    if (!(transparent/total <= 0.99)) return CGRectZero;
    int left=(int)((double)(minX/scale)+0.5-2.0), top=(int)((double)(minY/scale)+0.5-2.0);
    int right=(int)((double)(maxX/scale)+0.5+2.0), bottom=(int)((double)(maxY/scale)+0.5+2.0);
    return CGRectMake((int)(rect.origin.x+left),(int)(rect.origin.y+(rect.size.height-bottom)),(int)fabsf((float)left-(float)right),(int)fabsf((float)top-(float)bottom));
}
+ (void)restart { // 0x10000db80
    [NSUserDefaults.standardUserDefaults setObject:@"YES" forKey:@"IsRestart"];
    [NSUserDefaults.standardUserDefaults synchronize];
    NSString *path=NSBundle.mainBundle.bundlePath;
    NSTask *task=[NSTask new];
    task.launchPath=@"/usr/bin/open";
    task.arguments=@[@"-n",path];
    [task launch];
    exit(0);
}
+ (CGMutablePathRef)CGPathFromPath:(NSBezierPath *)path { // 0x10000ef58; caller owns the Create result
    CGMutablePathRef result=CGPathCreateMutable();
    NSInteger count=path.elementCount;
    for (NSInteger i=0;i<count;i++) {
        NSPoint p[3];
        switch ([path elementAtIndex:i associatedPoints:p]) {
            case 0: CGPathMoveToPoint(result,NULL,p[0].x,p[0].y); break;
            case 1: CGPathAddLineToPoint(result,NULL,p[0].x,p[0].y); break;
            case 2: CGPathAddCurveToPoint(result,NULL,p[0].x,p[0].y,p[1].x,p[1].y,p[2].x,p[2].y); break;
            case 3: CGPathCloseSubpath(result); break;
            default: break;
        }
    }
    return result;
}
+ (void)activateAppWithIdentifier:(NSString *)identifier { // 0x100011828
    if (identifier) {
        NSArray *apps=[NSRunningApplication runningApplicationsWithBundleIdentifier:identifier];
        if (apps.count) [apps[0] activateWithOptions:2];
    }
}
+ (BOOL)checkRect:(CGRect)a OverlapWithRect:(CGRect)b { // 0x1000121a8, original tests corners, not CGRectIntersectsRect
    if (NSPointInRect(a.origin,b)) return YES;
    if (NSPointInRect(NSMakePoint(a.origin.x+a.size.width,a.origin.y),b)) return YES;
    if (NSPointInRect(NSMakePoint(a.origin.x,a.origin.y+a.size.height),b)) return YES;
    if (NSPointInRect(NSMakePoint(a.origin.x+a.size.width,a.origin.y+a.size.height),b)) return YES;
    if (NSPointInRect(b.origin,a)) return YES;
    if (NSPointInRect(NSMakePoint(b.origin.x+b.size.width,b.origin.y),a)) return YES;
    if (NSPointInRect(NSMakePoint(b.origin.x,b.origin.y+b.size.height),a)) return YES;
    return NSPointInRect(NSMakePoint(b.origin.x+b.size.width,b.origin.y+b.size.height),a);
}
+ (id)fixedKeyCaptionForKeyCode:(unsigned long long)code { // 0x100011894; 91 pointer slots at 0x1001a8648
    static NSString * const captions[] = {
        @"↩︎",
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        @"⇥︎",
        nil,
        nil,
        @"⌫︎",
        nil,
        @"esc",
        @"⌘︎",
        @"⌘︎",
        @"⇧︎",
        @"⇪︎",
        @"⌥︎",
        @"⌃︎",
        @"⇧︎",
        @"⌥︎",
        @"⌃︎",
        @"fn",
        @"F17",
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        @"⌧︎",
        nil,
        nil,
        nil,
        nil,
        @"⌤︎",
        nil,
        nil,
        @"F18",
        @"F19",
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        @"F20",
        nil,
        nil,
        nil,
        nil,
        nil,
        @"F5",
        @"F6",
        @"F7",
        @"F3",
        @"F8",
        @"F9",
        @"英数",
        @"F11",
        @"かな",
        @"F13",
        @"F16",
        @"F14",
        nil,
        @"F10",
        nil,
        @"F12",
        nil,
        @"F15",
        @"?⃝︎",
        @"↖︎",
        @"⇞︎",
        nil,
        @"F4",
        @"↘︎",
        @"F2",
        @"⇟︎",
        @"F1",
        @"⇠︎",
        @"⇢︎",
        @"⇣︎",
        @"⇡︎"
    };
    return code-36 < 91 ? captions[code-36] : nil;
}
+ (BOOL)haveOnlyOptionAsFlag { // 0x100011690
    NSDictionary *shortcuts=[NSUserDefaults.standardUserDefaults objectForKey:@"dicOfShortCutKey"];
    for (NSString *key in shortcuts) if ([shortcuts[key][@"modifierFlags"] integerValue] == 0x80000) return YES;
    return NO;
}
+ (id)convertStringToImage:(NSString *)text { // 0x10000f074
    NSDictionary *attributes=@{NSFontAttributeName:[NSFont systemFontOfSize:13], NSForegroundColorAttributeName:NSColor.textColor};
    NSSize size=[text sizeWithAttributes:attributes];
    NSImage *image=[[NSImage alloc] initWithSize:size];
    [image lockFocus];
    [NSColor.textBackgroundColor set];
    NSRect rect=NSMakeRect(0,0,size.width,size.height);
    NSRectFill(rect);
    [text drawInRect:rect withAttributes:attributes];
    [image unlockFocus];
    return image;
}
+ (BOOL)isCorrectRichTextWithAttributedString:(NSAttributedString *)text { // 0x10000f890
    __block BOOL valid=NO;
    [text enumerateAttributesInRange:NSMakeRange(0,text.length) options:0 usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) { // 0x10000f958
        if (attributes[NSForegroundColorAttributeName] && attributes[NSBackgroundColorAttributeName]) valid=YES;
    }];
    return valid;
}
+ (id)convertClipboardDataToImage:(BOOL)plain withPasteboard:(NSPasteboard *)pasteboard { // 0x10000f218
    if (!plain) {
        // Exact original priority; RTFD bytes are passed to initWithRTF too.
        for (NSPasteboardType type in @[NSPasteboardTypeHTML,NSRTFDPboardType,NSRTFPboardType]) {
            NSData *data=[pasteboard dataForType:type];
            if (!data) continue;
            NSAttributedString *text;
            if ([type isEqualToString:NSPasteboardTypeHTML]) text=[[NSAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:NULL error:NULL];
            else text=[[NSAttributedString alloc] initWithRTF:data documentAttributes:NULL];
            if (![self isCorrectRichTextWithAttributedString:text]) continue;
            NSRect bounds=[text boundingRectWithSize:NSZeroSize options:1];
            if (CGRectIsEmpty(bounds)) continue;
            NSSize size=NSMakeSize(bounds.size.width+20,bounds.size.height+20);
            NSImage *image=[[NSImage alloc] initWithSize:size];
            [image lockFocus];
            NSRect rect=NSMakeRect(0,0,size.width,size.height);
            [[NSBezierPath bezierPathWithRoundedRect:rect xRadius:10 yRadius:10] addClip];
            NSRectFill(rect);
            [text drawInRect:NSMakeRect(10,10,bounds.size.width,bounds.size.height)];
            [image unlockFocus];
            return image;
        }
        NSData *pdf=[pasteboard dataForType:NSPDFPboardType];
        if (pdf) {
            NSPDFImageRep *rep=[NSPDFImageRep imageRepWithData:pdf];
            NSImage *image=[[NSImage alloc] initWithSize:rep.size];
            [image addRepresentation:rep];
            return image;
        }
    }
    NSString *string=[[pasteboard stringForType:NSStringPboardType] stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
    if (!string) return nil;
    NSDictionary *attributes=@{NSFontAttributeName:[NSFont systemFontOfSize:13],NSForegroundColorAttributeName:NSColor.textColor};
    NSAttributedString *text=[[NSAttributedString alloc] initWithString:string attributes:attributes];
    NSRect bounds=[text boundingRectWithSize:NSZeroSize options:1];
    NSSize size=NSMakeSize(bounds.size.width+20,bounds.size.height+20);
    NSImage *image=[[NSImage alloc] initWithSize:size];
    [image lockFocus];
    [NSColor.textBackgroundColor set];
    NSRect rect=NSMakeRect(0,0,size.width,size.height);
    [[NSBezierPath bezierPathWithRoundedRect:rect xRadius:10 yRadius:10] addClip];
    NSRectFill(rect);
    [text drawAtPoint:NSMakePoint(10,10)];
    [image unlockFocus];
    return image;
}
+ (CGRect)currentScreenNotchRect { // 0x1000118b8: all four components cast to int32 before return
    if (@available(macOS 12.0, *)) {
        CGRect left=[(NSScreen *)[NSScreen currentScreenForMouseLocation] auxiliaryTopLeftArea];
        CGRect right=[(NSScreen *)[NSScreen currentScreenForMouseLocation] auxiliaryTopRightArea];
        return CGRectMake((int)(left.origin.x+left.size.width),(int)(left.origin.y<right.origin.y?left.origin.y:right.origin.y),(int)(right.origin.x-(left.origin.x+left.size.width)),(int)(left.size.height<right.size.height?right.size.height:left.size.height));
    }
    return CGRectZero;
}
+ (id)screenShotFromWindowID:(unsigned int)windowID { // 0x1000103d0
    extern NSScreen *IShotGlobal_1001dde80;
    uint64_t value = windowID;
    CFArrayRef windows = CFArrayCreate(kCFAllocatorDefault, (const void **)&value, 1, NULL);
    if (!windows) return nil;
    CGImageRef cgImage = IShotCGWindowListCreateImageFromArray(CGRectNull, windows, 9);
    CFRelease(windows);
    if (!cgImage) return nil;
    float scale = (float)IShotGlobal_1001dde80.backingScaleFactor;
    NSSize size = NSMakeSize((float)CGImageGetWidth(cgImage)/scale, (float)CGImageGetHeight(cgImage)/scale);
    NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:size];
    CFRelease(cgImage);
    return image;
}
+ (void)drawPencilMosaic:(id)info inRect:(CGRect)rect withActived:(BOOL)active { // 0x10000fa14
    NSColor *color = info[@"color"];
    int size = [info[@"size"] intValue];
    NSArray *points = info[@"allPoints"];
    CGPoint first = [points.firstObject CGPointValue];
    CGPoint last = [points.lastObject CGPointValue];
    CGContextRef context = NSGraphicsContext.currentContext.CGContext;
    if (context) {
        NSImage *image = info[@"imageOfMosaic"];
        [image drawInRect:NSMakeRect(-rect.origin.x,-rect.origin.y,image.size.width,image.size.height)];
        if (active) {
            CGPoint endpoints[] = {first,last};
            for (int i=0;i<2;i++) {
                CGRect marker = CGRectMake(endpoints[i].x-rect.origin.x-5,endpoints[i].y-rect.origin.y-5,10,10);
                CGContextSetFillColorWithColor(context,color.CGColor);
                CGContextFillEllipseInRect(context,marker);
                CGContextSetRGBFillColor(context,1,1,1,0.95);
                CGContextFillEllipseInRect(context,CGRectInset(marker,1,1));
            }
        }
    }
    if (size < 7) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [[NSColor.clearColor colorWithAlphaComponent:0.002] set];
        path.lineWidth = 7;
        for (NSUInteger i=0;i<points.count;i++) {
            CGPoint point = [points[i] CGPointValue];
            point.x -= rect.origin.x; point.y -= rect.origin.y;
            if (i==0) [path moveToPoint:point]; else [path lineToPoint:point];
        }
        [path stroke];
    }
}
+ (void)checkAllHotKeyForMacosSequoia { // 0x1000111d4; main block 0x100011678
    extern BOOL IShotGlobal_1001de168;
    extern void IShotFunction_10004d220(float,float,int,int);
    extern void IShotFunction_100047ffc(NSString *);
    NSDictionary *shortcuts=[NSUserDefaults.standardUserDefaults objectForKey:@"dicOfShortCutKey"];
    if (![self haveOnlyOptionAsFlag]) return;
    NSAlert *alert=[[NSAlert alloc] init];
    alert.messageText=NSLocalizedString(@"There is an \"Option+letter\" shortcut key in your iShot. To use Option as a shortcut key in MacOS 15, you need to authorize iShot's accessibility features.",@"");
    [alert addButtonWithTitle:NSLocalizedString(@"No: Clear shortcut keys related to Options, I will set them myself",@"")];
    [alert addButtonWithTitle:NSLocalizedString(@"Authorize privacy assistance function permissions",@"")];
    NSInteger response=[alert runModal];
    NSMutableDictionary *filtered=[NSMutableDictionary dictionaryWithCapacity:shortcuts.count];
    if (response==1000) {
        for (id key in shortcuts) {
            NSMutableDictionary *item=[NSMutableDictionary dictionaryWithDictionary:shortcuts[key]];
            if ([item[@"modifierFlags"] integerValue]!=0x80000) [filtered setObject:item forKey:key];
        }
        [NSUserDefaults.standardUserDefaults setObject:filtered forKey:@"dicOfShortCutKey"];
        [NSUserDefaults.standardUserDefaults synchronize];
    } else {
        IShotGlobal_1001de168=YES;
        CGEventRef event=CGEventCreate(NULL);
        CGPoint point=CGEventGetLocation(event);
        CFRelease(event);
        IShotFunction_10004d220((float)(point.x-1),(float)(point.y-1),0,6);
        [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"]];
        IShotFunction_100047ffc(@"TelliShotHelperToQuit");
        dispatch_async(dispatch_get_main_queue(), ^{ [NSApp terminate:self]; });
    }
}
+ (id)getImageFromArr:(NSMutableArray *)items { // 0x100011cf8
    extern NSArray *IShotGlobal_1001ddce0;
    NSMutableArray *copy=[items mutableCopy];
    [items removeAllObjects];
    for (NSUInteger i=0;i<copy.count;i++) {
        NSMutableDictionary *item=[NSMutableDictionary dictionaryWithDictionary:copy[i]];
        int layer=[item[@"kCGWindowLayer"] intValue];
        NSMutableDictionary *bounds=[NSMutableDictionary dictionaryWithDictionary:item[@"kCGWindowBounds"]];
        float x=[bounds[@"X"] floatValue],y=[bounds[@"Y"] floatValue];
        float width=[bounds[@"Width"] floatValue],height=[bounds[@"Height"] floatValue];
        CGImageRef cgImage=(__bridge CGImageRef)item[@"kCGWindowCGImageRef"];
        NSImage *image=nil;
        if (cgImage) {
            if ((layer>0 && layer!=24) || (layer==0 && [IShotGlobal_1001ddce0 containsObject:item[@"Height"]])) {
                CGRect real=[Global calcuateRealRectFromIMageRef:cgImage withOriginalRect:CGRectMake(x,y,width,height)];
                if (real.size.width<10 || real.size.height<10) continue;
                if (fabs(real.size.width-width)<=5 && fabs(real.size.height-height)<=5) {
                    image=[[NSImage alloc] initWithCGImage:cgImage size:NSMakeSize(width,height)];
                } else {
                    bounds[@"X"]=@(real.origin.x); bounds[@"Y"]=@(real.origin.y);
                    bounds[@"Width"]=@(real.size.width); bounds[@"Height"]=@(real.size.height);
                    item[@"kCGWindowBounds"]=bounds;
                    double scale=(float)((double)CGImageGetWidth(cgImage)/(double)width);
                    CGImageRef cropped=CGImageCreateWithImageInRect(cgImage,CGRectMake((real.origin.x-x)*scale,(real.origin.y-y)*scale,real.size.width*scale,real.size.height*scale));
                    if (cropped) {
                        image=[[NSImage alloc] initWithCGImage:cropped size:NSMakeSize(real.size.width*scale,real.size.height*scale)];
                        CFRelease(cropped);
                    }
                }
            } else image=[[NSImage alloc] initWithCGImage:cgImage size:NSMakeSize(width,height)];
            if (image) item[@"KCGWindowImage"]=image;
        }
        [items addObject:item];
    }
    [copy removeAllObjects];
    return items;
}
+ (void)pinToScreenWithImage:(NSImage *)image rect:(CGRect)rect { // 0x1000104ec; frame ABI confirmed by REA
    PinWindow *window=[[PinWindow alloc] initWithContentRect:rect styleMask:0 backing:2 defer:NO];
    window.opaque=NO; window.releasedWhenClosed=NO;
    window.backgroundColor=NSColor.clearColor;
    if (![NSUserDefaults.standardUserDefaults boolForKey:@"pinnedToOneSpace"]) window.collectionBehavior=1;
    window.level=25; window.acceptsMouseMovedEvents=YES;
    window.title=@"mappingWindowByiShot"; window.identifier=@"PinWindow";
    window.movableByWindowBackground=YES;
    CustomView *view=[[CustomView alloc] initWithFrame:window.frame];
    window.contentView=view;
    float radius=(float)[NSUserDefaults.standardUserDefaults integerForKey:@"sizeOfPinFillet"];
    [view setImage:[NSImage addRoundImgae:image withRadius:radius]];
    [window makeKeyAndOrderFront:nil];
}
#include "OCRMethods.inc"
#include "KeyboardMethods.inc"
@end
