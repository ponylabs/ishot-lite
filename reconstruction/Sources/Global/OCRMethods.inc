// Lite intentionally removes OCR/translation. Keep selectors compatible with
// shipped nibs and old one-step-action preferences; no OCR/network work is run.
+ (void)startOCRAtScreenRect:(CGRect)rect {}
+ (void)startOCRFromImage:(NSImage *)image {}
