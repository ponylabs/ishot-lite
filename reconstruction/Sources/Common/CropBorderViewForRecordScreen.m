#import "CropBorderViewForRecordScreen.h"
#import <QuartzCore/QuartzCore.h>
#import <IOKit/hid/IOHIDLib.h>
#import "../Camera/NSValue+CGPoint.h"
extern BOOL IShotCameraDragging_1001ddca8, IShotGlobal_1001de210, IShotGlobal_1001ddd58, IShotGlobal_1001ddde0, IShotGlobal_1001ddce8;
extern NSCursor *IShotGlobal_1001dddf8, *IShotGlobal_1001ddf88, *IShotGlobal_1001ddf90;
extern NSString *IShotGlobal_1001dde70;
static BOOL IShotGlobal_1001f18a8;
static int IShotGlobal_1001f18ac, IShotGlobal_1001f18b0;
#pragma clang fp contract(off)
@implementation CropBorderViewForRecordScreen
@synthesize borderColor=_borderColor, hideHandleRect=_hideHandleRect, toolBarViewRect=_toolBarViewRect;
- (instancetype)initWithFrame:(NSRect)frame {
    self=[super initWithFrame:frame];
    if(self) {
        self.wantsLayer=YES; self.layer.backgroundColor=NSColor.clearColor.CGColor;
        self.borderColor=[NSColor colorWithDeviceRed:0 green:130.0/255.0 blue:213.0/255.0 alpha:.85];
        _handleTrackRectArray=[NSMutableArray array]; [self updateTrackingAreas];
        if(@available(macOS 10.15,*)) {
            if(IOHIDCheckAccess(kIOHIDRequestTypeListenEvent)!=kIOHIDAccessTypeGranted) {
                [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"displayKeyboardEventWhenRecording"];
                [NSUserDefaults.standardUserDefaults synchronize];
            }
        }
    }
    return self;
}
- (void)dealloc { IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; }
- (void)drawRect:(NSRect)rect { } // Original 0x10001329c: RET.
// Original 0x1000132a0 tail-dispatches the same selector; preserve its recursion.
- (void)setToolBarViewRect:(NSRect)rect { [self setToolBarViewRect:rect]; }
- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event]; _beDragging=NO; [self.window disableCursorRects];
    if (event.clickCount==1) self.needsDisplay=YES;
}
- (void)mouseUp:(NSEvent *)event { [super mouseUp:event]; _beDragging=NO; [self updateTrackingAreas]; }
- (void)mouseDragged:(NSEvent *)event { [super mouseDragged:event]; _beDragging=YES; }
- (void)resetCursorRects { [super resetCursorRects]; if (_beDragging) [self addCursorRect:_contentTrackRect cursor:NSCursor.closedHandCursor]; }
- (void)setBorderColor:(NSColor *)color { _borderColor=color; self.needsDisplay=YES; }
- (void)setHideHandleRect:(BOOL)hide { _hideHandleRect=hide; [self updateTrackingAreas]; self.needsDisplay=YES; }
- (int)numberOfReSize { return _numberOfReSize; }
- (BOOL)isCanMove { return _isCanMove; }
- (void)setIsCanMove:(BOOL)value { _isCanMove=value; }
- (BOOL)isInResizeRect { return _isInResizeRect; }
- (NSArray *)_calculateAllNeededHandleTrackRects:(CGRect)rect {
    float width=(float)(rect.size.width-12.0),height=(float)(rect.size.height-12.0);
    double innerWidth=(double)((width-10.f)-2.f);
    float innerHeight=height-10.f;
    double right=(double)width+6.0-5.0,top=(double)height+6.0-5.0;
    return [@[[NSValue valueWithCGRect:CGRectMake(13,13,innerWidth,(double)(innerHeight-4.f))],
              [NSValue valueWithCGRect:CGRectMake(1,1,10,10)],
              [NSValue valueWithCGRect:CGRectMake(12,1,innerWidth,10)],
              [NSValue valueWithCGRect:CGRectMake(right,1,10,10)],
              [NSValue valueWithCGRect:CGRectMake(right+1,12,10,(double)(innerHeight-2.f))],
              [NSValue valueWithCGRect:CGRectMake(right,top,10,10)],
              [NSValue valueWithCGRect:CGRectMake(12,top,innerWidth,10)],
              [NSValue valueWithCGRect:CGRectMake(1,top,10,10)],
              [NSValue valueWithCGRect:CGRectMake(2,12,10,(double)(innerHeight-2.f))]] mutableCopy];
}
- (int)_calculateMouseIsOnCropBorderViewWithPoint:(CGPoint)p {
    BOOL onlyWindow=self.onlyClipCurrentWindow;
    CGRect r=NSInsetRect(self.frame,5,5);
    if(onlyWindow) return NSPointInRect(p,r)?0:9;
    if(NSPointInRect(p,NSInsetRect(self.frame,10,10))) return 0;
    double x=r.origin.x,y=r.origin.y; float w=(float)r.size.width,h=(float)r.size.height;
    CGRect rects[]={CGRectMake(x-5,y-5,10,10),CGRectMake(x+5,y-5,w-10.f,10),
        CGRectMake(x+(double)w-5,y-5,10,10),CGRectMake(x+(double)w-5,y+5,10,h-10.f),
        CGRectMake(x+(double)w-5,y+(double)h-5,10,10),CGRectMake(x+5,y+(double)h-5,w-10.f,10),
        CGRectMake(x-5,y+(double)h-5,10,10),CGRectMake(x-5,y+5,10,h-10.f)};
    for(int i=0;i<8;i++) if(NSPointInRect(p,rects[i])) return i+1;
    return 9;
}
- (void)updateTrackingAreas {
    [self.trackingAreas enumerateObjectsUsingBlock:^(NSTrackingArea *area,NSUInteger index,BOOL *stop) { [self removeTrackingArea:area]; }];
    if (!self.hideHandleRect) {
        [_handleTrackRectArray setArray:[self _calculateAllNeededHandleTrackRects:self.frame]];
        _contentTrackRect=NSMakeRect(1,1,self.frame.size.width-2,self.frame.size.height-2);
        for (NSUInteger i=0;i<_handleTrackRectArray.count;i++) {
            NSTrackingArea *area=[[NSTrackingArea alloc] initWithRect:[_handleTrackRectArray[i] CGRectValue] options:0x41 owner:self userInfo:@{@"number":@((int)i)}];
            [self addTrackingArea:area];
        }
    }
}
- (void)mouseEntered:(NSEvent *)event {
    _whichInResizeRect=-1;
    if(_beDragging || IShotCameraDragging_1001ddca8 || IShotGlobal_1001de210) return;
    _isCanMove=NO;
    if(self.hideHandleRect || _beDragging || !IShotGlobal_1001ddd58) return;
    NSInteger n=[((__bridge NSDictionary *)event.userData)[@"number"] integerValue];
    if(IShotGlobal_1001ddd58 && !IShotGlobal_1001ddde0 && n==100) IShotGlobal_1001ddce8=YES;
    else if(n==0) { IShotGlobal_1001f18a8=YES; if(!_isInResizeRect) [NSCursor.openHandCursor set]; return; }
    if(!self.onlyClipCurrentWindow) {
        NSCursor *cursor=nil; NSString *mode=nil;
        if((n&~4L)==3) { mode=@"Resize_135"; cursor=IShotGlobal_1001ddf88; }
        else if((n&~4L)==2) { mode=@"Resize_90"; cursor=NSCursor.resizeUpDownCursor; }
        else if((n&~4L)==1) { mode=@"Resize_45"; cursor=IShotGlobal_1001ddf90; }
        else if(n==8 || n==4) { mode=@"Resize_0"; cursor=NSCursor.resizeLeftRightCursor; }
        if(mode) {
            _numberOfReSize=(int)n; _isInResizeRect=YES; _whichInResizeRect=(int)n;
            IShotGlobal_1001dde70=mode; IShotGlobal_1001dddf8=cursor; [cursor set]; return;
        }
        if(n<9) return;
        _isCanMove=YES; IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor; [NSCursor.openHandCursor set];
    }
    if(n==100) { IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; }
}
- (void)mouseExited:(NSEvent *)event {
    _whichInResizeRect=-1;
    if(_beDragging || IShotGlobal_1001de210) return;
    _isCanMove=NO;
    NSInteger n=[((__bridge NSDictionary *)event.userData)[@"number"] integerValue];
    if(IShotGlobal_1001ddd58 && !IShotGlobal_1001ddde0 && n==100) IShotGlobal_1001ddce8=NO;
    IShotGlobal_1001f18a8=NSPointInRect(event.locationInWindow,CGRectInset(self.frame,5,5));
    if(!self.hideHandleRect || IShotGlobal_1001f18a8) {
        if(n>0) {
            _isInResizeRect=NO;
            if(!_beDragging) {
                if(IShotGlobal_1001f18a8) {
                    IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor; [NSCursor.openHandCursor set];
                } else { IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; }
            }
            if(n==100) [NSCursor.openHandCursor set];
            return;
        }
        if(_beDragging || _isInResizeRect || IShotGlobal_1001f18a8) return;
    }
    IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set];
}
- (void)mouseMoved:(NSEvent *)event {
    IShotGlobal_1001f18ac=[self _calculateMouseIsOnCropBorderViewWithPoint:event.locationInWindow];
    if(IShotGlobal_1001f18ac!=IShotGlobal_1001f18b0) {
        IShotGlobal_1001f18b0=IShotGlobal_1001f18ac;
        int n=IShotGlobal_1001f18ac; NSCursor *cursor=nil; NSString *mode=nil;
        if((n&~4)==1) { mode=@"Resize_45"; cursor=IShotGlobal_1001ddf90; }
        if((n&~4)==2) { mode=@"Resize_0"; cursor=NSCursor.resizeUpDownCursor; }
        if((n&~4)==3) { mode=@"Resize_135"; cursor=IShotGlobal_1001ddf88; }
        if(n==8 || n==4) { mode=@"Resize_0"; cursor=NSCursor.resizeLeftRightCursor; }
        if(mode) {
            _numberOfReSize=n; _isInResizeRect=YES; _whichInResizeRect=n;
            IShotGlobal_1001dde70=mode; IShotGlobal_1001dddf8=cursor; [cursor set];
        }
        if(n==9) { IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; return; }
    }
    if(IShotGlobal_1001f18ac==0) {
        IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor; [NSCursor.openHandCursor set];
    }
}
@end
