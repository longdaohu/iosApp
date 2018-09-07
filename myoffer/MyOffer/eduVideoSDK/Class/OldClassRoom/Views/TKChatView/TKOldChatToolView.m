//
//  TKOldChatToolView.m
//  EduClass
//
//  Created by admin on 2018/6/6.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKOldChatToolView.h"

#define ThemeKP(args) [@"ClassRoom.TKChatViews." stringByAppendingString:args]

@interface TKOldChatToolView ()<UITextViewDelegate>
    
    @property (nonatomic, strong) UIImageView *backImageView;//背景图
    @property (nonatomic, assign) BOOL isDistance;
    
    @end



@implementation TKOldChatToolView
- (instancetype)initWithFrame:(CGRect)frame isDistance:(BOOL)isDistance{
    if (self = [super initWithFrame:frame]) {
        
        _isDistance = isDistance;
        
        _inputField =({
            
            TKEmotionTextView *tInputField =  [[TKEmotionTextView alloc] initWithFrame:CGRectMake(10,
                                                                                                  10,
                                                                                                  frame.size.width - 20,
                                                                                                  frame.size.height)];
            tInputField.sakura.backgroundColor(ThemeKP(@"chatToolBackgroundColor"));
            tInputField.sakura.textColor(ThemeKP(@"chatToolTextColor"));
            tInputField.placehoder = MTLocalized(@"Say.say");
            tInputField.font = [UIFont systemFontOfSize:15];
            tInputField.delegate = self;
            //        tInputField.maxNumberOfLines = 5;
            tInputField.returnKeyType = UIReturnKeySend;
            tInputField.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
            
            tInputField.layer.masksToBounds = YES;
            tInputField.layer.cornerRadius = 5;
            tInputField;
            
        });
        [self addSubview:_inputField];
        //
        //        _sendButton =({
        //            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //
        //            [button setTitle:MTLocalized(@"Button.send") forState:(UIControlStateNormal)];
        //            button.sakura.titleColor(ThemeKP(@"chatToolBackgroundColor"),UIControlStateNormal);
        //            button.sakura.backgroundImage(ThemeKP(@"button_send_default"),UIControlStateNormal);
        //            button.sakura.backgroundImage(ThemeKP(@"button_send_click"),UIControlStateSelected);
        //            [button addTarget:self action:@selector(sendButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        //
        //            button;
        //        });
        
        //        [self addSubview:_sendButton];
        
        
        //        _emotionButton = ({
        //            UIButton *button = [UIButton  buttonWithType:(UIButtonTypeCustom)];
        //
        //            button.sakura.image(ThemeKP(@"icon_expression"),UIControlStateSelected);
        //            button.sakura.image(ThemeKP(@"icon_keyboard"),UIControlStateNormal);
        //            button.selected = YES;
        //            [button addTarget:self action:@selector(emotionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        //            button;
        //        });
        //        [self addSubview:_emotionButton];
        //
        //        _picButton = ({
        //            UIButton *button = [UIButton  buttonWithType:(UIButtonTypeCustom)];
        //
        //
        //            button.sakura.image(ThemeKP(@"icon_pic"),UIControlStateNormal);
        //            button;
        //        });
        
        [self loadLayout];
        
    }
    return self;
}
    
- (void)loadLayout{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(touchMainPage:)
                                                name:stouchMainPageNotification
                                              object:nil];
    
    
    //添加表情选中的通知    监听键盘
    // 监听表情选中的通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:TKEmotionDidSelectedNotification object:nil];
    //    // 监听删除按钮点击的通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:TKEmotionDidDeletedNotification object:nil];
    
}
- (void)touchMainPage:(NSNotification*)notify{
//    self.emotionButton.selected = _isDistance ;
    [self.inputField resignFirstResponder];
}
- (void)layoutSubviews{
    
    
    
    //    CGFloat sendWidth = 60;
    //    CGFloat inputWidth = self.width - sendWidth - 5;
    CGFloat sendWidth = 0;
    CGFloat inputWidth = self.width - sendWidth;
    
    CGFloat inputX = 0;
    
    if (_isDistance) {
        
        inputWidth = self.width - sendWidth - 20;
        inputX = 5;
    }
    
    CGFloat inputHeight;
    
    if (self.height > 30) {
        inputHeight = 30;
    }
    
    _inputField.frame = CGRectMake(inputX, 5, inputWidth, self.height - 10);
    
    //    _sendButton.frame = CGRectMake(_inputField.rightX + 5, 5, sendWidth, self.height-10);
    //
    //    _emotionButton.frame = CGRectMake(_inputField.rightX-_inputField.height, CGRectGetMinY(_inputField.frame), _inputField.height, _inputField.height);
    //
    //    _picButton.frame =CGRectMake(_emotionButton.leftX-_inputField.height, 0, _inputField.height, _inputField.height);
    
}
#pragma mark - 发送事件
//- (void)sendButtonClick:(UIButton *)sender{
//}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.inputField.inputView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatToolViewDidBeginEditing:)]) {
        [self.delegate chatToolViewDidBeginEditing:textView];
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        if (!_inputField || !_inputField.realText || _inputField.realText.length == 0)
        {
            return NO;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessage:)]) {
            //            _emotionButton.selected = YES;
            [self.delegate sendMessage:_inputField.realText];
            
        }
        
    }
    
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     - (void)drawRect:(CGRect)rect {
     // Drawing code
     }
     */
    
    @end
