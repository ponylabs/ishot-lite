#import "ColorNamer.h"
#import <float.h>
#import <math.h>
#pragma clang fp contract(off)
// REA original 0x10008d580; preserve float arithmetic and unwrapped hue.
static void ColorHSL(float r,float g,float b,float *h,float *s,float *l) {
    r/=255.f; g/=255.f; b/=255.f;
    float mn=g<b?g:b; mn=r<mn?r:mn;
    float mx=g<b?b:g; mx=r<mx?mx:r;
    float delta=mx-mn, light=(mn+mx)*.5f, sat=0, hue=0;
    if(light>0 && light<1) sat=(delta/(light<.5f?light+light:2.f-(light+light)))*255.f;
    if(delta>0) {
        if(mx==r && mx!=g) hue=(g-b)/delta+0.f;
        if(mx==g && mx!=b) hue=(b-r)/delta+2.f+hue;
        if(mx==b && mx!=r) hue=(r-g)/delta+4.f+hue;
        hue=(hue/6.f)*255.f;
    }
    if(h)*h=hue; if(s)*s=sat; if(l)*l=light*255.f;
}
@implementation ColorNamer
- (instancetype)init {
    if((self=[super init])) {
        colorDictionary=
#include "ColorNamer-dictionary.inc"
        ;
        colorAttributes=[NSMutableDictionary new];
        for(NSString *key in colorDictionary) {
            NSColor *c=[ColorNamer colorFromHexString:key];
            float r=c.redComponent*255.,g=c.greenComponent*255.,b=c.blueComponent*255.,h,s,l;
            ColorHSL(r,g,b,&h,&s,&l);
            [colorAttributes setValue:@[@(r),@(g),@(b),@(h),@(s),@(l)] forKey:key];
        }
    }
    return self;
}
- (NSDictionary *)findNameForColor:(NSColor *)color { return [self algorithm:color]; }
- (NSDictionary *)findNameForColorHexString:(NSString *)hex { return [self algorithm:[ColorNamer colorFromHexString:hex]]; }
- (NSDictionary *)algorithm:(NSColor *)color {
    float r=color.redComponent*255.,g=color.greenComponent*255.,b=color.blueComponent*255.,h,s,l;
    NSString *value=[NSString stringWithFormat:@"%.f",(double)(((r+g)+b)/3.f)];
    NSString *rgb=[NSString stringWithFormat:@"%d,%d,%d",(int)((double)r+.5),(int)((double)g+.5),(int)((double)b+.5)];
    ColorHSL(r,g,b,&h,&s,&l);
    NSString *hex=[ColorNamer hexStringFromColor:color],*nearest=@"";
    float best=-1;
    for(NSString *key in colorDictionary) {
        if([hex isEqualToString:key]) return @{@"rgb":rgb,@"hex":hex,@"colorName":colorDictionary[key],@"colorValue":value};
        NSArray *a=colorAttributes[key];
        float dr=r-[a[0] floatValue],dg=g-[a[1] floatValue],db=b-[a[2] floatValue];
        float dh=h-[a[3] floatValue],ds=s-[a[4] floatValue],dl=l-[a[5] floatValue];
        float hsl=dh*dh+ds*ds+dl*dl, distance=((dr*dr+dg*dg)+db*db)+(hsl+hsl);
        if(best<0 || distance<best) { best=distance; nearest=key; }
    }
    return @{@"rgb":rgb,@"hex":hex,@"colorName":colorDictionary[nearest],@"colorValue":value};
}
+ (NSColor *)colorFromHexString:(NSString *)hex {
    unsigned value=0; NSScanner *scanner=[NSScanner scannerWithString:hex];
    scanner.scanLocation=0; [scanner scanHexInt:&value];
    return [NSColor colorWithCalibratedRed:((value>>16)&255)/255. green:((value>>8)&255)/255. blue:(value&255)/255. alpha:1];
}
+ (NSString *)hexStringFromColor:(NSColor *)color {
    return [NSString stringWithFormat:@"%02X%02X%02X",(int)(color.redComponent*255.+.5),(int)(color.greenComponent*255.+.5),(int)(color.blueComponent*255.+.5)];
}
+ (instancetype)sharedInstance { static ColorNamer *instance; if(!instance)instance=[ColorNamer new]; return instance; }
+ (NSString *)nameOfColor:(NSColor *)color { return [[ColorNamer sharedInstance] nameOfColor:color]; }
- (NSString *)nameOfColor:(NSColor *)color {
    double r=color.redComponent/255.,g=color.greenComponent/255.,b=color.blueComponent/255.,h=0;
    if(!(r==g && g==b)) {
        h=acos((((r-g)+r)-b)/(sqrt((r-g)*(r-g)+(r-b)*(g-b))*2.))/6.2832;
        if(g<b)h=6.28318-h;
    }
    for(NSUInteger i=0;i<self.colorList.count;i++) {
        NSArray *row=[self.colorList objectAtIndex:i];
        if(h<=[row[2] intValue])return row[1];
    }
    return @"";
}
- (NSString *)nameForColor:(NSColor *)color {
    double r=0,g=0,b=0,a=0; [color getRed:&r green:&g blue:&b alpha:&a];
    double best=DBL_MAX; NSString *result=nil;
    for(NSUInteger i=0;i<self.colorList.count;i++) {
        NSArray *row=[self.colorList objectAtIndex:i];
        double dr=r-(double)([row[4] floatValue]/100.f),dg=g-(double)([row[3] floatValue]/100.f),db=b-(double)([row[2] floatValue]/100.f);
        double distance=sqrt(dr*dr+dg*dg+db*db);
        if(distance<best) {best=distance;result=row[0];}
    }
    return result;
}
#include "ColorNamer-list.inc"
@end
