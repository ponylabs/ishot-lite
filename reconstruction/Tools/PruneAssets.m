// Build-only CoreUI adapter. Selectors/type encodings inspected on this host;
// the Python caller verifies the exact surviving rendition names and digests.
#import <Foundation/Foundation.h>
#import <dlfcn.h>
@interface NSObject (LiteAssetStorage)
- (id)initWithPath:(NSString *)path forWriting:(BOOL)writing;
- (id)initWithPath:(NSString *)path;
- (const void *)keyList;
- (NSData *)convertRenditionKeyToKeyData:(const void *)key;
- (NSArray *)allAssetKeys;
- (NSInteger)themeIdentifier;
- (void)removeAssetForKey:(id)key;
- (BOOL)removeAssetName:(NSString *)name;
- (BOOL)writeToDiskAndCompact:(BOOL)compact;
@end
int main(int argc,const char **argv) {
    @autoreleasepool {
        if(argc!=3) return 2;
        dlopen("/System/Library/PrivateFrameworks/CoreUI.framework/CoreUI",RTLD_LAZY);
        NSDictionary *removed=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:@(argv[2])] options:0 error:NULL];
        id store=[[NSClassFromString(@"CUIMutableCommonAssetStorage") alloc] initWithPath:@(argv[1]) forWriting:YES];
        if(!store || !removed) return 3;
        id reader=[[NSClassFromString(@"CUIStructuredThemeStore") alloc] initWithPath:@(argv[1])];
        NSSet *identifiers=[NSSet setWithArray:removed.allValues];
        for(id key in [store allAssetKeys]) if([identifiers containsObject:@([key themeIdentifier])]) [store removeAssetForKey:[reader convertRenditionKeyToKeyData:[key keyList]]];
        for(NSString *name in removed) if(![store removeAssetName:name]) return 4;
        return [store writeToDiskAndCompact:YES] ? 0 : 5;
    }
}
