#import <AppKit/AppKit.h>
#import <objc/runtime.h>
#import <math.h>
#import "../SnipUtil.h"
#import "../LCPermissionModel.h"
#import "../AppSandboxFileAccess.h"
#import "../WebpConverter.h"
#import "../LCAuthGuideHostApp.h"
#import "../LCAuthGuideKit.h"
#import "../LCPermissionWindowController.h"
#import "../LCPermissionViews.h"
#import "../LCPermisoAssistant.h"
#import "../OverlayWindowController.h"
#import "../OverlayContentView.h"
#import "../AppDragSourceView.h"
#import <webp/decode.h>
static void check(BOOL result,NSString *message){if(!result){fprintf(stderr,"FAIL: %s\n",message.UTF8String);exit(1);}}
static BOOL near(double a,double b){return fabs(a-b)<1e-10;}
int main(void){@autoreleasepool {
    [NSApplication sharedApplication];
    check([SnipUtil pointDistance:NSMakePoint(1,2) toPoint:NSMakePoint(4,6)]==25,@"squared distance");
    check(NSEqualRects([SnipUtil uniformRect:NSMakeRect(8,9,-3,-5)],NSMakeRect(5,4,3,5)),@"negative geometry");
    check(NSEqualRects([SnipUtil rectToZero:NSMakeRect(-4,8,3,7)],NSMakeRect(0,0,3,7)),@"zero origin");
    check([SnipUtil isPoint:NSMakePoint(0,0) inRect:NSMakeRect(0,0,10,10)] && ![SnipUtil isPoint:NSMakePoint(10,10) inRect:NSMakeRect(0,0,10,10)],@"native half-open rect");
    NSMutableString *text=[@"initial" mutableCopy];LCPermissionModel *model=[[LCPermissionModel alloc] initWithAuthType:0 desc:text];[text appendString:@" retained"];check([model.desc isEqualToString:text],@"initializer retains desc");model.desc=text;[text appendString:@" changed"];check(![model.desc isEqualToString:text],@"setter copies desc");
    AppSandboxFileAccessOpenSavePanelDelegate *delegate=[[AppSandboxFileAccessOpenSavePanelDelegate alloc] initWithFileURL:[NSURL fileURLWithPath:@"/tmp/evidence/file"]];
    check([delegate panel:delegate shouldEnableURL:[NSURL fileURLWithPath:@"/tmp/evidence"]],@"ancestor enabled");check(![delegate panel:delegate shouldEnableURL:[NSURL fileURLWithPath:@"/tmp/evidence-other"]],@"component boundary");check(![delegate panel:delegate shouldEnableURL:[NSURL fileURLWithPath:@"/tmp/evidence/file/child"]],@"descendant disabled");
    AppSandboxFileAccess *access=[[AppSandboxFileAccess alloc] initWithMessage:@"Allow %@"];
    check(access.bookmarkPersistanceDelegate==access.defaultDelegate,@"default persistence delegate");access.bookmarkPersistanceDelegate=nil;check(access.bookmarkPersistanceDelegate==access.defaultDelegate,@"nil delegate reset");
    NSError *error=nil;NSData *invalid=[WebpConverter convertImageToWebP:nil configBlock:^(WebPConfig *config){config->quality=101;} error:&error];check(invalid==nil && error.code==-101,@"invalid WebP configuration");
    const uint8_t pixels[]={255,0,0,255,0,255,0,255,0,0,255,255,255,255,255,255};CGDataProviderRef provider=CGDataProviderCreateWithData(NULL,pixels,sizeof(pixels),NULL);CGColorSpaceRef space=CGColorSpaceCreateDeviceRGB();CGImageRef cg=CGImageCreate(2,2,8,32,8,space,(CGBitmapInfo)kCGImageAlphaLast,provider,NULL,NO,kCGRenderingIntentDefault);NSImage *image=[[NSImage alloc] initWithCGImage:cg size:NSMakeSize(2,2)];
    NSData *encoded=[WebpConverter convertImageToWebP:image configBlock:nil error:&error];int width=0,height=0;check(WebPGetInfo(encoded.bytes,encoded.length,&width,&height) && width==2 && height==2,@"synthetic WebP encode");CGImageRelease(cg);CGColorSpaceRelease(space);CGDataProviderRelease(provider);
    LCAuthGuideHostApp *host=[[LCAuthGuideHostApp alloc] initWithDisplayName:@"Evidence Fixture" bundleURL:[NSURL fileURLWithPath:@"/tmp/Fixture.app"] icon:image];
    AppDragSourceView *drag=[[AppDragSourceView alloc] initWithHostApp:host];check(drag.rowView.subviews.count==4 && drag.rowView.constraints.count+drag.constraints.count+drag.iconBgView.constraints.count+drag.rightIconView.constraints.count>=18,@"drag UI constraint graph");check([drag respondsToSelector:@selector(draggingSession:sourceOperationForMask:)],@"original drag selector retained");
    NSPasteboardItem *item=[[NSPasteboardItem alloc] init];[drag pasteboard:nil item:item provideDataForType:NSPasteboardTypeFileURL];check([[item dataForType:NSPasteboardTypeFileURL] isEqual:host.bundleURL.dataRepresentation],@"file URL data provider");
    OverlayContentView *content=[[OverlayContentView alloc] initWithHostApp:host permissionType:0 onBack:nil];check(content.subviews.count==1 && content.subviews.firstObject.subviews.count==5,@"overlay view graph");
    OverlayWindowController *overlay=[[OverlayWindowController alloc] initWithHostApp:host type:0 onBack:nil];check(overlay.windowSize.width==500 && overlay.windowSize.height>=110,@"overlay dimensions");check(![(PassiveOverlayPanel *)overlay.window canBecomeKey],@"passive overlay");
    check([overlay springProgressAt:-1]==0 && [overlay springProgressAt:NAN]==0,@"spring numeric edge cases");double p=[overlay springProgressAt:0.36];check(near(p,1-exp(-M_PI)*(M_PI+1)),@"critical damping formula");
    NSRect from=NSMakeRect(0,0,20,20),to=NSMakeRect(100,200,80,60);check(NSEqualRects([overlay curvedFrameFrom:from to:to progress:0],from) && NSEqualRects([overlay curvedFrameFrom:from to:to progress:1],to),@"quadratic flight endpoints");
    NSPoint anchor=[overlay anchoredOriginForSettingsFrame:NSMakeRect(300,600,700,400) visibleFrame:NSMakeRect(0,0,2000,1400) isAlignRight:YES];check(anchor.x==500 && near(anchor.y,600-overlay.windowSize.height),@"settings anchor");
    LCPermissionViewController *permissions=[[LCPermissionViewController alloc] init];permissions.authTypes=@[model];[permissions viewDidLayout];check(permissions.box.contentView.subviews.count==1,@"permission child model");check(permissions.box.frame.size.height==100,@"permission geometry");
    LCPermissionItem *permission=(LCPermissionItem *)permissions.box.contentView.subviews.firstObject;check([permission refreshStatus]==NO,@"unknown item remains ungranted without OS query");
    LCAuthGuideKit *kit=[[LCAuthGuideKit alloc] init];check([kit isPermissionGranted:0],@"unknown auth type pass semantics");__block NSUInteger callbacks=0;kit.allAuthPassedHandler=^{callbacks++;};[kit showPermissionAuth:@[]];check(callbacks==1 && kit.monitorTimer==nil,@"empty auth list fast path");
    check([IShotPermissionURL_10009e518(10).absoluteString hasSuffix:@"Privacy_ListenEvent"],@"permission table");
    [overlay close];puts("dependency tests passed: geometry, models, sandbox delegates, WebP, permission UI and overlay; no permission requests or external launches");
}return 0;}
