#import "CaptureAudioFunctions.h"
// 0x10004b094: selector 'dIn ' or 'dOut', global scope, main element.
void IShotFunction_10004b094(AudioDeviceID device, int input) {
    AudioObjectPropertyAddress address = {input ? 0x64496e20 : 0x644f7574, 0x676c6f62, 0};
    AudioObjectSetPropertyData(1, &address, 0, NULL, 4, &device);
}
// 0x10004bf98. The shipped routine does not free the device buffer or release UID values.
uintptr_t IShotFunction_10004bf98(NSArray *deviceUIDs) {
    AudioObjectPropertyAddress address = {0x64657623, 0x6f757470, 0};
    UInt32 size;
    if (AudioObjectGetPropertyDataSize(1, &address, 0, NULL, &size) == 0) {
        AudioDeviceID *devices = malloc(size);
        AudioObjectGetPropertyData(1, &address, 0, NULL, &size, devices);
        for (UInt32 i = 0; i < (size >> 2); i++) {
            UInt32 uidSize = 8;
            CFStringRef uid;
            address = (AudioObjectPropertyAddress){0x75696420, 0x6f757470, 0};
            AudioObjectGetPropertyData(devices[i], &address, 0, NULL, &uidSize, &uid);
            if ([deviceUIDs containsObject:(__bridge id)uid]) AudioHardwareDestroyAggregateDevice(devices[i]);
        }
    }
    return 0;
}
#import <AVFoundation/AVFoundation.h>
// 0x10004ad10
NSString *IShotFunction_10004ad10(void) {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    if (device) return device.localizedName;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    for (AVCaptureDevice *candidate in devices)
        if ([candidate.manufacturer isEqualToString:@"Apple Inc."]) return candidate.localizedName;
    for (AVCaptureDevice *candidate in devices) {
        NSString *uid = candidate.uniqueID;
        if (![uid hasSuffix:@"_UID"] && ![uid hasSuffix:@"Soundflower"] && ![uid hasPrefix:@"com.rogueamoeba"]) return candidate.localizedName;
    }
    return @"None";
}
// 0x10004abbc
BOOL IShotFunction_10004abbc(void) {
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio])
        if ([device.localizedName isEqualToString:@"iShotAudioPlugin"]) return YES;
    return NO;
}
// 0x10004c0c8; original leaves allocated device array/CF strings retained.
AudioDeviceID IShotFunction_10004c0c8(NSString *uid) {
    AudioObjectPropertyAddress address = {0x64657623, 0x6f757470, 0};
    UInt32 size;
    if (AudioObjectGetPropertyDataSize(1, &address, 0, NULL, &size) == 0) {
        AudioDeviceID *devices = malloc(size);
        AudioObjectGetPropertyData(1, &address, 0, NULL, &size, devices);
        for (UInt32 i = 0; i < (size >> 2); i++) {
            UInt32 uidSize = 8;
            CFStringRef candidate;
            address = (AudioObjectPropertyAddress){0x75696420, 0x6f757470, 0};
            AudioObjectGetPropertyData(devices[i], &address, 0, NULL, &uidSize, &candidate);
            if ([(__bridge NSString *)candidate isEqualToString:uid]) return devices[i];
        }
    }
    return 0;
}
// 0x10004c20c
AudioDeviceID IShotFunction_10004c20c(NSString *name) {
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio])
        if ([device.localizedName isEqualToString:name]) return IShotFunction_10004c0c8(device.uniqueID);
    return 0;
}
// 0x10004c3f4. Caller passes the previous helper's returned device in x0.
UInt32 IShotFunction_10004c3f4(AudioDeviceID device) {
    AudioObjectPropertyAddress address = {0x7472616e, 0x6f757470, 0};
    UInt32 size = 4, transport = 0;
    AudioObjectGetPropertyData(device, &address, 0, NULL, &size, &transport);
    return transport;
}
// 0x10004b044
void IShotFunction_10004b044(AudioDeviceID device) {
    AudioObjectPropertyAddress address = {0x766f6c6d, 0x6f757470, 0};
    Float32 volume = 1.0f;
    AudioObjectSetPropertyData(device, &address, 0, NULL, 4, &volume);
}
// 0x10004b4c4: preserves the original error paths and unfreed enumeration buffer.
NSString *IShotFunction_10004b4c4(int input) {
    AudioObjectPropertyAddress address = {0x64657623, 0x676c6f62, 0};
    UInt32 size;
    OSStatus status = AudioObjectGetPropertyDataSize(1, &address, 0, NULL, &size);
    if (status) { printf("Error in AudioObjectGetPropertyDataSize: %d\n", status); return nil; }
    UInt32 count = size >> 2;
    AudioDeviceID *devices = calloc(count, 4);
    status = AudioObjectGetPropertyData(1, &address, 0, NULL, &size, devices);
    if (status) { printf("Error in AudioObjectGetPropertyData: %d\n", status); return nil; }
    AudioDeviceID defaultDevice = 0;
    size = 4;
    address = (AudioObjectPropertyAddress){input ? 0x64496e20 : 0x644f7574, 0x676c6f62, 0};
    status = AudioObjectGetPropertyData(1, &address, 0, NULL, &size, &defaultDevice);
    if (status) { printf("Error in AudioObjectGetPropertyData: kAudioHardwarePropertyDefaultOutputDevice: %d\n", status); return nil; }
    for (UInt32 i = 0; i < count; i++) {
        address = (AudioObjectPropertyAddress){0x73746d23, input ? 0x696e7074 : 0x6f757470, 0};
        UInt32 streamSize = 0;
        status = AudioObjectGetPropertyDataSize(devices[i], &address, 0, NULL, &streamSize);
        if (status == 0 && streamSize != 0 && devices[i] == defaultDevice) {
            CFStringRef uid;
            size = 8;
            address = (AudioObjectPropertyAddress){0x75696420, 0x676c6f62, 0};
            status = AudioObjectGetPropertyData(devices[i], &address, 0, NULL, &size, &uid);
            if (status == 0) return CFBridgingRelease(uid);
            printf("Error in AudioObjectGetPropertyData: %d\n", status);
        }
    }
    return nil;
}
// 0x10004b0f4
void IShotFunction_10004b0f4(int hidden, AudioDeviceID device) {
    AudioObjectPropertyAddress address = {0x68696465, 0x676c6f62, 0};
    CFNumberRef number = CFNumberCreate(NULL, 3, &hidden);
    AudioObjectSetPropertyData(device, &address, 0, NULL, 8, &number);
    if (number) CFRelease(number);
}
// 0x10004bbf4; five attempts per secondary subdevice, each failed attempt sleeps 0.2 s.
OSStatus IShotFunction_10004bbf4(AudioDeviceID device) {
    AudioObjectPropertyAddress address = {0x6f776e64, 0x676c6f62, 0};
    AudioClassID qualifier = 0x61737562;
    UInt32 size = 4;
    OSStatus status = AudioObjectGetPropertyDataSize(device, &address, 4, &qualifier, &size);
    if (status == 0) {
        UInt32 count = size >> 2;
        AudioObjectID *objects = __builtin_alloca(count * 4);
        size = count * 4;
        status = AudioObjectGetPropertyData(device, &address, 4, &qualifier, &size, objects);
        if (status == 0) {
            address = (AudioObjectPropertyAddress){0x64726674, 0x676c6f62, 0};
            for (UInt32 i = 1; i < count; i++) {
                UInt32 enabled = 1;
                for (UInt32 attempt = 0; attempt < 5; attempt++) {
                    status = AudioObjectSetPropertyData(objects[i], &address, 0, NULL, 4, &enabled);
                    if (status == 0) break;
                    [NSThread sleepForTimeInterval:0.2];
                }
            }
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false);
        }
    }
    return status;
}
// 0x10004ba34
AudioDeviceID IShotFunction_10004ba34(NSArray *subdevices) {
    NSDictionary *description = @{@"name":[[NSBundle mainBundle] localizedStringForKey:@"iShot Multi_Output Device" value:@"" table:nil], @"uid":@"iShotAudioMultiOutputDevice_UID", @"subdevices":subdevices, @"master":subdevices[0][@"uid"], @"stacked":@1};
    AudioDeviceID device = 0;
    AudioHardwareCreateAggregateDevice((__bridge CFDictionaryRef)description, &device);
    IShotFunction_10004bbf4(device);
    return device;
}
// 0x10004bdcc
AudioDeviceID IShotFunction_10004bdcc(NSArray *subdevices) {
    NSDictionary *description = @{@"name":[[NSBundle mainBundle] localizedStringForKey:@"iShot Aggregate Device" value:@"" table:nil], @"uid":@"iShotAudioAggregateDevice_UID", @"subdevices":subdevices, @"master":subdevices[0][@"uid"], @"stacked":@0};
    AudioDeviceID device = 0;
    AudioHardwareCreateAggregateDevice((__bridge CFDictionaryRef)description, &device);
    IShotFunction_10004b0f4(1, device);
    IShotFunction_10004bbf4(device);
    return device;
}
