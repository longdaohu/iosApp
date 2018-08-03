//
//  HomeApplySubjecttCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/13.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeApplySubjecttCell.h"
#import "MyOfferButton.h"

@interface HomeApplySubjecttCell ()
@property(nonatomic,strong)NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong)NSArray *titles;
@end


@implementation HomeApplySubjecttCell

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"经济与金融",@"商科",@"工程学",@"人文与社会科学",@"理学",@"建筑与规划",@"艺术与设计",@"医学",@"农学"];
    }
    
    return _titles;
}

- (NSMutableArray *)items{
    if (!_items) {
        
        _items  = [NSMutableArray array];
    }
    return _items;
}

- (void)awakeFromNib {
    [super awakeFromNib];
 
    for (NSInteger index = 0; index < self.titles.count; index++) {
 
        NSString *bg_icon = [NSString stringWithFormat:@"area_%ld.jpg",index];
        NSString *icon = [NSString stringWithFormat:@"area_icon_%ld",index];
        MyOfferButton *item = [MyOfferButton new];
        item.margin = 6;
        item.type = MyofferButtonTypeImageTop;
        [self.bgView addSubview:item];
        [item setBackgroundImage:XImage(bg_icon) forState:UIControlStateNormal];
        item.titleLabel.font = XFONT(12);
        [item setImage:XImage(icon) forState:UIControlStateNormal];
        [item setTitle:self.titles[index] forState:UIControlStateNormal];
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        item.layer.cornerRadius = 4;
        item.layer.masksToBounds = YES;
    }
    
    
}

- (void)itemClick:(UIButton *)sender{
    
    if (self.actionBlock) {
        self.actionBlock(sender.currentTitle);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGSize bg_size = self.contentView.bounds.size;
    CGFloat margin = 20;
    CGFloat item_w = (bg_size.width - 4*margin)/3;
    CGFloat item_h = item_w;
    CGFloat item_x = 0;
    CGFloat item_y = 0;
    for (NSInteger index = 0; index < self.bgView.subviews.count; index++) {
        UIView *item = self.bgView.subviews[index];
        item_x = (item_w + margin) * (index%3);
        item_y = (item_h + margin) * (index/3);
        item.frame = CGRectMake(item_x, item_y, item_w, item_h);
    }
    
}

@end
