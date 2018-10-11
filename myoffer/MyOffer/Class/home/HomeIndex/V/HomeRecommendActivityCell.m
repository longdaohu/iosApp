//
//  HomeRecommendActivityCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/4.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeRecommendActivityCell.h"
#import "HomeBannerObject.h"

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
    self.iconViews = @[self.twoView,self.threeView,self.oneView];
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
    
    NSArray *subviews =  [self.iconViews subarrayWithRange:NSMakeRange(0, self.iconViews.count-1)];
    
    for (NSInteger index = 0; index < subviews.count; index++) {
        UIImageView *itemView = subviews[index];
        
        if (index < items.count) {
            HomeBannerObject *dic = items[index];
            NSString *icon = [dic.image toUTF8WithString];
            [itemView sd_setImageWithURL:[NSURL URLWithString:icon]  placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
        }else{
            itemView.userInteractionEnabled = NO;
            itemView.alpha = 0;
        }

    }
}

- (void)actionClick:(UITapGestureRecognizer *)tap{
    
    NSString *path = @"";
    if (tap.view.tag == (self.iconViews.count - 1)) {
        path = @"caseInvitation";
    }else{
         HomeBannerObject *dic = self.items[tap.view.tag];
         path = dic.target;
    }
    if (self.actionBlock) {
        self.actionBlock(path);
    }
}



@end
