#import "GKCropBorderView.h"
#import <QuartzCore/QuartzCore.h>
#import "../Global/Global.h"
@interface NSView (IShotToImageDeclaration)
- (NSImage *)toImage;
@end
extern CGPoint IShotFunction_10004cdb8(CGPoint,CGPoint,CGPoint,CGPoint,double);
extern BOOL IShotFunction_10004ce78(CGPoint,CGPoint,CGPoint,CGPoint);
extern NSCursor *IShotGlobal_1001ddf98;
extern uint64_t IShotGlobal_1001de070;
#import "../Camera/NSValue+CGPoint.h"
extern BOOL IShotGlobal_1001ddfd0;
extern NSCursor *IShotGlobal_1001dddf8;
extern BOOL IShotGlobal_1001de098, IShotGlobal_1001de0c0, IShotGlobal_1001de180, IShotGlobal_1001de0d0, IShotGlobal_1001de0d5;
extern NSMutableDictionary *IShotGlobal_1001de058, *IShotGlobal_1001de0c8;
extern NSMutableArray *IShotGlobal_1001de050, *IShotGlobal_1001de138;
extern int IShotGlobal_1001de048;
extern BOOL IShotGlobal_1001de088, IShotGlobal_1001de210, IShotGlobal_1001de0c3, IShotGlobal_1001dde91, IShotGlobal_1001ddfd1;
extern NSString *IShotGlobal_1001de090, *IShotGlobal_1001dde70, *IShotGlobal_1001ddde8, *IShotGlobal_1001dde78;
extern NSCursor *IShotGlobal_1001ddf88, *IShotGlobal_1001ddf90, *IShotGlobal_1001de0e0;
extern NSWindow *IShotGlobal_1001de0b8;
extern int IShotGlobal_1001dd0d0, IShotGlobal_1001dd0d4;
static BOOL IShotGlobal_1001f19c8;
#pragma clang fp contract(off)
@implementation GKCropBorderView
@synthesize borderColor=_borderColor,hideHandleRect=_hideHandleRect;
- (instancetype)initWithFrame:(NSRect)frame {
    self=[super initWithFrame:frame]; IShotGlobal_1001ddfd0=NO;
    if (self) {
        self.wantsLayer=YES; self.layer.backgroundColor=NSColor.clearColor.CGColor;
        self.borderColor=[NSColor colorWithDeviceRed:0 green:130.0/255.0 blue:213.0/255.0 alpha:.85];
        _handleTrackRectArray=[NSMutableArray array]; [self updateTrackingAreas];
    }
    return self;
}
- (void)dealloc { IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; }
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
- (CGPoint)getPointFrom:(CGPoint)point to:(CGRect)rect {
    double x=point.x,y=point.y;
    if (rect.origin.x<=x) { double end=rect.origin.x+rect.size.width; if (!(x<end)) x=end; }
    else x=rect.origin.x;
    double top=rect.origin.y+rect.size.height;
    if (y<=top) { top=y; if (y<=rect.origin.y) top=rect.origin.y; }
    return CGPointMake(x,top);
}
- (double)distanceBetweenPoint:(CGPoint)a and:(CGPoint)b { double x=b.x-a.x,y=b.y-a.y; return sqrt(x*x+y*y); }
- (double)angleBetweenPoint:(CGPoint)a and:(CGPoint)b { return atan2(a.y-b.y,a.x-b.x); }
- (BOOL)isLineIntersectingCircleWithPoint1:(CGPoint)p1 point2:(CGPoint)p2 center:(CGPoint)center radius:(double)radius {
    double dx=p2.x-p1.x,dy=p2.y-p1.y,a=dx*dx+dy*dy;
    if (!(a>1e-7)) return NO;
    double cx=p1.x-center.x,cy=p1.y-center.y,b=dx*cx+dy*cy; b=b+b;
    double determinant=b*b+(a*-4.0)*((cx*cx+cy*cy)-radius*radius);
    if (!(determinant>=0)) return NO;
    double root=sqrt(determinant),t=(root-b)/(a+a);
    if (t>=0 && t<=1) return YES;
    t=(-b-root)/(a+a); return t>=0 && t<=1;
}
- (BOOL)containsPoint:(CGPoint)point withPath:(CGPathRef)path {
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    CGContextSaveGState(context); CGContextAddPath(context,path);
    BOOL result=CGContextPathContainsPoint(context,point,kCGPathFill);
    CGContextRestoreGState(context); return result;
}
- (BOOL)point:(CGPoint)a andPoint:(CGPoint)b crossWithCyclePoint:(CGPoint)c radius:(float)radius {
    double left=c.x-radius,right=c.x+radius,top=c.y+radius,bottom=c.y-radius;
    double dx=b.x-a.x,dy=b.y-a.y;
    double x=a.x+dx*(top-a.y)/dy;
    double minY=b.y<=a.y?b.y:a.y,maxY=b.y<=a.y?a.y:b.y;
    if (left<=x && x<=right && minY<=top && top<=maxY) return YES;
    x=a.x+dx*(bottom-a.y)/dy;
    if (left<=x && x<=right && minY<=bottom && bottom<=maxY) return YES;
    double y=a.y+dy*(left-a.x)/dx;
    double minX=b.x<=a.x?b.x:a.x,maxX=b.x<=a.x?a.x:b.x;
    if (bottom<=y && y<=top && minX<=left && left<=maxX) return YES;
    y=a.y+dy*(right-a.x)/dx;
    return bottom<=y && y<=top && minX<=right && right<=maxX;
}
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
- (void)updateTrackingAreas {
    if (IShotGlobal_1001de098) return;
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
- (void)drawRect:(NSRect)rect {
    if (IShotGlobal_1001de0c0) return;
    id alphaValue=IShotGlobal_1001de0c8[@"highlight"][@"colorAlpha"];
    double alpha=alphaValue?(double)[alphaValue floatValue]:.5;
    BOOL current=IShotGlobal_1001de058 && [IShotGlobal_1001de058[@"type"] intValue]==8;
    BOOL found=current;
    if (!current && IShotGlobal_1001de048<(int)IShotGlobal_1001de050.count) {
        for (NSInteger i=(NSInteger)IShotGlobal_1001de050.count-IShotGlobal_1001de048-1;i>=0;i--)
            if ([IShotGlobal_1001de050[i][@"type"] intValue]==8) { found=YES; break; }
    }
    if (found) {
        [[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:alpha] set];
        if (!IShotGlobal_1001de138.count) {
            if (IShotGlobal_1001de180) NSRectFill(self.bounds);
            else if (IShotGlobal_1001de0d0 && !IShotGlobal_1001de0d5)
                [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.bounds,6,6) xRadius:self.borderRadius yRadius:self.borderRadius] fill];
            else NSRectFill(NSInsetRect(self.bounds,6,6));
        } else if (IShotGlobal_1001de138.count==1) {
            NSRect r=[IShotGlobal_1001de138[0][@"rect"] rectValue]; r.origin.x-=self.frame.origin.x; r.origin.y-=self.frame.origin.y;
            double radius=5; if (@available(macOS 11.0,*)) radius=10;
            NSBezierPath *path=[NSBezierPath bezierPathWithRoundedRect:r xRadius:radius yRadius:radius];
            [[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:alpha] set]; [path fill];
        } else {
            for (NSDictionary *window in IShotGlobal_1001de138) {
                NSRect r=[window[@"rect"] rectValue]; r.origin.x-=self.frame.origin.x; r.origin.y-=self.frame.origin.y;
                [NSColor.clearColor set]; NSRectFill(r);
                [[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:alpha] set]; NSRectFill(r);
            }
        }
        [NSGraphicsContext saveGraphicsState]; if (current) [self drawCurrentHighlightStroke];
        [self drawAllHighlight]; [NSGraphicsContext restoreGraphicsState];
    }
    [self drawAllBackgroundOfText];
}
- (BOOL)mouseOnLinOfNote:(CGPoint)point {
    NSMutableArray *seen=[NSMutableArray new];
    if (IShotGlobal_1001de048 >= (int)IShotGlobal_1001de050.count) return NO;
    for (NSInteger i=(NSInteger)IShotGlobal_1001de050.count-IShotGlobal_1001de048-1;i>=0;i--) {
        NSDictionary *stroke=IShotGlobal_1001de050[i];
        NSString *key=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
        if ([seen containsObject:key]) continue;
        [seen addObject:key];
        if ([stroke[@"type"] integerValue]!=7) continue;
        NSScrollView *view=stroke[@"scrollView"];
        int size=[stroke[@"size"] intValue]; double delta=size/15+2;
        NSRect frame=NSMakeRect(view.frame.origin.x-delta,view.frame.origin.y-3,
                               view.frame.size.width+3-delta,view.frame.size.height+8);
        NSPoint cycle=[stroke[@"cyclePoint"] pointValue];
        NSPoint end=[self getPointFrom:cycle to:frame];
        BOOL crosses=[self point:cycle andPoint:end crossWithCyclePoint:point radius:5.f];
        double distance=[self distanceBetweenPoint:point and:cycle];
        if (crosses && !NSPointInRect(point,NSInsetRect(frame,-5,-5)) && size*.75+5 < (double)(float)distance) return YES;
    }
    return NO;
}
- (void)mouseEntered:(NSEvent *)event {
    if (IShotGlobal_1001de180 && [IShotGlobal_1001de090 isEqualToString:@"zoom"]) {
        IShotGlobal_1001dd0d0=[self _calculateMouseIsOnCropBorderViewWithPoint:event.locationInWindow];
        if (IShotGlobal_1001dd0d0) [IShotGlobal_1001de0b8 orderOut:self];
        else [IShotGlobal_1001de0b8 makeKeyAndOrderFront:self];
        return;
    }
    _whichInResizeRect=-1;
    if (_beDragging || IShotGlobal_1001de0c0 || IShotGlobal_1001de210) return;
    if ([IShotGlobal_1001de090 isEqualToString:@"zoom"] && IShotGlobal_1001de180) {
        IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; return;
    }
    _isCanMove=NO;
    if (!_hideHandleRect && !_beDragging && IShotGlobal_1001de088) {
        NSInteger number=[((__bridge NSDictionary *)event.userData)[@"number"] integerValue];
        if (number==0) {
            IShotGlobal_1001f19c8=YES;
            if (!_isInResizeRect && [IShotGlobal_1001de090 isEqualToString:@""]) {
                if (!_onlyClipCurrentWindow) {
                    IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor;
                    _isCanMove=YES; [NSCursor.openHandCursor set];
                } else { IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; }
            }
        } else if (!_onlyClipCurrentWindow) {
            NSCursor *cursor=nil; NSString *mode=nil;
            if ((number & ~4L)==3) { mode=@"Resize_135"; cursor=IShotGlobal_1001ddf88; }
            else if ((number & ~4L)==2) { mode=@"Resize_90"; cursor=NSCursor.resizeUpDownCursor; }
            else if ((number & ~4L)==1) { mode=@"Resize_45"; cursor=IShotGlobal_1001ddf90; }
            else if (number==8 || number==4) { mode=@"Resize_0"; cursor=NSCursor.resizeLeftRightCursor; }
            if (mode) {
                _numberOfReSize=(int)number; _whichInResizeRect=(int)number; _isInResizeRect=YES;
                IShotGlobal_1001dde70=mode; IShotGlobal_1001dddf8=cursor; [cursor set];
            } else if (number>=9) {
                _isCanMove=YES; IShotGlobal_1001dde70=@"WholeMove";
                IShotGlobal_1001dddf8=NSCursor.openHandCursor; [NSCursor.openHandCursor set];
            }
        }
    }
    if (_hideHandleRect && IShotGlobal_1001de088) {
        IShotGlobal_1001f19c8=YES; [IShotGlobal_1001de0e0 set];
        IShotGlobal_1001dde70=@"cursorCreateNew"; IShotGlobal_1001dddf8=IShotGlobal_1001de0e0;
    }
}
- (void)mouseExited:(NSEvent *)event {
    _whichInResizeRect=-1;
    if (_beDragging || !IShotGlobal_1001de088 || IShotGlobal_1001de0c0 || IShotGlobal_1001de210) return;
    if ([IShotGlobal_1001de090 isEqualToString:@"zoom"] && IShotGlobal_1001de180) {
        IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; return;
    }
    _isCanMove=NO; IShotGlobal_1001ddfd0=NO;
    NSInteger number=[((__bridge NSDictionary *)event.userData)[@"number"] integerValue];
    NSPoint point=event.locationInWindow;
    IShotGlobal_1001f19c8=NSPointInRect(point,CGRectInset(self.frame,5,5));
    if (!_hideHandleRect || IShotGlobal_1001f19c8) {
        if (number>=1) {
            _isInResizeRect=NO; if (_beDragging) return;
            if (IShotGlobal_1001f19c8) {
                if ([IShotGlobal_1001de090 isEqualToString:@""]) {
                    if (_onlyClipCurrentWindow) return;
                    IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor;
                    [NSCursor.openHandCursor set]; return;
                }
                if (IShotGlobal_1001de0e0) {
                    IShotGlobal_1001dde70=@"cursorCreateNew"; IShotGlobal_1001dddf8=IShotGlobal_1001de0e0;
                    [IShotGlobal_1001de0e0 set];
                }
                return;
            }
        } else {
            if (_beDragging || _isInResizeRect) return;
            if (IShotGlobal_1001f19c8) {
                if ([IShotGlobal_1001dde70 hasPrefix:@"Resize"]) return;
                NSDictionary *stroke=[self isOnStrokesUnderMouse:point];
                if (stroke) {
                    IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor;
                    [NSCursor.openHandCursor set];
                    IShotGlobal_1001ddfd0=[stroke[@"type"] intValue]==[IShotGlobal_1001de058[@"type"] intValue] &&
                        [stroke[@"list"] intValue]==[IShotGlobal_1001de058[@"list"] intValue]; return;
                }
                if ([self mouseOnLinOfNote:point]) return;
            }
        }
    }
    IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set];
}
- (void)mouseMoved:(NSEvent *)event {
    if (IShotGlobal_1001de180 && [IShotGlobal_1001de090 isEqualToString:@"zoom"]) {
        IShotGlobal_1001dd0d0=[self _calculateMouseIsOnCropBorderViewWithPoint:event.locationInWindow];
        if (IShotGlobal_1001dd0d0!=IShotGlobal_1001dd0d4) {
            if (IShotGlobal_1001dd0d0==0) [IShotGlobal_1001de0b8 makeKeyAndOrderFront:self];
            else [IShotGlobal_1001de0b8 orderOut:self];
        }
        IShotGlobal_1001dd0d4=IShotGlobal_1001dd0d0; return;
    }
    if (IShotGlobal_1001de0c3 || IShotGlobal_1001dde91) return;
    NSPoint point=event.locationInWindow;
    IShotGlobal_1001dd0d0=[self _calculateMouseIsOnCropBorderViewWithPoint:point];
    if (IShotGlobal_1001dd0d0!=IShotGlobal_1001dd0d4) {
        IShotGlobal_1001dd0d4=IShotGlobal_1001dd0d0;
        int number=IShotGlobal_1001dd0d0;
        NSString *mode=nil; NSCursor *cursor=nil;
        if ((number & ~4)==1) { mode=@"Resize_45"; cursor=IShotGlobal_1001ddf90; }
        if ((number & ~4)==2) { mode=@"Resize_0"; cursor=NSCursor.resizeUpDownCursor; }
        if ((number & ~4)==3) { mode=@"Resize_135"; cursor=IShotGlobal_1001ddf88; }
        if (number==8 || number==4) { mode=@"Resize_0"; cursor=NSCursor.resizeLeftRightCursor; }
        if (mode) {
            _numberOfReSize=number; _isInResizeRect=YES; _whichInResizeRect=number;
            IShotGlobal_1001dde70=mode; IShotGlobal_1001dddf8=cursor; [cursor set];
        }
        if (number==9) { IShotGlobal_1001dddf8=nil; [NSCursor.arrowCursor set]; return; }
    }
    if (IShotGlobal_1001dd0d0!=0) return;
    if ([IShotGlobal_1001de090 isEqualToString:@""] && !IShotGlobal_1001de180) {
        IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor;
        [NSCursor.openHandCursor set]; return;
    }
    if (IShotGlobal_1001de058[@"type"]) {
        if ([self _calculateMouseIsOnActivedResizeRectWithPoint:point]) { IShotGlobal_1001ddfd1=YES; return; }
        IShotGlobal_1001ddfd1=NO;
    }
    _isInResizeRect=NO; IShotGlobal_1001ddde8=@""; IShotGlobal_1001dde78=@"";
    NSDictionary *stroke=[self isOnStrokesUnderMouse:point];
    if (stroke) {
        int type=[stroke[@"type"] intValue];
        if (type==6 || type==7) {
            if (type==6) IShotGlobal_1001ddde8=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
            return;
        }
        IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor; [NSCursor.openHandCursor set];
        IShotGlobal_1001ddfd0=type==[IShotGlobal_1001de058[@"type"] intValue] &&
            [stroke[@"list"] intValue]==[IShotGlobal_1001de058[@"list"] intValue];
        if (type==5) IShotGlobal_1001dde78=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
        return;
    }
    if ([self mouseOnLinOfNote:point] || !IShotGlobal_1001de0e0) return;
    IShotGlobal_1001dde70=@"cursorCreateNew"; IShotGlobal_1001dddf8=IShotGlobal_1001de0e0; [IShotGlobal_1001de0e0 set];
}
- (NSArray *)_calculateAllNeededHandleSquareRects:(CGRect)r {
    double x=r.origin.x,y=r.origin.y; float w=(float)r.size.width,h=(float)r.size.height;
    float halfW=w*.5f,halfH=h*.5f;
    double left=x-5,bottom=y-5,right=x+(double)w-5,top=y+(double)h-5,mx=x+(double)halfW,my=y+(double)halfH;
    CGRect rects[]={CGRectMake(x+5+1,y+5+1,0,0),CGRectMake(left,bottom,10,10),CGRectMake(mx-5,bottom,10,10),
        CGRectMake(right,bottom,10,10),CGRectMake(right,my-5,10,10),CGRectMake(right,top,10,10),
        CGRectMake(mx-5,top,10,10),CGRectMake(left,top,10,10),CGRectMake(left,my-5,10,10)};
    NSMutableArray *result=[NSMutableArray new];
    for(int i=0;i<9;i++) [result addObject:[NSValue valueWithCGRect:rects[i]]];
    int type=[IShotGlobal_1001de058[@"type"] intValue];
    if(type==8 || type==5) {
        double iw=(halfW-10.f)-2.f,ih=(halfH-10.f)-2.f;
        CGRect extra[]={CGRectMake(x+5+1,bottom,iw,10),CGRectMake(mx+5+1,bottom,iw,10),
            CGRectMake(right,y+5+1,10,ih),CGRectMake(right,my+5+1,10,ih),CGRectMake(right,my+5+1,10,ih),
            CGRectMake(x+5+1,top,iw,10),CGRectMake(mx+5+1,top,iw,10),
            CGRectMake(left,y+5+1,10,ih),CGRectMake(left,my+5+1,10,ih)};
        for(int i=0;i<9;i++) [result addObject:[NSValue valueWithCGRect:extra[i]]];
    }
    return result;
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
- (void)drawCurrentHighlightStroke {
    NSRect source=[IShotGlobal_1001de058[@"Rect"] rectValue];
    CGContextRef context=NSGraphicsContext.currentContext.CGContext;
    float w=(float)fabs(source.size.width),h=(float)fabs(source.size.height);
    float x=(float)(source.origin.x+source.size.width*.5-(double)(w*.5f)-self.frame.origin.x);
    float y=(float)(source.origin.y+source.size.height*.5-(double)(h*.5f)-self.frame.origin.y);
    NSRect r=NSMakeRect(x,y,w,h);
    if(w!=0 && context) {
        NSArray *handles=[self _calculateAllNeededHandleSquareRects:r];
        for(int i=1;i<9;i++) {
            CGRect rect=[handles[i] CGRectValue]; CGContextSetRGBFillColor(context,0,0,0,1);
            CGContextFillEllipseInRect(context,rect); CGContextSetRGBFillColor(context,1,1,1,1);
            CGContextFillEllipseInRect(context,CGRectInset(rect,1,1));
        }
    }
    NSBezierPath *path=[IShotGlobal_1001de058[@"squareOfHighlight"] boolValue]?
        [NSBezierPath bezierPathWithRoundedRect:r xRadius:5 yRadius:5]:[NSBezierPath bezierPathWithOvalInRect:r];
    [path setClip]; [path closePath]; [NSColor.clearColor set]; NSRectFill(r);
    if(w!=0 && context) {
        NSArray *handles=[self _calculateAllNeededHandleSquareRects:r];
        for(int i=1;i<9;i++) {
            CGRect rect=[handles[i] CGRectValue]; CGContextSetRGBFillColor(context,0,0,0,1);
            CGContextFillEllipseInRect(context,rect); CGContextSetRGBFillColor(context,1,1,1,1);
            CGContextFillEllipseInRect(context,CGRectInset(rect,1,1));
        }
    }
}
- (void)drawAllHighlight {
    NSMutableArray *seen=[NSMutableArray new];
    [seen addObject:[NSString stringWithFormat:@"%@%@",IShotGlobal_1001de058[@"type"],IShotGlobal_1001de058[@"list"]]];
    if(IShotGlobal_1001de048 >= (int)IShotGlobal_1001de050.count) return;
    for(NSInteger i=(NSInteger)IShotGlobal_1001de050.count-IShotGlobal_1001de048-1;i>=0;i--) {
        NSDictionary *stroke=IShotGlobal_1001de050[i];
        NSString *key=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
        if([seen containsObject:key]) continue; [seen addObject:key];
        if([stroke[@"type"] integerValue]!=8) continue;
        float x1=[stroke[@"X1"] floatValue],y1=[stroke[@"Y1"] floatValue];
        float x2=[stroke[@"X2"] floatValue],y2=[stroke[@"Y2"] floatValue];
        NSRect r=NSMakeRect((double)x1-self.frame.origin.x,(double)y1-self.frame.origin.y,x2-x1,y2-y1);
        NSBezierPath *path=[stroke[@"squareOfHighlight"] boolValue]?
            [NSBezierPath bezierPathWithRoundedRect:r xRadius:5 yRadius:5]:[NSBezierPath bezierPathWithOvalInRect:r];
        [path setClip]; [NSColor.clearColor set]; NSRectFill(r); [path closePath];
    }
}
- (void)drawAllBackgroundOfText {
    NSMutableArray *seen=[NSMutableArray new];
    [seen addObject:[NSString stringWithFormat:@"%@%@",IShotGlobal_1001de058[@"type"],IShotGlobal_1001de058[@"list"]]];
    if(IShotGlobal_1001de048 >= (int)IShotGlobal_1001de050.count) return;
    for(NSInteger i=(NSInteger)IShotGlobal_1001de050.count-IShotGlobal_1001de048-1;i>=0;i--) {
        NSDictionary *stroke=IShotGlobal_1001de050[i];
        NSString *key=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
        if([seen containsObject:key]) continue; [seen addObject:key];
        NSInteger type=[stroke[@"type"] integerValue];
        NSInteger style=[stroke[type==6?@"typeIndexOfText":@"typeIndexOfNote"] integerValue];
        NSView *view=stroke[@"scrollView"];
        if(style==0) {
            NSRect r=view.frame; r.origin.x-=self.frame.origin.x; r.origin.y-=self.frame.origin.y;
            [[view toImage] drawInRect:r fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1]; continue;
        }
        NSTextView *text=stroke[@"textView"]; NSColor *textColor=text.textColor;
        if((float)textColor.alphaComponent<1.f) text.textColor=[textColor colorWithAlphaComponent:1];
        NSRect r=view.frame; r.origin.x-=self.frame.origin.x; r.origin.y-=self.frame.origin.y;
        NSInteger index=[stroke[type==6?@"colorIndexOfText":@"colorIndexOfNote"] integerValue];
        NSColor *color;
        switch(index) {
            case 0: color=[NSColor colorWithRed:0x1.6161616161616p-5 green:0x1.4141414141414p-1 blue:0x1.9d9d9d9d9d9dap-1 alpha:1]; break;
            case 1: color=[NSColor colorWithRed:0x1.fbfbfbfbfbfc0p-1 green:0x1.4d4d4d4d4d4d5p-2 blue:0x1.1515151515151p-1 alpha:1]; break;
            case 2: color=[NSColor colorWithRed:0x1.9393939393939p-1 green:0x1.3535353535353p-2 blue:0x1.8989898989899p-1 alpha:1]; break;
            case 3: color=[NSColor colorWithRed:0x1.fdfdfdfdfdfe0p-1 green:0x1.6969696969697p-3 blue:0x1.e1e1e1e1e1e1ep-3 alpha:1]; break;
            case 4: color=[NSColor colorWithRed:0x1.0909090909091p-3 green:0x1.9595959595959p-1 blue:0x1.9595959595959p-2 alpha:1]; break;
            case 5: color=[NSColor colorWithRed:0x1.fdfdfdfdfdfe0p-1 green:0x1.9191919191919p-1 blue:0x1.5151515151515p-2 alpha:1]; break;
            case 6: color=NSColor.grayColor; break;
            case 7: color=NSColor.blackColor; break;
            default: color=NSColor.whiteColor; break;
        }
        [NSGraphicsContext saveGraphicsState]; NSImage *image=[view toImage];
        if(style==1) {
            NSRect real=[Global calcuateRealRectFromNSImage:image withOriginalRect:r];
            NSBezierPath *path=[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(real,-2,-2) xRadius:4 yRadius:4];
            [color setFill]; [path fill];
            [image drawInRect:r fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1];
        } else {
            CGContextRef context=NSGraphicsContext.currentContext.CGContext;
            CGSize offsets[]={CGSizeMake(0x1.0ccccccccccccp+1,0),CGSizeMake(-0x1.0ccccccccccccp+1,0),CGSizeMake(0,-0x1.0ccccccccccccp+1),CGSizeMake(0,0x1.0ccccccccccccp+1),
                CGSizeMake(1.5,1.5),CGSizeMake(1.5,-1.5),CGSizeMake(-1.5,1.5),CGSizeMake(-1.5,-1.5)};
            for(int j=0;j<8;j++) {
                CGContextSetShadowWithColor(context,offsets[j],0,color.CGColor);
                [image drawInRect:r fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1];
            }
        }
        [NSGraphicsContext restoreGraphicsState];
    }
}
- (BOOL)_calculateMouseIsOnActivedResizeRectWithPoint:(CGPoint)p {
    uint32_t type=[IShotGlobal_1001de058[@"type"] intValue];
    if (!(type<9 && ((1U<<type)&0x123U)) && (type&~1U)!=2) return NO;
    float x1=[IShotGlobal_1001de058[@"X1"] floatValue],y1=[IShotGlobal_1001de058[@"Y1"] floatValue];
    float x2=[IShotGlobal_1001de058[@"X2"] floatValue],y2=[IShotGlobal_1001de058[@"Y2"] floatValue];
    if(type<9 && ((1U<<type)&0x123U)) {
        float w=x2-x1,h=y2-y1;
        double left=(double)x1-5,bottom=(double)y1-5,right=(double)x1+(double)w-5,top=(double)y1+(double)h-5;
        double mx=(double)x1+(double)(w*.5f)-5,my=(double)y1+(double)(h*.5f)-5;
        CGRect handles[]={CGRectMake(left,bottom,10,10),CGRectMake(mx,bottom,10,10),CGRectMake(right,bottom,10,10),
            CGRectMake(right,my,10,10),CGRectMake(right,top,10,10),CGRectMake(mx,top,10,10),
            CGRectMake(left,top,10,10),CGRectMake(left,my,10,10)};
        for(int i=0;i<8;i++) if(NSPointInRect(p,handles[i])) {
            if(i==0 || i==4) { IShotGlobal_1001dde70=@"Resize_45"; IShotGlobal_1001dddf8=IShotGlobal_1001ddf90; }
            else if(i==2 || i==6) { IShotGlobal_1001dde70=@"Resize_135"; IShotGlobal_1001dddf8=IShotGlobal_1001ddf88; }
            else if(i==1 || i==5) { IShotGlobal_1001dde70=@"Resize_0"; IShotGlobal_1001dddf8=NSCursor.resizeUpDownCursor; }
            else { IShotGlobal_1001dde70=@"Resize_90"; IShotGlobal_1001dddf8=NSCursor.resizeLeftRightCursor; }
            [IShotGlobal_1001dddf8 set]; IShotGlobal_1001de070=i+1; return YES;
        }
        return NO;
    }
    int hit=0;
    if(NSPointInRect(p,NSMakeRect(x1-5.f,y1-5.f,10,10))) hit=1;
    else if(NSPointInRect(p,NSMakeRect(x2-5.f,y2-5.f,10,10))) hit=2;
    else if([IShotGlobal_1001de058[@"normalTypeOfArrow"] isEqualToString:@"1"] && type==3) {
        NSPoint a=NSPointFromString(IShotGlobal_1001de058[@"controlPoint1"]);
        NSPoint b=NSPointFromString(IShotGlobal_1001de058[@"controlPoint2"]);
        if(NSPointInRect(p,NSMakeRect(a.x-5,a.y-5,10,10))) hit=3;
        else if(NSPointInRect(p,NSMakeRect(b.x-5,b.y-5,10,10))) hit=4;
    }
    if(!hit) return NO;
    IShotGlobal_1001dde70=@"Resize"; IShotGlobal_1001dddf8=IShotGlobal_1001ddf98;
    [IShotGlobal_1001ddf98 set]; IShotGlobal_1001de070=hit; return YES;
}
- (NSDictionary *)isOnStrokesUnderMouse:(CGPoint)p {
    NSMutableArray *seen=[NSMutableArray new];
    if(IShotGlobal_1001de048 >= (int)IShotGlobal_1001de050.count) return nil;
    for(NSInteger i=(NSInteger)IShotGlobal_1001de050.count-IShotGlobal_1001de048-1;i>=0;i--) {
        NSDictionary *stroke=IShotGlobal_1001de050[i];
        NSString *key=[NSString stringWithFormat:@"%@%@",stroke[@"type"],stroke[@"list"]];
        if([seen containsObject:key]) continue; [seen addObject:key];
        NSInteger type=[stroke[@"type"] integerValue];
        float x1=[stroke[@"X1"] floatValue],y1=[stroke[@"Y1"] floatValue];
        float x2=[stroke[@"X2"] floatValue],y2=[stroke[@"Y2"] floatValue];
        int size=[stroke[@"size"] intValue],margin=size>4?size:4;
        CGPoint a=CGPointMake(x1,y1),b=CGPointMake(x2,y2);
        switch(type) {
            case 0: case 5: case 8: {
                CGRect r=CGRectMake(x1,y1,x2-x1,y2-y1);
                if(!NSPointInRect(p,CGRectInset(r,margin,margin)) && NSPointInRect(p,CGRectInset(r,-margin,-margin))) return stroke;
                break;
            }
            case 1: {
                float dx=(float)(p.x-(double)((x1+x2)*.5f)),dy=(float)(p.y-(double)((y1+y2)*.5f));
                float rx=fabsf(x2-x1)*.5f,ry=fabsf(y2-y1)*.5f;
                dx*=dx; dy*=dy;
                float ox=rx+(float)margin,oy=ry+(float)margin,ix=rx-(float)margin,iy=ry-(float)margin;
                float outer=dx/(ox*ox)+dy/(oy*oy),inner=dx/(ix*ix)+dy/(iy*iy);
                if(outer<1.f && inner>1.f) return stroke;
                break;
            }
            case 2:
                if([self point:a andPoint:b crossWithCyclePoint:p radius:(float)((size/2>4?size/2:4)+1)]) return stroke;
                break;
            case 3: {
                if([stroke[@"normalTypeOfArrow"] isEqualToString:@"1"]) {
                    CGPoint c1=NSPointFromString(stroke[@"controlPoint1"]),c2=NSPointFromString(stroke[@"controlPoint2"]);
                    uint32_t width=size>3?(uint32_t)size:3;
                    NSBezierPath *path=NSBezierPath.bezierPath; [path moveToPoint:a]; [path curveToPoint:b controlPoint1:c1 controlPoint2:c2];
                    CGPoint previous=a;
                    for(int j=0;j<100;j++) {
                        CGPoint q=IShotFunction_10004cdb8(a,c1,c2,b,(double)j/100.0);
                        float radius=j?(float)((double)(int32_t)width*.5):(float)(width>>1);
                        if([self point:previous andPoint:q crossWithCyclePoint:p radius:radius]) return stroke;
                        previous=q;
                    }
                    double dx=b.x-c2.x,dy=b.y-c2.y,width3=(int32_t)(width+3);
                    double length=hypot(dx,dy),nx=(dx/length)*width3,ny=(dy/length)*width3;
                    double norm=sqrt(dy*dy+dx*dx),px=(-dy/norm)*width3,py=(dx/norm)*width3;
                    if(IShotFunction_10004ce78(p,CGPointMake(px+b.x,py+b.y),CGPointMake(b.x-px,b.y-py),CGPointMake(nx+nx+b.x,ny+ny+b.y))) return stroke;
                } else if([stroke[@"normalTypeOfArrow"] isEqualToString:@"0"]) {
                    double scale=[self distanceBetweenPoint:a and:b]/30.0,angle=[self angleBetweenPoint:b and:a];
                    double dx=p.x-a.x,dy=p.y-a.y;
                    double along=dx*cos(angle)+dy*sin(angle),across=fabs(dy*cos(angle)-dx*sin(angle))-1;
                    double thickness=(double)(int32_t)((uint32_t)size*3U+2U)/scale,shoulder=scale*(thickness*-1.1+30);
                    if(along>0 && along<shoulder) {
                        double edge=[self angleBetweenPoint:CGPointMake(scale*(30-thickness),scale*(thickness*.4)) and:CGPointMake(0,scale*.05)];
                        double test=[self angleBetweenPoint:CGPointMake(along,across) and:CGPointMake(0,scale*.05)];
                        if(fabs(edge)>fabs(test)) return stroke;
                    } else if(along<scale*30 && along>0) {
                        double edge=[self angleBetweenPoint:CGPointMake(shoulder,scale*(thickness*.8)) and:CGPointMake(scale*30,0)];
                        double test=[self angleBetweenPoint:CGPointMake(along,across) and:CGPointMake(scale*30,0)];
                        if(fabs(edge)<fabs(test)) return stroke;
                    }
                }
                break;
            }
            case 4: {
                NSArray *points=stroke[@"allPoints"]; float radius=(float)((size/2>4?size/2:4)+1);
                for(NSUInteger j=0;j<points.count-1;j++)
                    if([self point:[points[j] CGPointValue] andPoint:[points[j+1] CGPointValue] crossWithCyclePoint:p radius:radius]) return stroke;
                break;
            }
            case 6: case 7: {
                IShotGlobal_1001ddfd0=NO;
                NSRect r=[stroke[@"scrollView"] frame]; double padding=size/15+2;
                r=NSMakeRect(r.origin.x-padding-3,r.origin.y-3,r.size.width+padding*.9+8,r.size.height+8);
                if(NSPointInRect(p,NSInsetRect(r,-8,-8))) {
                    if(!NSPointInRect(p,NSInsetRect(r,8,8))) {
                        IShotGlobal_1001dde70=@"WholeMove"; IShotGlobal_1001dddf8=NSCursor.openHandCursor;
                        [NSCursor.openHandCursor set];
                    } else {
                        IShotGlobal_1001ddfd0=YES; IShotGlobal_1001dde70=@"AboveText"; IShotGlobal_1001dddf8=nil;
                        [NSCursor.IBeamCursor set];
                    }
                    return stroke;
                }
                if(type==7) {
                    CGPoint center=[stroke[@"cyclePoint"] pointValue];
                    double radius=(float)[((NSTextView *)stroke[@"textView"]).font pointSize]/5.f+11.f;
                    if(NSPointInRect(p,NSMakeRect(center.x-radius*.8-1,center.y-radius*.8-1,radius*1.6+2,radius*1.6+2))) {
                        IShotGlobal_1001ddfd0=YES; IShotGlobal_1001dde70=@"WholeMove";
                        IShotGlobal_1001dddf8=NSCursor.openHandCursor; [NSCursor.openHandCursor set]; return stroke;
                    }
                }
                break;
            }
        }
    }
    return nil;
}
@end
