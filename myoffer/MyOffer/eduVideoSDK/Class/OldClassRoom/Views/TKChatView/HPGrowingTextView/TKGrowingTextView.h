

#import <UIKit/UIKit.h>

#import "TKTextViewInternal.h"

@class TKGrowingTextView;
@class TKTextViewInternal;

@protocol TKGrowingTextViewDelegate

@optional

- (BOOL)growingTextViewShouldBeginEditing:(TKGrowingTextView *)growingTextView;
- (BOOL)growingTextViewShouldEndEditing:(TKGrowingTextView *)growingTextView;

- (void)growingTextViewDidBeginEditing:(TKGrowingTextView *)growingTextView;
- (void)growingTextViewDidEndEditing:(TKGrowingTextView *)growingTextView;

- (BOOL)growingTextView:(TKGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)growingTextViewDidChange:(TKGrowingTextView *)growingTextView;

- (void)growingTextView:(TKGrowingTextView *)growingTextView willChangeHeight:(float)height;
- (void)growingTextView:(TKGrowingTextView *)growingTextView didChangeHeight:(float)height;

- (BOOL)growingTextViewShouldReturn:(TKGrowingTextView *)growingTextView;

- (void)growingTextView:(TKGrowingTextView *)growingTextView didPasteImages:(NSArray *)images;

@end

@interface TKGrowingTextView : UIView <UITextViewDelegate>
{
	TKTextViewInternal *internalTextView;	
	UIScrollView *_scrollView;
	int minHeight;
	int maxHeight;
	
	//class properties
	int maxNumberOfLines;
	int minNumberOfLines;
	
	//uitextview properties
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    UITextAlignment textAlignment;
#pragma clang diagnostic pop
	
	NSRange selectedRange;
	BOOL editable;
	UIDataDetectorTypes dataDetectorTypes;
	UIReturnKeyType returnKeyType;
    
    UIEdgeInsets contentInset;
    BOOL _isSetText;
}

//real class properties
@property (nonatomic) int maxNumberOfLines;
@property (nonatomic) int minNumberOfLines;
@property (nonatomic) BOOL animateHeightChange;
@property (nonatomic, retain) TKTextViewInternal *internalTextView;


@property (nonatomic) bool oneTimeLongAnimation;

//uitextview properties
@property(nonatomic, assign) NSObject<TKGrowingTextViewDelegate> *delegate;
@property(nonatomic,assign) NSString *text;
@property(nonatomic,assign) UIFont *font;
@property(nonatomic,assign) UIColor *textColor;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property(nonatomic) UITextAlignment textAlignment;    // default is UITextAlignmentLeft

#pragma clang diagnostic pop

@property(nonatomic) NSRange selectedRange;            // only ranges of length 0 are supported
@property(nonatomic,getter=isEditable) BOOL editable;
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_0);
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
@property (nonatomic, assign) UIEdgeInsets contentInset;

//uitextview methods
//need others? use .internalTextView
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;

- (BOOL)hasText;
- (void)scrollRangeToVisible:(NSRange)range;

- (void)scrollToCaret;
- (void)softSetMaxNumberOfLines:(int)maxNumberOfLines;
- (void)textViewDidChange:(UITextView *)__unused textView;

@end
