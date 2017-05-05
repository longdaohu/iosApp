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
@property(nonatomic,strong)UIView *top_line;
//选项数组
@property(nonatomic,strong)NSArray *items;

@end



@implementation CenterHeaderView
+ (instancetype)centerSectionViewWithResponse:(NSDictionary * )response actionBlock:(centerSectionViewBlock)actionBlock{
    
    CenterHeaderView *sectionView =  [[CenterHeaderView alloc] init];
    
    sectionView.response     =  response;
    
    sectionView.actionBlock = actionBlock;
    
    return sectionView;
}

 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor =XCOLOR_WHITE;
        
        CenterSectionItem *pipei  = [self itemWithIcon:@"center_pipei" title:@"智能匹配" subtitle:@"0 所" itemTag:centerItemTypepipei];
        CenterSectionItem *favor  = [self itemWithIcon:@"center_Favorite" title:@"收藏院校" subtitle:@"0 所" itemTag:centerItemTypefavor];
        CenterSectionItem *test  = [self itemWithIcon:@"center_service" title:@"MBTI测试" subtitle:@"职业性格" itemTag:centerItemTypetest];
        self.items = @[pipei,favor,test];
        
        
        UIView *top_line = [UIView new];
        self.top_line = top_line;
        top_line.backgroundColor = XCOLOR_line;
        [self addSubview:top_line];
     
        
    }
    return self;
}



- (CenterSectionItem *)itemWithIcon:(NSString *)iconName title:(NSString *)title subtitle:(NSString *)subName itemTag:(centerItemType)type{

    CenterSectionItem *item  = [CenterSectionItem viewWithIcon:iconName title:title subtitle:subName];
    item.tag                 = type;
    item.actionBlack = ^(UIButton *sender){
        
        if (self.actionBlock) {
            
            self.actionBlock(type);
        }
    };
    
    [self addSubview:item];
    
    return  item;
}


- (void)setHeaderFrame:(MeCenterHeaderViewFrame *)headerFrame{

    _headerFrame = headerFrame;
    
    CGFloat item_Y = 0;
    CGFloat item_W = headerFrame.item_Width;
    CGFloat item_H = headerFrame.section_Height;
    
    for (NSInteger index = 0; index < self.items.count; index++) {
        
        CGFloat item_X = index * item_W;
        CenterSectionItem *itemView = self.items[index];
        itemView.header_Frame = headerFrame;
        itemView.frame = CGRectMake( item_X, item_Y, item_W, item_H);
        
    }
  
    
}

-(void)setResponse:(NSDictionary *)response{

    _response = response;
    
    if(!response)  return;
    
    CenterSectionItem *pipei  = self.items[0];
    pipei.count =  [NSString stringWithFormat:@"%@  所",response[@"recommendationsCount"]];

    CenterSectionItem *favor  = self.items[1];
    favor.count =   [NSString stringWithFormat:@"%@  所",response[@"favoritesCount"]];

//    CenterSectionItem *service  = self.items[2];
//    service.count = [response[@"paid_service_description"] length] ? [NSString stringWithFormat:@"%@",response[@"paid_service_description"]] : @"暂未获得套餐";
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    
    CGSize contentSize = self.bounds.size;
    
    self.top_line.frame =  CGRectMake(0, 0, contentSize.width, 0.5);
 
}


@end
