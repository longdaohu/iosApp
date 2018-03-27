//
//  HomeHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HomeHeaderView.h"
#import "TopNavView.h"
#import "HeadItem.h"


@interface HomeHeaderView ()<UIScrollViewDelegate>
//logo图片
@property(nonatomic,strong)UIImageView *Logo;
//名称数组
@property(nonatomic,strong)NSArray *itemTitles;
//图片数组
@property(nonatomic,strong)NSArray *itemImages;

@property(nonatomic,strong)UIView *downView;

@property(nonatomic,strong)UIView *bottom_line;

@property(nonatomic,strong)UIView *marginView;


@end

@implementation HomeHeaderView

 
+ (instancetype)headerViewWithFrame:(CGRect)frame actionBlock:(HomeHeaderViewBlock)actionBlock
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
        
        _itemImages =@[@"home_woyao",@"home_xiaobai",@"Home_pipei",@"Home_rank",@"Home_super",@"home_Mall"];
    }
  
    return _itemImages;
}

-(NSArray *)itemTitles
{
    if (!_itemTitles) {
        
        _itemTitles =@[@"我要留学" ,@"留学指南",@"智能匹配",@"大学排名",@"海外超级导师",@"留学购"];
        
    }
    
    return _itemTitles;
}


-(void)makeUI{

    self.backgroundColor = XCOLOR_WHITE;
    
    self.downView =[[UIView alloc] init];
    [self addSubview:self.downView];
    
    for (int i = 0 ;i < self.itemTitles.count ; i++) {
        
        HeadItem *item = [HeadItem itemInitWithTitle:self.itemTitles[i] imageName:self.itemImages[i]];
        item.tag       =  i;
        item.actionBlock = ^(NSInteger index){
            
            [self buttonClick:index];
        };
        [self.downView addSubview:item];
    }
    
    self.marginView =[[UIView alloc] init];
    self.marginView.backgroundColor = XCOLOR_BG;
    [self addSubview:self.marginView];
    
    self.bottom_line =[[UIView alloc] init];
    self.bottom_line.backgroundColor = XCOLOR_line;
    [self.marginView addSubview:self.bottom_line];

}


- (void)setHeaderFrame:(HomeHeaderFrame *)headerFrame{

    _headerFrame = headerFrame;
  
    self.downView.frame   = headerFrame.downView_frame;
   
    self.marginView.frame = headerFrame.margin_frame;
    
    self.bottom_line.frame = CGRectMake(0,0,self.marginView.mj_w, 1);
    
    for (int index = 0 ;index < headerFrame.headerItem_frames.count ; index++) {
        
        HeadItem *item = (HeadItem *)self.downView.subviews[index];
        item.frame = [headerFrame.headerItem_frames[index] CGRectValue];
        item.headerFrame = headerFrame;
        
    }

}



- (void)buttonClick:(NSInteger)index{

    if (self.actionBlock) self.actionBlock(index);
}




@end
