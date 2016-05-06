//
//  YourBindView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "YourBindView.h"
@interface  YourBindView ()
@property (strong, nonatomic)  UIView *LineOne;
@property (strong, nonatomic)  UIView *LineTwo;
@property (strong, nonatomic)  UIButton *CancelBtn;
@property (strong, nonatomic)  UIButton *BindSubmit;
@property (strong, nonatomic)  UIView *bgView;
@end

@implementation YourBindView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor = XCOLOR_WHITE;
        self.bgView.layer.cornerRadius = 5;
        [self addSubview:self.bgView];
        
 
        self.Bind_PhoneFT =[self makeTextFieldWithPlaceholder:GDLocalizedString(@"LoginVC-004")];
        
        self.LineOne =[self makeLine];
        
        self.Bind_PastWordFT =[self makeTextFieldWithPlaceholder:GDLocalizedString(@"LoginVC-0011")];

        
        self.LineTwo =[self makeLine];
   
        self.CancelBtn = [self makeButtonWithTitle:GDLocalizedString(@"Potocol-Cancel")  andTag:10 andBackgroudColor:XCOLOR_LIGHTGRAY andTitleFontSize:15];
        
        self.BindSubmit = [self makeButtonWithTitle:GDLocalizedString(@"bangdingVC-bindBtn")  andTag:11 andBackgroudColor:XCOLOR_RED andTitleFontSize:15];
        
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
    [sender addTarget:self action:@selector(BindViewItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:sender];
    
    return sender;
}

-(UITextField *)makeTextFieldWithPlaceholder:(NSString *)placeholder
{
    XTextField *TextF =[[XTextField alloc] init];
    TextF.borderStyle = UITextBorderStyleNone;
    TextF.placeholder = placeholder;
    [self.bgView addSubview:TextF];
    
    return TextF;
}

-(UIView *)makeLine
{
    UIView *Line =[[UIView alloc] init];
    Line.backgroundColor = BACKGROUDCOLOR;
    [self.bgView addSubview:Line];
    
    return Line;
}


- (void)BindViewItemClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(YourBindView:didClick:)]) {
        
        [self.delegate YourBindView:self didClick:sender];
    }
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];

    CGFloat bgx = 20;
    CGFloat bgy = 0;
    CGFloat bgw = XScreenWidth - 40;
    CGFloat bgh = 210;
    self.bgView.frame = CGRectMake(bgx, bgy, bgw, bgh);
    
    CGFloat bpx = 20;
    CGFloat bpy = 25;
    CGFloat bpw = bgw - 40;
    CGFloat bph = 40;
    self.Bind_PhoneFT.frame =  CGRectMake(bpx, bpy, bpw, bph);
    
    CGFloat onex = bpx;
    CGFloat oney = CGRectGetMaxY(self.Bind_PhoneFT.frame);
    CGFloat onew = bpw;
    CGFloat oneh = 1;
    self.LineOne.frame = CGRectMake(onex, oney, onew, oneh);
    
  
    CGFloat pwx = bpx;
    CGFloat pwy = CGRectGetMaxY(self.LineOne.frame) + ITEM_MARGIN;
    CGFloat pww = bpw;
    CGFloat pwh = bph;
    self.Bind_PastWordFT.frame =  CGRectMake(pwx, pwy, pww, pwh);
    
    CGFloat twox = bpx;
    CGFloat twoy = CGRectGetMaxY(self.Bind_PastWordFT.frame);
    CGFloat twow = bpw;
    CGFloat twoh = 1;
    self.LineTwo.frame = CGRectMake(twox, twoy, twow, twoh);
    
    
    CGFloat cancelx = 20;
    CGFloat cancelw = 0.5 * (bgw - 50);
    CGFloat cancelh = 40;
    CGFloat cancely = bgh - 50;
    self.CancelBtn.frame = CGRectMake(cancelx, cancely, cancelw, cancelh);
    
    CGFloat submity = cancely;
    CGFloat submitw = cancelw;
    CGFloat submith = cancelh;
    CGFloat submitx = CGRectGetMaxX(self.CancelBtn.frame) +10;
    self.BindSubmit.frame = CGRectMake(submitx, submity, submitw, submith);
    
    
 
}


@end
