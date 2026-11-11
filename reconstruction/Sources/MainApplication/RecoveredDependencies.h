#import <Cocoa/Cocoa.h>

// Generated from shipped Objective-C metadata; declarations only.
// Object encodings carry ABI type id; concrete object/block signatures may be unknown.

@interface RecordAudioController : NSWindowController
- (id)initFromXib; // 0x100006380
- (void)observeValueForKeyPath:(id)arg0 ofObject:(id)arg1 change:(id)arg2 context:(void *)arg3; // 0x10000659c
- (void)awakeFromNib; // 0x100006930
- (void)checkButtonOfSystemSoundClick:(id)arg0; // 0x100006fa8
- (void)handleNSPopUpButtonWillPopUpNotification:(id)arg0; // 0x100007368
- (void)setMenuForMicroPhoneButton; // 0x10000736c
- (void)windowDidLoad; // 0x1000077e8
- (void)startBtnClick:(id)arg0; // 0x10000781c
- (void)pauseBtnClick:(id)arg0; // 0x100007c10
- (void)stopBtnClick:(id)arg0; // 0x100007cf0
- (void)refreshiShotMultiOutputDevice; // 0x100008018
- (void)refreshiShotAggregateDevice; // 0x100008288
- (void)updateMeters; // 0x100008618
- (void)windowWillClose:(id)arg0; // 0x100008810
- (void)actionWhenWindowOpened; // 0x100008b74
- (BOOL)isRecording; // 0x10000917c
- (void)setIsRecording:(BOOL)arg0; // 0x10000918c
- (id)linearPCMAudioCapture; // 0x10000919c
- (void)setLinearPCMAudioCapture:(id)arg0; // 0x1000091ac
- (id)audioCaptureOfAAC; // 0x1000091c0
- (void)setAudioCaptureOfAAC:(id)arg0; // 0x1000091d0
- (BOOL)isAudioFormatLinearPCM; // 0x1000091e4
- (void)setIsAudioFormatLinearPCM:(BOOL)arg0; // 0x1000091f4
- (id)popupButtonOfMicrophone; // 0x100009204
- (void)setPopupButtonOfMicrophone:(id)arg0; // 0x100009214
- (id)textFieldOfRecordeTime; // 0x100009228
- (void)setTextFieldOfRecordeTime:(id)arg0; // 0x100009238
- (id)pauseButton; // 0x10000924c
- (void)setPauseButton:(id)arg0; // 0x10000925c
- (id)startButton; // 0x100009270
- (void)setStartButton:(id)arg0; // 0x100009280
- (id)stopButton; // 0x100009294
- (void)setStopButton:(id)arg0; // 0x1000092a4
- (id)checkButtonOfSystemSound; // 0x1000092b8
- (void)setCheckButtonOfSystemSound:(id)arg0; // 0x1000092c8
- (id)microPhoneImageView; // 0x1000092dc
- (void)setMicroPhoneImageView:(id)arg0; // 0x1000092ec
@end

@interface Global : NSObject
+ (void)hideCursor; // 0x10000cd0c
+ (void)showCursor; // 0x10000cd68
+ (BOOL)notOnlyWhiteColorInQQOrWeChat:(id)arg0; // 0x10000cd7c
+ (BOOL)sameArrColumn:(id)arg0 to:(id)arg1; // 0x10000cf24
+ (int)getSameColorValueInArrColumn:(id)arg0 from:(int)arg1 withUp:(BOOL)arg2; // 0x10000d078
+ (BOOL)sameArr:(id)arg0 to:(id)arg1; // 0x10000d214
+ (double)_calcuateDistanceOfTwoPoints:(CGPoint)arg0 :(CGPoint)arg1; // 0x10000d4f4
+ (CGRect)calcuateRealRectFromIMageRef:(struct CGImage *)arg0 withOriginalRect:(CGRect)arg1; // 0x10000d510
+ (CGRect)calcuateRealRectFromNSImage:(id)arg0 withOriginalRect:(CGRect)arg1; // 0x10000d7e4
+ (BOOL)checkIfSameColorFromImageRef:(struct CGImage *)arg0; // 0x10000da78
+ (void)restart; // 0x10000db80
+ (void)startOCRAtScreenRect:(CGRect)arg0; // 0x10000dc64
+ (void)startOCRFromImage:(id)arg0; // 0x10000e834
+ (struct CGPath *)CGPathFromPath:(id)arg0; // 0x10000ef58
+ (id)convertStringToImage:(id)arg0; // 0x10000f074
+ (id)convertClipboardDataToImage:(BOOL)arg0 withPasteboard:(id)arg1; // 0x10000f218
+ (BOOL)isCorrectRichTextWithAttributedString:(id)arg0; // 0x10000f890
+ (void)drawPencilMosaic:(id)arg0 inRect:(CGRect)arg1 withActived:(BOOL)arg2; // 0x10000fa14
+ (void)saveKeyEventInfo:(id)arg0; // 0x10000fdc4
+ (id)screenShotFromWindowID:(unsigned int)arg0; // 0x1000103d0
+ (void)pinToScreenWithImage:(id)arg0 rect:(CGRect)arg1; // 0x1000104ec
+ (void)saveFlagsChangedEventInfo:(id)arg0; // 0x1000106e8
+ (void)popupRequestScreenCaptureAccess; // 0x100010eec
+ (void)popupRequestPrivacyAccessibilityWithQuit:(BOOL)arg0; // 0x100010ff0
+ (void)checkAllHotKeyForMacosSequoia; // 0x1000111d4
+ (BOOL)haveOnlyOptionAsFlag; // 0x100011690
+ (void)activateAppWithIdentifier:(id)arg0; // 0x100011828
+ (id)fixedKeyCaptionForKeyCode:(unsigned long long)arg0; // 0x100011894
+ (CGRect)currentScreenNotchRect; // 0x1000118b8
+ (void)screenCaptureOverMacOS15:(unsigned int)arg0 withSize:(CGSize)arg1; // 0x1000119b4
+ (id)getImageFromArr:(id)arg0; // 0x100011cf8
+ (BOOL)checkRect:(CGRect)arg0 OverlapWithRect:(CGRect)arg1; // 0x1000121a8
@end

@interface FFmpegCommandToolController : NSWindowController
- (id)initFromXib; // 0x100040664
- (void)awakeFromNib; // 0x1000406e0
- (void)windowDidLoad; // 0x10004073c
- (void)ffmpegTranscodeFrom:(id)arg0 toFile:(id)arg1 withType:(id)arg2; // 0x100040770
- (void)executeFFMPEGTaskWithArgs:(id)arg0 needCallback:(BOOL)arg1; // 0x100040bc0
- (void)notifiedForStdErrorOrtdOutput:(id)arg0; // 0x100041050
- (int)getTotolTimeFrom:(id)arg0; // 0x10004180c
- (void)notifiedForComplete:(id)arg0; // 0x1000418d8
- (void)commandToolfinished; // 0x1000418dc
- (void)deleteFile:(id)arg0; // 0x100041ad4
- (id)windowTitle; // 0x100041b2c
- (void)setWindowTitle:(id)arg0; // 0x100041b3c
- (id)ffmpegTask; // 0x100041b50
- (void)setFfmpegTask:(id)arg0; // 0x100041b60
- (id)progressIndicator; // 0x100041b74
- (void)setProgressIndicator:(id)arg0; // 0x100041b84
- (id)progressTextField; // 0x100041b98
- (void)setProgressTextField:(id)arg0; // 0x100041ba8
- (id)leftTimeTextField; // 0x100041bbc
- (void)setLeftTimeTextField:(id)arg0; // 0x100041bcc
- (id)type; // 0x100041be0
- (void)setType:(id)arg0; // 0x100041bf0
- (id)sourceFile; // 0x100041c04
- (void)setSourceFile:(id)arg0; // 0x100041c14
- (id)targetFile; // 0x100041c28
- (void)setTargetFile:(id)arg0; // 0x100041c38
@end

@interface MenuView : NSView
- (id)initWithFrame:(CGRect)arg0; // 0x1000455bc
- (void)dealloc; // 0x100045e80
- (void)installGlobalMouseMonitor; // 0x100045ec4
- (void)uninstallGlobalMouseMonitor; // 0x100046294
- (void)stopButtonClick:(id)arg0; // 0x10004636c
- (void)annotateButtonClick:(id)arg0; // 0x1000463cc
- (void)durationButtonClick:(id)arg0; // 0x100046408
- (void)endRecord; // 0x1000464b0
- (void)pauseButtonClick:(id)arg0; // 0x100046570
- (void)timerDurationTimeOut:(id)arg0; // 0x1000467dc
- (void)drawRect:(CGRect)arg0; // 0x10004699c
- (void)keyDown:(id)arg0; // 0x1000469a0
- (void)mouseMoved:(id)arg0; // 0x1000469a4
- (void)mouseExited:(id)arg0; // 0x1000469a8
- (void)mouseEntered:(id)arg0; // 0x1000469c4
- (void)mouseUp:(id)arg0; // 0x1000469e0
- (id)annotateButton; // 0x1000469e4
- (void)setAnnotateButton:(id)arg0; // 0x1000469f4
- (id)stopButton; // 0x100046a08
- (void)setStopButton:(id)arg0; // 0x100046a18
- (id)pauseButton; // 0x100046a2c
- (void)setPauseButton:(id)arg0; // 0x100046a3c
- (id)durationButton; // 0x100046a50
- (void)setDurationButton:(id)arg0; // 0x100046a60
- (id)mouseDownMonitor; // 0x100046a74
- (void)setMouseDownMonitor:(id)arg0; // 0x100046a84
- (id)mouseUpMonitor; // 0x100046a94
- (void)setMouseUpMonitor:(id)arg0; // 0x100046aa4
@end

@interface PinLibraryController : NSWindowController
- (id)init; // 0x1000471fc
- (void)deleteAllPin:(id)arg0; // 0x1000472ac
- (void)refreshCollectionView; // 0x1000473e8
- (id)getFilesAtPathSortedByModificationDate:(id)arg0; // 0x1000474b4
- (void)awakeFromNib; // 0x100047948
- (void)windowDidBecomeKey:(id)arg0; // 0x100047b74
- (void)windowWillClose:(id)arg0; // 0x100047b78
- (void)keyDown:(id)arg0; // 0x100047b7c
- (void)keyUp:(id)arg0; // 0x100047bf0
- (long long)collectionView:(id)arg0 numberOfItemsInSection:(long long)arg1; // 0x100047bf8
- (id)collectionView:(id)arg0 itemForRepresentedObjectAtIndexPath:(id)arg1; // 0x100047c04
- (id)PinLibraryCollectionView; // 0x100047cb0
- (void)setPinLibraryCollectionView:(id)arg0; // 0x100047cc0
@end

@interface MXClipScreenManager : NSObject
- (id)init; // 0x10005daa4
- (void)startCaptureFromPinAnnotate:(BOOL)arg0; // 0x10005dc3c
- (void)changeKeyWindowWithScreen:(id)arg0; // 0x10005f2d8
- (void)reset; // 0x10005f440
- (void)clearClipWindowControllerArray; // 0x10005f468
- (void)clipWindowController:(id)arg0; // 0x10005f608
- (void)clipWindowControllerDidCancel:(id)arg0; // 0x10005f60c
- (void)startScreenShots; // 0x10005f708
- (void)startAnnotation; // 0x10005f92c
- (void)cancelScreenShot; // 0x10005fa1c
- (void)refreshMosaicDrawRect; // 0x10005fb24
- (void)refreshHighlightDrawRect; // 0x10005fc74
- (void)scrollScreenShot; // 0x10005fdc4
- (void)disableTextView; // 0x10005ff14
- (BOOL)isWorking; // 0x100060064
- (void)setIsWorking:(BOOL)arg0; // 0x10006006c
- (id)clipWindowControllerArray; // 0x100060074
- (void)setClipWindowControllerArray:(id)arg0; // 0x10006007c
+ (id)sharedInstance; // 0x10005da08
@end

@interface MXRecordScreenManager : NSObject
- (id)init; // 0x100061864
- (void)readyToRecordScreen; // 0x10006197c
- (void)changeKeyWindowWithScreen:(id)arg0; // 0x100061ce8
- (void)reset; // 0x100061e50
- (void)recordScreenWindowController:(id)arg0 finishRecordWithFileName:(id)arg1 saveToLocal:(BOOL)arg2; // 0x100061e90
- (void)recordScreenWindowControllerDidSelectRegion:(id)arg0; // 0x100061ed4
- (void)recordScreenWindowControllerRemoveEventMonitor:(id)arg0; // 0x100061ff8
- (void)recordScreenWindowControllerDidCancel:(id)arg0; // 0x100062038
- (void)clearRecordWindowControllerArray; // 0x100062248
- (id)arrayRect; // 0x10006231c
- (void)setArrayRect:(id)arg0; // 0x100062324
- (BOOL)isWorking; // 0x100062330
- (void)setIsWorking:(BOOL)arg0; // 0x100062338
- (id)recordWindowControllerArray; // 0x100062340
- (void)setRecordWindowControllerArray:(id)arg0; // 0x100062348
+ (id)sharedInstance; // 0x1000617f4
@end

@interface AnnotatedImageController : NSWindowController
- (id)initWithWindow:(id)arg0; // 0x100078760
- (void)setAnnotatedImageViewFrame:(CGRect)arg0; // 0x100078820
- (void)windowDidLoad; // 0x100078914
- (void)updateToolbarBoxStyle; // 0x1000799b0
- (void)setTextColor:(id)arg0 inView:(id)arg1; // 0x100079f0c
- (void)selectTextFont:(id)arg0; // 0x10007a064
- (void)selectNoteFont:(id)arg0; // 0x10007a1c0
- (void)displayChanged:(id)arg0; // 0x10007a31c
- (void)resetButtonBox; // 0x10007a3f0
- (void)ignoresMouseEvents:(BOOL)arg0; // 0x10007bb3c
- (void)handleMouseEvent:(id)arg0; // 0x10007bb74
- (BOOL)canBecomeKeyWindow; // 0x10007bdac
- (BOOL)canBecomeMainWindow; // 0x10007bdb4
- (void)keyDown:(id)arg0; // 0x10007bdbc
- (void)mouseMoved:(id)arg0; // 0x10007bdd8
- (void)draggedAllToolBar:(id)arg0; // 0x10007cc7c
- (void)flagsChanged:(id)arg0; // 0x10007cfd0
- (void)checkMouseIfOnTipsBox; // 0x10007d274
- (void)checkMouseOnWhichButton; // 0x10007d3a8
- (void)disableTips; // 0x10007e0c4
- (void)getUsersData; // 0x10007e320
- (BOOL)windowShouldClose:(id)arg0; // 0x10007e84c
- (id)getFunctionFromNumber:(int)arg0; // 0x10007e854
- (void)enableUndoButton; // 0x10007e878
- (void)disEnableUndoButton; // 0x10007e8ac
- (void)disEnableScrollScreenShotButton; // 0x10007e8e0
- (void)observeValueForKeyPath:(id)arg0 ofObject:(id)arg1 change:(id)arg2 context:(void *)arg3; // 0x10007e914
- (void)scrollScreenshotButtonClick:(id)arg0; // 0x10007f260
- (void)squareButtonClick:(id)arg0; // 0x10007f870
- (void)ellipseButtonClick:(id)arg0; // 0x10007fa58
- (void)lineButtonClick:(id)arg0; // 0x10007fc08
- (void)arrowButtonClick:(id)arg0; // 0x10007fdb8
- (void)pencilButtonClick:(id)arg0; // 0x10007ff68
- (void)zoomButtonClick:(id)arg0; // 0x100080118
- (void)mosaicButtonClick:(id)arg0; // 0x100080134
- (void)textButtonClick:(id)arg0; // 0x100080434
- (void)noteButtonClick:(id)arg0; // 0x1000805e4
- (void)highlightButtonClick:(id)arg0; // 0x100080794
- (void)squareButtonState; // 0x1000808fc
- (void)ellipseButtonState; // 0x100080d2c
- (void)lineButtonState; // 0x1000810e0
- (void)arrowButtonState; // 0x1000812d4
- (void)pencilPenButtonState; // 0x100081600
- (void)mosaicButtonState; // 0x100081910
- (void)textButtonState; // 0x100081be8
- (void)noteButtonState; // 0x100081fec
- (void)highlightButtonState; // 0x1000823f0
- (void)adjustTextSizeOrFont; // 0x100082694
- (void)refreshAllButtonState; // 0x100082834
- (void)cancelButtonClick:(id)arg0; // 0x100083198
- (void)OCRButtonClick:(id)arg0; // 0x10008330c
- (void)saveAsFile; // 0x100083630
- (void)undoButton:(id)arg0; // 0x100083644
- (void)redoButton:(id)arg0; // 0x100083740
- (void)clearButtonClick:(id)arg0; // 0x1000837a4
- (void)mapButtonClick:(id)arg0; // 0x1000837c0
- (void)saveButtonClick:(id)arg0; // 0x100083a78
- (void)copyToPasteButtonClick:(id)arg0; // 0x100083e0c
- (void)scrollScreenshotErrorWarnButtonClick:(id)arg0; // 0x100084020
- (void)sliderOfSizeSlide:(id)arg0; // 0x100084070
- (void)sliderOfOpacitySlide:(id)arg0; // 0x10008414c
- (void)refreshAllSizeAndDrawRect:(id)arg0; // 0x10008446c
- (void)adjustColorAndSizeButton:(int)arg0; // 0x1000848fc
- (void)selectColor1ButtonClick:(id)arg0; // 0x1000852c8
- (void)selectColor2ButtonClick:(id)arg0; // 0x100085410
- (void)selectColor3ButtonClick:(id)arg0; // 0x100085558
- (void)selectColor4ButtonClick:(id)arg0; // 0x1000856a0
- (void)selectColor5ButtonClick:(id)arg0; // 0x1000857e8
- (void)selectColor6ButtonClick:(id)arg0; // 0x100085930
- (void)getActivedColorBox:(id)arg0; // 0x100085acc
- (void)closeWindow; // 0x100085db4
- (void)hiddenButton; // 0x1000861a8
- (void)unhiddenButton; // 0x100086228
- (void)openWindow; // 0x1000862d4
- (void)showPicker:(id)arg0; // 0x100086be4
- (void)colorChanged:(id)arg0; // 0x100086d20
- (void)costomHotKey; // 0x100086ebc
- (void)unregisterAllHotKey; // 0x100087100
- (void)scrollFinished; // 0x100087168
- (void)scrollWheelFromTextView:(id)arg0; // 0x100087174
- (void)scrollWheel:(id)arg0; // 0x100087584
- (void)adjustColorOpacityByScrollWheelEvent:(float)arg0; // 0x100087f78
- (void)resetCursor; // 0x1000882c4
- (BOOL)isOnStrokesUnderMouse:(CGPoint)arg0; // 0x100088b0c
- (double)angleBetweenPoint:(CGPoint)arg0 and:(CGPoint)arg1; // 0x100089920
- (double)distanceBetweenPoint:(CGPoint)arg0 and:(CGPoint)arg1; // 0x100089930
- (BOOL)point:(CGPoint)arg0 andPoint:(CGPoint)arg1 crossWithCyclePoint:(CGPoint)arg2 radius:(float)arg3; // 0x10008994c
- (id)pasteLeftSideDistance; // 0x100089a54
- (void)setPasteLeftSideDistance:(id)arg0; // 0x100089a74
- (id)colorBox1; // 0x100089a88
- (void)setColorBox1:(id)arg0; // 0x100089aa8
- (id)colorBox2; // 0x100089abc
- (void)setColorBox2:(id)arg0; // 0x100089adc
- (id)colorBox3; // 0x100089af0
- (void)setColorBox3:(id)arg0; // 0x100089b10
- (id)colorBox4; // 0x100089b24
- (void)setColorBox4:(id)arg0; // 0x100089b44
- (id)colorBox5; // 0x100089b58
- (void)setColorBox5:(id)arg0; // 0x100089b78
- (id)userColorSingleBox; // 0x100089b8c
- (void)setUserColorSingleBox:(id)arg0; // 0x100089bac
- (id)displaySize; // 0x100089bc0
- (void)setDisplaySize:(id)arg0; // 0x100089be0
- (id)displayOpacity; // 0x100089bf4
- (void)setDisplayOpacity:(id)arg0; // 0x100089c14
- (id)squareButton; // 0x100089c28
- (void)setSquareButton:(id)arg0; // 0x100089c48
- (id)ellipseButton; // 0x100089c5c
- (void)setEllipseButton:(id)arg0; // 0x100089c7c
- (id)lineButton; // 0x100089c90
- (void)setLineButton:(id)arg0; // 0x100089cb0
- (id)arrowButton; // 0x100089cc4
- (void)setArrowButton:(id)arg0; // 0x100089ce4
- (id)pencilPenButton; // 0x100089cf8
- (void)setPencilPenButton:(id)arg0; // 0x100089d18
- (id)mosaicButton; // 0x100089d2c
- (void)setMosaicButton:(id)arg0; // 0x100089d4c
- (id)textButton; // 0x100089d60
- (void)setTextButton:(id)arg0; // 0x100089d80
- (id)noteButton; // 0x100089d94
- (void)setNoteButton:(id)arg0; // 0x100089db4
- (id)highlightButton; // 0x100089dc8
- (void)setHighlightButton:(id)arg0; // 0x100089de8
- (id)undoButton; // 0x100089dfc
- (void)setUndoButton:(id)arg0; // 0x100089e1c
- (id)mapButton; // 0x100089e30
- (void)setMapButton:(id)arg0; // 0x100089e50
- (id)OCRButton; // 0x100089e64
- (void)setOCRButton:(id)arg0; // 0x100089e84
- (id)cancelButton; // 0x100089e98
- (void)setCancelButton:(id)arg0; // 0x100089eb8
- (id)saveButton; // 0x100089ecc
- (void)setSaveButton:(id)arg0; // 0x100089eec
- (id)pasteButton; // 0x100089f00
- (void)setPasteButton:(id)arg0; // 0x100089f20
- (id)sliderOfSize; // 0x100089f34
- (void)setSliderOfSize:(id)arg0; // 0x100089f54
- (id)textFieldOfSize; // 0x100089f68
- (void)setTextFieldOfSize:(id)arg0; // 0x100089f88
- (id)sliderOfOpacity; // 0x100089f9c
- (void)setSliderOfOpacity:(id)arg0; // 0x100089fbc
- (id)textFieldOfOpacity; // 0x100089fd0
- (void)setTextFieldOfOpacity:(id)arg0; // 0x100089ff0
- (id)boxSquare; // 0x10008a004
- (void)setBoxSquare:(id)arg0; // 0x10008a024
- (id)boxEllipse; // 0x10008a038
- (void)setBoxEllipse:(id)arg0; // 0x10008a058
- (id)boxLine; // 0x10008a06c
- (void)setBoxLine:(id)arg0; // 0x10008a08c
- (id)boxArrow; // 0x10008a0a0
- (void)setBoxArrow:(id)arg0; // 0x10008a0c0
- (id)boxPencil; // 0x10008a0d4
- (void)setBoxPencil:(id)arg0; // 0x10008a0f4
- (id)boxMosaic; // 0x10008a108
- (void)setBoxMosaic:(id)arg0; // 0x10008a128
- (id)boxSelectMosaic; // 0x10008a13c
- (void)setBoxSelectMosaic:(id)arg0; // 0x10008a15c
- (id)boxSelectHighlight; // 0x10008a170
- (void)setBoxSelectHighlight:(id)arg0; // 0x10008a190
- (id)boxText; // 0x10008a1a4
- (void)setBoxText:(id)arg0; // 0x10008a1c4
- (id)boxNote; // 0x10008a1d8
- (void)setBoxNote:(id)arg0; // 0x10008a1f8
- (id)boxHighlight; // 0x10008a20c
- (void)setBoxHighlight:(id)arg0; // 0x10008a22c
- (id)boxOCR; // 0x10008a240
- (void)setBoxOCR:(id)arg0; // 0x10008a260
- (id)boxUndo; // 0x10008a274
- (void)setBoxUndo:(id)arg0; // 0x10008a294
- (id)boxMap; // 0x10008a2a8
- (void)setBoxMap:(id)arg0; // 0x10008a2c8
- (id)boxZoom; // 0x10008a2dc
- (void)setBoxZoom:(id)arg0; // 0x10008a2fc
- (id)boxClear; // 0x10008a310
- (void)setBoxClear:(id)arg0; // 0x10008a330
- (id)boxCancel; // 0x10008a344
- (void)setBoxCancel:(id)arg0; // 0x10008a364
- (id)boxScrollScreenshot; // 0x10008a378
- (void)setBoxScrollScreenshot:(id)arg0; // 0x10008a398
- (id)boxSave; // 0x10008a3ac
- (void)setBoxSave:(id)arg0; // 0x10008a3cc
- (id)boxCopyToPaste; // 0x10008a3e0
- (void)setBoxCopyToPaste:(id)arg0; // 0x10008a400
- (id)boxSquare2; // 0x10008a414
- (void)setBoxSquare2:(id)arg0; // 0x10008a434
- (id)boxEllipse2; // 0x10008a448
- (void)setBoxEllipse2:(id)arg0; // 0x10008a468
- (id)boxArrow2; // 0x10008a47c
- (void)setBoxArrow2:(id)arg0; // 0x10008a49c
- (id)boxText2; // 0x10008a4b0
- (void)setBoxText2:(id)arg0; // 0x10008a4d0
- (id)boxNote2; // 0x10008a4e4
- (void)setBoxNote2:(id)arg0; // 0x10008a504
- (id)boxPencil2; // 0x10008a518
- (void)setBoxPencil2:(id)arg0; // 0x10008a538
- (id)popUpButtonSquare; // 0x10008a54c
- (void)setPopUpButtonSquare:(id)arg0; // 0x10008a56c
- (id)popUpButtonEllipse; // 0x10008a580
- (void)setPopUpButtonEllipse:(id)arg0; // 0x10008a5a0
- (id)popUpButtonLine; // 0x10008a5b4
- (void)setPopUpButtonLine:(id)arg0; // 0x10008a5d4
- (id)popUpButtonArrow; // 0x10008a5e8
- (void)setPopUpButtonArrow:(id)arg0; // 0x10008a608
- (id)popUpButtonPencil; // 0x10008a61c
- (void)setPopUpButtonPencil:(id)arg0; // 0x10008a63c
- (id)popUpButtonMosaic; // 0x10008a650
- (void)setPopUpButtonMosaic:(id)arg0; // 0x10008a670
- (id)popUpButtonText; // 0x10008a684
- (void)setPopUpButtonText:(id)arg0; // 0x10008a6a4
- (id)popUpButtonNote; // 0x10008a6b8
- (void)setPopUpButtonNote:(id)arg0; // 0x10008a6d8
- (id)popUpButtonHighlight; // 0x10008a6ec
- (void)setPopUpButtonHighlight:(id)arg0; // 0x10008a70c
- (id)popUpButtonOCR; // 0x10008a720
- (void)setPopUpButtonOCR:(id)arg0; // 0x10008a740
- (id)popUpButtonMap; // 0x10008a754
- (void)setPopUpButtonMap:(id)arg0; // 0x10008a774
- (id)popUpButtonClear; // 0x10008a788
- (void)setPopUpButtonClear:(id)arg0; // 0x10008a7a8
- (id)popUpButtonZoom; // 0x10008a7bc
- (void)setPopUpButtonZoom:(id)arg0; // 0x10008a7dc
- (id)popUpButtonScrollScreenshot; // 0x10008a7f0
- (void)setPopUpButtonScrollScreenshot:(id)arg0; // 0x10008a810
- (id)popUpButtonSave; // 0x10008a824
- (void)setPopUpButtonSave:(id)arg0; // 0x10008a844
- (id)popUpButtonCopyToPaste; // 0x10008a858
- (void)setPopUpButtonCopyToPaste:(id)arg0; // 0x10008a878
- (id)popUpButtonTextFont; // 0x10008a88c
- (void)setPopUpButtonTextFont:(id)arg0; // 0x10008a8ac
- (id)popUpButtonNoteFont; // 0x10008a8c0
- (void)setPopUpButtonNoteFont:(id)arg0; // 0x10008a8e0
- (id)willOpenPopUpButton; // 0x10008a8f4
- (void)setWillOpenPopUpButton:(id)arg0; // 0x10008a914
- (id)cpToPasteOrUpdateMapOfTextField; // 0x10008a928
- (void)setCpToPasteOrUpdateMapOfTextField:(id)arg0; // 0x10008a948
- (id)indicatorFieldWidth; // 0x10008a95c
- (void)setIndicatorFieldWidth:(id)arg0; // 0x10008a97c
- (id)indicatorFieldHeight; // 0x10008a990
- (void)setIndicatorFieldHeight:(id)arg0; // 0x10008a9b0
- (id)semaphore; // 0x10008a9c4
- (void)setSemaphore:(id)arg0; // 0x10008a9d4
- (id)imageFilePath; // 0x10008a9e0
- (void)setImageFilePath:(id)arg0; // 0x10008a9f0
- (BOOL)userCanceled; // 0x10008a9fc
- (void)setUserCanceled:(BOOL)arg0; // 0x10008aa10
- (id)backgroundImageWindow; // 0x10008aa20
- (void)setBackgroundImageWindow:(id)arg0; // 0x10008aa40
- (id)buttonBox; // 0x10008aa54
- (void)setButtonBox:(id)arg0; // 0x10008aa74
- (id)colorBox; // 0x10008aa88
- (void)setColorBox:(id)arg0; // 0x10008aaa8
- (id)realColorBox; // 0x10008aabc
- (void)setRealColorBox:(id)arg0; // 0x10008aadc
- (id)sanjiao; // 0x10008aaf0
- (void)setSanjiao:(id)arg0; // 0x10008ab10
- (id)scrollScreenshotButton; // 0x10008ab24
- (void)setScrollScreenshotButton:(id)arg0; // 0x10008ab44
- (id)scrollScreenshotErrorWarnButton; // 0x10008ab58
- (void)setScrollScreenshotErrorWarnButton:(id)arg0; // 0x10008ab78
- (id)openedBoxOfTips; // 0x10008ab8c
- (void)setOpenedBoxOfTips:(id)arg0; // 0x10008abac
@end

@interface YLAppRating : NSObject
+ (void)showWithAppID:(id)arg0; // 0x10009c254
+ (void)showWithAppID:(id)arg0 minExecCount:(long long)arg1 daysSinceFirstLaunch:(long long)arg2 daysSinceLastPrompt:(long long)arg3 delayInSeconds:(long long)arg4; // 0x10009c268
@end

@interface LCPermissionModel : NSObject
- (id)initWithAuthType:(long long)arg0 desc:(id)arg1; // 0x10009f630
- (long long)authType; // 0x10009f708
- (void)setAuthType:(long long)arg0; // 0x10009f710
- (id)desc; // 0x10009f718
- (void)setDesc:(id)arg0; // 0x10009f720
+ (id)modelWithAuthType:(long long)arg0 desc:(id)arg1; // 0x10009f6b0
@end

@interface LCAuthGuideKit : NSObject
- (id)init; // 0x1000a0674
- (void)showPermissionAuth:(id)arg0; // 0x1000a06d0
- (BOOL)isPermissionGranted:(long long)arg0; // 0x1000a0b10
- (void)passAuth; // 0x1000a0b6c
- (void)skipAuth; // 0x1000a0bf8
- (void)dismissAuthWindow; // 0x1000a0c64
- (void)openPrivacyAccessibilitySetting; // 0x1000a11f8
- (void)openScreenCaptureSetting; // 0x1000a12b4
- (void)openFullDiskAccessSetting; // 0x1000a13b0
- (id)tutorialLink; // 0x1000a15dc
- (void)setTutorialLink:(id)arg0; // 0x1000a15e4
- (BOOL)shouldTerminateOnClose; // 0x1000a15ec
- (void)setShouldTerminateOnClose:(BOOL)arg0; // 0x1000a15f4
- (id)closeWindowAlertMessage; // 0x1000a15fc
- (void)setCloseWindowAlertMessage:(id)arg0; // 0x1000a1604
- (id /* block signature absent from encoding */)allAuthPassedHandler; // 0x1000a160c
- (void)setAllAuthPassedHandler:(id /* block signature absent from encoding */)arg0; // 0x1000a1614
- (id)permissionWC; // 0x1000a161c
- (void)setPermissionWC:(id)arg0; // 0x1000a1624
- (id)monitorTimer; // 0x1000a1630
- (void)setMonitorTimer:(id)arg0; // 0x1000a1638
+ (id)shared; // 0x1000a0604
+ (BOOL)getPrivacyAccessibilityIsEnabled; // 0x1000a0cd0
+ (BOOL)getScreenCaptureIsEnabled; // 0x1000a0cec
+ (BOOL)getFullDiskAccessIsEnabled; // 0x1000a0f60
+ (BOOL)isInputMonitoringEnabled; // 0x1000a11b0
+ (id)bundle; // 0x1000a1414
+ (id)localizedString:(id)arg0; // 0x1000a14c4
+ (id)bundleImage:(id)arg0; // 0x1000a1540
@end

@interface AppSandboxFileAccess : NSObject
- (id)initWithMessage:(id)arg0; // 0x1000b81d8
- (id)askPermissionForURL:(id)arg0; // 0x1000b83d8
- (id)persistPermissionPath:(id)arg0; // 0x1000b8a0c
- (id)persistPermissionURL:(id)arg0; // 0x1000b8a64
- (BOOL)accessFilePath:(id)arg0 withBlock:(id /* block signature absent from encoding */)arg1 persistPermission:(BOOL)arg2; // 0x1000b8aec
- (BOOL)accessFileURL:(id)arg0 withBlock:(id /* block signature absent from encoding */)arg1 persistPermission:(BOOL)arg2; // 0x1000b8afc
- (BOOL)accessFilePath:(id)arg0 persistPermission:(BOOL)arg1 withBlock:(id /* block signature absent from encoding */)arg2; // 0x1000b8b0c
- (BOOL)accessFileURL:(id)arg0 persistPermission:(BOOL)arg1 withBlock:(id /* block signature absent from encoding */)arg2; // 0x1000b8b98
- (BOOL)requestAccessPermissionsForFilePath:(id)arg0 persistPermission:(BOOL)arg1 withBlock:(id /* block signature absent from encoding */)arg2; // 0x1000b8cb8
- (BOOL)requestAccessPermissionsForFileURL:(id)arg0 persistPermission:(BOOL)arg1 withBlock:(id /* block signature absent from encoding */)arg2; // 0x1000b8d44
- (void)setBookmarkPersistanceDelegate:(id)arg0; // 0x1000b8f00
- (id)title; // 0x1000b8f58
- (void)setTitle:(id)arg0; // 0x1000b8f60
- (id)message; // 0x1000b8f68
- (void)setMessage:(id)arg0; // 0x1000b8f70
- (id)prompt; // 0x1000b8f78
- (void)setPrompt:(id)arg0; // 0x1000b8f80
- (id)bookmarkPersistanceDelegate; // 0x1000b8f88
- (id)defaultDelegate; // 0x1000b8fa0
- (void)setDefaultDelegate:(id)arg0; // 0x1000b8fa8
+ (id)fileAccessWithMessage:(id)arg0; // 0x1000b818c
@end

@interface AppPrefsWindowController : NSWindowController
- (id)init; // 0x1000bd710
- (void)windowDidBecomeKey:(id)arg0; // 0x1000bdcfc
- (void)checkAllOpenSavePath; // 0x1000be1e4
- (void)setupLeftMenuTableView; // 0x1000be384
- (void)windowDidLoad; // 0x1000bed88
- (void)systemThemeChanged:(id)arg0; // 0x1000beef4
- (void)awakeFromNib; // 0x1000bef78
- (void)observeValueForKeyPath:(id)arg0 ofObject:(id)arg1 change:(id)arg2 context:(void *)arg3; // 0x1000c01dc
- (BOOL)control:(id)arg0 textShouldEndEditing:(id)arg1; // 0x1000c05a4
- (long long)collectionView:(id)arg0 numberOfItemsInSection:(long long)arg1; // 0x1000c0634
- (id)collectionView:(id)arg0 itemForRepresentedObjectAtIndexPath:(id)arg1; // 0x1000c069c
- (void)shortcutRecorderWillBegin; // 0x1000c0784
- (double)tableView:(id)arg0 heightOfRow:(long long)arg1; // 0x1000c0788
- (long long)numberOfRowsInTableView:(id)arg0; // 0x1000c07c4
- (id)tableView:(id)arg0 viewForTableColumn:(id)arg1 row:(long long)arg2; // 0x1000c0848
- (id)tableViewForScreenShotShortcut:(id)arg0 row:(long long)arg1; // 0x1000c0908
- (id)tableViewForAnnotatedShortcut:(id)arg0 row:(long long)arg1; // 0x1000c0fc0
- (BOOL)tableView:(id)arg0 shouldSelectRow:(long long)arg1; // 0x1000c15b0
- (void)handleNSPopUpButtonWillPopUpNotification:(id)arg0; // 0x1000c15b8
- (BOOL)shortcutRecorder:(id)arg0 shouldUnconditionallyAllowModifierFlags:(unsigned long long)arg1 forKeyCode:(unsigned short)arg2; // 0x1000c1800
- (void)shortcutRecorderDidEndRecording:(id)arg0; // 0x1000c187c
- (void)HotKeyAction:(id)arg0; // 0x1000c1bf8
- (void)selectAppNameToOpen:(id)arg0; // 0x1000c1c4c
- (void)adjustSizeOfShadow:(id)arg0; // 0x1000c20f8
- (void)adjustSizeOfFillet:(id)arg0; // 0x1000c21a4
- (void)adjustPinSizeOfFillet:(id)arg0; // 0x1000c2250
- (void)adjustDefaultTransparencyOfPin:(id)arg0; // 0x1000c22fc
- (void)tryToScreenShotWithShell:(id)arg0; // 0x1000c23a8
- (void)resumeSavePath:(id)arg0; // 0x1000c23e0
- (void)selectSavePath:(id)arg0; // 0x1000c25b0
- (void)selectPathWhenSavePath:(id)arg0; // 0x1000c2c74
- (void)resetCustomizePickColorString:(id)arg0; // 0x1000c2dec
- (void)resetScreenShotShortcutTableView:(id)arg0; // 0x1000c2e54
- (void)resetAnnotatedShortcutTableView:(id)arg0; // 0x1000c2fb0
- (void)resetPinSetting:(id)arg0; // 0x1000c3174
- (void)hideMenuBarIcon:(id)arg0; // 0x1000c3228
- (void)switchTabWithIndex:(long long)arg0; // 0x1000c3288
- (void)rateOnAppStore:(id)arg0; // 0x1000c33c4
- (void)feedbackProblem:(id)arg0; // 0x1000c342c
- (void)QQExchangeGroup:(id)arg0; // 0x1000c3494
- (void)gotoOfficialWebsite:(id)arg0; // 0x1000c34fc
- (void)helpOfRGBprofile:(id)arg0; // 0x1000c3564
- (void)videoOfScreenshotStandardMode:(id)arg0; // 0x1000c35cc
- (void)videoOfScreenshotWindowUnderCursor:(id)arg0; // 0x1000c3634
- (void)videoOfScreenshotPreviousArea:(id)arg0; // 0x1000c369c
- (void)videoOfScreenshotWithShell:(id)arg0; // 0x1000c3704
- (void)videoOfMultiWindowScreenshot:(id)arg0; // 0x1000c37d4
- (void)videoOfScrollScreenshot:(id)arg0; // 0x1000c383c
- (void)videoOfPinPicture:(id)arg0; // 0x1000c38a4
- (void)videoOfPickColor:(id)arg0; // 0x1000c390c
- (void)videoOfRecordScreen:(id)arg0; // 0x1000c3974
- (void)videoOfRecordAudio:(id)arg0; // 0x1000c39dc
- (void)videoOfOCR:(id)arg0; // 0x1000c3a44
- (void)FAQ:(id)arg0; // 0x1000c3aac
- (void)allVideo:(id)arg0; // 0x1000c3b14
- (void)helperOfScreenshotPerformanceMode:(id)arg0; // 0x1000c3b7c
- (void)viewSettingsPermissions:(id)arg0; // 0x1000c3be4
- (void)buttonOfOpenSavePathClick:(id)arg0; // 0x1000c3c4c
- (void)resetDefaults:(id)arg0; // 0x1000c3dcc
- (id)creatNSTextFieldWithStringValue:(id)arg0 isEditable:(BOOL)arg1 atRow:(long long)arg2; // 0x1000c40d0
- (id)version; // 0x1000c422c
- (void)setVersion:(id)arg0; // 0x1000c424c
- (id)iconImageView; // 0x1000c4260
- (void)setIconImageView:(id)arg0; // 0x1000c4280
- (id)selectedAppName; // 0x1000c42c8
- (void)setSelectedAppName:(id)arg0; // 0x1000c42e8
- (id)buttonOfSaveImagePath; // 0x1000c42fc
- (void)setButtonOfSaveImagePath:(id)arg0; // 0x1000c431c
- (id)buttonOfSaveVideoPath; // 0x1000c4330
- (void)setButtonOfSaveVideoPath:(id)arg0; // 0x1000c4350
- (id)buttonOfSaveAudioPath; // 0x1000c4364
- (void)setButtonOfSaveAudioPath:(id)arg0; // 0x1000c4384
- (id)buttonOfOpenPathofSaveScreenShotsPhoto; // 0x1000c4398
- (void)setButtonOfOpenPathofSaveScreenShotsPhoto:(id)arg0; // 0x1000c43b8
- (id)buttonOfOpenPathofSaveVideo; // 0x1000c43cc
- (void)setButtonOfOpenPathofSaveVideo:(id)arg0; // 0x1000c43ec
- (id)buttonOfOpenPathofSaveAudio; // 0x1000c4400
- (void)setButtonOfOpenPathofSaveAudio:(id)arg0; // 0x1000c4420
- (id)openPinLibraryWindowRecorder; // 0x1000c4434
- (void)setOpenPinLibraryWindowRecorder:(id)arg0; // 0x1000c4454
- (id)hiddenAndShowAllPinWindowRecorder; // 0x1000c4468
- (void)setHiddenAndShowAllPinWindowRecorder:(id)arg0; // 0x1000c4488
- (id)mapFromPasteRecorder; // 0x1000c449c
- (void)setMapFromPasteRecorder:(id)arg0; // 0x1000c44bc
- (id)recordScreenRecorder; // 0x1000c44d0
- (void)setRecordScreenRecorder:(id)arg0; // 0x1000c44f0
- (id)pauseScreenRecorder; // 0x1000c4504
- (void)setPauseScreenRecorder:(id)arg0; // 0x1000c4524
- (id)annotateOfScreenRecorder; // 0x1000c4538
- (void)setAnnotateOfScreenRecorder:(id)arg0; // 0x1000c4558
- (id)recordingRecorder; // 0x1000c456c
- (void)setRecordingRecorder:(id)arg0; // 0x1000c458c
- (id)OCRRecorder; // 0x1000c45a0
- (void)setOCRRecorder:(id)arg0; // 0x1000c45c0
- (id)annotatedShortcutScrollView; // 0x1000c4608
- (void)setAnnotatedShortcutScrollView:(id)arg0; // 0x1000c4628
- (id)screenShotShortcutScrollView; // 0x1000c463c
- (void)setScreenShotShortcutScrollView:(id)arg0; // 0x1000c465c
- (id)leftTabTableView; // 0x1000c4670
- (void)setLeftTabTableView:(id)arg0; // 0x1000c4690
- (id)leftTabTitles; // 0x1000c46a4
- (void)setLeftTabTitles:(id)arg0; // 0x1000c46b4
- (id)freeAppsVC; // 0x1000c46c8
- (void)setFreeAppsVC:(id)arg0; // 0x1000c46d8
- (id)leftMenuHandler; // 0x1000c46ec
- (void)setLeftMenuHandler:(id)arg0; // 0x1000c46fc
- (id)leftBox; // 0x1000c4710
- (void)setLeftBox:(id)arg0; // 0x1000c4730
@end

@interface ScreenshotWithShellController : NSWindowController
- (id)initFromXib; // 0x1000c4ca0
- (void)awakeFromNib; // 0x1000c4d1c
- (void)windowDidLoad; // 0x1000c4db8
- (CGSize)collectionView:(id)arg0 layout:(id)arg1 sizeForItemAtIndexPath:(id)arg2; // 0x1000c4e7c
- (long long)collectionView:(id)arg0 numberOfItemsInSection:(long long)arg1; // 0x1000c4f20
- (id)collectionView:(id)arg0 itemForRepresentedObjectAtIndexPath:(id)arg1; // 0x1000c4f88
- (void)autoMatchModels:(id)arg0; // 0x1000c50b8
- (void)pinShellView:(id)arg0; // 0x1000c50c4
- (void)selectedShellName:(id)arg0; // 0x1000c5304
- (void)screenShotWithShellName:(id)arg0; // 0x1000c55a4
- (id)collectionView; // 0x1000c6194
- (void)setCollectionView:(id)arg0; // 0x1000c61b4
@end


@interface NSImage (Screenshot)
- (id)normalRGBBitmapImageRepresentationWithScaleFactor:(double)arg0; // 0x1000bd110
- (id)bitmapImageRepresentationWithScaleFactor:(float)arg0; // 0x1000bd238
- (long long)pixelsWide; // 0x1000a69e4
- (long long)pixelsHigh; // 0x1000a6b58
- (CGSize)pixelSize; // 0x1000a6ccc
+ (id)imageOfBestRepresentationFrom:(id)arg0; // 0x1000bcfa0
+ (id)imageFullScreen; // 0x10003cfb4
+ (id)imageMainFullScreen; // 0x10003d0ac
+ (id)imageMainScreenForRect:(CGRect)arg0; // 0x10003d134
+ (id)imageRectangleScreen:(CGRect)arg0 exceptWinodws:(id)arg1; // 0x10003d1f0
+ (id)captureCurrentScreenshot:(CGRect)arg0; // 0x10003d3e0
+ (id)captureScreenshot; // 0x10003d44c
+ (id)captureScreenhotBelowWindow:(id)arg0 onRect:(CGRect)arg1; // 0x10003d4dc
+ (id)captureWindowWithWindowID:(unsigned int)arg0; // 0x10003d58c
+ (void)saveImageToPaste:(id)arg0; // 0x10003d644
+ (id)cutImageToRect:(id)arg0 Rect:(CGRect)arg1; // 0x10003d77c
+ (struct CGImage *)createCGImageRefFromImage:(id)arg0; // 0x10003d940
+ (void)saveImage:(id)arg0 toFile:(id)arg1 withType:(unsigned long long)arg2; // 0x10003da84
+ (void)saveData:(id)arg0 toFile:(id)arg1; // 0x10003e1fc
+ (void)postNotificationOrOpenFile:(id)arg0; // 0x10003e25c
+ (id)getImageWindowUnderMouse; // 0x10003e438
+ (id)resizeImage:(id)arg0 size:(CGSize)arg1; // 0x10003ed20
+ (id)resizeImage:(id)arg0 scale:(float)arg1 addShadowWithColor:(id)arg2; // 0x10003ee8c
+ (id)resizeImage:(id)arg0 scale:(float)arg1; // 0x10003f054
+ (id)addRoundImgae:(id)arg0 withRadius:(float)arg1; // 0x10003f1b0
+ (id)addFilletImgae:(id)arg0 withRadius:(float)arg1; // 0x10003f2cc
+ (id)resizeImage:(id)arg0 value:(float)arg1; // 0x10003f644
+ (id)addShadow:(id)arg0 withSize:(float)arg1; // 0x10003f7a8
+ (id)analysisQRCode:(id)arg0; // 0x10003f99c
+ (id)ocrFromImage:(id)arg0; // 0x10003fc04
+ (id)ocrGetTextYFromImage:(id)arg0; // 0x1000400c4
+ (id)md5WithImage:(id)arg0; // 0x1000404dc
@end

@interface NSScreen (PointConversion)
- (CGPoint)convertPointToScreenCoordinates:(CGPoint)arg0; // 0x1000b5898
- (CGPoint)flipPoint:(CGPoint)arg0; // 0x1000b58f4
+ (id)currentScreenForMouseLocation; // 0x1000b57bc
@end
