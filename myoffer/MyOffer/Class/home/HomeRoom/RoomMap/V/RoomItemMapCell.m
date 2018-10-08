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
    
    self.iconView.layer.cornerRadius = 4;
    self.iconView.layer.masksToBounds = true;
    self.priceLab.textColor = XCOLOR_RED;
}

- (void)setItemFrameModel:(RoomItemFrameModel *)itemFrameModel{
    
    _itemFrameModel = itemFrameModel;
    self.titleLab.text = itemFrameModel.item.name;
    self.priceLab.text = [NSString stringWithFormat:@"%@",itemFrameModel.item.price];
    self.unitLab.text = itemFrameModel.item.unit;
    if ([itemFrameModel.item.thumbnail hasPrefix:@"http"]){
        NSURL *path = [NSURL URLWithString:[itemFrameModel.item.thumbnail toUTF8WithString]];
        [self.iconView sd_setImageWithURL:path  placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    }else{
        self.iconView.image = [UIImage imageNamed:@"PlaceHolderImage"];
    }
    
    [self makeFeatureItemWithArray:itemFrameModel.item.feature];
}


- (void)setItem:(HomeRoomIndexFlatsObject *)item{
    _item = item;
    
    if ([item.thumb hasPrefix:@"http"]){
        NSURL *path = [NSURL URLWithString:[item.thumb toUTF8WithString]];
        [self.iconView sd_setImageWithURL:path  placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    }else{
        self.iconView.image = [UIImage imageNamed:@"PlaceHolderImage"];
    }
    self.titleLab.text = item.name;
    self.priceLab.text = item.rent;
    self.unitLab.text = item.unit;
    [self makeFeatureItemWithArray:item.feature];
}

- (void)makeFeatureItemWithArray:(NSArray *)tags{
    
    
    [self.tagsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger index = 0; index<tags.count; index++) {
        UILabel *sender = [[UILabel alloc] init];
        sender.font = XFONT(12);
        sender.textAlignment = NSTextAlignmentCenter;
        sender.backgroundColor = index % 2 ? XCOLOR_RED : XCOLOR_LIGHTBLUE;
        sender.layer.cornerRadius = 2;
        sender.layer.masksToBounds = YES;
        sender.textColor = XCOLOR_WHITE;
        sender.text = tags[index];
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
        if (sender_x + sender_w > self.tagsView.mj_w) {
            sender_w = 0;
        }
        sender.frame = CGRectMake(sender_x, 0, sender_w, 20);
        sender_x += (sender_w + 10);
    }

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shaper = [CAShapeLayer layer];
    shaper.path = path.CGPath;
    self.layer.mask = shaper;
}

@end
