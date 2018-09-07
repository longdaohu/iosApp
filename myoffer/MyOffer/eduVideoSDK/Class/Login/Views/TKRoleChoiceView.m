//
//  TKRoleChoiceView.m
//  EduClass
//
//  Created by lyy on 2018/4/28.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKRoleChoiceView.h"

@interface TKRoleChoiceView()

@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UIButton *cancelButton;//取消
@property (strong, nonatomic)  UIView *lineView;
@property (strong, nonatomic)  UIButton *studentButton;
@property (strong, nonatomic)  UIButton *teacherButton;
@property (strong, nonatomic)  UIButton *patrolButton;

@end

@implementation TKRoleChoiceView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.sakura.backgroundColor(@"Login.roleChoiceBackColor");
        
        _titleLabel = [[UILabel alloc]init];
        [self addSubview:_titleLabel];
        
        _cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:_cancelButton];
        
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
        
        _studentButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:_studentButton];
        
        _teacherButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:_teacherButton];
        
        _patrolButton =[UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:_patrolButton];
        
        
        [self loadAllView];
        [self showDefault];
        
    }
    return self;
}

- (void)loadAllView{
    _titleLabel.frame = CGRectMake(0, 0, self.width, self.height/5.0);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _cancelButton.frame = CGRectMake(self.width-65, 0, 60, self.height/5.0);
    _cancelButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    _lineView.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), self.width, 1);
    
    CGFloat btnWidth = 100;
    CGFloat btnHeight = 36;
    
    CGFloat btnY = (self.height - CGRectGetMaxY(_lineView.frame)-btnHeight)/2.0+CGRectGetMaxY(_lineView.frame);
    
    
    CGFloat margin = (self.width-(btnWidth * 3))/4.0;
    
    _studentButton.frame = CGRectMake(margin, btnY, btnWidth, btnHeight);
    
    _teacherButton.frame = CGRectMake(_studentButton.rightX+margin, btnY, btnWidth, btnHeight);
    
    _patrolButton.frame = CGRectMake(_teacherButton.rightX+margin, btnY, btnWidth, btnHeight);
    
    _titleLabel.text = MTLocalized(@"Label.choiceIdentity");
    
    _titleLabel.sakura.textColor(@"Login.roleChoiceTitleColor");
    
    [_cancelButton setTitle:MTLocalized(@"Prompt.Cancel") forState:UIControlStateNormal];
    
    _cancelButton.sakura.titleColor(@"Login.roleChoiceTitleColor",UIControlStateNormal);
    
    _lineView.sakura.backgroundColor(@"Login.roleLineBackColor");
    
    
    [self resetButton:_studentButton title:MTLocalized(@"Role.Student") action:@selector(studentClick:)];
    
    [self resetButton:_teacherButton title:MTLocalized(@"Role.Teacher") action:@selector(teacherClick:)];
    
    [self resetButton:_patrolButton title:MTLocalized(@"Role.Patrol") action:@selector(assistantClick:)];
    
    
    
}
- (void)showDefault{
    
    NSNumber  *role = [[NSUserDefaults standardUserDefaults] objectForKey:@"userrole"];
    
    NSString *roleStr;
    if (role != nil && [role isKindOfClass:[NSNumber class]])
    {
        switch ([role intValue]) {
            case 0:
                roleStr = MTLocalized(@"Role.Teacher");
                break;
            case 2:
                roleStr = MTLocalized(@"Role.Student");
                break;
            case 4:
                roleStr = MTLocalized(@"Role.Patrol");
            default:
                break;
        }
    }else{
        
        roleStr = MTLocalized(@"Role.Student");
    }
    
    
    if ([roleStr isEqualToString:_teacherButton.titleLabel.text])
    {
        _teacherButton.selected = YES;
        _teacherButton.sakura.backgroundColor(@"Login.roleChoiceSelectedColor");
        
    }else if ([roleStr isEqualToString:_patrolButton.titleLabel.text]){
        
        _patrolButton.selected = YES;
        _patrolButton.sakura.backgroundColor(@"Login.roleChoiceSelectedColor");
        
    }else{
        _studentButton.selected = YES;
        _studentButton.sakura.backgroundColor(@"Login.roleChoiceSelectedColor");
        
        
    }
}
- (void)resetButton:(UIButton *)button title:(NSString *)title action:(SEL)action{
    
    [button setTitle:title forState:UIControlStateNormal];
    button.sakura.titleColor(@"Login.roleChoiceSelectedColor",UIControlStateNormal);
    button.sakura.titleColor(@"Login.roleChoiceNomalColor",UIControlStateSelected);
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 18;
    button.layer.borderColor = [TKTheme cgColorWithPath:@"Login.roleChoiceSelectedColor"];
    button.layer.borderWidth = 1;
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)cancelButtonClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceCancel)]) {
        [self.delegate choiceCancel];
    }
}
- (void)studentClick:(UIButton *)sender{
    
    self.studentButton.selected = YES;
    self.teacherButton.selected = NO;
    self.patrolButton.selected = NO;
    self.studentButton.sakura.backgroundColor(@"Login.roleChoiceSelectedColor");
    self.teacherButton.sakura.backgroundColor(@"Login.roleChoiceNomalColor");
    self.patrolButton.sakura.backgroundColor(@"Login.roleChoiceNomalColor");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceRole:)]) {
        [self.delegate choiceRole:MTLocalized(@"Role.Student")];
    }
}
- (void)teacherClick:(UIButton *)sender{
    
    self.studentButton.selected = NO;
    self.teacherButton.selected = YES;
    self.patrolButton.selected = NO;
    self.teacherButton.sakura.backgroundColor(@"Login.roleChoiceSelectedColor");
    self.studentButton.sakura.backgroundColor(@"Login.roleChoiceNomalColor");
    self.patrolButton.sakura.backgroundColor(@"Login.roleChoiceNomalColor");
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceRole:)]) {
        [self.delegate choiceRole:MTLocalized(@"Role.Teacher")];
    }
}
- (void)assistantClick:(UIButton *)sender{
    
    self.studentButton.selected = NO;
    self.teacherButton.selected = NO;
    self.patrolButton.selected = YES;
    self.patrolButton.sakura.backgroundColor(@"Login.roleChoiceSelectedColor");
    self.studentButton.sakura.backgroundColor(@"Login.roleChoiceNomalColor");
    self.teacherButton.sakura.backgroundColor(@"Login.roleChoiceNomalColor");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceRole:)]) {
        [self.delegate choiceRole:MTLocalized(@"Role.Patrol")];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
