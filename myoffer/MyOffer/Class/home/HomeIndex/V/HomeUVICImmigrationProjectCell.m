//
//  HomeUVICImmigrationProjectCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/25.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeUVICImmigrationProjectCell.h"

@interface HomeUVICImmigrationProjectCell ()
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property(nonatomic,strong)CAShapeLayer *shadowLayer;
@property(nonatomic,strong)NSMutableArray *celles;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn;


@end

@implementation HomeUVICImmigrationProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = XCOLOR_WHITE;
    self.contentView.layer.cornerRadius = CORNER_RADIUS;
    self.contentView.layer.masksToBounds = true;
}

- (void)setItem:(NSDictionary *)item{
    _item = item;
    
    [self.iconView setImage:XImage(item[@"icon"])];
    [self.titleBtn setTitle:item[@"title"] forState:UIControlStateNormal];
    [self.tagBtn setTitle:item[@"tag"] forState:UIControlStateNormal];
    self.subLab.text = item[@"summary"];
 
}

- (NSMutableArray *)celles{
    
    if (!_celles) {
        _celles = [NSMutableArray array];
    }
    return _celles;
}

- (CAShapeLayer *)shadowLayer{
    if (!_shadowLayer) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor = XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 0);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.05;
        _shadowLayer = shaper;
        
        [self.layer insertSublayer:shaper below:self.contentView.layer];
        
    }
    
    return _shadowLayer;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.shadowLayer.shadowPath) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
        self.shadowLayer.shadowPath = path.CGPath;
    }
}

@end






