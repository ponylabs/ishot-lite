#import "SnipUtil.h"
@implementation SnipUtil
// 0x1000572fc, 0x100057300: distance deliberately remains squared.
+ (BOOL)isPoint:(NSPoint)p inRect:(NSRect)r { return NSPointInRect(p, r); }
+ (double)pointDistance:(NSPoint)a toPoint:(NSPoint)b { double x=a.x-b.x,y=a.y-b.y; return x*x+y*y; }
// 0x100057318: MI comparison preserves unordered values.
+ (NSRect)uniformRect:(NSRect)r { if (r.size.width<0) { r.origin.x+=r.size.width; r.size.width=-r.size.width; } if (r.size.height<0) { r.origin.y+=r.size.height; r.size.height=-r.size.height; } return r; }
+ (NSRect)rectToZero:(NSRect)r { return NSOffsetRect(r,-r.origin.x,-r.origin.y); }
// 0x100057350: original truncates origin coordinates to signed 32-bit integers.
+ (NSRect)cgWindowRectToScreenRect:(NSRect)r { double h=NSScreen.mainScreen.frame.size.height; for(NSScreen *s in NSScreen.screens) if((int)s.frame.origin.x==0 && (int)s.frame.origin.y==0) h=s.frame.size.height; r.origin.y=(h-r.size.height)-r.origin.y; return r; }
@end
