// Exercises recovered event routing without installing monitors or starting capture.
#import "../MXClipWindowController.h"
#import "../MXClipView.h"
#import "../../Editor/AnnotatedImageController.h"
#import "../../Imaging/Imaging.h"
#import <unistd.h>
#include <assert.h>
NSScreen *IShotGlobal_1001dde80;
AnnotatedImageController *IShotGlobal_1001de160;
NSString *IShotGlobal_1001ddfc0,*IShotGlobal_1001ddfc8,*IShotGlobal_1001dde70;
NSMutableArray *IShotGlobal_1001de050;
NSMutableDictionary *IShotGlobal_1001de058;
int64_t IShotGlobal_1001ddd00;
double IShotGlobal_1001ddcf8;
BOOL IShotGlobal_1001de088,IShotGlobal_1001dde94,IShotGlobal_1001ddfb8,IShotGlobal_1001dded8,IShotGlobal_1001dded9,IShotGlobal_1001de0c2,IShotGlobal_1001ddcf0,IShotGlobal_1001de0c0;
#include "../MXClipWindowController-events.inc"
@interface EventFixture : NSObject
@property(nonatomic,strong) id responder;
@property(nonatomic) NSUInteger refreshes;
@end
@implementation EventFixture
- (id)clipView { return self; }
- (id)window { return self; }
- (id)firstResponder { return self.responder ?: self; }
- (id)indicatorFieldWidth { return @"width"; }
- (id)indicatorFieldHeight { return @"height"; }
- (void)refreshIndicatorFieldSize { self.refreshes++; }
@end
static NSEvent *key(NSString *characters,unsigned short code,NSUInteger flags) {
    return [NSEvent keyEventWithType:NSEventTypeKeyDown location:NSZeroPoint modifierFlags:flags timestamp:0 windowNumber:0 context:nil characters:characters charactersIgnoringModifiers:characters isARepeat:NO keyCode:code];
}
int main(void) {
    @autoreleasepool {
        EventFixture *fixture=[EventFixture new]; MXClipWindowController *controller=(id)fixture;
        NSEvent *event=key(@"6",22,0); assert(IShotClipLocal(controller,event)==event);
        uint64_t bits; memcpy(&bits,&IShotGlobal_1001ddcf8,8); assert(bits==0x3ffc71c71c71c71c);
        event=key(@"0",29,0); assert(IShotClipLocal(controller,event)==event && IShotGlobal_1001ddcf8==0);
        IShotGlobal_1001de088=YES; IShotGlobal_1001dde94=YES;
        event=key(@"",51,0); assert(IShotClipLocal(controller,event)==event && IShotGlobal_1001ddd00==51);
        event=key(@"\r",36,0); assert(IShotClipLocal(controller,event)==event && IShotGlobal_1001ddd00==36);
        fixture.responder=@"width"; assert(IShotClipLocal(controller,event)==nil && fixture.refreshes==1);
        event=key(@"7",26,0); assert(IShotClipLocal(controller,event)==event);
        event=key(@"c",8,NSEventModifierFlagCommand); assert(IShotClipLocal(controller,event)==nil);
        NSLog(@"ClipEventTests passed");
    }
}
