#import "../PreferenceControls.h"
#import "../PreferenceHelpers.h"
#import "../LeftMenuTableHandler.h"
#import "../FreeAppsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Carbon/Carbon.h>
#import <assert.h>
int main(void) { @autoreleasepool {
    [NSApplication sharedApplication];
    NSView *parent=[[NSView alloc] initWithFrame:NSMakeRect(0,0,200,100)]; parent.bounds=NSMakeRect(10,30,200,100);
    NSView *child=[[NSView alloc] initWithFrame:NSMakeRect(7,2,40,20)]; [parent addSubview:child]; [child centerYInSuperview];
    assert(NSEqualRects(child.frame,NSMakeRect(7,70,40,20)));
    assert(IShotFunction_100049f34(kVK_F1)); assert(IShotFunction_100049f34(kVK_F20)); assert(!IShotFunction_100049f34(kVK_ANSI_A)); assert(!IShotFunction_100049f34(UINT64_MAX));
    assert([@"x" isValidString]); assert(![@"" isValidString]); assert(![@1 isValidString]);
    NSMutableString *name=[@"sample" mutableCopy]; FreeAppModel *model=[FreeAppModel modelWithIcon:@"icon" name:name desc:@"desc" link:@"link"]; [name appendString:@" changed"]; assert([model.name isEqualToString:@"sample"]);
    LCFlipView *flip=[[LCFlipView alloc] init]; flip.tag=79; assert(flip.isFlipped && flip.tag==79);
    LCTableRowView *row=[[LCTableRowView alloc] init]; assert(row.contentHeight==25 && row.horizontalInset==8 && row.rowCornerRadius==10 && row.selectionOffsetX==5);
    NSEvent *event=[NSEvent otherEventWithType:NSEventTypeApplicationDefined location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:0 context:nil subtype:0 data1:0 data2:0];
    row.emphasized=NO; assert(row.emphasized); [row mouseEntered:event]; assert(row.mouseInside); [row mouseExited:event]; assert(!row.mouseInside);
    LeftMenuTableHandler *handler=[[LeftMenuTableHandler alloc] init]; handler.dataList=@[@{@"title":@"a",@"image":@"b"}]; NSTableView *table=[[NSTableView alloc] init]; assert([handler numberOfRowsInTableView:table]==1 && handler.tableView==table);
    LCTableRowView *menuRow=(id)[handler tableView:table rowViewForRow:0]; assert(menuRow.contentHeight==22 && menuRow.rowCornerRadius==8 && menuRow.horizontalInset==10);
    LCSizeInputTextField *field=[[LCSizeInputTextField alloc] initWithFrame:NSMakeRect(0,0,80,20)]; assert(!field.bordered && !field.drawsBackground && field.editable && field.selectable && field.layer.cornerRadius==6);
    LCTableViewScrollView *scroll=[[LCTableViewScrollView alloc] initWithFrame:NSMakeRect(0,0,200,100)]; [scroll updateBorderStyle]; assert(scroll.layer.borderWidth==1); scroll.isTransparentBackground=NO; assert(scroll.layer.borderWidth==0);
    puts("Preferences tests passed: frame conversion, key eligibility, model ownership, row state, menu and nib controls; no defaults mutations or external launches");
} return 0; }
