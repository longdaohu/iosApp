//
//  HomeApplyUniCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/8.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeApplyUniCell.h"
@interface  HomeApplyUniCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *enLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong)NSMutableArray *labels;
@property (weak, nonatomic) IBOutlet UIView *labelsView;

@end

@implementation HomeApplyUniCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = CORNER_RADIUS;
    self.bgView.layer.masksToBounds = YES;
}


- (NSMutableArray *)labels{
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

-  (void)setItem:(NSDictionary *)item{
    _item = item;
    
    self.titleLab.text = item[@"name"];
    self.enLab.text = item[@"officialName"];
    self.addressLab.text = [NSString stringWithFormat:@"%@ | %@ | %@",item[@"country"],item[@"area"],item[@"city"]];
    NSString *label = item[@"label"];
    NSArray *labels = [label componentsSeparatedByString:@","];
    for (NSInteger index = 0; index < labels.count; index++) {
        UILabel *item = [UILabel new];
        item.text = labels[index];
        item.font = XFONT(10);
        item.layer.cornerRadius = 7;
        item.layer.masksToBounds = YES;
        item.layer.borderColor = XCOLOR_WHITE.CGColor;
        item.layer.borderWidth = 1;
        item.textColor = XCOLOR_WHITE;
        item.textAlignment = NSTextAlignmentCenter;
        [self.labelsView addSubview:item];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize bgViewSize = self.labelsView.bounds.size;
    CGFloat item_x = 0;
    CGFloat item_y = 0;
    CGFloat item_w = 0;
    CGFloat item_h = 14;
    for (NSInteger index = 0; index < self.labelsView.subviews.count; index++) {
        UILabel *item = self.labelsView.subviews[index];
        item_w = [item.text stringWithfontSize:10].width + 10;
        if (item_w + item_x > bgViewSize.width) return;
        item.frame = CGRectMake(item_x, item_y, item_w, item_h);
        item_x += (item_w + 10);
    }
}

@end
