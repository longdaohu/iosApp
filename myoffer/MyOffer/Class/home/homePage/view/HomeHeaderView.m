//
//  HomeHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HomeHeaderView.h"
#import "XUToolbar.h"
#import "TopNavView.h"
#import "HeadItem.h"

@interface HomeHeaderView ()<UIScrollViewDelegate>
//logo图片
@property(nonatomic,strong)UIImageView *Logo;
//背景图片
@property (strong, nonatomic)TopNavView *upViewBackgroudView;
//button背景
@property(nonatomic,strong)UIView *itemsBgView;
//名称数组
@property(nonatomic,strong)NSArray *itemTitles;
//图片数组
@property(nonatomic,strong)NSArray *itemImages;
@end

@implementation HomeHeaderView

 
+ (instancetype)headerViewWithFrame:(CGRect)frame withactionBlock:(HomeHeaderViewBlock)actionBlock
{
    
    HomeHeaderView *headerView = [[HomeHeaderView alloc]  initWithFrame:frame];
    
    headerView.actionBlock = actionBlock;
    
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

-(NSArray *)itemImages
{
    if (!_itemImages) {
        
        _itemImages =@[@"home_woyao",@"home_xiaobai",@"Home_pipei",@"Home_mbti",@"Home_super",@"home_Mall"];
    }
    
    return _itemImages;
}

-(NSArray *)itemTitles
{
    if (!_itemTitles) {
        
        _itemTitles =@[@"我要留学" ,@"留学小白",@"智能匹配",@"职业性格测试",@"海外超级导师",@"留学服务套餐"];
        
    }
    
    return _itemTitles;
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
    
 
    self.itemsBgView  =[[UIView alloc] init];
    [self.upView addSubview:self.itemsBgView];
    
    for (int i = 0 ;i < self.itemTitles.count ; i++) {
        
        HeadItem *item = [HeadItem itemInitWithTitle:self.itemTitles[i] imageName:self.itemImages[i]];
        item.tag       =  i;
        item.actionBlock = ^(NSInteger index){
            [self buttonClick:index];
        };
        [self.itemsBgView addSubview:item];
    }


}

- (void)buttonClick:(NSInteger)index{

    if (self.actionBlock) self.actionBlock(index);
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
    
    CGFloat itemsBgX = 0;
    CGFloat itemsBgY = CGRectGetMaxY(self.Logo.frame) + ITEM_MARGIN;
    CGFloat itemsBgW = contentSize.width;
    CGFloat itemsBgH = upH - itemsBgY - 20;
    self.itemsBgView.frame = CGRectMake(itemsBgX, itemsBgY, itemsBgW,itemsBgH);
    
    
    CGFloat itemW =  itemsBgW / 3;
    CGFloat itemH =  itemsBgH * 0.5;
    for (int index = 0 ;index < self.itemsBgView.subviews.count ; index++) {
        HeadItem *item = (HeadItem *)self.itemsBgView.subviews[index];
        CGFloat itemX  =  (index % 3) * itemW;
        CGFloat itemY  =  itemH  * (index / 3);
        item.frame     = CGRectMake(itemX, itemY, itemW, itemH);
        
    }

   
}




@end
