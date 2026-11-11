#import "SRRecorderControl.h"
#import "SRTransformers.h"
#include <math.h>
static NSImage *SRImages[19];
@implementation SRRecorderControl
@synthesize objectValue = _objectValue;
@synthesize enabled = _enabled;
- (instancetype)initWithFrame:(NSRect)frame { if ((self = [super initWithFrame:frame])) [self _initInternalState]; return self; }
- (instancetype)initWithCoder:(NSCoder *)coder { if ((self = [super initWithCoder:coder])) [self _initInternalState]; return self; }
- (void)_initInternalState {
    _allowsEmptyModifierFlags = NO; _drawsASCIIEquivalentOfShortcut = YES;
    _allowsEscapeToCancelRecording = YES; _allowsDeleteToClearShortcutAndEndRecording = YES; _enabled = YES;
    _allowedModifierFlags = 0x1e0000; _requiredModifierFlags = 0;
    _mouseTrackingButtonTag = NSUIntegerMax; _snapBackButtonToolTipTag = NSIntegerMax;
    if (floor(NSAppKitVersionNumber) > 1038) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setContentHuggingPriority:250 forOrientation:0]; [self setContentHuggingPriority:1000 forOrientation:1];
        [self setContentCompressionResistancePriority:250 forOrientation:0]; [self setContentCompressionResistancePriority:1000 forOrientation:1];
    }
    if (floor(NSAppKitVersionNumber) <= 1265) { _shapeXRadius = 11; _shapeYRadious = 12; }
    else { _shapeXRadius = 2; _shapeYRadious = 2; }
    [self setToolTip:SRLoc(@"Click to record shortcut")]; [self updateTrackingAreas];
}
- (void)dealloc { [[NSNotificationCenter defaultCenter] removeObserver:self]; }
- (void)setAllowedModifierFlags:(NSUInteger)allowed requiredModifierFlags:(NSUInteger)required allowsEmptyModifierFlags:(BOOL)empty {
    allowed &= 0x1e0000; required &= 0x1e0000;
    if ((allowed & required) != required) [NSException raise:NSInvalidArgumentException format:@"Required flags (%lu) MUST be allowed (%lu)", required, allowed];
    if (empty && required) [NSException raise:NSInvalidArgumentException format:@"Empty modifier flags MUST be disallowed if required modifier flags are not empty."];
    _allowedModifierFlags = allowed; _requiredModifierFlags = required; _allowsEmptyModifierFlags = empty;
}
- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled; [self setNeedsDisplay:YES]; if (!_enabled) [self endRecording];
    if (floor(NSAppKitVersionNumber) > 1038) [self noteFocusRingMaskChanged];
}
- (void)setObjectValue:(NSDictionary *)value {
    if ((id)value == [NSNull null]) value = nil;
    _objectValue = [value copy]; [self propagateValue:_objectValue forBinding:NSValueBinding];
    if (![self isRecording]) { NSAccessibilityPostNotification(self, NSAccessibilityTitleChangedNotification); [self setNeedsDisplay:YES]; }
}
- (BOOL)beginRecording {
    if (![self isEnabled]) return NO;
    if ([self isRecording]) return YES;
    [self setNeedsDisplay:YES];
    if ([[self delegate] respondsToSelector:@selector(shortcutRecorderShouldBeginRecording:)] && ![[self delegate] shortcutRecorderShouldBeginRecording:self]) { NSBeep(); return NO; }
    [[self delegate] shortcutRecorderWillBegin];
    [self willChangeValueForKey:@"isRecording"]; _isRecording = YES; [self didChangeValueForKey:@"isRecording"];
    [self updateTrackingAreas]; [self setToolTip:SRLoc(@"Type shortcut")]; NSAccessibilityPostNotification(self, NSAccessibilityTitleChangedNotification);
    return YES;
}
- (void)endRecording { [self endRecordingWithObjectValue:[self objectValue]]; }
- (void)clearAndEndRecording { [self endRecordingWithObjectValue:nil]; }
- (void)endRecordingWithObjectValue:(NSDictionary *)value {
    if (![self isRecording]) return;
    [self willChangeValueForKey:@"isRecording"]; _isRecording = NO; [self didChangeValueForKey:@"isRecording"];
    [self setObjectValue:value]; [self updateTrackingAreas]; [self setToolTip:SRLoc(@"Click to record shortcut")];
    [self setNeedsDisplay:YES]; NSAccessibilityPostNotification(self, NSAccessibilityTitleChangedNotification);
    if ([[self window] firstResponder] == self && ![self canBecomeKeyView]) [[self window] makeFirstResponder:nil];
    if ([[self delegate] respondsToSelector:@selector(shortcutRecorderDidEndRecording:)]) [[self delegate] shortcutRecorderDidEndRecording:self];
}
- (NSBezierPath *)controlShape {
    NSRect rect = [self bounds]; rect.size.height = 20 - [self alignmentRectInsets].bottom;
    if (floor(NSAppKitVersionNumber) <= 1265) rect = NSInsetRect(rect, 1, 1);
    return [NSBezierPath bezierPathWithRoundedRect:rect xRadius:_shapeXRadius yRadius:_shapeYRadious];
}
- (NSRect)rectForLabel:(NSString *)label withAttributes:(NSDictionary *)attributes {
    NSSize size = [label sizeWithAttributes:attributes]; NSRect bounds = NSInsetRect([self bounds], _shapeXRadius, 0);
    size.width = fmin(ceil(size.width), NSWidth(bounds)); size.height = ceil(size.height);
    CGFloat textHeight = size.height + [attributes[NSFontAttributeName] descender];
    NSRect rect = NSMakeRect(NSMidX(bounds) - size.width / 2, 20 - [self baselineOffsetFromBottom] - textHeight + 3, size.width, size.height);
    rect = [self centerScanRect:rect];
    if ([self isRecording]) {
        CGFloat offset = NSMinX([self snapBackButtonRect]) - NSMaxX(rect);
        if (offset < 0) {
            rect = NSOffsetRect(rect, offset, 0);
            if (NSMinX(rect) < NSMinX(bounds)) { rect.size.width -= NSMinX(bounds) - NSMinX(rect); rect.origin.x = NSMinX(bounds); }
        }
    }
    if (rect.size.width < size.width || rect.size.height < size.height) NSLog(@"WARNING: label rect (%@) is smaller than label size (%@). You may want to adjust size of the control.", NSStringFromRect(rect), NSStringFromSize(size));
    return rect;
}
- (NSRect)snapBackButtonRect {
    NSRect clear = [self clearButtonRect], bounds = [self bounds]; CGFloat x = NSMinX(clear) - 1 - 14 - 3;
    return NSMakeRect(x, NSMinY(bounds), fdim(NSMinX(clear), x), 20);
}
- (NSRect)clearButtonRect {
    NSRect bounds = [self bounds]; CGFloat x = NSMaxX(bounds) - 4 - 1, width = 0;
    if ([[self objectValue] count]) { x -= 14; width = fdim(NSMaxX(bounds), x); }
    return NSMakeRect(x, NSMinY(bounds), width, 20);
}
- (NSString *)label {
    NSString *label;
    if ([self isRecording]) {
        NSUInteger flags = [NSEvent modifierFlags] & [self allowedModifierFlags];
        label = flags ? [[SRModifierFlagsTransformer sharedTransformer] transformedValue:@(flags)] : [self stringValue];
        if (![label length]) label = SRLoc(@"Type shortcut");
    } else { label = [self stringValue]; if (![label length]) label = SRLoc(@"Click to record shortcut"); }
    return label;
}
- (NSString *)accessibilityLabel {
    NSString *label;
    if ([self isRecording]) {
        label = [[SRModifierFlagsTransformer sharedPlainTransformer] transformedValue:@([NSEvent modifierFlags] & [self allowedModifierFlags])];
        if (![label length]) label = SRLoc(@"Type shortcut");
    } else { label = [self accessibilityStringValue]; if (![label length]) label = SRLoc(@"Click to record shortcut"); }
    return label;
}
- (NSString *)stringValue {
    if (![[self objectValue] count]) return nil;
    NSString *flags = [[SRModifierFlagsTransformer sharedTransformer] transformedValue:[self objectValue][@"modifierFlags"]];
    SRKeyCodeTransformer *transformer = [self drawsASCIIEquivalentOfShortcut] ? [SRKeyCodeTransformer sharedPlainASCIITransformer] : [SRKeyCodeTransformer sharedPlainTransformer];
    NSString *key = [transformer transformedValue:[self objectValue][@"keyCode"] withImplicitModifierFlags:nil explicitModifierFlags:[self objectValue][@"modifierFlags"]];
    return [NSString stringWithFormat:@"%@%@", flags, key];
}
- (NSString *)accessibilityStringValue {
    if (![[self objectValue] count]) return nil;
    NSString *flags = [[SRModifierFlagsTransformer sharedPlainTransformer] transformedValue:[self objectValue][@"modifierFlags"]];
    SRKeyCodeTransformer *transformer = [self drawsASCIIEquivalentOfShortcut] ? [SRKeyCodeTransformer sharedPlainASCIITransformer] : [SRKeyCodeTransformer sharedPlainTransformer];
    NSString *key = [transformer transformedValue:[self objectValue][@"keyCode"]];
    return [flags length] ? [NSString stringWithFormat:@"%@-%@", flags, key] : [NSString stringWithFormat:@"%@", key];
}
- (NSDictionary *)labelAttributes { return ![self isEnabled] ? [self disabledLabelAttributes] : [self isRecording] ? [self recordingLabelAttributes] : [self normalLabelAttributes]; }
- (NSDictionary *)normalLabelAttributes {
    static NSDictionary *attributes; static dispatch_once_t once;
    dispatch_once(&once, ^{ NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init]; [style setAlignment:1]; [style setLineBreakMode:4]; [style setBaseWritingDirection:0]; attributes = @{NSParagraphStyleAttributeName:[style copy], NSFontAttributeName:[NSFont labelFontOfSize:[NSFont systemFontSize] - 2], NSForegroundColorAttributeName:[NSColor controlTextColor]}; }); return attributes;
}
- (NSDictionary *)recordingLabelAttributes {
    static NSDictionary *attributes; static dispatch_once_t once;
    dispatch_once(&once, ^{ NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init]; [style setAlignment:1]; [style setLineBreakMode:4]; [style setBaseWritingDirection:0]; attributes = @{NSParagraphStyleAttributeName:[style copy], NSFontAttributeName:[NSFont labelFontOfSize:[NSFont systemFontSize] - 2], NSForegroundColorAttributeName:[NSColor disabledControlTextColor]}; }); return attributes;
}
- (NSDictionary *)disabledLabelAttributes {
    static NSDictionary *attributes; static dispatch_once_t once;
    dispatch_once(&once, ^{ NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init]; [style setAlignment:1]; [style setLineBreakMode:4]; [style setBaseWritingDirection:0]; attributes = @{NSParagraphStyleAttributeName:[style copy], NSFontAttributeName:[NSFont labelFontOfSize:[NSFont systemFontSize] - 2], NSForegroundColorAttributeName:[NSColor disabledControlTextColor]}; }); return attributes;
}
- (void)drawBackground:(NSRect)dirtyRect {
    NSRect rect = [self bounds]; rect.size.height = 20;
    if ([self needsToDrawRect:rect]) {
        [NSGraphicsContext saveGraphicsState]; NSUInteger index;
        if ([self isRecording]) index = 3;
        else if ([self isMainButtonHighlighted]) index = [NSColor currentControlTint] == 1 ? 0 : 6;
        else index = [self isEnabled] ? 9 : 16;
        NSDrawThreePartImage(rect, SRImages[index], SRImages[index + 1], SRImages[index + 2], NO, NSCompositingOperationSourceOver, 1, [self isFlipped]);
        [NSGraphicsContext restoreGraphicsState];
    }
}
- (void)drawInterior:(NSRect)rect { [self drawLabel:rect]; if ([self isRecording]) { [self drawSnapBackButton:rect]; [self drawClearButton:rect]; } }
- (void)drawLabel:(NSRect)dirtyRect {
    NSString *label = [self label]; NSDictionary *attributes = [self labelAttributes]; NSRect rect = [self rectForLabel:label withAttributes:attributes];
    if ([self needsToDrawRect:rect]) { [NSGraphicsContext saveGraphicsState]; [label drawInRect:rect withAttributes:attributes]; [NSGraphicsContext restoreGraphicsState]; }
}
- (void)drawSnapBackButton:(NSRect)dirtyRect {
    NSRect rect = [self snapBackButtonRect];
    rect.origin.x += 3; rect.origin.y += floor([self alignmentRectInsets].top + (rect.size.height - 14) / 2); rect.size = NSMakeSize(14, 14); rect = [self centerScanRect:rect];
    if ([self needsToDrawRect:rect]) {
        [NSGraphicsContext saveGraphicsState]; NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSFontAttributeName] = [NSFont systemFontOfSize:13]; attributes[NSForegroundColorAttributeName] = [NSColor textColor];
        [@"↩" drawAtPoint:NSMakePoint(rect.origin.x + 4, rect.origin.y - 1) withAttributes:attributes]; [NSGraphicsContext restoreGraphicsState];
    }
}
- (void)drawClearButton:(NSRect)dirtyRect {
    NSRect rect = [self clearButtonRect]; if (rect.size.width == 0) return;
    rect.origin.x += 1; rect.origin.y += floor([self alignmentRectInsets].top + (rect.size.height - 14) / 2); rect.size = NSMakeSize(14, 14); rect = [self centerScanRect:rect];
    if ([self needsToDrawRect:rect]) {
        [NSGraphicsContext saveGraphicsState]; NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSFontAttributeName] = [NSFont systemFontOfSize:11]; attributes[NSForegroundColorAttributeName] = [NSColor textColor];
        [@"ㄨ" drawAtPoint:NSMakePoint(rect.origin.x + 4, rect.origin.y) withAttributes:attributes]; [NSGraphicsContext restoreGraphicsState];
    }
}
- (CGFloat)backingScaleFactor { return floor(NSAppKitVersionNumber) <= 1038 || ![self window] ? 1 : [[self window] backingScaleFactor]; }
- (BOOL)isMainButtonHighlighted { return _mouseTrackingButtonTag == 2 && [self mouse:[self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil] inRect:[self bounds]]; }
- (BOOL)isSnapBackButtonHighlighted { return _mouseTrackingButtonTag == 0 && [self mouse:[self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil] inRect:[self snapBackButtonRect]]; }
- (BOOL)isClearButtonHighlighted { return _mouseTrackingButtonTag == 1 && [self mouse:[self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil] inRect:[self clearButtonRect]]; }
- (BOOL)areModifierFlagsValid:(NSUInteger)flags forKeyCode:(unsigned short)code {
    flags &= 0x1e0000;
    if ([[self delegate] respondsToSelector:@selector(shortcutRecorder:shouldUnconditionallyAllowModifierFlags:forKeyCode:)] && [[self delegate] shortcutRecorder:self shouldUnconditionallyAllowModifierFlags:flags forKeyCode:code]) return YES;
    if (!flags && ![self allowsEmptyModifierFlags]) return NO;
    return (flags & [self requiredModifierFlags]) == [self requiredModifierFlags] && (flags & [self allowedModifierFlags]) == flags;
}
- (void)propagateValue:(id)value forBinding:(NSString *)binding {
    if (!binding) [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd object:self file:@"SRRecorderControl.m" lineNumber:797 description:@"Invalid parameter not satisfying: %@", @"aBinding != nil"];
    NSDictionary *info = [self infoForBinding:binding]; if (!info || (id)info == [NSNull null]) return;
    id object = info[NSObservedObjectKey]; NSString *path = info[NSObservedKeyPathKey];
    if (!object || object == [NSNull null]) [NSException raise:NSInternalInconsistencyException format:@"NSObservedObjectKey MUST NOT be nil for binding \"%@\"", binding];
    if (!path || (id)path == [NSNull null]) [NSException raise:NSInternalInconsistencyException format:@"NSObservedKeyPathKey MUST NOT be nil for binding \"%@\"", binding];
    NSDictionary *options = info[NSOptionsKey];
    if (options) {
        NSValueTransformer *transformer = [options valueForKey:NSValueTransformerBindingOption];
        if (!transformer || (id)transformer == [NSNull null]) { NSString *name = [options valueForKey:NSValueTransformerNameBindingOption]; if (name && (id)name != [NSNull null]) transformer = [NSValueTransformer valueTransformerForName:name]; }
        if (transformer && (id)transformer != [NSNull null]) {
            if ([[transformer class] allowsReverseTransformation]) value = [transformer reverseTransformedValue:value];
            else NSLog(@"WARNING: binding \"%@\" has value transformer, but it doesn't allow reverse transformations in %s", binding, __PRETTY_FUNCTION__);
        }
    }
    [object setValue:value forKeyPath:path];
}
+ (BOOL)automaticallyNotifiesObserversOfValue { return NO; }
- (void)setValue:(id)value {
    if (NSIsControllerMarker(value)) [NSException raise:NSInternalInconsistencyException format:@"SRRecorderControl's NSValueBinding does not support controller value markers."];
    [self setObjectValue:value];
}
- (id)value { return [self objectValue]; }
- (BOOL)accessibilityIsIgnored { return NO; }
- (NSArray *)accessibilityAttributeNames {
    static NSArray *names; static dispatch_once_t once;
    dispatch_once(&once, ^{ NSMutableArray *result = [[super accessibilityAttributeNames] mutableCopy]; for (NSString *name in @[NSAccessibilityRoleAttribute, NSAccessibilityTitleAttribute, NSAccessibilityEnabledAttribute]) if (![result containsObject:name]) [result addObject:name]; names = [result copy]; }); return names;
}
- (id)accessibilityAttributeValue:(NSString *)attribute {
    if ([attribute isEqualToString:NSAccessibilityRoleAttribute]) return NSAccessibilityButtonRole;
    if ([attribute isEqualToString:NSAccessibilityTitleAttribute]) return [self accessibilityLabel];
    if ([attribute isEqualToString:NSAccessibilityEnabledAttribute]) return @([self isEnabled]);
    return [super accessibilityAttributeValue:attribute];
}
- (NSArray *)accessibilityActionNames {
    static NSArray *all, *button, *recorder; static dispatch_once_t once;
    dispatch_once(&once, ^{ all = @[NSAccessibilityPressAction, NSAccessibilityCancelAction, NSAccessibilityDeleteAction]; button = @[NSAccessibilityPressAction]; recorder = @[NSAccessibilityCancelAction, NSAccessibilityDeleteAction]; });
    return floor(NSAppKitVersionNumber) <= 1038 ? all : ![self isEnabled] ? @[] : [self isRecording] ? recorder : button;
}
- (NSString *)accessibilityActionDescription:(NSString *)action { return NSAccessibilityActionDescription(action); }
- (void)accessibilityPerformAction:(NSString *)action {
    if ([action isEqualToString:NSAccessibilityPressAction]) [self beginRecording];
    else if ([self isRecording] && [action isEqualToString:NSAccessibilityCancelAction]) [self endRecording];
    else if ([self isRecording] && [action isEqualToString:NSAccessibilityDeleteAction]) [self clearAndEndRecording];
}
- (NSString *)view:(NSView *)view stringForToolTip:(NSToolTipTag)tag point:(NSPoint)point userData:(void *)data {
    return tag == _snapBackButtonToolTipTag ? SRLoc(@"Use old shortcut") : [super view:view stringForToolTip:tag point:point userData:data];
}
- (BOOL)isOpaque { return NO; }
- (BOOL)isFlipped { return YES; }
- (void)viewWillDraw {
    [super viewWillDraw]; static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (floor(NSAppKitVersionNumber) <= 1265) {
            SRImages[0] = SRImage(@"shortcut-recorder-bezel-blue-highlighted-left"); SRImages[1] = SRImage(@"shortcut-recorder-bezel-blue-highlighted-middle"); SRImages[2] = SRImage(@"shortcut-recorder-bezel-blue-highlighted-right");
            SRImages[3] = SRImage(@"shortcut-recorder-bezel-editing-left"); SRImages[4] = SRImage(@"shortcut-recorder-bezel-editing-middle"); SRImages[5] = SRImage(@"shortcut-recorder-bezel-editing-right");
            SRImages[6] = SRImage(@"shortcut-recorder-bezel-graphite-highlight-mask-left"); SRImages[7] = SRImage(@"shortcut-recorder-bezel-graphite-highlight-mask-middle"); SRImages[8] = SRImage(@"shortcut-recorder-bezel-graphite-highlight-mask-right");
            SRImages[9] = SRImage(@"shortcut-recorder-bezel-left"); SRImages[10] = SRImage(@"shortcut-recorder-bezel-middle"); SRImages[11] = SRImage(@"shortcut-recorder-bezel-right");
            SRImages[12] = SRImage(@"shortcut-recorder-clear-highlighted"); SRImages[13] = SRImage(@"shortcut-recorder-clear"); SRImages[14] = SRImage(@"shortcut-recorder-snapback-highlighted"); SRImages[15] = SRImage(@"shortcut-recorder-snapback");
            SRImages[16] = SRImage(@"shortcut-recorder-bezel-disabled-left"); SRImages[17] = SRImage(@"shortcut-recorder-bezel-disabled-middle"); SRImages[18] = SRImage(@"shortcut-recorder-bezel-disabled-right");
        } else {
            SRImages[6] = SRImage(@"shortcut-recorder-yosemite-bezel-graphite-highlight-mask-left"); SRImages[7] = SRImage(@"shortcut-recorder-yosemite-bezel-graphite-highlight-mask-middle"); SRImages[8] = SRImage(@"shortcut-recorder-yosemite-bezel-graphite-highlight-mask-right");
            SRImages[12] = SRImage(@"shortcut-recorder-yosemite-clear-highlighted"); SRImages[13] = SRImage(@"shortcut-recorder-yosemite-clear"); SRImages[14] = SRImage(@"shortcut-recorder-yosemite-snapback-highlighted"); SRImages[15] = SRImage(@"shortcut-recorder-yosemite-snapback");
        }
    });
}
- (void)drawRect:(NSRect)rect {
    [self drawBackground:rect]; [self drawInterior:rect];
    if (floor(NSAppKitVersionNumber) <= 1038 && [self isEnabled] && [[self window] firstResponder] == self) { [NSGraphicsContext saveGraphicsState]; NSSetFocusRingStyle(0); [[self controlShape] fill]; [NSGraphicsContext restoreGraphicsState]; }
}
- (void)drawFocusRingMask { if ([self isEnabled] && [[self window] firstResponder] == self) [[self controlShape] fill]; }
- (NSRect)focusRingMaskBounds { return [self isEnabled] && [[self window] firstResponder] == self ? [[self controlShape] bounds] : NSZeroRect; }
- (NSEdgeInsets)alignmentRectInsets { return NSEdgeInsetsMake(0, 0, 1 / [self backingScaleFactor], 0); }
- (CGFloat)baselineOffsetFromBottom { return 8; }
- (NSSize)intrinsicContentSize { NSRect rect = [self rectForLabel:SRLoc(@"Click to record shortcut") withAttributes:[self normalLabelAttributes]]; return NSMakeSize(rect.size.width + _shapeXRadius + _shapeXRadius, 20); }
- (void)updateTrackingAreas {
    if (_mainButtonTrackingArea) [self removeTrackingArea:_mainButtonTrackingArea];
    _mainButtonTrackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:0x411 owner:self userInfo:nil]; [self addTrackingArea:_mainButtonTrackingArea];
    if (_snapBackButtonTrackingArea) { [self removeTrackingArea:_snapBackButtonTrackingArea]; _snapBackButtonTrackingArea = nil; }
    if (_clearButtonTrackingArea) { [self removeTrackingArea:_clearButtonTrackingArea]; _clearButtonTrackingArea = nil; }
    if (_snapBackButtonToolTipTag != NSIntegerMax) { [self removeToolTip:_snapBackButtonToolTipTag]; _snapBackButtonToolTipTag = NSIntegerMax; }
    if ([self isRecording]) {
        _snapBackButtonTrackingArea = [[NSTrackingArea alloc] initWithRect:[self snapBackButtonRect] options:0x411 owner:self userInfo:nil]; [self addTrackingArea:_snapBackButtonTrackingArea];
        _clearButtonTrackingArea = [[NSTrackingArea alloc] initWithRect:[self clearButtonRect] options:0x411 owner:self userInfo:nil]; [self addTrackingArea:_clearButtonTrackingArea];
        _snapBackButtonToolTipTag = [self addToolTipRect:[_snapBackButtonTrackingArea rect] owner:self userData:NULL];
    }
}
- (void)viewWillMoveToWindow:(NSWindow *)window {
    if ([self window]) [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignKeyNotification object:[self window]];
    if (window) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRecording) name:NSWindowDidResignKeyNotification object:window];
    [super viewWillMoveToWindow:window];
}
- (BOOL)acceptsFirstResponder { return [self isEnabled]; }
- (BOOL)becomeFirstResponder { if (floor(NSAppKitVersionNumber) <= 1038) [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]]; return [super becomeFirstResponder]; }
- (BOOL)resignFirstResponder { if (floor(NSAppKitVersionNumber) <= 1038) [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]]; [self endRecording]; _mouseTrackingButtonTag = NSUIntegerMax; return [super resignFirstResponder]; }
- (BOOL)acceptsFirstMouse:(NSEvent *)event { return YES; }
- (BOOL)canBecomeKeyView { return [super canBecomeKeyView] && [NSApp isFullKeyboardAccessEnabled]; }
- (BOOL)needsPanelToBecomeKey { return YES; }
- (void)mouseDown:(NSEvent *)event {
    if (![self isEnabled]) { [super mouseDown:event]; return; }
    NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    if (![self isRecording]) {
        if ([self mouse:point inRect:[self bounds]]) { _mouseTrackingButtonTag = 2; [self setNeedsDisplay:YES]; }
        else [super mouseDown:event];
    } else if ([self mouse:point inRect:[self snapBackButtonRect]]) { _mouseTrackingButtonTag = 0; [self setNeedsDisplayInRect:[self snapBackButtonRect]]; }
    else if ([self mouse:point inRect:[self clearButtonRect]]) { _mouseTrackingButtonTag = 1; [self setNeedsDisplayInRect:[self clearButtonRect]]; }
    else [super mouseDown:event];
}
- (void)mouseUp:(NSEvent *)event {
    if (![self isEnabled] || _mouseTrackingButtonTag == NSUIntegerMax) { [super mouseUp:event]; return; }
    if (![[self window] isKeyWindow]) [self setNeedsDisplay:YES];
    else {
        NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
        if (_mouseTrackingButtonTag == 2 && [self mouse:point inRect:[self bounds]]) [self beginRecording];
        else if (_mouseTrackingButtonTag == 0 && [self mouse:point inRect:[self snapBackButtonRect]]) [self endRecording];
        else if (_mouseTrackingButtonTag == 1 && [self mouse:point inRect:[self clearButtonRect]]) [self clearAndEndRecording];
    }
    _mouseTrackingButtonTag = NSUIntegerMax;
}
- (void)mouseEntered:(NSEvent *)event {
    if (![self isEnabled]) { [super mouseEntered:event]; return; }
    if ((_mouseTrackingButtonTag == 2 && [event trackingArea] == _mainButtonTrackingArea) || (_mouseTrackingButtonTag == 0 && [event trackingArea] == _snapBackButtonTrackingArea) || (_mouseTrackingButtonTag == 1 && [event trackingArea] == _clearButtonTrackingArea)) [self setNeedsDisplayInRect:[[event trackingArea] rect]];
    [super mouseEntered:event];
}
- (void)mouseExited:(NSEvent *)event {
    if (![self isEnabled]) { [super mouseExited:event]; return; }
    if ((_mouseTrackingButtonTag == 2 && [event trackingArea] == _mainButtonTrackingArea) || (_mouseTrackingButtonTag == 0 && [event trackingArea] == _snapBackButtonTrackingArea) || (_mouseTrackingButtonTag == 1 && [event trackingArea] == _clearButtonTrackingArea)) [self setNeedsDisplayInRect:[[event trackingArea] rect]];
    [super mouseExited:event];
}
- (void)keyDown:(NSEvent *)event { if (![self performKeyEquivalent:event]) [super keyDown:event]; }
- (BOOL)performKeyEquivalent:(NSEvent *)event {
    if (![self isEnabled] || [[self window] firstResponder] != self || _mouseTrackingButtonTag != NSUIntegerMax) return NO;
    if (![self isRecording]) return [event keyCode] == 49 ? [self beginRecording] : NO;
    if ([event keyCode] == 0xffff) return NO;
    if ([self allowsEscapeToCancelRecording] && [event keyCode] == 53 && !([event modifierFlags] & 0x1e0000)) { [self endRecording]; return YES; }
    if ([self allowsDeleteToClearShortcutAndEndRecording] && ([event keyCode] == 51 || [event keyCode] == 117) && !([event modifierFlags] & 0x1e0000)) { [self clearAndEndRecording]; return YES; }
    if (![self areModifierFlagsValid:[event modifierFlags] forKeyCode:[event keyCode]]) return NO;
    NSDictionary *value = @{@"keyCode":@([event keyCode]), @"modifierFlags":@([event modifierFlags] & 0x1e0000), @"characters":[event characters], @"charactersIgnoringModifiers":[event charactersIgnoringModifiers]};
    if (![[self delegate] respondsToSelector:@selector(shortcutRecorder:canRecordShortcut:)] || [[self delegate] shortcutRecorder:self canRecordShortcut:value]) [self endRecordingWithObjectValue:value];
    return YES;
}
- (void)flagsChanged:(NSEvent *)event {
    if ([self isRecording]) {
        NSUInteger flags = [event modifierFlags] & 0x1e0000;
        if (flags && ![self areModifierFlagsValid:flags forKeyCode:[event keyCode]]) NSBeep();
        [self setNeedsDisplay:YES];
    }
    [super flagsChanged:event];
}
+ (void)initialize { if (self == [SRRecorderControl class]) { [self exposeBinding:NSValueBinding]; [self exposeBinding:NSEnabledBinding]; } }
@end
