#import "../ColorPickerImageView.m"
// Only the display geometry is a controlled test fixture; naming and branding use restored production code.
@interface PickerScreen:NSObject
@end
@implementation PickerScreen
- (NSRect)frame{return NSMakeRect(0,0,1000,800);}
- (double)backingScaleFactor{return 2.;}
@end
@implementation NSScreen (PickerTestScreen)
+ (NSScreen *)currentScreenForMouseLocation{return (id)[PickerScreen new];}
@end
NSString *IShotGlobal_1001ddfc0,*IShotGlobal_1001ddfc8;
static NSBitmapImageRep *render(ColorPickerImageView *view){
 NSBitmapImageRep *bitmap=[[NSBitmapImageRep alloc]initWithBitmapDataPlanes:NULL pixelsWide:120 pixelsHigh:120 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:32];[NSGraphicsContext saveGraphicsState];NSGraphicsContext.currentContext=[NSGraphicsContext graphicsContextWithBitmapImageRep:bitmap];[view drawRect:NSMakeRect(0,0,120,120)];[NSGraphicsContext restoreGraphicsState];return bitmap;
}
int main(){@autoreleasepool{
 [NSApplication sharedApplication];ColorPickerImageView *view=[[ColorPickerImageView alloc]initWithFrame:NSMakeRect(0,0,120,120)];NSEvent *event=[NSEvent mouseEventWithType:NSEventTypeLeftMouseDragged location:NSMakePoint(100.75,200.25) modifierFlags:0 timestamp:1 windowNumber:0 context:nil eventNumber:1 clickCount:1 pressure:0];[view mouseDragged:event];
 NSCAssert(!IShotGlobal_1001f1950&&IShotGlobal_1001f1970==189.&&IShotGlobal_1001f1978==1188.&&IShotGlobal_1001f1980==24.,@"float scale, integer truncation and y inversion");NSCAssert([IShotGlobal_1001f1958 isEqualToString:@"101,600"],@"position formatting");
 NSBitmapImageRep *source=[[NSBitmapImageRep alloc]initWithBitmapDataPlanes:NULL pixelsWide:24 pixelsHigh:24 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:32];for(int y=0;y<24;y++)for(int x=0;x<24;x++)[source setColor:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1] atX:x y:y];view.image=[[NSImage alloc]initWithCGImage:source.CGImage size:NSMakeSize(24,24)];IShotGlobal_1001f1970=IShotGlobal_1001f1978=0;
 view.tag=1;NSBitmapImageRep *first=render(view);view.tag=3;NSBitmapImageRep *second=render(view);NSCAssert(memcmp(first.bitmapData,second.bitmapData,first.bytesPerRow*first.pixelsHigh)!=0,@"direction-dependent crosshair");
 IShotGlobal_1001f1960=[ColorNamer new];IShotGlobal_1001f1950=YES;[NSUserDefaults.standardUserDefaults removeObjectForKey:@"colorSpaceOfPickColor"];NSBitmapImageRep *moving=render(view);NSCAssert([IShotGlobal_1001f1968[@"colorName"] isEqualToString:@"Black"]&&[IShotGlobal_1001ddfc0 isEqualToString:@"000000"],@"color naming and exported hex");NSCAssert(memcmp(second.bitmapData,moving.bitmapData,second.bytesPerRow*second.pixelsHigh)!=0,@"moving color name/coordinates/grid rendering");
 NSLog(@"PASS picker drag coordinates, directional crosshair, bitmap render and color naming output");
}}
