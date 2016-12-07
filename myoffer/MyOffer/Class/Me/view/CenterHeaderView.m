//
//  centerSectionView.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/24.
//  Copyright © 2015年 UVIC. All rights reserved.
//



#import "CenterHeaderView.h"
#import "CenterSectionItem.h"
@interface CenterHeaderView()
//分隔线
@property(nonatomic,strong)NSArray *lines;
//选项数组
@property(nonatomic,strong)NSArray *items;

@end



@implementation CenterHeaderView
+(instancetype)centerSectionViewWithResponse:(NSDictionary * )response{

    CenterHeaderView *sectionView =  [[CenterHeaderView alloc] init];
    sectionView.response           =  response;
    
    return sectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor =XCOLOR_WHITE;
        
        CenterSectionItem *pipei  = [CenterSectionItem viewWithIcon:@"center_pipei" title:@"智能匹配" subtitle:@"0 所"];
        pipei.tag                 = centerItemTypepipei;
        pipei.actionBlack = ^(UIButton *sender){
            
            if (self.sectionBlock) {
        
                self.sectionBlock(centerItemTypepipei);
            }
        };
        
        CenterSectionItem *favor  = [CenterSectionItem viewWithIcon:@"center_Favorite" title:@"收藏院校" subtitle:@"0 所"];
        favor.tag                 = centerItemTypefavor;
        favor.actionBlack = ^(UIButton *sender){
         
            if (self.sectionBlock) {
                
                self.sectionBlock(centerItemTypefavor);
            }
        };
        CenterSectionItem *service  = [CenterSectionItem viewWithIcon:@"center_service" title:@"留学服务" subtitle:@"暂未获得套餐"];
        service.tag                 = centerItemTypeservice;
        service.actionBlack = ^(UIButton *sender){
            
            if (self.sectionBlock) {
                
                self.sectionBlock(centerItemTypeservice);
            }
        };
        
        [self addSubview:pipei];
        [self addSubview:favor];
        [self addSubview:service];
        self.items = @[pipei,favor,service];
        
        UIView *lineOne = [[UIView alloc] init];
        UIView *lineTwo = [[UIView alloc] init];
        UIView *lineTop = [[UIView alloc] init];
        self.lines      = @[lineOne,lineTwo,lineTop];
        for (UIView *line in self.lines) {
            [self addSubview:line];
            line.backgroundColor = XCOLOR_LIGHTGRAY;
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    

    CGFloat itemY = 0;
    CGFloat itemW = XScreenWidth / 3;
    CGFloat itemH = self.bounds.size.height;
    
    for (NSInteger index = 0; index < self.items.count; index++) {
        
        CGFloat itemX = index * itemW;

        CenterSectionItem *itemView = self.items[index];
        
        itemView.frame = CGRectMake( itemX, itemY, itemW, itemH);
        
    }
    
    
    
    CGFloat lineW = 0.5;
    CGFloat lineH = self.bounds.size.height * 0.5;
    CGFloat lineY = lineH * 0.5;
    
    for (NSInteger index = 0; index < self.lines.count - 1; index ++) {
        
        CGFloat lineX = itemW * (index + 1);

        UIView *line = self.lines[index];
        
        line.frame = CGRectMake(lineX, lineY,  lineW, lineH);
        
    }
    
    UIView *top =self.lines[2];
    top.frame = CGRectMake(0, 0, XScreenWidth, lineW);
 
}


-(void)setResponse:(NSDictionary *)response{

    _response = response;
    
    
    if(!response)  return;
    
    CenterSectionItem *pipei  = self.items[0];
    pipei.count =  [NSString stringWithFormat:@"%@  所",response[@"recommendationsCount"]];

    CenterSectionItem *favor  = self.items[1];
    favor.count =   [NSString stringWithFormat:@"%@  所",response[@"favoritesCount"]];

    CenterSectionItem *service  = self.items[2];
    service.count = [response[@"paid_service_description"] length] ? [NSString stringWithFormat:@"%@",response[@"paid_service_description"]] : @"暂未获得套餐";
    
}


@end
