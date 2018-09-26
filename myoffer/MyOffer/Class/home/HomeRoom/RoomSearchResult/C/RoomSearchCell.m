//
//  RoomSearchCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomSearchCell.h"

@interface RoomSearchCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *rentLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong) CAShapeLayer *shaper;

@end

@implementation RoomSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    for (NSInteger i = 0 ; i < 5  ;i++) {
        
        UILabel *sender = [[UILabel alloc] init];
        sender.backgroundColor = i%2 ?  XCOLOR_LIGHTBLUE :  XCOLOR_RED;
        sender.textAlignment = NSTextAlignmentCenter;
        sender.font = XFONT(10);
        sender.textColor = XCOLOR_WHITE;
        sender.layer.cornerRadius = 2;
        sender.layer.masksToBounds = YES;
        [self.bgView addSubview:sender];
    }
}

- (CAShapeLayer *)shaper{
    if (!_shaper) {
        _shaper = [CAShapeLayer layer];
    }
    
    return _shaper;
}

- (void)setItem:(HomeRoomIndexFlatsObject *)item{
    _item = item;
 
    NSURL *path = [NSURL URLWithString:[item.thumbnail toUTF8WithString]];
    [self.iconView sd_setImageWithURL:path  placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    self.titleLab.text = item.name;
    self.rentLab.text = item.rent;
    self.unitLab.text = item.unit;
    [self makeFeatureItemWithArray:item.feature];
}

- (void)makeFeatureItemWithArray:(NSArray *)tags{
    
    NSInteger max =  tags.count > self.bgView.subviews.count ? self.bgView.subviews.count : tags.count;
     for (NSInteger i = 0 ; i < max  ;i++) {
        UILabel *sender = self.bgView.subviews[i];
        sender.text = tags[i];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.iconView.bounds cornerRadius:8];
    self.shaper.path = path.CGPath;
    self.shaper.fillColor = XCOLOR_RED.CGColor;
    self.iconView.layer.mask = self.shaper;
 
    CGFloat max_w = self.bgView.mj_w;
    CGFloat tag_x = max_w;
    CGFloat tag_y = 0;
    CGFloat tag_w = 0;
    CGFloat tag_h = self.bgView.mj_h;
 
    for (NSInteger index = 0; index < self.bgView.subviews.count; index++) {
        
        UILabel *sender  = self.bgView.subviews[index];
        if (sender.text.length == 0) return;
        tag_w = [sender.text stringWithfontSize:10].width + 10;
        tag_x -= tag_w;
        if (tag_x < 0){
            tag_w = 0;
            tag_x = 0;
        }
         sender.frame = CGRectMake(tag_x, tag_y, tag_w, tag_h);
         tag_x -= 10;
    }
    
    
}


@end
