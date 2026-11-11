#pragma once
#import <Cocoa/Cocoa.h>
@interface ZoomWindow : NSPanel
@end
@interface ZoomView : NSView
@property(nonatomic) NSRect zoomFrame;
@end
