#import "SRCommon.h"
@class SRRecorderControl;
@protocol SRRecorderControlDelegate <NSObject>
@optional
- (BOOL)shortcutRecorderShouldBeginRecording:(SRRecorderControl *)control;
- (void)shortcutRecorderWillBegin;
- (void)shortcutRecorderDidEndRecording:(SRRecorderControl *)control;
- (BOOL)shortcutRecorder:(SRRecorderControl *)control canRecordShortcut:(NSDictionary *)shortcut;
- (BOOL)shortcutRecorder:(SRRecorderControl *)control shouldUnconditionallyAllowModifierFlags:(NSUInteger)flags forKeyCode:(unsigned short)code;
@end
@interface SRRecorderControl : NSView {
    NSTrackingArea *_mainButtonTrackingArea, *_snapBackButtonTrackingArea, *_clearButtonTrackingArea;
    NSUInteger _mouseTrackingButtonTag;
    NSToolTipTag _snapBackButtonToolTipTag;
    CGFloat _shapeXRadius, _shapeYRadious;
}
@property(unsafe_unretained) id<SRRecorderControlDelegate> delegate;
@property(readonly) NSUInteger allowedModifierFlags;
@property(readonly) NSUInteger requiredModifierFlags;
@property(readonly) BOOL allowsEmptyModifierFlags;
@property BOOL drawsASCIIEquivalentOfShortcut;
@property BOOL allowsEscapeToCancelRecording;
@property BOOL allowsDeleteToClearShortcutAndEndRecording;
@property(nonatomic, getter=isEnabled) BOOL enabled;
@property(nonatomic, readonly) BOOL isRecording;
@property(nonatomic, copy) NSDictionary *objectValue;
- (void)_initInternalState;
- (void)setAllowedModifierFlags:(NSUInteger)allowed requiredModifierFlags:(NSUInteger)required allowsEmptyModifierFlags:(BOOL)empty;
- (BOOL)beginRecording;
- (void)endRecording;
- (void)clearAndEndRecording;
- (void)endRecordingWithObjectValue:(NSDictionary *)value;
- (NSBezierPath *)controlShape;
- (NSRect)rectForLabel:(NSString *)label withAttributes:(NSDictionary *)attributes;
- (NSRect)snapBackButtonRect;
- (NSRect)clearButtonRect;
- (NSString *)label;
- (NSString *)stringValue;
- (NSString *)accessibilityStringValue;
- (NSDictionary *)labelAttributes;
- (NSDictionary *)normalLabelAttributes;
- (NSDictionary *)recordingLabelAttributes;
- (NSDictionary *)disabledLabelAttributes;
- (void)drawBackground:(NSRect)rect;
- (void)drawInterior:(NSRect)rect;
- (void)drawLabel:(NSRect)rect;
- (void)drawSnapBackButton:(NSRect)rect;
- (void)drawClearButton:(NSRect)rect;
- (CGFloat)backingScaleFactor;
- (BOOL)isMainButtonHighlighted;
- (BOOL)isSnapBackButtonHighlighted;
- (BOOL)isClearButtonHighlighted;
- (BOOL)areModifierFlagsValid:(NSUInteger)flags forKeyCode:(unsigned short)code;
- (void)propagateValue:(id)value forBinding:(NSString *)binding;
- (void)setValue:(id)value;
- (id)value;
@end
