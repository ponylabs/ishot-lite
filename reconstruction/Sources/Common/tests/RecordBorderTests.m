#import "../CropBorderViewForRecordScreen.m"
// Test-only access fixture prevents changing the user's defaults during init.
IOHIDAccessType IOHIDCheckAccess(IOHIDRequestType type){return kIOHIDAccessTypeGranted;}
BOOL IShotCameraDragging_1001ddca8,IShotGlobal_1001de210,IShotGlobal_1001ddd58,IShotGlobal_1001ddde0,IShotGlobal_1001ddce8;
NSCursor *IShotGlobal_1001dddf8,*IShotGlobal_1001ddf88,*IShotGlobal_1001ddf90;
NSString *IShotGlobal_1001dde70;
static NSEvent *enter(NSDictionary *info){return [NSEvent enterExitEventWithType:NSEventTypeMouseEntered location:NSMakePoint(30,40) modifierFlags:0 timestamp:1 windowNumber:0 context:nil eventNumber:1 trackingNumber:1 userData:(__bridge void *)info];}
int main(){@autoreleasepool{
 [NSApplication sharedApplication];CropBorderViewForRecordScreen *v=[[CropBorderViewForRecordScreen alloc]initWithFrame:NSMakeRect(10,20,200,160)];NSCAssert(v.trackingAreas.count==9,@"nine original areas");
 NSPoint points[]={{15,25},{100,25},{205,25},{205,100},{205,175},{100,175},{15,175},{15,100}};for(int i=0;i<8;i++)NSCAssert([v _calculateMouseIsOnCropBorderViewWithPoint:points[i]]==i+1,@"direction %d",i+1);
 NSCAssert([v _calculateMouseIsOnCropBorderViewWithPoint:NSMakePoint(50,50)]==0&&[v _calculateMouseIsOnCropBorderViewWithPoint:NSMakePoint(0,0)]==9,@"inside/outside");
 v.onlyClipCurrentWindow=YES;NSCAssert([v _calculateMouseIsOnCropBorderViewWithPoint:NSMakePoint(16,26)]==0,@"window mode ignores handles");v.onlyClipCurrentWindow=NO;
 IShotGlobal_1001ddd58=YES;[v mouseEntered:enter(@{@"number":@2})];NSCAssert(v.isInResizeRect&&v.numberOfReSize==2&&[IShotGlobal_1001dde70 isEqualToString:@"Resize_90"],@"entered top/bottom cursor routing");
 IShotGlobal_1001de210=YES;[v mouseEntered:enter(@{@"number":@4})];NSCAssert(v.whichInResizeRect==-1&&v.numberOfReSize==2,@"active recording gate");IShotGlobal_1001de210=NO;
 [v mouseEntered:enter(@{@"number":@100})];NSCAssert(IShotGlobal_1001ddce8&&IShotGlobal_1001dddf8==nil,@"toolbar marker path");
 v.hideHandleRect=YES;NSCAssert(v.trackingAreas.count==0,@"hide removes areas");NSLog(@"PASS recording crop eight resize hits, window mode, cursor gates, toolbar marker and tracking removal");
}}
