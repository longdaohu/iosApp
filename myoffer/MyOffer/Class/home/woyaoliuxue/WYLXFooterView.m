//
//  XliuxueFooterView.m
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "WYLXFooterView.h"

@interface WYLXFooterView ()
//我要留学
@property(nonatomic,strong)UIButton *submitBtn;
//智能匹配
@property(nonatomic,strong)UIButton *pipeiBtn;
//匹配提示
@property(nonatomic,strong)UILabel *pipeiLab;

@end

@implementation WYLXFooterView
+(instancetype)footerViewWithBlock:(WYLXfooterBlock)actionBlock
{
     WYLXFooterView  *footer = [[WYLXFooterView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, 240)];
    
    footer.actionBlock = actionBlock;
    
    return footer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.submitBtn= [self makeButtonWithTitle:GDLocalizedString(@"WoYaoLiuXue_Request") andTag:FooterButtonTypeLiuxue andBackgroudColor:XCOLOR_RED andTextColor:XCOLOR_WHITE];
        self.pipeiBtn= [self makeButtonWithTitle:GDLocalizedString(@"WoYaoLiuXue_Match")  andTag:FooterButtonTypePipei andBackgroudColor:XCOLOR_WHITE andTextColor:XCOLOR_RED];
        self.pipeiBtn.backgroundColor = XCOLOR_WHITE;
      
        
        self.pipeiLab = [UILabel labelWithFontsize:XPERCENT * 13 TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
        self.pipeiLab.adjustsFontSizeToFitWidth = YES;
        self.pipeiLab.text = GDLocalizedString(@"WoYaoLiuXue_tryInTel");
        [self addSubview:self.pipeiLab];

    }
    return self;
}


-(UIButton *)makeButtonWithTitle:(NSString *)title andTag:(FooterButtonType)type  andBackgroudColor:(UIColor *)bgColor andTextColor:(UIColor *)textColor{
    
    UIButton *sender =  [[UIButton alloc] init];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:textColor forState:UIControlStateNormal];
    [sender setTitleColor:XCOLOR_LIGHTGRAY forState:UIControlStateHighlighted];
    sender.backgroundColor = bgColor;
    sender.layer.borderColor = XCOLOR_RED.CGColor;
    sender.tag = type;
     sender.layer.cornerRadius = 5;
    sender.layer.borderWidth = 1;
    [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sender];
    return sender;
}




-(void)onClick:(UIButton *)sender
{
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat submitX  = 20;
    CGFloat submitY  = 20 * XPERCENT;
    CGFloat submitW  = XScreenWidth - submitX * 2;
    CGFloat submitH  = 40;
    self.submitBtn.frame = CGRectMake(submitX, submitY, submitW, submitH);
    
    
    CGFloat plX  = submitX;
    CGFloat plY  = CGRectGetMaxY(self.submitBtn.frame) + submitY;
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
