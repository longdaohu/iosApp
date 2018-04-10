//
//  OrderActionCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/4.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "OrderActionCell.h"

@interface OrderActionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation OrderActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = true;
}

- (void)setCell_selected:(BOOL)cell_selected{
    
    _cell_selected  = cell_selected;
 
    NSString *imageName = cell_selected ?   @"order_discount_select"  : @"order_discount_nomal" ;
    
    [self.iconView setImage: [UIImage imageNamed:imageName]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

