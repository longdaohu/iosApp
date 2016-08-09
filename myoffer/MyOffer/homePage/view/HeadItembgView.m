//
//  HeadItembgView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "HeadItembgView.h"
#import "HeadItem.h"


@interface HeadItembgView ()
@property(nonatomic,strong)NSArray *itemTitles;
@property(nonatomic,strong)NSArray *itemImages;

@end

@implementation HeadItembgView

-(NSArray *)itemImages
{
    if (!_itemImages) {
        _itemImages =@[@"home_woyao",@"home_xiaobai",@"Home_pipei",@"home_Mall"];
    }
    return _itemImages;
}

-(NSArray *)itemTitles
{
    if (!_itemTitles) {
        
        _itemTitles =@[GDLocalizedString(@"Discover_woyao"),GDLocalizedString(@"Discover_xiaobai"),GDLocalizedString(@"Discover_zhinengpipei"),@"留学服务"];
    }
    return _itemTitles;
}

 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i = 0 ;i < 4 ; i++) {
            HeadItem *item = [[HeadItem alloc] init];
            item.iconTag   = i;
            item.title     = self.itemTitles[i];
            item.icon      = self.itemImages[i];
            
            item.actionBlock = ^(UIButton *sender){
                
                 if ([self.delegate respondsToSelector:@selector(HeadItembgView:WithItemtap:)]) {
                    [self.delegate HeadItembgView:self WithItemtap:sender];
                }
                
            };
            [self addSubview:item];
        }
      
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat itemW = (XScreenWidth - 100) * 0.25;
    CGFloat itemH =  self.bounds.size.height;
    
     for (int i = 0 ;i < self.subviews.count ; i++) {
        
        HeadItem *item = (HeadItem *)self.subviews[i];
         
         CGFloat x  = 20 + i * (20 + itemW);
         CGFloat y  = 0;
         item.frame = CGRectMake(x, y, itemW, itemH);
      }
   
}
@end
