//
//  HomeRecommendActivityCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/4.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeRecommendActivityCell.h"

@interface HomeRecommendActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *oneView;
@property (weak, nonatomic) IBOutlet UIImageView *twoView;
@property (weak, nonatomic) IBOutlet UIImageView *threeView;
@property(nonatomic,strong)NSArray *iconViews;
@end

@implementation HomeRecommendActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.oneView.layer.cornerRadius = 4;
    self.oneView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 4;
    self.twoView.layer.masksToBounds = YES;
    self.threeView.layer.cornerRadius = 4;
    self.threeView.layer.masksToBounds = YES;
    self.iconViews = @[self.oneView,self.twoView,self.threeView];
    for (NSInteger index = 0; index < self.iconViews.count; index++) {
        UIImageView *item = self.iconViews[index];
        item.userInteractionEnabled = YES;
        item.tag = index;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionClick:)];
        [item addGestureRecognizer:tap];
    }
}

- (void)setItems:(NSArray *)items{
    _items = items;
 
    if (items.count == 0) return;
    
    
    for (NSInteger index = 0; index < self.iconViews.count; index++) {
    
        UIImageView *item = self.iconViews[index];
        
        if (index < items.count) {
 
            NSDictionary *dic = items[index];
            NSString *icon = [dic[@"thumbnail"] toUTF8WithString];
            [item sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:nil];
 
         }else{
             
            item.userInteractionEnabled = NO;
            item.alpha = 0;
        }
    }
}

- (void)actionClick:(UITapGestureRecognizer *)tap{
    
    if (self.actionBlock) {
        NSDictionary *dic = self.items[tap.view.tag];
        self.actionBlock(dic[@"id"]);
    }
}


@end
