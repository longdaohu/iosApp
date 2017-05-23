//
//  ZixunFooterView.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/22.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ZixunFooterView.h"

@interface ZixunFooterView ()
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@end

@implementation ZixunFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self makeUI];
    }
    return self;
}

- (void)makeUI{

    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setTitle:@"4000666522" forState:UIControlStateNormal];
    [leftBtn setImage:XImage(@"call") forState:UIControlStateNormal];
    [leftBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
    leftBtn.layer.cornerRadius = CORNER_RADIUS;
    leftBtn.layer.borderWidth = 1;
    leftBtn.layer.borderColor = XCOLOR_RED.CGColor;
    [self addSubview:leftBtn];
    self.leftBtn = leftBtn;
    [leftBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_RED] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_Disable] forState:UIControlStateDisabled];
    [self addSubview:rightBtn];
    self.rightBtn = rightBtn;
    rightBtn.layer.cornerRadius = CORNER_RADIUS;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.enabled = NO;
    self.backgroundColor = XCOLOR_WHITE;

}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat left_X = 10;
    CGFloat left_Y = 0;
    CGFloat left_W = (contentSize.width - left_X * 3) * 0.5;
    CGFloat left_H = 50;
    self.leftBtn.frame = CGRectMake(left_X, left_Y, left_W, left_H);
    
    
    CGFloat right_X = CGRectGetMaxX(self.leftBtn.frame ) + left_X;
    CGFloat right_Y = left_Y;
    CGFloat right_W = left_W;
    CGFloat right_H = left_H;
    self.rightBtn.frame = CGRectMake(right_X, right_Y, right_W, right_H);
    
}

- (void)onClick:(UIButton *)sender{

    if (sender == self.leftBtn) {
        
        sender.enabled = NO;
    }
    
    
    if (self.actionBlock) self.actionBlock(sender);
    
}

-(void)callButtonEnable:(BOOL)enable{

    self.leftBtn.enabled = enable;
}
-(void)submitButtonEnable:(BOOL)enable{

    self.rightBtn.enabled = enable;
}



@end
