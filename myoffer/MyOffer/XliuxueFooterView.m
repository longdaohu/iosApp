//
//  XliuxueFooterView.m
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "XliuxueFooterView.h"

typedef enum {
    buttonTypePipei = 1,
    buttonTypeLiuxue
} buttonType;



@interface XliuxueFooterView ()
//我要留学
@property(nonatomic,strong)UIButton *submitBtn;
//智能匹配
@property(nonatomic,strong)UIButton *pipeiBtn;
//匹配提示
@property(nonatomic,strong)UILabel *pipeiLab;

@end

@implementation XliuxueFooterView

+(instancetype)footerView
{
    return [[XliuxueFooterView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.submitBtn= [self makeButtonWithTitle:GDLocalizedString(@"WoYaoLiuXue_Request") andTag:buttonTypeLiuxue andBackgroudColor:XCOLOR_RED andTextColor:XCOLOR_WHITE];
        self.pipeiBtn= [self makeButtonWithTitle:GDLocalizedString(@"WoYaoLiuXue_Match")  andTag:buttonTypePipei andBackgroudColor:XCOLOR_WHITE andTextColor:XCOLOR_RED];
        self.pipeiBtn.backgroundColor = XCOLOR_WHITE;
      
        self.pipeiLab =[self makeLabelWithTextFontSize:FONTSIZE(15)];
        self.pipeiLab.text = GDLocalizedString(@"WoYaoLiuXue_tryInTel");
        
    }
    return self;
}


-(UIButton *)makeButtonWithTitle:(NSString *)title andTag:(buttonType)type  andBackgroudColor:(UIColor *)bgColor andTextColor:(UIColor *)textColor{
    
    UIButton *sender =  [[UIButton alloc] init];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:textColor forState:UIControlStateNormal];
    [sender setTitleColor:XCOLOR_LIGHTGRAY forState:UIControlStateHighlighted];
    sender.backgroundColor = bgColor;
    sender.layer.borderColor = XCOLOR_RED.CGColor;
    sender.tag = type;
     sender.layer.cornerRadius = 5;
    sender.layer.borderWidth = 1;
    [sender addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sender];
    return sender;
}


-(UILabel *)makeLabelWithTextFontSize:(CGFloat)size{
    
     UILabel *Lab = [UILabel labelWithFontsize:size TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
     Lab.adjustsFontSizeToFitWidth = YES;
     [self addSubview:Lab];
    
    return Lab;
}

-(void)click:(UIButton *)sender
{
     if ([self.delegate respondsToSelector:@selector(liuxueFooterView:didClick:)]) {
        [self.delegate liuxueFooterView:self didClick:sender];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat submitX  = 20;
    CGFloat submitY  = 30;
    CGFloat submitW  = XScreenWidth - submitX * 2;
    CGFloat submitH  = 40;
    self.submitBtn.frame = CGRectMake(submitX, submitY, submitW, submitH);
    
    
    CGFloat plX  = submitX;
    CGFloat plY  = CGRectGetMaxY(self.submitBtn.frame) + 30;
    CGFloat plW  = submitW;
    CGFloat plH  = 20;
    self.pipeiLab.frame = CGRectMake(plX, plY, plW, plH);
    
    CGFloat piX  = submitX;
    CGFloat piY  = CGRectGetMaxY(self.pipeiLab.frame) + 5;
    CGFloat piW  = submitW;
    CGFloat piH  = 40;
    self.pipeiBtn.frame = CGRectMake(piX, piY, piW, piH);
    
}


@end
