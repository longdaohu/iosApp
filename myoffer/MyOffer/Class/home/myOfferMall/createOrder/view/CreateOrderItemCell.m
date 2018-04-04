//
//  CreateOrderItemCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "CreateOrderItemCell.h"

@interface CreateOrderItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *massageLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation CreateOrderItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setItem:(myofferGroupModel *)item{
    
    _item = item;
    
    self.titleLab.text = item.header_title;
    self.massageLab.text =item.sub;

}



@end
