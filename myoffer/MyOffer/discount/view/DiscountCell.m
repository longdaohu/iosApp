//
//  DiscountCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/2.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "DiscountCell.h"
#import "DiscountItem.h"

@interface DiscountCell ()
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceCtrt;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedView;

@end

@implementation DiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.commitBtn.layer.borderColor = XCOLOR_WHITE.CGColor;
    self.backgroundColor = XCOLOR_BG;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = true;
}

- (void)setType:(OrderDiscountCellType)type{
    
    _type = type;
    
    if (type == OrderDiscountCellTypeNoClickButton) {
        self.priceCtrt.constant = 40;
        self.commitBtn.hidden = YES;
    }else{
        self.priceCtrt.constant = 20;
        self.commitBtn.hidden = NO;
    }
}

- (IBAction)click:(UIButton *)sender {
 
    if (self.item.disabled) return;
    
    if (self.discountCellBlock) {
        self.discountCellBlock();
    }
}

- (void)setItem:(DiscountItem *)item{
    
    _item = item;
 
    self.titleLab.text = item.name;
    self.timeLab.text = item.time;
    self.priceLab.attributedText =  item.attriPrice;
    [self.iconView setImage:[UIImage imageNamed:item.imageName]];
    self.selectedView.hidden = !item.selected;
    
    if (item.disabled) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
 
}

@end
