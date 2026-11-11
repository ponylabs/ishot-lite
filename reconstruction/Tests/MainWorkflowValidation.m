// Integration fixture: all product classes/methods come from the real recovered archive.
#import <Cocoa/Cocoa.h>
#import "../Sources/Editor/AnnotatedImageController.h"
#import "../Sources/Editor/AnnotatedImageView.h"
#import "../Sources/Imaging/NSScrollView+ToImage.h"
#import "../Sources/Capture/RecordScreenClipView.h"
#import "../Sources/Common/CropBorderViewForRecordScreen.h"
extern AnnotatedImageController *IShotGlobal_1001de160;
extern NSMutableArray *IShotGlobal_1001de050;
extern NSMutableDictionary *IShotGlobal_1001de058;
extern NSString *IShotGlobal_1001dde70;
extern int IShotGlobal_1001de048;
static void Check(BOOL pass,NSString *message){if(!pass)@throw [NSException exceptionWithName:@"WorkflowValidation" reason:message userInfo:nil];}
static NSEvent *Event(NSEventType type,CGPoint point){return [NSEvent mouseEventWithType:type location:point modifierFlags:0 timestamp:1 windowNumber:0 context:nil eventNumber:1 clickCount:1 pressure:1];}
int main(int argc,const char **argv){@autoreleasepool{@try{
    Check(argc==2,@"output directory argument required"); NSString *output=@(argv[1]);
    [NSApplication sharedApplication]; [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
    NSDictionary *defaults=[NSDictionary dictionaryWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"DefaultPreferences" ofType:@"plist"]];
    Check(defaults!=nil,@"bundled default preferences"); [NSUserDefaults.standardUserDefaults registerDefaults:defaults];
    // Test-only volatile settings; no purchased flags or hardware acquisition are involved.
    NSMutableDictionary *args=[[NSUserDefaults.standardUserDefaults volatileDomainForName:NSArgumentDomain] mutableCopy];
    args[@"filledOfSquare"]=@YES; args[@"enableRoundOfSquare"]=@NO; args[@"selectedCameraOfRecordScreen"]=@"None";
    [NSUserDefaults.standardUserDefaults setVolatileDomain:args forName:NSArgumentDomain];
    IShotGlobal_1001de160=[[AnnotatedImageController alloc] initWithWindowNibName:@"AnnotatedImage"];
    NSWindow *window=IShotGlobal_1001de160.window; [window orderOut:nil];
    Check(window && IShotGlobal_1001de160.squareButton && IShotGlobal_1001de160.sliderOfOpacity,@"real AnnotatedImage nib outlets");
    AnnotatedImageView *nibView=[IShotGlobal_1001de160 valueForKey:@"annotatedImageView"];
    Check([nibView isKindOfClass:AnnotatedImageView.class],@"nib annotated view class");
    // A fresh real drawing view provides the document fixture via its recovered initializer.
    AnnotatedImageView *drawing=[[AnnotatedImageView alloc] initWithFrame:NSMakeRect(0,0,320,240)];
    [IShotGlobal_1001de160 setValue:drawing forKey:@"annotatedImageView"];
    NSImage *fixture=[[NSImage alloc] initWithSize:NSMakeSize(320,240)];
    [fixture lockFocus]; [NSColor.whiteColor setFill]; NSRectFill(NSMakeRect(0,0,320,240)); [fixture unlockFocus];
    NSScrollView *canvas=[[NSScrollView alloc] initWithFrame:NSMakeRect(0,0,320,240)];
    NSView *document=[[NSView alloc] initWithFrame:NSMakeRect(0,0,320,240)];
    NSImageView *background=[[NSImageView alloc] initWithFrame:document.bounds]; background.image=fixture;
    [document addSubview:background]; [document addSubview:drawing]; canvas.documentView=document;
    NSWindow *fixtureWindow=[[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,320,240) styleMask:0 backing:NSBackingStoreBuffered defer:NO]; fixtureWindow.contentView=canvas;
    [IShotGlobal_1001de160 squareButtonClick:IShotGlobal_1001de160.squareButton];
    IShotGlobal_1001de160.sliderOfOpacity.floatValue=100;
    // The production hit-test state for drawing on an empty image, rather than moving a stroke.
    IShotGlobal_1001dde70=@"cursorCreateNew";
    [drawing mousedown:Event(NSEventTypeLeftMouseDown,NSMakePoint(40,50))];
    for(int i=1;i<=8;i++)[drawing mouseDragged:Event(NSEventTypeLeftMouseDragged,NSMakePoint(40+15*i,50+10*i))];
    [drawing mouseup:Event(NSEventTypeLeftMouseUp,NSMakePoint(160,130))];
    Check(IShotGlobal_1001de050.count==1,@"one committed stroke via real event handlers");
    NSDictionary *stroke=IShotGlobal_1001de050.firstObject;
    Check([stroke[@"type"] intValue]==0 && [stroke[@"X1"] doubleValue]==40 && [stroke[@"X2"] doubleValue]==160,@"committed square coordinates");
    [drawing undoDraw]; Check(IShotGlobal_1001de048==1,@"real undo");
    [drawing redoDraw]; Check(IShotGlobal_1001de048==0,@"real redo");
    [IShotGlobal_1001de058 removeAllObjects]; // Deselect committed stroke, excluding editing handles from export.
    [drawing setNeedsDisplay:YES];
    NSData *png=[canvas toDataWithFileType:NSBitmapImageFileTypePNG];
    Check(png.length>100,@"real ToImage PNG export");
    NSString *path=[output stringByAppendingPathComponent:@"workflow-square.png"];
    Check([png writeToFile:path atomically:YES],@"write exported image");
    NSBitmapImageRep *decoded=[NSBitmapImageRep imageRepWithData:png];
    Check(decoded.pixelsWide>=320 && decoded.pixelsHigh>=240,@"PNG dimensions");
    NSUInteger colored=0; for(NSInteger y=0;y<decoded.pixelsHigh;y++)for(NSInteger x=0;x<decoded.pixelsWide;x++){
        NSColor *color=[[decoded colorAtX:x y:y] colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace];
        if(color.alphaComponent>.9 && color.redComponent>.7 && color.greenComponent<.4 && color.blueComponent<.4)colored++;
    }
    Check(colored>500,@"export contains colored committed square pixels");
    RecordScreenClipView *record=[[RecordScreenClipView alloc] initWithFrame:NSMakeRect(0,0,320,240) type:0];
    [record showClipViewWithFrame:NSMakeRect(20,30,100,80) withToolbar:[[NSView alloc] initWithFrame:NSMakeRect(0,0,200,40)]];
    Check([record.cropBorderViewForRecordScreen isKindOfClass:CropBorderViewForRecordScreen.class] && record.indicatorField && record.tipView,@"real recording selection dependencies");
    [record setFrameForContentView:NSMakeRect(22.5,32.5,120.5,90.5)];
    Check(NSEqualRects(record.contentRect,NSMakeRect(22,32,120,90)),@"real recording selection update");
    NSDictionary *result=@{@"passed":@YES,@"nib":@"AnnotatedImage",@"strokeCount":@(IShotGlobal_1001de050.count),@"undoRedo":@YES,@"png":path,@"pixelsWide":@(decoded.pixelsWide),@"pixelsHigh":@(decoded.pixelsHigh),@"redPixelCount":@(colored),@"recordSelectionDependencies":@YES,@"limits":@"Synthetic image/event input; real product implementations. No device capture or save-button screen acquisition."};
    [[NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:NULL] writeToFile:[output stringByAppendingPathComponent:@"workflow-result.json"] atomically:YES];
    NSLog(@"PASS MainWorkflowValidation %@",result); return 0;
}@catch(NSException *e){fprintf(stderr,"FAIL %s: %s\n",e.name.UTF8String,e.reason.UTF8String);return 1;}}}
