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
+ (instancetype)viewWithbgBlock:(HeadItembgViewBlock)actionBlock
{

    HeadItembgView *BgView = [[HeadItembgView alloc] init];
    
    BgView.actionBlock = ^(NSInteger itemTag){
        
//        NSLog(@"itemTag  %ld",itemTag);
        actionBlock(itemTag);
        
    };

    return BgView;
}


-(NSArray *)itemImages
{
    if (!_itemImages) {
        _itemImages =@[@"home_woyao",@"home_xiaobai",@"Home_pipei",@"home_Mall",@"home_Mall",@"home_Mall"];
    }
    return _itemImages;
}

-(NSArray *)itemTitles
{
    if (!_itemTitles) {
        _itemTitles =@[GDLocalizedString(@"Discover_woyao"),GDLocalizedString(@"Discover_xiaobai"),GDLocalizedString(@"Discover_zhinengpipei"),@"职业性格测试",@"海外超级导师",@"留学服务服务"];
    }
    return _itemTitles;
}

 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i = 0 ;i < self.itemTitles.count ; i++) {
            
            HeadItem *item = [HeadItem itemWithTitle:self.itemTitles[i] imageName:self.itemImages[i]];
            item.tag       = i;
            item.actionBlock = ^(UIView *it){
                
                [self itemTap:it.tag];
 
            };
            
            [self addSubview:item];
        }
      
    }
    return self;
}

-(void)itemTap:(NSInteger)tag{
    
    
    if (self.actionBlock) {
 
        self.actionBlock(tag);
    }
}





-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize  contentSize = self.bounds.size;
    
    CGFloat itemW =  contentSize.width / 3;
    CGFloat itemH =  contentSize.height * 0.5;

     for (int index = 0 ;index < self.subviews.count ; index++) {
        
         HeadItem *item = (HeadItem *)self.subviews[index];
         CGFloat itemX  =  (index % 3) * itemW;
         CGFloat itemY  =  itemH  * (index / 3);
         item.frame     = CGRectMake(itemX, itemY, itemW, itemH);
         
      }
   
}
@end
