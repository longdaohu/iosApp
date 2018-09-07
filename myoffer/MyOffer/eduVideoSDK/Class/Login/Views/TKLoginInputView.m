//
//  TKLoginInputView.m
//  EduClass
//
//  Created by lyy on 2018/4/17.
//  Copyright © 2018年 拓课云. All rights reserved.
//

#import "TKLoginInputView.h"
#import "TKRoleChoiceView.h"


@interface TKLoginInputView()<UITextFieldDelegate,TKRoleChoiceDelegate>

@property (nonatomic, strong) UIView *backgroundView;//底层背景图
//@property (nonatomic, strong) UILabel *inputPlaceholder;//输入框上的提示文字

@property (nonatomic, strong) UIButton *choiceRoleButton;//角色选择按钮

@property (nonatomic, strong) UIImageView *iconImageView;//icon
//只有是选择器的时候才显示
@property (nonatomic, strong) UILabel *showLabel;

@property (nonatomic, strong) TKRoleChoiceView *choiceViewKeyboard;

@end

@implementation TKLoginInputView

- (instancetype)initWithFrame:(CGRect)frame showText:(NSString *)text placeholderText:(NSString *)placeholder isShow:(BOOL)show setImageName:(NSString *)imageName{
    
    if (self = [super initWithFrame:frame]) {
        self.text = text;
        _backgroundView = [[UIView alloc]init];
        [self addSubview:_backgroundView];
        [self sendSubviewToBack:_backgroundView];
        _inputView = [[UITextField alloc]init];
        [self addSubview:_inputView];
        
       
        _iconImageView = [[UIImageView alloc]init];
        [self addSubview:_iconImageView];
        
        _showLabel = [[UILabel alloc]init];
        _showLabel.textAlignment = NSTextAlignmentRight;
        //选择角色点击事件
        _choiceRoleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _choiceRoleButton.selected = NO;
        
        [self setDefaultAttributeShowText:text placeholderText:placeholder isShow:show setImageName:imageName];
        
        
    }
    return self;
}

- (void)setDefaultAttributeShowText:(NSString *)text placeholderText:(NSString *)placeholder isShow:(BOOL)show setImageName:(NSString *)imageName{
    
    _backgroundView.sakura.backgroundColor(@"Login.inputViewBackColor");
    _backgroundView.sakura.alpha(@"Login.inputViewBackAlpha");
    _backgroundView.layer.cornerRadius = 21;
    _backgroundView.layer.masksToBounds = true;
    
    _inputView.enabled = YES;
    
    
    if (placeholder) {
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:
                                          @{NSForegroundColorAttributeName:[TKTheme colorWithPath:@"Login.inputViewPlaceholderColor"],
                                            NSFontAttributeName:[UIFont systemFontOfSize:14]
                                            }];
        _inputView.attributedPlaceholder = attrString;
    }
    
    _inputView.text = text;
    _inputView.sakura.textColor(@"Login.inputViewTextColor");
    _inputView.sakura.font(@"Login.inputViewTextFont");
    _inputView.sakura.tintColor(@"Login.inputViewTextColor");
    
    _iconImageView.sakura.image(imageName);
    _iconImageView.contentMode = UIViewContentModeCenter;
    
    
    _backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _inputView.frame = CGRectMake(20, 0, CGRectGetWidth(_backgroundView.frame)-60, CGRectGetHeight(_backgroundView.frame));
    
    _inputView.delegate = self;
//    _inputPlaceholder.frame = CGRectMake(20, 0, CGRectGetWidth(_backgroundView.frame)-60, CGRectGetHeight(_backgroundView.frame));
    
    _showLabel.frame = CGRectMake(CGRectGetMaxX(_inputView.frame)-100, 0, 100, CGRectGetHeight(_inputView.frame));
    
    _iconImageView.frame = CGRectMake(CGRectGetMaxX(_inputView.frame), 0, 20, CGRectGetHeight(_inputView.frame));
    
    if (show) {
        
        _showLabel.text = MTLocalized(@"Label.choiceIdentity");
        
        _showLabel.sakura.textColor(@"Login.rolePromptTextColor");
        _showLabel.sakura.font(@"Login.rolePromptTextFont");
        [self addSubview:_showLabel];
        
        [self addSubview: _choiceRoleButton];
        
        _choiceRoleButton.frame = CGRectMake(0, 0, self.width, self.height);
        [_choiceRoleButton addTarget:self action:@selector(choiceRoleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
}
- (void)choiceRoleButtonClick:(UIButton *)sender{
    
    if (sender.selected) {
        sender.selected = NO;
        
        [self openChoiceRole];
        
    }else{
        sender.selected = YES;
        
        [self openChoiceRole];
        
    }
}

#pragma mark textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.inputDelegate && @selector(loginTextField:shouldChangeCharactersInRange:replacementString:)) {
        return [self.inputDelegate loginTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }else{
        return YES;
    }
  
}
- (void)setText:(NSString *)text{
    _text = text;
    _inputView.text = text;
}


- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)openChoiceRole{
    [self.inputView resignFirstResponder];
    _inputView.inputView = nil;
    _inputView.inputView = self.choiceViewKeyboard;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputView becomeFirstResponder];
    });
}

- (UIView *)choiceViewKeyboard{
    if (!_choiceViewKeyboard) {
        
        self.choiceViewKeyboard = [[TKRoleChoiceView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH/5.0)];
        self.choiceViewKeyboard.delegate = self;
        
    }
    return _choiceViewKeyboard;
}

#pragma mark - TKRoleChoiceView 代理
- (void)choiceCancel{
    [self.inputView resignFirstResponder];
}
- (void)choiceRole:(NSString *)role{
    
    int irole = 0;
    NSArray *array = @[MTLocalized(@"Role.Teacher"),MTLocalized(@"Role.Student"),MTLocalized(@"Role.Patrol")];//0-老师 ,1-助教，2-学生 4-寻课
    if (role != nil && [role isKindOfClass:[NSString class]])
    {
        NSInteger index = [array indexOfObject:role];
        switch (index) {
            case 0:
                irole = 0;
                break;
            case 1:
                irole = 2;
                break;
            case 2:
                irole = 4;
                break;
            default:
                break;
        }
        
        /* default selected item */
        if (index>array.count-1) {
            irole = 2;
        }
    }
    
    if (self.choiceRoleDelegate && @selector(choiceRole:)) {
        [self.choiceRoleDelegate choiceRole:irole];
    }
    
    self.inputView.text = role;
    [self.inputView resignFirstResponder];
}



@end
