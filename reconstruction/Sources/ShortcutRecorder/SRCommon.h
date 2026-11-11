#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
NSBundle *SRBundle(void);
NSString *SRLoc(NSString *key);
NSImage *SRImage(NSString *name);
UInt32 SRCocoaToCarbonFlags(NSUInteger flags);
NSUInteger SRCarbonToCocoaFlags(UInt32 flags);
NSString *SRReadableStringForCocoaModifierFlagsAndKeyCode(NSUInteger flags, unsigned short code);
NSString *SRReadableASCIIStringForCocoaModifierFlagsAndKeyCode(NSUInteger flags, unsigned short code);
BOOL SRKeyCodeWithFlagsEqualToKeyEquivalentWithFlags(unsigned short code, NSUInteger flags, NSString *equivalent, NSUInteger equivalentFlags);
