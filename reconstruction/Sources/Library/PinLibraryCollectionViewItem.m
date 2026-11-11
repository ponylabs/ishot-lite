#import "PinLibrary.h"
#import "../MainApplication/AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
extern PinLibraryController *IShotGlobal_1001de188;
NSString *IShotGlobal_1001f19d0;
@implementation PinLibraryCollectionViewItem
- (instancetype)init { return [super init]; } // 0x10005d0b0
- (void)viewDidLoad { // 0x10005d0e4
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 3;
    NSString *full = self.identifier;
    NSString *preview = [full stringByReplacingOccurrencesOfString:@"PinLibrary" withString:@"PreviewImageOfPinLibrary"];
    BOOL exists = [NSFileManager.defaultManager fileExistsAtPath:preview];
    self.imageView.image = [[NSImage alloc] initWithContentsOfFile:exists ? preview : full];
    self.imageView.identifier = full;
}
- (void)mouseMoved:(NSEvent *)event { IShotGlobal_1001f19d0 = self.identifier; } // 0x10005d2ac
- (void)mouseDown:(NSEvent *)event { if (event.clickCount == 2) [self pin:self]; } // 0x10005d2d8
- (void)close:(id)sender { // 0x10005d318
    NSString *preview = [IShotGlobal_1001f19d0 stringByReplacingOccurrencesOfString:@"PinLibrary" withString:@"PreviewImageOfPinLibrary"];
    [NSFileManager.defaultManager removeItemAtPath:preview error:NULL];
    if ([NSFileManager.defaultManager removeItemAtPath:IShotGlobal_1001f19d0 error:NULL]) [IShotGlobal_1001de188 refreshCollectionView];
}
- (void)pin:(id)sender { // 0x10005d3d0
    NSData *data = [[NSData alloc] initWithContentsOfFile:IShotGlobal_1001f19d0];
    NSImage *image = [[NSImage alloc] initWithData:data];
    if (image) [[AppDelegate appDelegate] mapImageToScreen:image isAddToPinLibrary:NO];
}
@end
