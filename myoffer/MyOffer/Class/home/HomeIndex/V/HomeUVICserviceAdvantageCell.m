//
//  HomeUVICserviceAdvantageCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/25.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeUVICserviceAdvantageCell.h"

@interface HomeUVICserviceAdvantageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property(nonatomic,strong)CAShapeLayer *shadowLayer;

@end

@implementation HomeUVICserviceAdvantageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconView.layer.cornerRadius = CORNER_RADIUS;
    self.iconView.layer.masksToBounds = true;
    
    self.contentView.layer.shadowColor = XCOLOR_BLACK.CGColor;
    self.contentView.layer.shadowOffset =  CGSizeMake(0, 0);
    self.contentView.layer.shadowRadius = 10;
    self.contentView.layer.shadowOpacity = 0.2;
 
}

- (void)setItem:(NSDictionary *)item{
    _item = item;
    
    [self.iconView setImage:XImage(item[@"icon"])];
    self.titleLab.text = item[@"title"];
}

- (CAShapeLayer *)shadowLayer{
    if (!_shadowLayer) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor = XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 0);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.1;
        _shadowLayer = shaper;

        [self.layer insertSublayer:shaper below:self.contentView.layer];
    
    }
    
    return _shadowLayer;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    if (!self.shadowLayer.shadowPath) {
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
//        self.shadowLayer.shadowPath = path.CGPath;
//    }
 
}


@end
