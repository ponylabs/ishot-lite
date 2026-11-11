#import "ColorPickerImageView.h"
#import <ApplicationServices/ApplicationServices.h>
#import <float.h>
#import "../Common/ColorNamer.h"
#import "../Common/NSColor+Moxtra.h"
@interface NSScreen (IShotColorPickerScreen)
+ (NSScreen *)currentScreenForMouseLocation;
@end
extern CGImageRef IShotCGWindowListCreateImage(CGRect,CGWindowListOption,CGWindowID,CGWindowImageOption) __asm__("_CGWindowListCreateImage");
extern NSSize IShotFunction_1000483f0(NSString *,int);
extern NSString *IShotGlobal_1001ddfc0,*IShotGlobal_1001ddfc8;
BOOL IShotGlobal_1001f1950;
NSString *IShotGlobal_1001f1958;
ColorNamer *IShotGlobal_1001f1960;
NSDictionary *IShotGlobal_1001f1968;
double IShotGlobal_1001f1970,IShotGlobal_1001f1978,IShotGlobal_1001f1980,IShotGlobal_1001f1988;
#pragma clang fp contract(off)
@implementation ColorPickerImageView
- (void)mouseMovedAtPoint:(CGPoint)point {} // 0x1000511d4: RET.
- (void)mouseMoved:(NSEvent *)event { // 0x1000511d8
 IShotGlobal_1001f1950=YES;NSScreen *screen=[NSScreen currentScreenForMouseLocation];CGEventRef cg=CGEventCreate(NULL);CGPoint p=CGEventGetLocation(cg);
 if(cg){CFRelease(cg);double x=p.x-screen.frame.origin.x;double y=(NSScreen.deepestScreen.frame.size.height-p.y)-screen.frame.origin.y;float scale=(float)screen.backingScaleFactor;
  IShotGlobal_1001f1970=(double)((float)(int)(x*(double)scale)-scale*6.f);IShotGlobal_1001f1978=(screen.frame.size.height*(double)scale-(double)(int)(y*(double)scale))-(double)(scale*6.f);IShotGlobal_1001f1980=(double)(scale*12.f);IShotGlobal_1001f1988=IShotGlobal_1001f1980;
  IShotGlobal_1001f1958=[NSString stringWithFormat:@"%.f,%.f",x,screen.frame.size.height-y];self.needsDisplay=YES;
 }
}
- (void)mouseDragged:(NSEvent *)event { // 0x100051370
 IShotGlobal_1001f1950=NO;NSPoint p=event.locationInWindow;NSScreen *screen=[NSScreen currentScreenForMouseLocation];float scale=(float)screen.backingScaleFactor;
 IShotGlobal_1001f1970=(double)((float)(int)(p.x*(double)scale)-scale*6.f);IShotGlobal_1001f1978=(screen.frame.size.height*(double)scale-(double)(int)(p.y*(double)scale))-(double)(scale*6.f);IShotGlobal_1001f1980=(double)(scale*12.f);IShotGlobal_1001f1988=IShotGlobal_1001f1980;
 IShotGlobal_1001f1958=[NSString stringWithFormat:@"%.f,%.f",p.x,screen.frame.size.height-p.y];self.needsDisplay=YES;
}
- (void)drawRect:(NSRect)dirty { // 0x1000514b0: deliberately no super draw.
 CGImageRef cg;
 if(!self.image){CGEventRef event=CGEventCreate(NULL);CGPoint p=CGEventGetLocation(event);if(event)CFRelease(event);cg=IShotCGWindowListCreateImage(CGRectMake(p.x-6,p.y-6,12,12),4,(CGWindowID)self.window.windowNumber,1);}
 else{if(IShotGlobal_1001f1980==0.)return;cg=CGImageCreateWithImageInRect([self.image CGImageForProposedRect:NULL context:nil hints:nil],CGRectMake(IShotGlobal_1001f1970,IShotGlobal_1001f1978,IShotGlobal_1001f1980,IShotGlobal_1001f1988));}
 if(!cg)return;
 NSColor *top=NSColor.whiteColor,*topOutline=NSColor.blackColor,*bottom=NSColor.whiteColor,*bottomOutline=NSColor.blackColor;
 if(IShotGlobal_1001f1950==1){
  NSBitmapImageRep *bitmap=[[NSBitmapImageRep alloc]initWithCGImage:cg];int width=(int)CGImageGetWidth(cg),height=(int)CGImageGetHeight(cg);NSColor *color=[bitmap colorAtX:width/2-1 y:height/2];NSInteger mode=[NSUserDefaults.standardUserDefaults integerForKey:@"colorSpaceOfPickColor"];
  if(mode>0){NSInteger count=color.numberOfComponents;CGFloat components[]={color.redComponent,color.greenComponent,color.blueComponent,1.};color=[NSColor colorWithColorSpace:bitmap.colorSpace components:components count:count];NSColorSpace *space=mode==3?NSColorSpace.genericRGBColorSpace:mode==2?NSColorSpace.sRGBColorSpace:mode==1?NSColorSpace.displayP3ColorSpace:NSColorSpace.adobeRGB1998ColorSpace;color=[color colorUsingColorSpace:space];}
  if(!IShotGlobal_1001f1960)IShotGlobal_1001f1960=[ColorNamer new];IShotGlobal_1001f1968=[IShotGlobal_1001f1960 findNameForColor:color];
  double sum=0;int count=0;for(int y=height-6;y<height;y++){for(int x=0;x<width;x++){NSColor *pixel=[bitmap colorAtX:x y:y];sum+=(double)(((float)pixel.redComponent+(float)pixel.greenComponent)+(float)pixel.blueComponent);}if(width>0)count=(int)((uint32_t)count+(uint32_t)width);}
  if((float)((sum/(double)count)/3.)>.5f){bottom=NSColor.blackColor;bottomOutline=NSColor.whiteColor;}else{bottom=NSColor.whiteColor;bottomOutline=NSColor.blackColor;}
  sum=0;for(int y=0;y<5;y++)for(int x=0;x<width;x++){NSColor *pixel=[bitmap colorAtX:x y:y];sum+=(double)(((float)pixel.redComponent+(float)pixel.greenComponent)+(float)pixel.blueComponent);}
  if((float)((sum/(double)(int)((uint32_t)(width>0?width:0)*5U))/3.)>.5f){top=NSColor.blackColor;topOutline=NSColor.whiteColor;}else{top=NSColor.whiteColor;topOutline=NSColor.blackColor;}
 }
 NSImage *image=[[NSImage alloc]initWithCGImage:cg size:NSMakeSize(120,120)];CGImageRelease(cg);NSGraphicsContext.currentContext.imageInterpolation=1;NSGraphicsContext.currentContext.shouldAntialias=NO;BOOL moving=IShotGlobal_1001f1950;[image drawInRect:NSMakeRect(0,0,120,120)];[[NSColor.grayColor colorWithAlphaComponent:.25]set];
 for(int x=5;x!=120;x+=5){NSBezierPath *p=[NSBezierPath bezierPath];[p moveToPoint:NSMakePoint(x+.5,0)];[p lineToPoint:NSMakePoint(x+.5,120)];[p closePath];[p stroke];}
 for(int y=5;y!=120;y+=5){NSBezierPath *p=[NSBezierPath bezierPath];[p moveToPoint:NSMakePoint(0,y+.5)];[p lineToPoint:NSMakePoint(120,y+.5)];[p closePath];[p stroke];}
 [NSColor.moxtraBrandingColor set];NSBezierPath *border=[NSBezierPath bezierPathWithRect:NSMakeRect(1,1,118,118)];border.lineWidth=2;[border stroke];
 NSBezierPath *cross=[NSBezierPath bezierPath];
 if(moving){NSBezierPath *center=[NSBezierPath bezierPathWithRect:NSMakeRect(54.5,54.5,6.5,6.5)];center.lineWidth=1;[center stroke];[[NSColor.moxtraBrandingColor colorWithAlphaComponent:.5]set];cross.lineWidth=5;
  [cross moveToPoint:NSMakePoint(0,58)];[cross lineToPoint:NSMakePoint(55,58)];[cross moveToPoint:NSMakePoint(60,58)];[cross lineToPoint:NSMakePoint(120,58)];[cross moveToPoint:NSMakePoint(58,0)];[cross lineToPoint:NSMakePoint(58,55)];[cross moveToPoint:NSMakePoint(58,60)];[cross lineToPoint:NSMakePoint(58,100)];
 }else{[[NSColor.moxtraBrandingColor colorWithAlphaComponent:.5]set];cross.lineWidth=10;switch(self.tag){
  case 1:[cross moveToPoint:NSMakePoint(60,120)];[cross lineToPoint:NSMakePoint(60,60)];[cross lineToPoint:NSMakePoint(120,60)];break;
  case 3:[cross moveToPoint:NSMakePoint(0,60)];[cross lineToPoint:NSMakePoint(60,60)];[cross lineToPoint:NSMakePoint(60,120)];break;
  case 5:[cross moveToPoint:NSMakePoint(60,0)];[cross lineToPoint:NSMakePoint(60,60)];[cross lineToPoint:NSMakePoint(0,60)];break;
  case 7:[cross moveToPoint:NSMakePoint(60,0)];[cross lineToPoint:NSMakePoint(60,60)];[cross lineToPoint:NSMakePoint(120,60)];break;
  case 2:case 6:[cross moveToPoint:NSMakePoint(0,60)];[cross lineToPoint:NSMakePoint(120,60)];break;
  case 4:case 8:[cross moveToPoint:NSMakePoint(60,0)];[cross lineToPoint:NSMakePoint(60,120)];break;
 }}[cross stroke];
 if(IShotGlobal_1001f1950!=1)return;NSGraphicsContext.currentContext.shouldAntialias=YES;
 NSString *name=[NSBundle.mainBundle localizedStringForKey:IShotGlobal_1001f1968[@"colorName"] value:@"" table:nil];if(!name)return;
 NSMutableDictionary *nameAttr=[@{NSFontAttributeName:[NSFont systemFontOfSize:13],NSForegroundColorAttributeName:topOutline}mutableCopy];
 double nameWidth=[name boundingRectWithSize:NSMakeSize(FLT_MAX,0) options:1 attributes:nameAttr context:nil].size.width;
 for(int size=12;nameWidth>120.;size--){nameAttr[NSFontAttributeName]=[NSFont systemFontOfSize:size];nameWidth=[name boundingRectWithSize:NSMakeSize(FLT_MAX,0) options:1 attributes:nameAttr context:nil].size.width;}
 NSMutableDictionary *positionAttr=[@{NSFontAttributeName:[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:bottomOutline}mutableCopy];double positionWidth=[IShotGlobal_1001f1958 boundingRectWithSize:NSMakeSize(FLT_MAX,0) options:1 attributes:positionAttr context:nil].size.width;
 IShotGlobal_1001ddfc0=IShotGlobal_1001f1968[@"hex"];IShotGlobal_1001ddfc8=IShotGlobal_1001f1968[@"rgb"];
 float hexWidth=(float)IShotFunction_1000483f0(IShotGlobal_1001ddfc0,8).width,rgbWidth=(float)IShotFunction_1000483f0(IShotGlobal_1001ddfc8,8).width;
 NSMutableDictionary *rgbAttr=[@{NSFontAttributeName:[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:bottomOutline}mutableCopy];
 double nx=60.-nameWidth*.5,px=30.-positionWidth*.5,hx=90.-(double)hexWidth*.5,rx=90.-(double)rgbWidth*.5;
 for(int i=0;i<8;i++){double dx=0,rdx=0,ny=104,py=4,ry=16;switch(i){case 1:ny=102;py=2;ry=14;break;case 2:dx=rdx=-1;ny=103;py=3;ry=15;break;case 3:dx=1;ny=103;py=3;ry=15;break;case 4:dx=rdx=-.7;ny=103.7;py=3.7;ry=15.7;break;case 5:dx=rdx=.7;ny=103.7;py=3.7;ry=15.7;break;case 6:dx=rdx=-.7;ny=102.3;py=2.3;ry=14.3;break;case 7:dx=rdx=.7;ny=102.3;py=2.3;ry=14.3;break;}
  [name drawAtPoint:NSMakePoint(nx+dx,ny) withAttributes:nameAttr];[IShotGlobal_1001f1958 drawAtPoint:NSMakePoint(px+dx,py) withAttributes:positionAttr];[IShotGlobal_1001ddfc0 drawAtPoint:NSMakePoint(hx+dx,py) withAttributes:positionAttr];[IShotGlobal_1001ddfc8 drawAtPoint:NSMakePoint(rx+rdx,ry) withAttributes:rgbAttr];
 }
 nameAttr[NSForegroundColorAttributeName]=top;[name drawAtPoint:NSMakePoint(nx,103) withAttributes:nameAttr];positionAttr[NSForegroundColorAttributeName]=bottom;[IShotGlobal_1001f1958 drawAtPoint:NSMakePoint(px,3) withAttributes:positionAttr];rgbAttr[NSForegroundColorAttributeName]=bottom;[IShotGlobal_1001ddfc0 drawAtPoint:NSMakePoint(hx,3) withAttributes:rgbAttr];[IShotGlobal_1001ddfc8 drawAtPoint:NSMakePoint(rx,15) withAttributes:rgbAttr];
}
@end
