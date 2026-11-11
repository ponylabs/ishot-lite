#import "ShellControllers.h"
#import "CollectionViewItem.h"
#import "../Imaging/Imaging.h"
#import "../MainApplication/AppDelegate.h"
#include <stdlib.h>
extern NSScreen *IShotGlobal_1001dde80;
extern BOOL IShotGlobal_1001de168,IShotGlobal_1001dd139;
ShellWindowController *IShotGlobal_1001de2c0;
extern BOOL IShotFunction_10004c554(NSScreen *);
extern NSString *IShotFunction_10004c730(void);
extern void IShotFunction_100047ffc(NSString *);
extern CGImageRef IShotCGWindowListCreateImage(CGRect,CGWindowListOption,CGWindowID,CGWindowImageOption) __asm__("_CGWindowListCreateImage");
@implementation ScreenshotWithShellController
@synthesize collectionView=_collectionView;
- (instancetype)initFromXib { // 0x1000c4ca0
    self=[super init];
    if (self) [NSBundle.mainBundle loadNibNamed:@"ScreenshotWithShell" owner:self topLevelObjects:NULL];
    return self;
}
- (void)awakeFromNib { // 0x1000c4d1c
    self.window.level=100; self.window.movableByWindowBackground=YES;
    [self.window standardWindowButton:2].hidden=YES;
}
- (void)windowDidLoad { // 0x1000c4db8
    [super windowDidLoad];
    NSCollectionViewFlowLayout *layout=[[NSCollectionViewFlowLayout alloc] init];
    layout.itemSize=NSMakeSize(160,140);
    layout.minimumInteritemSpacing=10; layout.minimumLineSpacing=10;
    layout.sectionInset=NSEdgeInsetsMake(10,10,10,10);
    self.collectionView.collectionViewLayout=layout;
}
- (NSSize)collectionView:(NSCollectionView *)view layout:(NSCollectionViewFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)index { // 0x1000c4e7c
    double margins=layout.sectionInset.left+layout.sectionInset.right;
    double spacing=layout.minimumInteritemSpacing*-3.0;
    return NSMakeSize(((view.bounds.size.width-margins)+spacing)*0.25,140);
}
- (NSInteger)collectionView:(NSCollectionView *)view numberOfItemsInSection:(NSInteger)section { // 0x1000c4f20
    return [[NSUserDefaults.standardUserDefaults objectForKey:@"arrOfDisplayModelWithShell"] count];
}
- (NSCollectionViewItem *)collectionView:(NSCollectionView *)view itemForRepresentedObjectAtIndexPath:(NSIndexPath *)index { // 0x1000c4f88
    CollectionViewItem *item=[[CollectionViewItem alloc] init];
    NSInteger position=index.item;
    item.title=[NSUserDefaults.standardUserDefaults objectForKey:@"arrOfDisplayModelWithShell"][position][@"Name"];
    item.identifier=[NSString stringWithFormat:@"%ld",(long)position];
    return item;
}
- (void)autoMatchModels:(id)sender { [self selectedShellName:@"autoMatchModels"]; } // 0x1000c50b8
- (void)pinShellView:(NSString *)name { // 0x1000c50c4
    NSDictionary *selected=nil;
    for (NSDictionary *item in [NSUserDefaults.standardUserDefaults objectForKey:@"arrOfDisplayModelWithShell"]) {
        if ([name isEqualToString:item[@"Name"]]) { selected=item; break; }
    }
    if (!IShotGlobal_1001de2c0) IShotGlobal_1001de2c0=[[ShellWindowController alloc] initWithData:selected];
    else [IShotGlobal_1001de2c0 sentShellData:selected];
    [IShotGlobal_1001de2c0.window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES]; [self.window close];
}
- (void)selectedShellName:(NSString *)name { // 0x1000c5304
    IShotGlobal_1001dde80=[NSScreen currentScreenForMouseLocation];
    if ([name hasPrefix:@"iPhone"] || [name hasPrefix:@"iPad"]) [self pinShellView:name];
    else {
        IShotGlobal_1001de168=YES; [self.window close];
        NSInteger delay=[[NSUserDefaults.standardUserDefaults stringForKey:@"timeOfDelayScreenshotsWithShell"] integerValue];
        dispatch_async(dispatch_get_global_queue(0,0), ^{ // 0x1000c549c
            for (NSInteger remaining=delay;remaining!=0;remaining--) system([[NSString stringWithFormat:@"say %lu",(unsigned long)remaining] UTF8String]);
            dispatch_async(dispatch_get_main_queue(), ^{ [self screenShotWithShellName:name]; IShotGlobal_1001de168=NO; }); // 0x1000c557c
        });
    }
}
- (void)screenShotWithShellName:(NSString *)name { // 0x1000c55a4; geometry register flow retained in refined assembly
    double deepestHeight=NSScreen.deepestScreen.frame.size.height;
    NSRect screen=IShotGlobal_1001dde80.frame;
    NSArray *models=[NSUserDefaults.standardUserDefaults objectForKey:@"arrOfDisplayModelWithShell"];
    NSRect outside=NSZeroRect,inside=NSZeroRect;
    if (![name isEqualToString:@"autoMatchModels"]) {
        for (NSDictionary *model in models) if ([name isEqualToString:model[@"Name"]]) {
            outside=NSRectFromString(model[@"OutsideRect"]); inside=NSRectFromString(model[@"InsideRect"]); break;
        }
    } else if (IShotFunction_10004c554(IShotGlobal_1001dde80)) {
        for (NSDictionary *model in models) {
            inside=NSRectFromString(model[@"InsideRect"]);
            if (NSEqualSizes(inside.size,IShotGlobal_1001dde80.frame.size)) {
                NSString *hardware=IShotFunction_10004c730(); name=model[@"Name"];
                if (([hardware hasPrefix:@"MacBookAir"] && [name hasPrefix:@"MacBook Air"]) ||
                    ([hardware hasPrefix:@"MacBookPro"] && [name hasPrefix:@"MacBook Pro"]) ||
                    ([hardware hasPrefix:@"iMac"] && [name hasPrefix:@"iMac"])) { outside=NSRectFromString(model[@"OutsideRect"]); break; }
            }
        }
        if (NSEqualRects(outside,NSZeroRect)) {
            IShotFunction_100047ffc([@"TelliShotHelperToUserNotification:" stringByAppendingString:NSLocalizedString(@"There is no Mac model in the database, please go to the official website to submit, thank you.",@"")]);
            return;
        }
    } else {
        NSMutableArray *candidates=[NSMutableArray new];
        float aspect=(float)(IShotGlobal_1001dde80.frame.size.width/IShotGlobal_1001dde80.frame.size.height);
        for (NSDictionary *model in models) if ([model[@"FullScreen"] boolValue] && ![model[@"BuiltIn"] boolValue]) {
            NSRect candidate=NSRectFromString(model[@"InsideRect"]);
            // Original jumps to sorting before adding an exact size match.
            if (NSEqualSizes(candidate.size,IShotGlobal_1001dde80.frame.size)) break;
            float ratio=(float)((candidate.size.width/candidate.size.height)/(double)aspect);
            [candidates addObject:@[[NSString stringWithFormat:@"%f",(double)ratio],model]];
        }
        NSArray *sorted=[candidates sortedArrayUsingComparator:^NSComparisonResult(NSArray *a,NSArray *b) { return [b[0] compare:a[0]]; }]; // 0x1000c6108
        NSDictionary *model=sorted[0][1];
        name=model[@"Name"]; inside=NSRectFromString(model[@"InsideRect"]); outside=NSRectFromString(model[@"OutsideRect"]);
    }
    if (NSEqualRects(outside,NSZeroRect)) return;
    CGRect capture=CGRectMake(screen.origin.x,(float)((deepestHeight-screen.size.height)-screen.origin.y),screen.size.width,screen.size.height);
    CGImageRef cg=IShotCGWindowListCreateImage(capture,4,(CGWindowID)self.window.windowNumber,0);
    NSImage *image=[[NSImage alloc] initWithCGImage:cg size:screen.size]; CGImageRelease(cg);
    NSImage *shell=[NSImage imageNamed:[name stringByAppendingString:@"Shell"]];
    NSImage *result=[[NSImage alloc] initWithSize:outside.size];
    [result lockFocus]; [NSGraphicsContext saveGraphicsState];
    [image drawInRect:inside]; [shell drawInRect:outside]; [NSGraphicsContext restoreGraphicsState];
    [result unlockFocus]; [[AppDelegate appDelegate] saveScreenWithShell:result];
}
@end
