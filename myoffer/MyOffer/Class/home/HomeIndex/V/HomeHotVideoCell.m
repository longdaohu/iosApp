//
//  HomeHotVideoCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/4.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeHotVideoCell.h"

@interface HomeHotVideoCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *subsView;
@property (weak, nonatomic) IBOutlet UIImageView *bigIconView;
@property (weak, nonatomic) IBOutlet UIImageView *aIconView;
@property (weak, nonatomic) IBOutlet UIImageView *bIconView;
@property (weak, nonatomic) IBOutlet UIImageView *cIconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property(nonatomic,strong)NSArray *iconViews;


@end

@implementation HomeHotVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = true;
    for (UIView *item in self.subsView.subviews) {
        item.layer.cornerRadius = 4;
        item.layer.masksToBounds = true;
    }
    self.iconViews = @[self.bigIconView,self.aIconView,self.bIconView,self.cIconView];
    for (NSInteger index = 0; index < self.iconViews.count; index++) {
        UIImageView *item = self.iconViews[index];
        item.userInteractionEnabled = YES;
        item.tag = index;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoClick:)];
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
             NSString *icon = [dic[@"adPostMc"] toUTF8WithString];
             [item sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:nil];
             if (index == 0) {
                 self.titleLab.text = dic[@"mainTitle"];
             }
         }else{
             item.userInteractionEnabled = NO;
         }
     }
 
}

- (void)videoClick:(UITapGestureRecognizer *)tap{
    
    if (self.actionBlock) {
        NSDictionary *dic = self.items[tap.view.tag];
        self.actionBlock(dic[@"id"]);
    }
}

@end
