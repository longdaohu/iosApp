//
//  XliuxueSuccessView.m
//  myOffer
//
//  Created by xuewuguojie on 16/7/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "WYLXSuccessView.h"

@interface WYLXSuccessView ()
//提交成功
@property (weak, nonatomic) IBOutlet UILabel *succeseLab;
//提示文字
@property (weak, nonatomic) IBOutlet UILabel *alerLab;
//返回按钮
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
//渐变色
@property(nonatomic,strong)CAGradientLayer *gradientLayer;

@end


@implementation WYLXSuccessView

+(instancetype)successViewWithBlock:(successBlock)actionBlock
{
    WYLXSuccessView  *SuccessView =  [[NSBundle mainBundle] loadNibNamed:@"WYLXSuccessView" owner:self options:nil].lastObject;
   
    SuccessView.frame = CGRectMake(0, XSCREEN_HEIGHT, XSCREEN_WIDTH, XSCREEN_HEIGHT);
    
    SuccessView.actionBlock = actionBlock;
    
    return SuccessView;
}


- (void)caseBack
{
    if (self.actionBlock) {
        
        self.actionBlock();
    }
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.gradientLayer.frame = self.frame;

}

-(void)awakeFromNib{

    [super awakeFromNib];
    
    //渐变色
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)XCOLOR(48, 202, 255).CGColor,
                       (id)XCOLOR(159, 0, 107).CGColor,
                       nil];
    gradient.startPoint = CGPointMake(0.8, 0);
    gradient.endPoint = CGPointMake(1, 1);
    [self.layer insertSublayer:gradient atIndex:0];
    self.gradientLayer = gradient;

    [self.OKButton  addTarget:self action:@selector(caseBack) forControlEvents:UIControlEventTouchUpInside];
    self.OKButton.layer.borderColor = XCOLOR_WHITE.CGColor;
    
    self.alerLab.font = [UIFont systemFontOfSize:XPERCENT * 14];
    self.succeseLab.font = [UIFont systemFontOfSize:XPERCENT * 18];
    
}


@end
