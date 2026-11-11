#import "../ColorNamer.m"
#include <assert.h>
int main(){@autoreleasepool{
 ColorNamer *namer=[ColorNamer new];NSCAssert(namer.colorList.count==242,@"original table cardinality");
 NSColor *red=[ColorNamer colorFromHexString:@"FF0000"];NSCAssert(red.redComponent==1&&red.greenComponent==0&&red.blueComponent==0,@"hex decode");NSCAssert([[ColorNamer hexStringFromColor:red]isEqualToString:@"FF0000"],@"hex encode");
 NSDictionary *result=[namer findNameForColor:red];NSCAssert([result[@"rgb"]isEqualToString:@"255,0,0"]&&[result[@"hex"]isEqualToString:@"FF0000"]&&[result[@"colorValue"]isEqualToString:@"85"],@"RGB and average intensity");
 NSDictionary *dictionary=[namer valueForKey:@"colorDictionary"];NSCAssert(dictionary.count==241,@"original dictionary cardinality");for(NSString *key in dictionary){NSDictionary *named=[namer findNameForColorHexString:key];NSCAssert([named[@"colorName"]isEqualToString:dictionary[key]],@"exact lookup %@",key);}
 float h,s,l;ColorHSL(255,0,255,&h,&s,&l);NSCAssert(h==-42.5f&&s==255.f&&l==127.5f,@"original unwrapped negative hue");ColorHSL(127,127,127,&h,&s,&l);NSCAssert(h==0&&s==0&&l==127,@"achromatic HSL");
 NSArray *samples=@[@"010203",@"FE0101",@"8040C0",@"123456",@"FDFDFD"];for(NSString *hex in samples){NSDictionary *named=[namer findNameForColorHexString:hex];NSCAssert([named[@"hex"]isEqualToString:hex]&&[dictionary.allValues containsObject:named[@"colorName"]],@"nearest named color %@",hex);}
 NSCAssert(ColorNamer.sharedInstance==ColorNamer.sharedInstance,@"original singleton");NSLog(@"PASS ColorNamer 241 exact colors, hex/RGB/intensity, HSL edges and nearest-color samples");
}}
