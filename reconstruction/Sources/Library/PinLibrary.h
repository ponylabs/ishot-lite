#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>
@interface PinLibraryController : NSWindowController
@property(nonatomic,strong) NSCollectionView *PinLibraryCollectionView;
- (void)deleteAllPin:(id)sender;
- (void)refreshCollectionView;
- (NSMutableArray *)getFilesAtPathSortedByModificationDate:(NSString *)path;
@end
@interface CSFSEventStream : NSObject
@property(nonatomic,assign) FSEventStreamRef syncEventStream;
+ (instancetype)sharedManager;
- (void)startEventStream:(NSArray *)paths;
- (void)stopEventStream;
- (void)fsEventsSetUp:(NSArray *)paths;
- (void)updateEventID;
- (void)setSyncEventID:(long long)value;
- (long long)syncEventID;
- (BOOL)validateIsPictureName:(NSString *)name;
@end
@interface PinLibraryCollectionViewItem : NSCollectionViewItem
- (void)close:(id)sender;
- (void)pin:(id)sender;
@end
@interface PinLibraryCollectionViewItemView : NSImageView {
    BOOL _isMouseEntered;
}
@property(nonatomic,strong) NSButton *pinButton;
@property(nonatomic,strong) NSButton *closeButton;
@end
