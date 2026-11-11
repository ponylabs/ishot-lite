#import <Foundation/Foundation.h>
// 0x10004c930; integer arithmetic and piecewise thresholds from original arm64.
int IShotFunction_10004c930(int input) {
    uint32_t value=(uint32_t)input,offset=0;
    if (input<91) {
        if (input>20) { value=(uint32_t)input*2U-40U; offset=20; }
        if (input>40) { value=(uint32_t)input*5U-200U; offset=60; }
        if (input>60) { value=(uint32_t)input*10U-600U; offset=160; }
        if (input>80) { value=(uint32_t)input*20U-1600U; offset=360; }
    } else { value=(uint32_t)input*50U-4500U; offset=560; }
    return (int)(value+offset);
}
// 0x10004c9b8; the original intentionally masks middle intervals to eight bits.
int IShotFunction_10004c9b8(uint32_t input) {
    uint32_t value,offset;
    if ((int)input<561) {
        if ((int)input<361) {
            offset=0; value=input;
            if ((int)input>20) { offset=20; value=((input+236U)>>1)&127U; }
            if ((int)input>60) { offset=40; value=((input-60U)&255U)/5U; }
            if ((int)input>160) { offset=60; value=((input+96U)&255U)/10U; }
        } else { offset=80; value=((input-104U)&255U)/20U; }
    } else { offset=90; value=(input-560U)/50U; }
    return (int)(value+offset);
}
