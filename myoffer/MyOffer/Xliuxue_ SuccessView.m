//
//  Xliuxue_ SuccessView.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/8.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "Xliuxue_ SuccessView.h"
@interface Xliuxue__SuccessView ()
//背景View
@property(nonatomic,strong)UIView  *bgView;
//图片
@property(nonatomic,strong)UIImageView *gouView;
//提交成功
@property(nonatomic,strong)UILabel *succeseLab;
//提示文字
@property(nonatomic,strong)UILabel *alerLab;
//返回按钮
@property(nonatomic,strong)UIButton *OKButton;
//渐变色
@property(nonatomic,strong)CAGradientLayer *gradientLayer;

@end


@implementation Xliuxue__SuccessView

+(instancetype)successView
{
    return [[Xliuxue__SuccessView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //渐变色
        CAGradientLayer *gradient = [CAGradientLayer layer];
        self.gradientLayer = gradient;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor colorWithRed:48/255.0 green:202/255.0 blue:255/255.0 alpha:1].CGColor,
                           (id)[UIColor colorWithRed:159/255.0 green:0/255.0 blue:107/255.0 alpha:1].CGColor,
                           nil];
        gradient.startPoint = CGPointMake(0.8, 0);
        gradient.endPoint = CGPointMake(1, 1);
        [self.layer insertSublayer:gradient atIndex:0];
        
        self.bgView =[[UIView alloc] init];
        [self addSubview:self.bgView];
        
        self.gouView =[[UIImageView alloc] init];
        self.gouView.contentMode = UIViewContentModeScaleAspectFit;
        self.gouView.image =[UIImage imageNamed:@"gou_white"];
        [self.bgView addSubview:self.gouView];
        
         self.succeseLab =[UILabel labelWithFontsize:20.0f  TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentCenter];
         self.succeseLab.text = GDLocalizedString(@"WoYaoLiuXue_submit");
         [self.bgView addSubview:self.succeseLab];
 
        self.alerLab =[UILabel labelWithFontsize:16.0f  TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentCenter];
        self.alerLab.numberOfLines = 0;
        self.alerLab.text =  GDLocalizedString(@"WoYaoLiuXue_aler");
        [self.bgView addSubview:self.alerLab];
        
        
        self.OKButton =[[UIButton alloc] init];
        [self.OKButton setTitle:GDLocalizedString(@"WoYaoLiuXue_home") forState:UIControlStateNormal];
        [self.OKButton setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        self.OKButton.layer.cornerRadius = 2;
        self.OKButton.layer.borderWidth = 1;
        self.OKButton.layer.borderColor = XCOLOR_WHITE.CGColor;
        [self addSubview:self.OKButton];
        [self.OKButton  addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

-(void)tap
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    
    self.gradientLayer.frame = self.frame;

    
    CGFloat bgX = 0;
    CGFloat bgY = XScreenHeight * 0.2 ;
    CGFloat bgW = XScreenWidth;
    CGFloat bgH = XScreenHeight  * 0.4;
    self.bgView.frame =CGRectMake(bgX, bgY, bgW, bgH);
    
    
    CGFloat gouY = 0;
    CGFloat gouW = 100;
    CGFloat gouH = 100;
    CGFloat gouX = 0.5 * (XScreenWidth - gouW);
    self.gouView.frame =CGRectMake(gouX, gouY, gouW, gouH);
    
    
    CGFloat successX = 0;
    CGFloat successY = CGRectGetMaxY(self.gouView.frame) + ITEM_MARGIN;
    CGFloat successW = XScreenWidth;
    CGFloat successH = 30;
    self.succeseLab.frame =CGRectMake(successX, successY, successW, successH);
    
    CGFloat alerX = ITEM_MARGIN;
    CGFloat alerY = CGRectGetMaxY(self.succeseLab.frame);
    CGFloat alerW = XScreenWidth - 2 * ITEM_MARGIN;
    CGFloat  alerH = 0;
    if (self.alerLab.text) {
        
        CGSize LabSize = [self.alerLab.text boundingRectWithSize:CGSizeMake(alerW, 999)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:FontWithSize(16)}
                                                         context:NULL].size;
        alerH = LabSize.height;
    }

    self.alerLab.frame =CGRectMake(alerX, alerY, alerW, alerH);

    

    CGFloat okH = 40;
    CGFloat okX = 20;
    CGFloat okW = XScreenWidth - 2 * okX;
    CGFloat okY = XScreenHeight * 0.8;
    self.OKButton.frame =CGRectMake(okX, okY, okW, okH);
    
}

@end
