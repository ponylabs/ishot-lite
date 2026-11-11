#pragma once
#import <Cocoa/Cocoa.h>
@class AnnotatedImageView;
// Runtime metadata: recovery/objc/metadata.json, AnnotatedImageController.
@interface AnnotatedImageController : NSWindowController {
    NSColorWell * colorWell;
    AnnotatedImageView * annotatedImageView;
    BOOL _userCanceled;
    __weak NSLayoutConstraint * _pasteLeftSideDistance;
    __weak NSBox * _colorBox1;
    __weak NSBox * _colorBox2;
    __weak NSBox * _colorBox3;
    __weak NSBox * _colorBox4;
    __weak NSBox * _colorBox5;
    __weak NSBox * _userColorSingleBox;
    __weak NSTextField * _displaySize;
    __weak NSTextField * _displayOpacity;
    __weak NSButton * _squareButton;
    __weak NSButton * _ellipseButton;
    __weak NSButton * _lineButton;
    __weak NSButton * _arrowButton;
    __weak NSButton * _pencilPenButton;
    __weak NSButton * _mosaicButton;
    __weak NSButton * _textButton;
    __weak NSButton * _noteButton;
    __weak NSButton * _highlightButton;
    __weak NSButton * _undoButton;
    __weak NSButton * _mapButton;
    __weak NSButton * _OCRButton;
    __weak NSButton * _cancelButton;
    __weak NSButton * _saveButton;
    __weak NSButton * _pasteButton;
    __weak NSSlider * _sliderOfSize;
    __weak NSTextField * _textFieldOfSize;
    __weak NSSlider * _sliderOfOpacity;
    __weak NSTextField * _textFieldOfOpacity;
    __weak NSBox * _boxSquare;
    __weak NSBox * _boxEllipse;
    __weak NSBox * _boxLine;
    __weak NSBox * _boxArrow;
    __weak NSBox * _boxPencil;
    __weak NSBox * _boxMosaic;
    __weak NSBox * _boxSelectMosaic;
    __weak NSBox * _boxSelectHighlight;
    __weak NSBox * _boxText;
    __weak NSBox * _boxNote;
    __weak NSBox * _boxHighlight;
    __weak NSBox * _boxOCR;
    __weak NSBox * _boxUndo;
    __weak NSBox * _boxMap;
    __weak NSBox * _boxZoom;
    __weak NSBox * _boxClear;
    __weak NSBox * _boxCancel;
    __weak NSBox * _boxScrollScreenshot;
    __weak NSBox * _boxSave;
    __weak NSBox * _boxCopyToPaste;
    __weak NSBox * _boxSquare2;
    __weak NSBox * _boxEllipse2;
    __weak NSBox * _boxArrow2;
    __weak NSBox * _boxText2;
    __weak NSBox * _boxNote2;
    __weak NSBox * _boxPencil2;
    __weak NSPopUpButton * _popUpButtonSquare;
    __weak NSPopUpButton * _popUpButtonEllipse;
    __weak NSPopUpButton * _popUpButtonLine;
    __weak NSPopUpButton * _popUpButtonArrow;
    __weak NSPopUpButton * _popUpButtonPencil;
    __weak NSPopUpButton * _popUpButtonMosaic;
    __weak NSPopUpButton * _popUpButtonText;
    __weak NSPopUpButton * _popUpButtonNote;
    __weak NSPopUpButton * _popUpButtonHighlight;
    __weak NSPopUpButton * _popUpButtonOCR;
    __weak NSPopUpButton * _popUpButtonMap;
    __weak NSPopUpButton * _popUpButtonClear;
    __weak NSPopUpButton * _popUpButtonZoom;
    __weak NSPopUpButton * _popUpButtonScrollScreenshot;
    __weak NSPopUpButton * _popUpButtonSave;
    __weak NSPopUpButton * _popUpButtonCopyToPaste;
    __weak NSPopUpButton * _popUpButtonTextFont;
    __weak NSPopUpButton * _popUpButtonNoteFont;
    __weak NSPopUpButton * _willOpenPopUpButton;
    __weak NSTextField * _cpToPasteOrUpdateMapOfTextField;
    __weak NSTextField * _indicatorFieldWidth;
    __weak NSTextField * _indicatorFieldHeight;
    id _semaphore;
    NSString * _imageFilePath;
    __weak NSWindow * _backgroundImageWindow;
    __weak NSBox * _buttonBox;
    __weak NSBox * _colorBox;
    __weak NSBox * _realColorBox;
    __weak NSImageView * _sanjiao;
    __weak NSButton * _scrollScreenshotButton;
    __weak NSButton * _scrollScreenshotErrorWarnButton;
    __weak NSBox * _openedBoxOfTips;
}
@property (weak) NSLayoutConstraint * pasteLeftSideDistance;
@property (weak) NSBox * colorBox1;
@property (weak) NSBox * colorBox2;
@property (weak) NSBox * colorBox3;
@property (weak) NSBox * colorBox4;
@property (weak) NSBox * colorBox5;
@property (weak) NSBox * userColorSingleBox;
@property (weak) NSTextField * displaySize;
@property (weak) NSTextField * displayOpacity;
@property (weak) NSButton * squareButton;
@property (weak) NSButton * ellipseButton;
@property (weak) NSButton * lineButton;
@property (weak) NSButton * arrowButton;
@property (weak) NSButton * pencilPenButton;
@property (weak) NSButton * mosaicButton;
@property (weak) NSButton * textButton;
@property (weak) NSButton * noteButton;
@property (weak) NSButton * highlightButton;
@property (weak) NSButton * undoButton;
@property (weak) NSButton * mapButton;
@property (weak) NSButton * OCRButton;
@property (weak) NSButton * cancelButton;
@property (weak) NSButton * saveButton;
@property (weak) NSButton * pasteButton;
@property (weak) NSSlider * sliderOfSize;
@property (weak) NSTextField * textFieldOfSize;
@property (weak) NSSlider * sliderOfOpacity;
@property (weak) NSTextField * textFieldOfOpacity;
@property (weak) NSBox * boxSquare;
@property (weak) NSBox * boxEllipse;
@property (weak) NSBox * boxLine;
@property (weak) NSBox * boxArrow;
@property (weak) NSBox * boxPencil;
@property (weak) NSBox * boxMosaic;
@property (weak) NSBox * boxSelectMosaic;
@property (weak) NSBox * boxSelectHighlight;
@property (weak) NSBox * boxText;
@property (weak) NSBox * boxNote;
@property (weak) NSBox * boxHighlight;
@property (weak) NSBox * boxOCR;
@property (weak) NSBox * boxUndo;
@property (weak) NSBox * boxMap;
@property (weak) NSBox * boxZoom;
@property (weak) NSBox * boxClear;
@property (weak) NSBox * boxCancel;
@property (weak) NSBox * boxScrollScreenshot;
@property (weak) NSBox * boxSave;
@property (weak) NSBox * boxCopyToPaste;
@property (weak) NSBox * boxSquare2;
@property (weak) NSBox * boxEllipse2;
@property (weak) NSBox * boxArrow2;
@property (weak) NSBox * boxText2;
@property (weak) NSBox * boxNote2;
@property (weak) NSBox * boxPencil2;
@property (weak) NSPopUpButton * popUpButtonSquare;
@property (weak) NSPopUpButton * popUpButtonEllipse;
@property (weak) NSPopUpButton * popUpButtonLine;
@property (weak) NSPopUpButton * popUpButtonArrow;
@property (weak) NSPopUpButton * popUpButtonPencil;
@property (weak) NSPopUpButton * popUpButtonMosaic;
@property (weak) NSPopUpButton * popUpButtonText;
@property (weak) NSPopUpButton * popUpButtonNote;
@property (weak) NSPopUpButton * popUpButtonHighlight;
@property (weak) NSPopUpButton * popUpButtonOCR;
@property (weak) NSPopUpButton * popUpButtonMap;
@property (weak) NSPopUpButton * popUpButtonClear;
@property (weak) NSPopUpButton * popUpButtonZoom;
@property (weak) NSPopUpButton * popUpButtonScrollScreenshot;
@property (weak) NSPopUpButton * popUpButtonSave;
@property (weak) NSPopUpButton * popUpButtonCopyToPaste;
@property (weak) NSPopUpButton * popUpButtonTextFont;
@property (weak) NSPopUpButton * popUpButtonNoteFont;
@property (weak) NSPopUpButton * willOpenPopUpButton;
@property (weak) NSTextField * cpToPasteOrUpdateMapOfTextField;
@property (weak) NSTextField * indicatorFieldWidth;
@property (weak) NSTextField * indicatorFieldHeight;
@property (strong) id semaphore;
@property (strong) NSString * imageFilePath;
@property (assign) BOOL userCanceled;
@property (weak) NSWindow * backgroundImageWindow;
@property (weak) NSBox * buttonBox;
@property (weak) NSBox * colorBox;
@property (weak) NSBox * realColorBox;
@property (weak) NSImageView * sanjiao;
@property (weak) NSButton * scrollScreenshotButton;
@property (weak) NSButton * scrollScreenshotErrorWarnButton;
@property (weak) NSBox * openedBoxOfTips;
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
@end
