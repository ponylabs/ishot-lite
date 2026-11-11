#import "WebpConverter.h"
@implementation WebpConverter
// 0x100050eb4. Deliberately retains original unchecked importer/encoder results and writer allocation lifetime.
+ (NSData *)convertImageToWebP:(NSImage *)image configBlock:(void (^)(WebPConfig *))block error:(NSError **)error {
    WebPConfig config; WebPPicture picture; NSString *description;
    if(!WebPConfigInitInternal(&config,WEBP_PRESET_DEFAULT,75.f,0x20e)) description=@"Configuration preset failed to initialize.";
    else {
        if(block) block(&config);
        config.image_hint=0;
        if(!WebPValidateConfig(&config)) description=@"One or more configuration parameters are beyond their valid ranges.";
        else if(!WebPPictureInitInternal(&picture,0x20e)) description=@"Failed to initialize structure. Version mismatch.";
        else {
            picture.colorspace=0; picture.writer=WebPMemoryWrite;
            WebPMemoryWriter writer; WebPMemoryWriterInit(&writer); picture.custom_ptr=&writer;
            CGImageRef cg=[image CGImageForProposedRect:NULL context:nil hints:nil];
            size_t stride=CGImageGetBytesPerRow(cg);
            picture.width=(int)CGImageGetWidth(cg); picture.height=(int)CGImageGetHeight(cg);
            CFDataRef pixels=CGDataProviderCopyData(CGImageGetDataProvider(cg)); const uint8_t *bytes=CFDataGetBytePtr(pixels);
            switch(CGImageGetAlphaInfo(cg)) {
                case 0: WebPPictureImportRGB(&picture,bytes,(int)stride); break;
                case 1: case 3: WebPPictureImportRGBA(&picture,bytes,(int)stride); break;
                case 2: case 4: WebPPictureImportBGRA(&picture,bytes,(int)stride); break;
                default: break;
            }
            WebPPictureARGBToYUVA(&picture,picture.colorspace); WebPCleanupTransparentArea(&picture); WebPEncode(&config,&picture);
            NSData *result=[NSData dataWithBytes:writer.mem length:writer.size]; WebPPictureFree(&picture); CFRelease(pixels); return result;
        }
    }
    NSMutableDictionary *info=[NSMutableDictionary dictionary]; [info setValue:description forKey:NSLocalizedDescriptionKey];
    if(error) *error=[NSError errorWithDomain:[NSString stringWithFormat:@"%@.errorDomain",NSBundle.mainBundle.bundleIdentifier] code:-101 userInfo:info];
    return nil;
}
@end
