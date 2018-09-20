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
@property (weak, nonatomic) IBOutlet UIView *tagsView;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;

@end

@implementation RoomItemMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setItemFrameModel:(RoomItemFrameModel *)itemFrameModel{
    
    _itemFrameModel = itemFrameModel;
    self.titleLab.text = itemFrameModel.item.name;
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",itemFrameModel.item.price];
    self.unitLab.text = itemFrameModel.item.unit;
    for (NSInteger index = 0; index<itemFrameModel.item.feature.count; index++) {
       
        UILabel *sender = [[UILabel alloc] init];
        sender.font = XFONT(12);
        sender.textAlignment = NSTextAlignmentCenter;
        sender.backgroundColor = index % 2 ? XCOLOR_RED : XCOLOR_LIGHTBLUE;
        sender.layer.cornerRadius = 2;
        sender.layer.masksToBounds = YES;
        sender.text = itemFrameModel.item.feature[index];
        [self.tagsView addSubview:sender];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat sender_x  = 0;
    for (NSInteger index = 0; index < self.tagsView.subviews.count; index++) {

        UILabel *sender =  self.tagsView.subviews[index];
        CGSize sender_size = [sender.text stringWithfontSize:12];
        CGFloat sender_w  = sender_size.width + 10;
        sender.frame = CGRectMake(sender_x, 0, sender_w, 20);
        sender_x += (sender_w + 10);
    }
    
    
}

@end
