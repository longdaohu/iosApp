//
//  YourPhoneView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/23.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "YourPhoneView.h"

@interface  YourPhoneView ()
@property (strong, nonatomic)  UIView *bgView;
@property (strong, nonatomic)  UIView *LineOne;
@property (strong, nonatomic)  UIView *LineTwo;
@property (strong, nonatomic)  UIView *LineThree;
//直接进入编辑框 ———— 取消按钮
@property (strong, nonatomic) UIButton *CancelBtn;
//直接进入编辑框 ———— 提交按钮
@property (strong, nonatomic) UIButton *CommitBtn;
//直接进入编辑框 ———— 编辑框抬头
@property (strong, nonatomic)  UILabel *TitleLab;



@end

@implementation YourPhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor = XCOLOR_WHITE;
        self.bgView.layer.cornerRadius = 5;
        [self addSubview:self.bgView];
        
        self.TitleLab = [[UILabel alloc] init];
        self.TitleLab.textAlignment = NSTextAlignmentCenter;
        self.TitleLab.text = GDLocalizedString(@"bangdingVC-profile");
        self.TitleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:19.0];
        [self.bgView addSubview:self.TitleLab];
        
        self.countryCode = (XTextField *)[self makeTextFieldWithPlaceholder:nil];
          self.countryCode.text = USER_EN ? GDLocalizedString(@"LoginVC-english"):GDLocalizedString(@"LoginVC-china");
 
        self.LineOne =[self makeLine];

        
        self.PhoneTF =[self makeTextFieldWithPlaceholder:GDLocalizedString(@"LoginVC-006")];
        
        self.LineTwo = [self makeLine];
        
        self.VerifyTF =[self makeTextFieldWithPlaceholder:GDLocalizedString(@"LoginVC-VerificationCode")];
        
        self.SendCodeBtn = [self makeButtonWithTitle:GDLocalizedString(@"LoginVC-008") andTag:10 andBackgroudColor:XCOLOR_WHITE andTitleFontSize:17];
        [self.SendCodeBtn  setTitleColor:XCOLOR_RED forState:UIControlStateNormal];

        self.LineThree = [self makeLine];
        

        self.CancelBtn =[self makeButtonWithTitle:GDLocalizedString(@"Potocol-Cancel")  andTag:11 andBackgroudColor:XCOLOR_LIGHTGRAY andTitleFontSize:15];
       
        self.CommitBtn =[self makeButtonWithTitle:GDLocalizedString(@"SearchResult_commit")   andTag:12 andBackgroudColor:XCOLOR_RED andTitleFontSize:15];
        
        
    }
    return self;
}

-(UIButton *)makeButtonWithTitle:(NSString *)titleName andTag:(NSInteger)tag andBackgroudColor:(UIColor *)bgColor andTitleFontSize:(CGFloat)fontSize
{
    UIButton  *sender =[[UIButton alloc] init];
    sender.backgroundColor = bgColor;
    [sender setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    [sender setTitle:titleName forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:fontSize];
     sender.tag = tag;
     sender.layer.cornerRadius = 2;
    [sender addTarget:self action:@selector(phoneViewItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:sender];
    
    return sender;
}

-(UIView *)makeLine
{
    UIView *Line =[[UIView alloc] init];
    Line.backgroundColor = XCOLOR_BG;
    [self.bgView addSubview:Line];
    
    return Line;
}

-(UITextField *)makeTextFieldWithPlaceholder:(NSString *)placeholder
{
    XTextField *TF =[[XTextField alloc] init];
    TF.keyboardType =  UIKeyboardTypeNumberPad;
    TF.borderStyle = UITextBorderStyleNone;
    TF.placeholder = placeholder;
    [self.bgView addSubview:TF];
    
    return TF;
}

- (void)phoneViewItemClick:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(YourPhoneView:WithButtonItem:)]) {
        
        [self.delegate YourPhoneView:self WithButtonItem:sender];
    }
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat bgx = 20;
    CGFloat bgy = 0;
    CGFloat bgw = XScreenWidth - 40;
    CGFloat bgh = self.bounds.size.height;
    self.bgView.frame = CGRectMake(bgx, bgy, bgw, bgh);
    
    
    CGFloat TitleLabx = 0;
    CGFloat TitleLaby = 0;
    CGFloat TitleLabw = bgw;
    CGFloat TitleLabh = 30;
    self.TitleLab.frame = CGRectMake(TitleLabx,TitleLaby, TitleLabw, TitleLabh);
    
    CGFloat countryx = 25;
    CGFloat countryy = CGRectGetMaxY(self.TitleLab.frame);
    CGFloat countryw = bgw - 40;
    CGFloat countryh = 40;
    self.countryCode.frame = CGRectMake(countryx,countryy, countryw, countryh);
    
    CGFloat onex = countryx;
    CGFloat oney = CGRectGetMaxY(self.countryCode.frame);
    CGFloat onew = countryw;
    CGFloat oneh = 1;
    self.LineOne.frame = CGRectMake(onex, oney, onew, oneh);
    
    CGFloat phonex = countryx;
    CGFloat phoney = CGRectGetMaxY(self.LineOne.frame) + ITEM_MARGIN;
    CGFloat phonew = countryw;
    CGFloat phoneh = countryh;
    self.PhoneTF.frame =  CGRectMake(phonex, phoney, phonew, phoneh);
    
    CGFloat twox = countryx;
    CGFloat twoy = CGRectGetMaxY(self.PhoneTF.frame);
    CGFloat twow = countryw;
    CGFloat twoh = 1;
    self.LineTwo.frame = CGRectMake(twox, twoy, twow, twoh);
    
    CGFloat Verx = countryx;
    CGFloat Very = CGRectGetMaxY(self.LineTwo.frame) + ITEM_MARGIN;
    CGFloat Verw = countryw;
    CGFloat Verh = countryh;
    self.VerifyTF.frame =  CGRectMake(Verx, Very, Verw, Verh);
    
    CGFloat codew = 100;
    CGFloat codex = CGRectGetMaxX(self.VerifyTF.frame) - codew;
    CGFloat codey = Very;
    CGFloat codeh = Verh;
    self.SendCodeBtn.frame =  CGRectMake(codex, codey, codew, codeh);
    
    
    CGFloat threex = countryx;
    CGFloat threey = CGRectGetMaxY(self.VerifyTF.frame);
    CGFloat threew = countryw;
    CGFloat threeh = 1;
    self.LineThree.frame = CGRectMake(threex, threey, threew, threeh);
 
    
    CGFloat cancelx = 20;
    CGFloat cancelw = 0.5 * (bgw - 50);
    CGFloat cancelh = 40;
    CGFloat cancely = CGRectGetMaxY(self.bgView.frame) - 50;
    self.CancelBtn.frame = CGRectMake(cancelx, cancely, cancelw, cancelh);
    
    CGFloat submity = cancely;
    CGFloat submitw = cancelw;
    CGFloat submith = cancelh;
    CGFloat submitx = CGRectGetMaxX(self.CancelBtn.frame) +10;
    self.CommitBtn.frame = CGRectMake(submitx, submity, submitw, submith);
    
    
}

@end
