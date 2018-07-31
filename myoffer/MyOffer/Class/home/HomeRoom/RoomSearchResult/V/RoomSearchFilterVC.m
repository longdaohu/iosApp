//
//  RoomSearchFilterVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomSearchFilterVC.h"
#import "Masonry.h"

@interface RoomSearchFilterVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)CAShapeLayer *shaper;
@property(nonatomic,strong)UITextField *price_TF_low;
@property(nonatomic,strong)UITextField *price_TF_Heigh;
@property(nonatomic,strong)UITextField *time_TF_low;
@property(nonatomic,strong)UITextField *time_TF_Heigh;
@end

@implementation RoomSearchFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    [self addNotificationCenter];
}

//键盘处理通知
-(void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)makeUI{
    
    self.view.backgroundColor = XCOLOR(0, 0, 0, 0);

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT, XSCREEN_WIDTH, 312)];
    self.bgView = bgView;
    bgView.backgroundColor = XCOLOR_WHITE;
    [self.view addSubview:bgView];
    bgView.layer.cornerRadius = 10;

    UILabel *priceTitleLab = [self  makeLabelWithText:@"价格区间" textColor:XCOLOR_TITLE font:[UIFont boldSystemFontOfSize:14] superView:bgView];
    [priceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.mas_equalTo(bgView).mas_offset(20);
        make.top.mas_equalTo(bgView).mas_offset(28);
    }];
    
    UILabel *priceSubLab = [self  makeLabelWithText:@"# 价格最高不超过1300€ #" textColor:XCOLOR_SUBTITLE font:XFONT(12) superView:bgView];
    [priceSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceTitleLab.mas_right);
        make.bottom.mas_equalTo(priceTitleLab.mas_bottom);
    }];
    
    UITextField *price_TF_Low = [self makeTextFieldWithPlaceholder:@"最低价" superView:bgView];
    self.price_TF_low = price_TF_Low;
    [price_TF_Low mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130, 36));
        make.left.mas_equalTo(priceTitleLab.mas_left);
        make.top.mas_equalTo(priceTitleLab.mas_bottom).mas_offset(10);
    }];
    
    UITextField *price_TF_High = [self makeTextFieldWithPlaceholder:@"最高价" superView:bgView];
    self.price_TF_Heigh = price_TF_High;
    [price_TF_High mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(price_TF_Low);
        make.right.mas_equalTo(bgView.mas_right).mas_offset(-20);
        make.top.mas_equalTo(price_TF_Low);
    }];
    
    UIView *line_one = [UIView new];
    line_one.backgroundColor = XCOLOR_RANDOM;
    [bgView addSubview:line_one];
    [line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(price_TF_Low.mas_right).mas_offset(10);
        make.right.mas_equalTo(price_TF_High.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(price_TF_Low.mas_centerY);
    }];
    
    UILabel *timeTitleLab = [self  makeLabelWithText:@"租房周期（月）" textColor:XCOLOR_TITLE font:[UIFont boldSystemFontOfSize:14] superView:bgView];
    [timeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(priceTitleLab.mas_left);
        make.top.mas_equalTo(price_TF_Low.mas_bottom).mas_offset(28);
    }];
    
    UILabel *timeSubLab = [self  makeLabelWithText:@"# 周期最长不超过10周 #" textColor:XCOLOR_SUBTITLE font:XFONT(12) superView:bgView];
    [timeSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeTitleLab.mas_right);
        make.bottom.mas_equalTo(timeTitleLab.mas_bottom);
    }];
    
    UITextField *time_TF_Low = [self makeTextFieldWithPlaceholder:@"最短租期" superView:bgView];
    self.time_TF_low = time_TF_Low;
    [time_TF_Low mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(price_TF_Low);
        make.left.mas_equalTo(priceTitleLab.mas_left);
        make.top.mas_equalTo(timeTitleLab.mas_bottom).mas_offset(10);
    }];
    
    UITextField *time_TF_High = [self makeTextFieldWithPlaceholder:@"最长租期" superView:bgView];
    self.time_TF_Heigh = time_TF_High;
    [time_TF_High mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(price_TF_Low);
        make.right.mas_equalTo(price_TF_High.mas_right);
        make.top.mas_equalTo(time_TF_Low.mas_top);
    }];
    
    UIView *line_time = [UIView new];
    line_time.backgroundColor = XCOLOR_RANDOM;
    [bgView addSubview:line_time];
    [line_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(line_one.mas_height);
        make.left.mas_equalTo(price_TF_Low.mas_right).mas_offset(10);
        make.right.mas_equalTo(price_TF_High.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(time_TF_High.mas_centerY);
    }];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = XCOLOR_WHITE;
    [bgView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(46);
        make.left.mas_equalTo(price_TF_Low.mas_left);
        make.right.mas_equalTo(price_TF_High.mas_right);
        make.top.mas_equalTo(time_TF_Low.mas_bottom).mas_offset(50);
    }];
    bottomView.layer.cornerRadius = 8;
    bottomView.layer.masksToBounds = YES;
    self.bottomView = bottomView;
    
    UIButton *restBtn = [UIButton new];
    [restBtn addTarget:self action:@selector(rest:) forControlEvents:UIControlEventTouchUpInside];
    restBtn.titleLabel.font = XFONT(14);
    [restBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
    [restBtn setTitle:@"重置" forState:UIControlStateNormal];
    [bottomView addSubview:restBtn];
    [restBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.left.mas_equalTo(bottomView.mas_left);
        make.top.mas_equalTo(bottomView.mas_top);
        make.bottom.mas_equalTo(bottomView.bottom);
    }];
    
    UIButton *comitBtn = [UIButton new];
    comitBtn.backgroundColor = XCOLOR_LIGHTBLUE;
    comitBtn.titleLabel.font = XFONT(14);
    [comitBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [comitBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    [comitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bottomView addSubview:comitBtn];
    [comitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(restBtn.mas_right);
        make.right.mas_equalTo(bottomView.mas_right);
        make.top.mas_equalTo(bottomView.mas_top);
        make.bottom.mas_equalTo(bottomView.bottom);
    }];
    
}

- (UILabel *)makeLabelWithText:(NSString *)text textColor:(UIColor *)textColor  font:(UIFont *)font  superView:(UIView *)superView{
    
    UILabel *sender = [UILabel new];
    sender.font = font;
    sender.textColor = textColor;
    sender.text = text;
    [superView addSubview:sender];
    
    return sender;
}

- (UITextField *)makeTextFieldWithPlaceholder:(NSString *)placeholder superView:(UIView *)superView{
   
    UITextField *TF = [UITextField new];
    TF.keyboardType = UIKeyboardTypeNumberPad;
    TF.textAlignment = NSTextAlignmentCenter;
    TF.backgroundColor = XCOLOR(239, 242, 245, 1);
    TF.placeholder = placeholder;
    [superView addSubview:TF];
    TF.delegate = self;
    TF.layer.cornerRadius = 4;
    
    return TF;
}

- (CAShapeLayer *)shaper{
    
    if (!_shaper) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor =  XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 3);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.5;
        _shaper = shaper;
        [self.bgView.layer insertSublayer:shaper atIndex:0];
    }
    
    return _shaper;
}


- (void)show{
    
    self.view.alpha = 1;
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.view.backgroundColor = XCOLOR(0, 0, 0, BACKGROUNDCOLOR_ALPHA);
        self.bgView.transform = CGAffineTransformMakeTranslation(0, -self.bgView.mj_h);
    }];
}

- (void)hiden{
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.view.backgroundColor = XCOLOR(0, 0, 0, 0);
        self.bgView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.view.alpha = 0;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self.view endEditing:YES];
    
    UITouch *touch = touches.anyObject;
    CGPoint pt = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.bgView.frame, pt)) return;
    
    [self hiden];
}

#pragma mark : 键盘处理
- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up {
    NSDictionary* userInfo = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    CGFloat bg_y  = CGRectGetMaxY(self.bgView.frame);
    CGFloat move = 0;
    if (up && (bg_y + keyboardEndFrame.size.height) > self.view.bounds.size.height) {
        move =  self.view.bounds.size.height - bg_y - keyboardEndFrame.size.height;
    }
 
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    self.view.mj_y =  move;
    [self.view layoutSubviews];
    [UIView commitAnimations];
    
}

- (void)rest:(UIButton *)sender{

     self.time_TF_Heigh.text = @"";
     self.time_TF_low.text = @"";
     self.price_TF_Heigh.text = @"";
     self.price_TF_low.text = @"";
    
     [self.view endEditing:YES];
}


- (void)commit:(UIButton *)sender{
 
    [self hiden];

    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
 
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bottomView.frame];
    self.shaper.shadowPath = path.CGPath;
}



#pragma mark : UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
//    NSInteger number = [textField.text integerValue];
    
    if (textField == self.price_TF_low) {
        
    }
    if (textField == self.price_TF_Heigh) {
        
    }
    if (textField == self.time_TF_low) {
        
    }
    if (textField == self.time_TF_Heigh) {
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length + 1  > 4) {
        return  NO;
    }
    return YES;
}

/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0); // if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    KDClassLog(@" 51ROOM筛选页 + RoomSearchFilterVC + dealloc");
}

@end
