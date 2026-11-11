#import <ApplicationServices/ApplicationServices.h>
// 0x10004d220. REA assembly confirms two float arguments in s0/s1.
void IShotFunction_10004d220(float x, float y, int button, int action) {
    CGEventType type;
    if (button==0 && action==1) type=1;
    else if (button==0 && action==0) type=2;
    else if (button==1 && action==1) type=3;
    else if (button==1 && action==0) type=4;
    else if (button==2 && action==1) type=25;
    else if (button==2 && action==0) type=26;
    else if (button==1 && action==3) type=7;
    else if (button==0 && action==3) type=6;
    else if (button==2 && action==3) type=27;
    else if (button==0 && action==6) type=5;
    else return;
    CGPoint point=CGPointMake(x,y);
    if (x==-1000000.f && y==-1000000.f) {
        CGEventRef current=CGEventCreate(NULL);
        point=CGEventGetLocation(current);
        CFRelease(current);
    }
    CGEventSourceRef source=CGEventSourceCreate(1);
    CGEventRef event=CGEventCreateMouseEvent(source,type,point,button);
    CGEventPost(1,event);
    CFRelease(event); CFRelease(source);
}
