//
//  RewardListCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RewardListCell.h"

@interface RewardListCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *dollarLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation RewardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(RewardItem *)item{
    _item = item;
    
    self.titleLab.text = item.stateDisplay;
    self.dollarLab.text = item.amount;
    self.timeLab.text = [NSString stringWithFormat:@"%@  %@",item.date,item.time];
}

@end
