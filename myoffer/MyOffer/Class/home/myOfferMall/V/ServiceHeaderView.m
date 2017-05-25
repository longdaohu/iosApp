//
//  ServiceHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceHeaderView.h"
#import "HeadItem.h"


@interface ServiceHeaderView ()
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)NSArray *countries;
@property(nonatomic,strong)NSArray *country_icones;

@end

@implementation ServiceHeaderView

- (NSArray *)countries{

    if (!_countries) {
        
        _countries = @[
                       @"英国",
                       @"澳大利亚",
                       @"香港"
                        ];
    }
    
    return _countries;
}

- (NSArray *)country_icones{
    
    if (!_country_icones) {
        
        _country_icones = @[
                       @"hero-country-UK",
                       @"hero-country-AU",
                       @"hero-country-HK"
                       ];
    }
    
    return _country_icones;
}


+ (instancetype)headerViewWithFrame:(CGRect)frame ationBlock:(ServiceHeaderViewBlock)actionBlock{
    
    ServiceHeaderView *headerView = [[ServiceHeaderView alloc]  initWithFrame:frame];
    
//    headerView.actionBlock = actionBlock;
    
    headerView.backgroundColor = XCOLOR_WHITE;
    
    return headerView;
    
}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) [self makeUI:frame];
    
    return self;
}

- (void)makeUI:(CGRect)frame{

    //国家地区View 用于存放子VIEW
    self.bottomView = [UIView new];
    [self addSubview:self.bottomView];

    
    
    for (NSInteger i = 0 ; i < self.countries.count; i++) {
        
        HeadItem *item = [HeadItem itemInitWithTitle:self.countries[i]  imageName:self.country_icones[i]];
        item.tag       =  i;
        item.actionBlock = ^(NSInteger index){
            
//            [self buttonClick:index];
        };
        
        [self.bottomView addSubview:item];
    }
    
    
    

 
    //底部分隔线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
    line.backgroundColor = XCOLOR_line;
    [self addSubview:line];

}


- (void)setHeaderFrame:(MyOfferServiceMallHeaderFrame *)headerFrame{

    _headerFrame = headerFrame;
  
    self.bottomView.frame = headerFrame.downView_frame;
    
 
    for (int index = 0 ;index < self.bottomView.subviews.count ; index++) {
        
        HeadItem *item = (HeadItem *)self.bottomView.subviews[index];
        
        item.mall_header_Frame = headerFrame;
        
         item.frame    = [headerFrame.headerItem_frames[index] CGRectValue];
        
    }
    
    
}

//- (void)buttonClick:(NSInteger)index{
//    
//    if (self.actionBlock)   self.actionBlock(self.countries[index]);
//    
//}


@end
