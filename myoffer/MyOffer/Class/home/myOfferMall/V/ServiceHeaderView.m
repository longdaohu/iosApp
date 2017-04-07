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
    
    headerView.actionBlock = actionBlock;
    
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
    CGFloat bottomX = 0;
    CGFloat bottomY = AdjustF(160.f) + 10;
    CGFloat bottomW = frame.size.width;
    CGFloat bottomH = frame.size.height - bottomY;
    self.bottomView.frame = CGRectMake(bottomX, bottomY, bottomW,bottomH);
    
    
    for (NSInteger i = 0 ; i < self.countries.count; i++) {
        
        HeadItem *item = [HeadItem itemInitWithTitle:self.countries[i]  imageName:self.country_icones[i]];
        
        item.tag       =  i;
        
        item.textColor = XCOLOR_BLACK;
        
        item.actionBlock = ^(NSInteger index){
            
            [self buttonClick:index];
        };
        
        [self.bottomView addSubview:item];
    }
    
    
    
    CGFloat itemW =  bottomW / 3;
    CGFloat itemH =  bottomH;
    for (int index = 0 ;index < self.bottomView.subviews.count ; index++) {
       
        HeadItem *item = (HeadItem *)self.bottomView.subviews[index];
        
        CGFloat itemX  =  (index % 3) * itemW;
        CGFloat itemY  =  0;
        item.frame     = CGRectMake(itemX, itemY, itemW, itemH);
        
    }
    
 
    //底部分隔线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
    line.backgroundColor = XCOLOR_line;
    [self addSubview:line];

}

- (void)buttonClick:(NSInteger)index{
    
    if (self.actionBlock)   self.actionBlock(self.countries[index]);
    
}


@end
