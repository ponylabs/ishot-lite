#pragma once
#import <Cocoa/Cocoa.h>
@interface ShellWindow : NSWindow @end
@interface ShellWindowController : NSWindowController
@property(nonatomic,strong) NSImageView *imageView;
- (instancetype)initWithData:(id)data;
- (void)sentShellData:(id)data;
- (void)refreshData;
- (void)screenshotbuttonClick:(id)sender;
- (void)helpButtonCLick:(id)sender;
- (void)resize:(int)value;
@end
@interface ScreenshotWithShellController : NSWindowController
@property(weak) IBOutlet NSCollectionView *collectionView;
- (instancetype)initFromXib;
- (void)autoMatchModels:(id)sender;
- (void)pinShellView:(NSString *)name;
- (void)selectedShellName:(NSString *)name;
- (void)screenShotWithShellName:(NSString *)name;
@end
