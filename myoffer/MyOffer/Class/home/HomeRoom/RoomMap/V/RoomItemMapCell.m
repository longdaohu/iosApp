//
//  RoomItemMapCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/9/19.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemMapCell.h"

@interface RoomItemMapCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIStackView *tagsView;

@end

@implementation RoomItemMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
