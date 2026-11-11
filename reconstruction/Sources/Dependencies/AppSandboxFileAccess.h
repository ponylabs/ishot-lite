#import <AppKit/AppKit.h>
@protocol AppSandboxFileAccessProtocol <NSObject>
- (NSData *)bookmarkDataForURL:(NSURL *)url;
- (void)setBookmarkData:(NSData *)data forURL:(NSURL *)url;
- (void)clearBookmarkDataForURL:(NSURL *)url;
@end
@interface AppSandboxFileAccessPersist : NSObject <AppSandboxFileAccessProtocol>
+ (NSString *)keyForBookmarkDataForURL:(NSURL *)url;
@end
@interface AppSandboxFileAccessOpenSavePanelDelegate : NSObject <NSOpenSavePanelDelegate>
@property(nonatomic,strong) NSArray *pathComponents;
- (instancetype)initWithFileURL:(NSURL *)url;
@end
@interface AppSandboxFileAccess : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,copy) NSString *prompt;
@property(nonatomic,weak) id<AppSandboxFileAccessProtocol> bookmarkPersistanceDelegate;
@property(nonatomic,strong) AppSandboxFileAccessPersist *defaultDelegate;
+ (instancetype)fileAccessWithMessage:(NSString *)message;
- (instancetype)initWithMessage:(NSString *)message;
- (NSURL *)askPermissionForURL:(NSURL *)url;
- (NSData *)persistPermissionPath:(NSString *)path;
- (NSData *)persistPermissionURL:(NSURL *)url;
- (BOOL)accessFilePath:(NSString *)path withBlock:(void (^)(void))block persistPermission:(BOOL)persist;
- (BOOL)accessFileURL:(NSURL *)url withBlock:(void (^)(void))block persistPermission:(BOOL)persist;
- (BOOL)accessFilePath:(NSString *)path persistPermission:(BOOL)persist withBlock:(void (^)(void))block;
- (BOOL)accessFileURL:(NSURL *)url persistPermission:(BOOL)persist withBlock:(void (^)(void))block;
- (BOOL)requestAccessPermissionsForFilePath:(NSString *)path persistPermission:(BOOL)persist withBlock:(void (^)(NSURL *,NSData *))block;
- (BOOL)requestAccessPermissionsForFileURL:(NSURL *)url persistPermission:(BOOL)persist withBlock:(void (^)(NSURL *,NSData *))block;
@end
