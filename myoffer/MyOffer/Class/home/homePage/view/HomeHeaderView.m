//
//  HomeHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HomeHeaderView.h"
#import "HeadItembgView.h"
#import "XUToolbar.h"
#import "TopNavView.h"

@interface HomeHeaderView ()<UIScrollViewDelegate>
//logo图片
@property(nonatomic,strong)UIImageView *Logo;
//背景图片
@property (strong, nonatomic)TopNavView *upViewBackgroudView;
//button背景
@property(nonatomic,strong)HeadItembgView *buttonsBgView;

@end

@implementation HomeHeaderView

 
+ (instancetype)headerViewWithFrame:(CGRect)frame withactionBlock:(HeadItembgViewBlock)actionBlock
{
    
    HomeHeaderView *headerView = [[HomeHeaderView alloc]  initWithFrame:frame];
    
    headerView.buttonsBgView.actionBlock = actionBlock;
    
    return headerView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        [self makeUI];
    }
    
    return self;
}

-(void)makeUI{

    self.upView =[[UIView alloc] init];
    [self addSubview:self.upView];

    
    self.upViewBackgroudView = [[TopNavView alloc] init];
    [self.upView addSubview:self.upViewBackgroudView];
    self.upViewBackgroudView.backgroundColor = XCOLOR_RED;
    
    self.Logo             = [[UIImageView alloc] init];
    self.Logo.image       = [UIImage imageNamed:@"logo white"];
    self.Logo.contentMode = UIViewContentModeScaleAspectFit;
    [self.upView addSubview:self.Logo];
    
 
    self.buttonsBgView  =[HeadItembgView bgview];
    [self.upView addSubview:self.buttonsBgView];

}




-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat upW = contentSize.width;
    CGFloat upH = contentSize.height * 0.6 + 20;
    self.upView.frame   = CGRectMake(upX, upY, upW,upH);
    self.upViewBackgroudView.frame = self.upView.bounds;
  
    
    CGFloat LogoX   = 0;
    CGFloat LogoY   = 30;
    CGFloat LogoW   = upW;
    CGFloat LogoH   = upH * 0.15;
    self.Logo.frame = CGRectMake(LogoX, LogoY, LogoW, LogoH);
    
    CGFloat bbgX = 0;
    CGFloat bbgY = CGRectGetMaxY(self.Logo.frame) + ITEM_MARGIN;
    CGFloat bbgW = contentSize.width;
    CGFloat bbgH = upH - bbgY - 20;
    self.buttonsBgView.frame = CGRectMake(bbgX, bbgY, bbgW,bbgH);
   
}




@end
