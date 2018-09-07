//
//  TKTextView.m
//
//  Created by Hans Pinckaers on 29-06-10.
//
//	MIT License
//
//	Copyright (c) 2011 Hans Pinckaers
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "TKGrowingTextView.h"
#import "TKTextViewInternal.h"

#define  KeyPath @"backgroundColor"
@interface TKGrowingTextView()
-(void)commonInitialiser;
-(void)resizeTextView:(NSInteger)newSizeH;
-(void)growDidStop;
@end
@implementation TKGrowingTextView
@synthesize internalTextView;
@synthesize delegate;

@synthesize font;
@synthesize textColor;
@synthesize textAlignment; 
@synthesize selectedRange;
@synthesize editable;
@synthesize dataDetectorTypes; 
@synthesize animateHeightChange;
@synthesize returnKeyType;

@synthesize oneTimeLongAnimation = _oneTimeLongAnimation;

// having initwithcoder allows us to use TKGrowingTextView in a Nib. -- aob, 9/2011
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInitialiser];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInitialiser];
    }
    return self;
}

-(void)commonInitialiser
{
    // Initialization code
    CGRect r = self.frame;
    r.origin.y = 0;
    r.origin.x = 0;
    _scrollView = [[UIScrollView alloc] initWithFrame:r];
    _scrollView.contentSize = CGSizeMake(r.size.width, r.size.height);
 //   _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_scrollView];
    internalTextView = [[TKTextViewInternal alloc] initWithFrame:r];
    _scrollView.backgroundColor = internalTextView.backgroundColor;
 //    _scrollView.backgroundColor = [UIColor orangeColor];
 //   internalTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    internalTextView.handleEditActions = true;
    internalTextView.delegate = self;
    internalTextView.scrollEnabled = NO;
    internalTextView.font = [UIFont systemFontOfSize:13]; 
    internalTextView.contentInset = UIEdgeInsetsZero;		
    internalTextView.showsHorizontalScrollIndicator = NO;
    internalTextView.text = @"-";
    [_scrollView addSubview:internalTextView];
    _isSetText = NO;
    UIView *internal = (UIView*)[[internalTextView subviews] objectAtIndex:0];
    minHeight = (int)internal.frame.size.height;
    minNumberOfLines = 1;
    
    animateHeightChange = YES;
    
    internalTextView.text = @"";
    
    [self setMaxNumberOfLines:3];
    [internalTextView addObserver:self forKeyPath:KeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutSubviews
{
    // Initialization code
    CGRect r = self.frame;
    r.origin.y = 0;
    r.origin.x = 0;
    _scrollView.frame = r;
    _scrollView.contentSize = CGSizeMake(r.size.width, r.size.height);
    internalTextView.frame = r;
}

-(void)sizeToFit
{
	CGRect r = self.frame;
    if ([self.text length] > 0) {
        return;
    } else {
        r.size.height = minHeight;
        self.frame = r;
    }
}

-(void)setFrame:(CGRect)aframe
{
	CGRect r = aframe;
	r.origin.y = 0;
	r.origin.x = contentInset.left;
    r.size.width -= contentInset.left + contentInset.right;
    
	//internalTextView.frame = r;
	
	[super setFrame:aframe];
}

-(void)setContentInset:(UIEdgeInsets)inset
{
    contentInset = inset;
    
    CGRect r = self.frame;
    r.origin.y = inset.top - inset.bottom;
    r.origin.x = inset.left;
    r.size.width -= inset.left + inset.right;
    
   // internalTextView.frame = r;
    
    [self setMaxNumberOfLines:maxNumberOfLines];
    [self setMinNumberOfLines:minNumberOfLines];
}

-(UIEdgeInsets)contentInset
{
    return contentInset;
}

-(void)setMaxNumberOfLines:(int)n
{
    // Use internalTextView for height calculations, thanks to Gwynne <http://blog.darkrainfall.org/>
    NSString *saveText = internalTextView.text, *newText = @"-";
    
    internalTextView.delegate = nil;
    internalTextView.hidden = YES;
    
    for (int i = 1; i < n; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    internalTextView.text = newText;
    
    maxHeight = (int)[self measureHeightOfUITextView:internalTextView];//(int)internalTextView.contentSize.height;
    
    internalTextView.text = saveText;
    internalTextView.hidden = NO;
    internalTextView.delegate = self;
    
    [self sizeToFit];
    
    maxNumberOfLines = n;
}

-(int)maxNumberOfLines
{
    return maxNumberOfLines;
}

-(void)setMinNumberOfLines:(int)m
{
	// Use internalTextView for height calculations, thanks to Gwynne <http://blog.darkrainfall.org/>
    NSString *saveText = internalTextView.text, *newText = @"-";
    
    internalTextView.delegate = nil;
    internalTextView.hidden = YES;
    for (int i = 1; i < m; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    internalTextView.text = newText;
    minHeight = (int)[self measureHeightOfUITextView:internalTextView];//(int)internalTextView.contentSize.height;
    internalTextView.text = saveText;
    internalTextView.hidden = NO;
    internalTextView.delegate = self;
    
    [self sizeToFit];
    
    minNumberOfLines = m;
}

-(int)minNumberOfLines
{
    return minNumberOfLines;
}
- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        return ceilf([textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)].height);
    }
    else
    {
        return textView.contentSize.height;
    }
}

- (void)textViewDidChange:(UITextView *)__unused textView
{
    BOOL beyond = false;
    if (internalTextView.text.length != 0)
    {
        int textLength = (int)internalTextView.text.length;
        NSString *text = internalTextView.text;
        bool hasNonWhitespace = false;
        for (int i = 0; i < textLength; i++)
        {
            unichar c = [text characterAtIndex:i];
            if (c != ' ' && c != '\n')
            {
                hasNonWhitespace = true;
                break;
            }
        }
        if (!hasNonWhitespace && [internalTextView.text characterAtIndex:internalTextView.text.length - 1] == '\n') {
            internalTextView.text = [internalTextView.text substringToIndex:internalTextView.text.length - 1];
        }

    }
	NSInteger newSizeH = (NSInteger)[self measureHeightOfUITextView:internalTextView];//
    if(newSizeH < minHeight || !internalTextView.hasText) newSizeH = minHeight; //not smalles than minHeight
    
    if (newSizeH > 36 && newSizeH < 42)
        newSizeH = 36;
    
    if (newSizeH != (NSInteger)internalTextView.frame.size.height) {
        internalTextView.frame = CGRectMake(0, 0, self.frame.size.width, newSizeH);
        _scrollView.contentSize = CGSizeMake(self.frame.size.width, newSizeH);
    }
	if ((NSInteger)self.frame.size.height != newSizeH)
	{
        if (newSizeH > maxHeight)
        {
            newSizeH = maxHeight;
            beyond = true;
        }
		if (newSizeH <= maxHeight && newSizeH != (NSInteger)self.frame.size.height)
		{
            if(animateHeightChange)
            {    
                float animationDuration = 0.15f;

                if (_oneTimeLongAnimation)
                {
                    _oneTimeLongAnimation = false;
                    animationDuration = 0.3f * 0.7f;
                }
                [UIView animateWithDuration:animationDuration delay:0 options:(UIViewAnimationOptionAllowUserInteraction| UIViewAnimationOptionBeginFromCurrentState) animations:^
                {
                    [self resizeTextView:newSizeH];
                } completion:^(__unused BOOL finished)
                {
                    if ([delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)])
                    {
                        [delegate growingTextView:self didChangeHeight:newSizeH];
                    }
                }];
            }
            else
            {
                [self resizeTextView:newSizeH];
                if ([delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)])
                {
                    [delegate growingTextView:self didChangeHeight:newSizeH];
                }	
            }
		}
		if (beyond && !_isSetText)
		{
            [self scrollToCaret];
 
		}
	}
	if ([delegate respondsToSelector:@selector(growingTextViewDidChange:)])
    {
		[delegate growingTextViewDidChange:self];
	}
    _oneTimeLongAnimation = false;
    _isSetText = NO;
}

- (void)softSetMaxNumberOfLines:(int)value
{
    maxNumberOfLines = value;
}

- (void)scrollToCaret
{
    if (internalTextView.selectedTextRange != nil)
    {
        UITextPosition *position = internalTextView.selectedTextRange.start;
        if (position != nil)
        {
            CGRect rect = [internalTextView caretRectForPosition:position];
            if (!CGRectIsInfinite(rect) && !CGRectIsNull(rect))
            {
                rect.origin.y -= 4;
                rect.size.height += 8;
                [_scrollView scrollRectToVisible:rect animated:false];
                if (_scrollView.contentOffset.y > [self measureHeightOfUITextView:internalTextView] - _scrollView.frame.size.height)
                    _scrollView.contentOffset = CGPointMake(0, [self measureHeightOfUITextView:internalTextView] - _scrollView.frame.size.height);
                if (_scrollView.contentOffset.y < 0)
                    _scrollView.contentOffset = CGPointZero;
            }
        }
    }
}

-(void)resizeTextView:(NSInteger)newSizeH
{
    if ((NSInteger)self.frame.size.height == newSizeH) {
        return;
    }
    if ([delegate respondsToSelector:@selector(growingTextView:willChangeHeight:)]) {
        [delegate growingTextView:self willChangeHeight:newSizeH];
    }
    CGRect internalTextViewFrame = self.frame;
    internalTextViewFrame.size.height = newSizeH; // + padding
    self.frame = internalTextViewFrame;
  //  _scrollView.frame = CGRectMake(0, 0, internalTextViewFrame.size.width, newSizeH);
    
    internalTextViewFrame.origin.y = contentInset.top - contentInset.bottom;
    internalTextViewFrame.origin.x = contentInset.left;
    internalTextViewFrame.size.width = _scrollView.contentSize.width;
    
    _scrollView.frame = internalTextViewFrame;
  //  internalTextView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
}

-(void)growDidStop
{
	if ([delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)]) {
		[delegate growingTextView:self didChangeHeight:self.frame.size.height];
	}
	
}

-(void)touchesEnded:(NSSet *)__unused touches withEvent:(UIEvent *)__unused event
{
    [internalTextView becomeFirstResponder];
}

- (BOOL)isFirstResponder
{
    return [internalTextView isFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    return [internalTextView becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
	return [internalTextView resignFirstResponder];
}

- (void)dealloc {
    [internalTextView removeObserver:self forKeyPath:KeyPath];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITextView properties
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setText:(NSString *)newText
{
    if (internalTextView.text.length == 0) {
        _isSetText = YES;
    }
    internalTextView.text = newText;
    // include this line to analyze the height of the textview.
    // fix from Ankit Thakur
    [self performSelector:@selector(textViewDidChange:) withObject:internalTextView];
  //  internalTextView.text = newText;
    [self setNeedsDisplay];
}

-(NSString*) text
{
    return internalTextView.text;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setFont:(UIFont *)afont
{
	internalTextView.font= afont;
	
	[self setMaxNumberOfLines:maxNumberOfLines];
	[self setMinNumberOfLines:minNumberOfLines];
}

-(UIFont *)font
{
	return internalTextView.font;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setTextColor:(UIColor *)color
{
	internalTextView.textColor = color;
}

-(UIColor*)textColor{
	return internalTextView.textColor;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

-(void)setTextAlignment:(UITextAlignment)aligment
{
    internalTextView.textAlignment = (NSTextAlignment)aligment;
}

-(UITextAlignment)textAlignment
{
    return (UITextAlignment)internalTextView.textAlignment;
}

#pragma clang diagnostic pop


///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setSelectedRange:(NSRange)range
{
	internalTextView.selectedRange = range;
}

-(NSRange)selectedRange
{
	return internalTextView.selectedRange;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setEditable:(BOOL)beditable
{
	internalTextView.editable = beditable;
}

-(BOOL)isEditable
{
	return internalTextView.editable;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setReturnKeyType:(UIReturnKeyType)keyType
{
	internalTextView.returnKeyType = keyType;
}

-(UIReturnKeyType)returnKeyType
{
	return internalTextView.returnKeyType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setDataDetectorTypes:(UIDataDetectorTypes)datadetector
{
	internalTextView.dataDetectorTypes = datadetector;
}

-(UIDataDetectorTypes)dataDetectorTypes
{
	return internalTextView.dataDetectorTypes;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)hasText{
	return [internalTextView hasText];
}

- (void)scrollRangeToVisible:(NSRange)range
{
	[internalTextView scrollRangeToVisible:range];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITextViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldBeginEditing:(UITextView *)__unused textView {
	if ([delegate respondsToSelector:@selector(growingTextViewShouldBeginEditing:)]) {
		return [delegate growingTextViewShouldBeginEditing:self];
		
	} else {
		return YES;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldEndEditing:(UITextView *)__unused textView {
	if ([delegate respondsToSelector:@selector(growingTextViewShouldEndEditing:)]) {
		return [delegate growingTextViewShouldEndEditing:self];
		
	} else {
		return YES;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidBeginEditing:(UITextView *)__unused textView {
	if ([delegate respondsToSelector:@selector(growingTextViewDidBeginEditing:)]) {
		[delegate growingTextViewDidBeginEditing:self];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidEndEditing:(UITextView *)__unused textView {
	if ([delegate respondsToSelector:@selector(growingTextViewDidEndEditing:)]) {
		[delegate growingTextViewDidEndEditing:self];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange) range
 replacementText:(NSString *)atext {
	
	//weird 1 pixel bug when clicking backspace when textView is empty
	if(![textView hasText] && [atext isEqualToString:@""]) return NO;
	
	if ([atext isEqualToString:@"\n"]) {
		if ([delegate respondsToSelector:@selector(growingTextViewShouldReturn:)])
        {   
			if (![delegate growingTextViewShouldReturn:self])
            {
				return YES;
			} else {
				[textView resignFirstResponder];
				return NO;
			}
		}
	}

    if ([delegate respondsToSelector:@selector(growingTextView:shouldChangeTextInRange:replacementText:)])
    {
        return [delegate growingTextView:self shouldChangeTextInRange:range replacementText:atext];
    }

	return YES;
	
    
}

- (void)textViewDidChangeSelection:(UITextView *)__unused textView
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == internalTextView && [keyPath isEqualToString:KeyPath]) {
        _scrollView.backgroundColor = internalTextView.backgroundColor;
    }
}

@end
