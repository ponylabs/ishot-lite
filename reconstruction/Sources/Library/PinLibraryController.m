#import "PinLibrary.h"
static NSMutableArray *IShotGlobal_1001f1940;
@implementation PinLibraryController
- (instancetype)init { // 0x1000471fc
    self = [super init];
    if (self) {
        [NSBundle.mainBundle loadNibNamed:@"PinLibrary" owner:self topLevelObjects:NULL];
        IShotGlobal_1001f1940 = [NSMutableArray arrayWithCapacity:10];
        [self refreshCollectionView];
    }
    return self;
}
- (void)deleteAllPin:(id)sender { // 0x1000472ac
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/PinLibrary"];
    [NSFileManager.defaultManager removeItemAtPath:path error:NULL];
    path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/PreviewImageOfPinLibrary"];
    [NSFileManager.defaultManager removeItemAtPath:path error:NULL];
    [self refreshCollectionView];
}
- (void)refreshCollectionView { // 0x1000473e8
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/PinLibrary"];
    [IShotGlobal_1001f1940 removeAllObjects];
    IShotGlobal_1001f1940 = [self getFilesAtPathSortedByModificationDate:path];
    [self.PinLibraryCollectionView reloadData];
}
- (NSMutableArray *)getFilesAtPathSortedByModificationDate:(NSString *)path { // 0x1000474b4
    NSArray *files = [NSFileManager.defaultManager contentsOfDirectoryAtPath:path error:NULL];
    NSMutableArray *result = [NSMutableArray new];
    for (NSString *file in files) {
        NSString *full = [path stringByAppendingPathComponent:file];
        NSDate *date = [NSFileManager.defaultManager attributesOfItemAtPath:full error:NULL][NSFileModificationDate];
        BOOL directory = YES;
        if ([NSFileManager.defaultManager fileExistsAtPath:full isDirectory:&directory] && !directory && [full.pathExtension isEqualToString:@"png"]) [result addObject:@{@"FullPath":full, @"ModDate":date}];
    }
    [result sortUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) { return [b[@"ModDate"] compare:a[@"ModDate"]]; }]; // 0x1000478b4
    NSUInteger limit = (NSUInteger)(NSInteger)[[NSUserDefaults.standardUserDefaults objectForKey:@"maxNumberOfPicturesInLibrary"] intValue];
    while (result.count > limit) {
        NSString *full = result.lastObject[@"FullPath"];
        NSString *preview = [full stringByReplacingOccurrencesOfString:@"PinLibrary" withString:@"PreviewImageOfPinLibrary"];
        [NSFileManager.defaultManager removeItemAtPath:preview error:NULL];
        [NSFileManager.defaultManager removeItemAtPath:full error:NULL];
        [result removeLastObject];
    }
    return result;
}
- (void)awakeFromNib { // 0x100047948
    self.window.level = 26;
    self.window.movableByWindowBackground = YES;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/PinLibrary"];
    [[CSFSEventStream sharedManager] startEventStream:@[path]];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowDidBecomeKey:) name:NSWindowDidBecomeKeyNotification object:self.window];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:self.window];
}
- (void)windowDidBecomeKey:(id)sender {} // 0x100047b74: RET
- (void)windowWillClose:(id)sender {} // 0x100047b78: RET
- (void)keyDown:(NSEvent *)event { // 0x100047b7c
    NSLog(@"%hu", event.keyCode);
    if (event.keyCode == 53) NSLog(@"keyDown:%hu", event.keyCode);
}
- (void)keyUp:(NSEvent *)event { (void)event.keyCode; } // 0x100047bf0
- (NSInteger)collectionView:(NSCollectionView *)view numberOfItemsInSection:(NSInteger)section { return IShotGlobal_1001f1940.count; } // 0x100047bf8
- (NSCollectionViewItem *)collectionView:(NSCollectionView *)view itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath { // 0x100047c04
    PinLibraryCollectionViewItem *item = [[PinLibraryCollectionViewItem alloc] init];
    item.identifier = IShotGlobal_1001f1940[indexPath.item][@"FullPath"];
    return item;
}
@end
