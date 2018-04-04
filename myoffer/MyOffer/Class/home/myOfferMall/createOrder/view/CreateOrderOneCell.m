//
//  CreateOrderOneCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "CreateOrderOneCell.h"

@interface CreateOrderOneCell ()
@property (weak, nonatomic) IBOutlet UIView *discount;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *forPersonLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end


@implementation CreateOrderOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(ServiceItem *)item{
    
    _item = item;
    
    self.discount.hidden = !item.reduce_flag;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:item.cover_url] placeholderImage:nil];
    self.titleLab.text = item.name;
    self.priceLab.text = item.price_str;
    self.forPersonLab.text = item.comment_suit_people[@"value"];
}


@end
