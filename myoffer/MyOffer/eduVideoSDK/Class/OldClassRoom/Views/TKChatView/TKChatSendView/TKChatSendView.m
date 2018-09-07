//
//  TKChatView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/29.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKChatSendView.h"
#import "TKGrowingTextView.h"

#import "TKUtil.h"
#import "TKMacro.h"
#import "TKEduSessionHandle.h"
//todo
#import "TKChatMessageModel.h" 
#import "TKEmojiHeader.h"
#import "TKIPhoneTypeString.h"

#define ThemeKP(args) [@"ClassRoom.TKChatViews." stringByAppendingString:args]


@interface TKChatSendView ()<TKGrowingTextViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>

@property(nonatomic,retain)UIView *iChatInputView;//全屏
@property(nonatomic,retain)UIView   *iChatTitleView;//抬头
@property(nonatomic,retain)UILabel  *iChatTitleLabel;//聊天
@property(nonatomic,retain)UIButton *iChatTitleClosedButton;//关闭
@property(nonatomic,retain)UIButton *iChatTitleSenddButton;//发送
@property(nonatomic,retain)UIButton *iChatTitleEmojiButton;//表情键盘选择
//@property (nonatomic, strong) TKGrowingTextView *iInputField;

@property (nonatomic, strong) TKEmotionTextView *iInputField;//输入框

@property (nonatomic, strong) TKEmotionKeyboard *kerboard; //自定义表情键盘

@property (nonatomic, strong) UILabel *iReplyText;


@property (nonatomic, strong) NSTimer *chatTimer;
@property (nonatomic, assign) BOOL chatTimerFlag;
@property (nonatomic, strong) NSString *lastSendChatTime;
@end


static const CGFloat sChatTitleViewWidth       = 598;
static const CGFloat sChatTitleViewHigh        = 59;
static const CGFloat sChatTitleViewClosedWidth = 70;


@implementation TKChatSendView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);

        
        
        [self addNotification];
        
//         添加手势 关闭视图
        UITapGestureRecognizer* tapTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTable:)];
        tapTableGesture.delegate = self;
        [self addGestureRecognizer:tapTableGesture];
        
        _iChatTitleView  =({
            UIView *tView= [[UIView alloc]initWithFrame:CGRectMake((ScreenW-sChatTitleViewWidth*Proportion)/2.0, 20*Proportion, sChatTitleViewWidth*Proportion , sChatTitleViewHigh*Proportion)];
            tView.backgroundColor = RGBACOLOR(33, 33, 35, 1);

            tView;
        });
        
        _iChatTitleLabel = ({
            UILabel *tTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sChatTitleViewClosedWidth*Proportion, 0,CGRectGetWidth(_iChatTitleView.frame)-sChatTitleViewClosedWidth*Proportion*2, CGRectGetHeight(_iChatTitleView.frame))];
            
            tTitleLabel.text = MTLocalized(@"Button.chat");
            tTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            tTitleLabel.backgroundColor = [UIColor clearColor];
            tTitleLabel.textAlignment = NSTextAlignmentCenter;
            tTitleLabel.font = TKFont(18);
            tTitleLabel.sakura.textColor(ThemeKP(@"chatSendTitleColor"));
            tTitleLabel;
        
        });
        
        _iChatTitleClosedButton = ({
            
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tButton.frame = CGRectMake(0, 0, sChatTitleViewClosedWidth*Proportion, CGRectGetHeight(_iChatTitleView.frame));
            tButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [tButton setTitle:MTLocalized(@"Button.closed") forState:UIControlStateNormal];
            tButton.sakura.titleColor(ThemeKP(@"chatCloseBtnBackColor"),UIControlStateNormal);
            [tButton addTarget:self action:@selector(chatTitleClosedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            tButton.backgroundColor = [UIColor clearColor];
            
            if ([[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5"]||
                [[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5"]||
                [[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5C"]||
                [[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5C"]||
                [[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5S"]||
                [[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5S"])  {
                
                tButton.titleLabel.font = TKFont(sChatTitleViewClosedWidth*Proportion/2.0);
            }else{
                
                tButton.titleLabel.font = TKFont(15);
            }
           
            
            tButton;
            
        });
        _iChatTitleSenddButton = ({
            
            CGFloat tBh = CGRectGetHeight(_iChatTitleView.frame)-10>30?30:CGRectGetHeight(_iChatTitleView.frame)-10;
            
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tButton.frame = CGRectMake(CGRectGetWidth(_iChatTitleView.frame)-sChatTitleViewClosedWidth*Proportion-10, (CGRectGetHeight(_iChatTitleView.frame)-tBh)/2.0, sChatTitleViewClosedWidth*Proportion, tBh);
            [tButton setTitle:MTLocalized(@"Button.send") forState:UIControlStateNormal];
            tButton.sakura.titleColor(ThemeKP(@"chatSendBtnTitleColor"),UIControlStateNormal);
            tButton.sakura.backgroundColor(ThemeKP(@"chatSendBtnBackColor"));
            tButton.titleLabel.font = TKFont(13);
            tButton.layer.masksToBounds = YES;
            tButton.layer.cornerRadius = 5;
            tButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [tButton addTarget:self action:@selector(chatTitleSenddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            tButton;
            
        });
        _iChatTitleEmojiButton = ({
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tButton.frame = CGRectMake(CGRectGetWidth(_iChatTitleView.frame)-sChatTitleViewClosedWidth*Proportion-CGRectGetHeight(_iChatTitleView.frame)-10, 5, CGRectGetHeight(_iChatTitleView.frame)-10, CGRectGetHeight(_iChatTitleView.frame)-10);
            
            tButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [tButton addTarget:self action:@selector(chatTitleEmojiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            tButton.backgroundColor = [UIColor clearColor];
            
//            [tButton setImage:LOADIMAGE(@"TKEmoji/icon_Emoji_normal") forState:(UIControlStateNormal)];
//
//            [tButton setImage:LOADIMAGE(@"TKEmoji/icon_Emoji_disabled") forState:(UIControlStateDisabled)];
//            [tButton setImage:LOADIMAGE(@"TKEmoji/icon_Emoji_hover") forState:(UIControlStateFocused)];
//            [tButton setImage:LOADIMAGE(@"TKEmoji/icon_Emoji_pressed") forState:(UIControlStateSelected)];
            [tButton setImage:LOADIMAGE(@"TKEmoji/icon_Emoji_normal") forState:(UIControlStateSelected)];
            [tButton setImage:LOADIMAGE(@"TKEmoji/icon_keyboard_normal") forState:(UIControlStateNormal)];
            tButton.contentMode = UIViewContentModeCenter;
            
            tButton.selected = YES;
            
            tButton;
        });
        [_iChatTitleView addSubview:_iChatTitleSenddButton];
        [_iChatTitleView addSubview:_iChatTitleEmojiButton];
        [_iChatTitleView addSubview:_iChatTitleClosedButton];
        [_iChatTitleView addSubview:_iChatTitleLabel];
        
        [self addSubview:_iChatTitleView];
        
        _iInputField =({

            CGFloat tInPutInerContainerWidth = CGRectGetWidth(_iChatTitleView.frame);
            CGFloat tInPutInerContainerHeigh =ScreenH - 100;
            CGRect rectInputFieldFrame = CGRectMake(CGRectGetMinX(_iChatTitleView.frame), CGRectGetMaxY(_iChatTitleView.frame), tInPutInerContainerWidth, tInPutInerContainerHeigh);
            TKEmotionTextView *tInputField =  [[TKEmotionTextView alloc] initWithFrame:rectInputFieldFrame];

            tInputField.placehoder = MTLocalized(@"Say.say");//@"说点什么吧";
            tInputField.textAlignment = NSTextAlignmentLeft;
            tInputField.contentMode = UIViewContentModeCenter;//设置textview的文字对齐方式

//            [tInputField setTextColor:RGBACOLOR(168, 168, 168, 1)];
            tInputField.sakura.textColor(ThemeKP(@"chatInputTextColor"));
//            [tInputField setTintColor:RGBACOLOR(255, 255, 255, 1)];
            tInputField.delegate         = self;
            tInputField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            tInputField.returnKeyType = UIReturnKeySend;
            tInputField.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
            
            tInputField.sakura.backgroundColor(ThemeKP(@"chatInputBackColor"));
                                         
            tInputField;

        });
        [self addSubview:_iInputField];
        
        
        _iReplyText                 = ({
            CGFloat tInPutInerContainerHeigh = 15;
            CGRect tReplyTextFrame = CGRectMake(CGRectGetMinX(_iChatTitleView.frame), CGRectGetMaxY(_iChatTitleView.frame), 100, tInPutInerContainerHeigh);
            UILabel *tReplyText                 = [[UILabel alloc] initWithFrame:tReplyTextFrame];
            
//            tReplyText.textColor       = [UIColor redColor];
            
            tReplyText.sakura.textColor(ThemeKP(@"chatInputTextColor"));
//            tReplyText.text            = MTLocalized(@"Say.say");//@"说点什么吧";
            tReplyText.textAlignment   = NSTextAlignmentLeft;
            tReplyText.numberOfLines   = 1;
            tReplyText.font            = TKFont(15);
            tReplyText;
            
        });
        [self addSubview:_iReplyText];
       
        
        
    }
    return self;
    
    
}
- (void)addNotification{
    //2017-11-16添加表情选中的通知    监听键盘
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:TKEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:TKEmotionDidDeletedNotification object:nil];
}
#pragma mark -  当表情选中的时候调用
- (void)emotionDidSelected:(NSNotification *)note
{
    TKEmotion *emotion = note.userInfo[TKSelectedEmotion];
    // 1.拼接表情
    [_iInputField appendEmotion:emotion];
    
}

/**
 *  当点击表情键盘上的删除按钮时调用
 */
- (void)emotionDidDeleted:(NSNotification *)note
{
    // 往回删
    [_iInputField deleteBackward];
}


#pragma mark -系统键盘与表情键盘切换
- (void)chatTitleEmojiButtonClicked:(UIButton *)aButton{
    if (aButton.selected) {
        aButton.selected = NO;
        
        [self openEmotion];
        
    }else{
        aButton.selected = YES;
        
        [self openEmotion];
        
    }
}
- (void)openEmotion{
    if (_iChatTitleEmojiButton.selected) {
        // 当前显示的是自定义键盘，切换为系统自带的键盘
        _iInputField.inputView = nil;
        // 显示表情图片
    } else
    {
        _iInputField.inputView = nil;
        // 当前显示的是系统自带的键盘，切换为自定义键盘
        // 如果临时更换了文本框的键盘，一定要重新打开键盘
        _iInputField.inputView = self.kerboard;
        // 不显示表情图片
    }
    // 关闭键盘
    [self.iInputField resignFirstResponder];
    // 记录是否正在更换键盘
    // 更换完毕完毕
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 打开键盘
        [self.iInputField becomeFirstResponder];
    });
}

-(void)chatTitleSenddButtonClicked:(UIButton*)aButton{
    if (!_iInputField || !_iInputField.realText || _iInputField.realText.length == 0)
    {
        return;
    }
    NSString *time = [TKUtil currentTime];
    //type = 0 聊天 type = 1 提问
    NSDictionary *messageDic = @{@"type":@0,@"time":time};
    
    NSDictionary *msg = @{@"msg":_iInputField.realText};
    
    BOOL isSame = [[TKEduSessionHandle shareInstance] judgmentOfTheSameMessage:_iInputField.realText lastSendTime:self.lastSendChatTime];
    if (isSame && _chatTimerFlag) {
        [TKUtil showMessage: MTLocalized(@"Prompt.NotRepeatChat")];
    }else{
        
        
        [[TKEduSessionHandle shareInstance] sessionHandleSendMessage:msg toID:sTellAll extensionJson:messageDic];
        
        [self creatTimer];
    }
    
    
    self.chatTimerFlag = true;
    
    _iInputField.text = @"";
    
    _iReplyText.hidden = NO;
    
    [_iInputField resignFirstResponder];
   
    
    [self hide];
    
    _iChatTitleEmojiButton.selected = YES;//键盘置为原来的样式
    _iInputField.inputView = nil;
}
- (void)creatTimer{
    if (!self.chatTimer) {
        self.lastSendChatTime = [NSString stringWithFormat:@"%f", [TKUtil getNowTimeTimestamp]];
        self.chatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    }
}

- (void)timerFire{
    
    self.chatTimerFlag = false;
    [self.chatTimer invalidate];
    self.chatTimer = nil;
    self.lastSendChatTime = nil;
    
}
#pragma mark - 键盘发送按钮事件
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        if (![_iInputField.text isEqualToString:@""]) {
            [self chatTitleSenddButtonClicked:nil];
        }
        return NO;
    }
    return YES;
}

-(void)chatTitleClosedButtonClicked:(UIButton *)aButton{
    [self hide];
    
}

-(void)show{
    
  
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    // [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [_iInputField becomeFirstResponder];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    [UIView commitAnimations];
    
}
-(void)hide{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    //   [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    //
    [self removeFromSuperview];
    [self endEditing:NO];
    
    _iInputField.inputView = nil;
    _iChatTitleEmojiButton.selected = YES;//键盘置为原来的样式
    
    _iInputField.text = @"";
    // [self refreshData];
    _iReplyText.hidden = NO;
    
    [UIView commitAnimations];
}
-(void)tapTable:(UIGestureRecognizer *)aTab{
//    [self hide];
    _iInputField.inputView = nil;
    _iChatTitleEmojiButton.selected = YES;//键盘置为原来的样式
    [self endEditing:YES];
}
- (void)changeInputAreaHeight:(int)height duration:(NSTimeInterval)duration orientationChange:(bool)orientationChange dragging:(bool)__unused dragging completion:(void (^)(BOOL finished))completion
{
    
}
- (void)updatePlaceholderVisibility:(bool)firstResponder
{
    _iReplyText.hidden = firstResponder || _iInputField.text.length != 0;
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.iChatTitleView) {
        return NO;
    }
    
    return YES;
}

#pragma mark TKTextViewInternalDelegate
- (void)TKTextViewChangedResponderState:(bool)firstResponder
{
    [self updatePlaceholderVisibility:firstResponder];
}
#pragma mark TKGrowingTextViewDelegate
- (void)growingTextView:(TKGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    [self growingTextView:growingTextView willChangeHeight:height animated:true];
}

- (void)growingTextView:(TKGrowingTextView *)__unused growingTextView willChangeHeight:(float)height animated:(bool)animated
{
//    CGRect inputContainerFrame = _inputContainer.frame;
//    float newHeight = MAX(10 + height, sChatBarHeight);
//    if (inputContainerFrame.size.height != newHeight)
//    {
//        int currentKeyboardHeight = _knownKeyboardHeight;
//        inputContainerFrame.size.height = newHeight;
//        inputContainerFrame.origin.y = _inputContainer.superview.frame.size.height - currentKeyboardHeight - inputContainerFrame.size.height;
//        _inputContainer.frame = inputContainerFrame;
//        _replyText.frame = CGRectMake(10, 5, _inputContainer.frame.size.width - 75 , _inputContainer.frame.size.height - 10);
//        
//        [TKUtil setHeight:_inputInerContainer To:newHeight-2*6];
//       
//        [TKUtil setHeight:_inputField To:CGRectGetHeight(_inputInerContainer.frame)];
//        
//    }
}

- (void)growingTextViewDidChange:(TKGrowingTextView *)growingTextView
{
    [self updatePlaceholderVisibility:[growingTextView.internalTextView isFirstResponder]];
}

- (BOOL)growingTextViewShouldReturn:(TKGrowingTextView *)growingTextView
{
    [self chatTitleSenddButtonClicked:nil];
    return YES;
}

- (BOOL)growingTextViewShouldBeginEditing:(TKGrowingTextView *)growingTextView
{
    _iReplyText.hidden = YES;
    return YES;
}
- (BOOL)growingTextViewShouldEndEditing:(TKGrowingTextView *)growingTextView
{
    return YES;
}


#pragma mark - 表情键盘初始化
- (TKEmotionKeyboard *)kerboard {
    if (!_kerboard) {
        self.kerboard = [TKEmotionKeyboard keyboard];
        
        self.kerboard.frame = CGRectMake(0, 0, self.frame.size.width, TKKeyBoardHeight);
        
        //        self.kerboard.width = SCREEN_WIDTH;
        //        self.kerboard.height = 216;
    }
    return _kerboard;
}
- (void)dealloc{
    [self.chatTimer invalidate];
    self.chatTimer = nil;
}
@end
