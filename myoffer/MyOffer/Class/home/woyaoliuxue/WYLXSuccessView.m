//
//  XliuxueSuccessView.m
//  myOffer
//
//  Created by xuewuguojie on 16/7/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "WYLXSuccessView.h"

@interface WYLXSuccessView ()
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


@implementation WYLXSuccessView

+(instancetype)successViewWithBlock:(successBlock)actionBlock
{
    WYLXSuccessView  *SuccessView = [[WYLXSuccessView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
    
    SuccessView.actionBlock = actionBlock;
    
    return SuccessView;
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
        
        self.succeseLab =[UILabel labelWithFontsize:XPERCENT * 18  TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentCenter];
        self.succeseLab.text = GDLocalizedString(@"WoYaoLiuXue_submit");
        [self.bgView addSubview:self.succeseLab];
        
        self.alerLab =[UILabel labelWithFontsize:XPERCENT * 14  TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentCenter];
        self.alerLab.numberOfLines = 0;
        self.alerLab.text =  GDLocalizedString(@"WoYaoLiuXue_aler");
        [self.bgView addSubview:self.alerLab];
        
        
        self.OKButton =[[UIButton alloc] init];
        [self.OKButton setTitle:GDLocalizedString(@"WoYaoLiuXue_home") forState:UIControlStateNormal];
        [self.OKButton setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        self.OKButton.layer.cornerRadius = CORNER_RADIUS;
        self.OKButton.layer.borderWidth = 1;
        self.OKButton.layer.borderColor = XCOLOR_WHITE.CGColor;
        [self addSubview:self.OKButton];
        [self.OKButton  addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

-(void)back
{
    if (self.actionBlock) {
        
        self.actionBlock();
    }
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    
    self.gradientLayer.frame = self.frame;
    
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat bgX = 0;
    CGFloat bgY = contentSize.height * 0.2 ;
    CGFloat bgW = contentSize.width;
    CGFloat bgH = contentSize.height * 0.4;
    self.bgView.frame =CGRectMake(bgX, bgY, bgW, bgH);
    
    
    CGFloat gouY = 0;
    CGFloat gouH = XPERCENT * 80;
    CGFloat gouW = gouH;
    CGFloat gouX = 0.5 * (contentSize.width - gouW);
    self.gouView.frame =CGRectMake(gouX, gouY, gouW, gouH);
    
    
    CGFloat successX = 0;
    CGFloat successY = CGRectGetMaxY(self.gouView.frame) + ITEM_MARGIN;
    CGFloat successW = contentSize.width;
    CGFloat successH = XPERCENT * 18;
    self.succeseLab.frame =CGRectMake(successX, successY, successW, successH);
    
    CGFloat alerX = ITEM_MARGIN;
    CGFloat alerY = CGRectGetMaxY(self.succeseLab.frame) + ITEM_MARGIN;
    CGFloat alerW = contentSize.width - 2 * ITEM_MARGIN;
    CGFloat  alerH = 0;
    if (self.alerLab.text) {
        CGSize LabSize = [self.alerLab.text KD_sizeWithAttributeFont:XFONT(XPERCENT * 14) maxWidth:alerW];
        alerH = LabSize.height;
    }
    
    self.alerLab.frame =CGRectMake(alerX, alerY, alerW, alerH);
    
    
    
    CGFloat okH = 40 * XPERCENT;
    CGFloat okX = 20;
    CGFloat okW = contentSize.width - 2 * okX;
    CGFloat okY = contentSize.height * 0.8;
    self.OKButton.frame =CGRectMake(okX, okY, okW, okH);
    
}

@end
