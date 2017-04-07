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
        CenterSectionItem *service  = [self itemWithIcon:@"center_service" title:@"留学购" subtitle:@"暂未获得套餐" itemTag:centerItemTypeservice];
        self.items = @[pipei,favor,service];
        

        UIView *lineTop = [[UIView alloc] init];
        self.lines      = @[lineTop];
        for (UIView *line in self.lines) {
            
            [self addSubview:line];
            
            line.backgroundColor = XCOLOR_LIGHTGRAY;
        }
        
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


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat itemY = 0;
    CGFloat itemW = contentSize.width / 3;
    CGFloat itemH = contentSize.height;
    
    for (NSInteger index = 0; index < self.items.count; index++) {
        
        CGFloat itemX = index * itemW;
        
        CenterSectionItem *itemView = self.items[index];
        
        itemView.frame = CGRectMake( itemX, itemY, itemW, itemH);
        
    }
    
    
    CGFloat lineW = 0.5;
    UIView *top =self.lines.lastObject;
    top.frame = CGRectMake(0, 0, contentSize.width, lineW);
    
}


@end
