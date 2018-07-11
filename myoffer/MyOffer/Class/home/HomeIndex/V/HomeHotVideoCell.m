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
@property (weak, nonatomic) IBOutlet UIView *title_bgView;
@property(nonatomic,strong)UIVisualEffectView *effectView;
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
        if (index == 0) {
            [item.superview addGestureRecognizer:tap];
        }else{
            [item addGestureRecognizer:tap];
         }
     }
    
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark ];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.alpha = 1;
    [self.title_bgView insertSubview:effectView  atIndex:0];
    self.effectView = effectView;
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
                 self.nameLab.text = [NSString stringWithFormat:@"%@ %@",dic[@"guest_name"],dic[@"guest_university_name"]];
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

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.effectView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_WIDTH);
    
}

@end
