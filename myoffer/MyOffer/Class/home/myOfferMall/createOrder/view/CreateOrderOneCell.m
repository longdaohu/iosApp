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
@property (weak, nonatomic) IBOutlet UIButton *fit_personBtn;

@end


@implementation CreateOrderOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
     self.selectionStyle = UITableViewCellSelectionStyleNone;
     self.fit_personBtn.layer.borderWidth = 1;
     self.fit_personBtn.layer.borderColor = XCOLOR_LIGHTBLUE.CGColor;
     self.fit_personBtn.layer.cornerRadius = 5;
     self.fit_personBtn.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(ServiceItem *)item{
    
    _item = item;
    
    self.discount.hidden = !item.reduce_flag;
 
    [self.iconView sd_setImageWithURL: [item.cover_url mj_url] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    self.titleLab.text = item.name;
    self.priceLab.text = item.price_str;
    self.forPersonLab.text = item.comment_suit_people[@"value"];
}


@end
