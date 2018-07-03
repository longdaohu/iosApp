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
@property (weak, nonatomic) IBOutlet UILabel *summaryLab;
@property(nonatomic,strong)CAShapeLayer *shadowLayer;

@end

@implementation HomeUVICserviceAdvantageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = XCOLOR_WHITE;
    self.contentView.layer.cornerRadius = CORNER_RADIUS;
    self.contentView.layer.masksToBounds = true;
 
}

- (void)setItem:(NSDictionary *)item{
    _item = item;
    
    [self.iconView setImage:XImage(item[@"icon"])];
    self.titleLab.text = item[@"title"];
    NSString *summary =  item[@"summary"];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:summary];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10.0;
    NSDictionary *dic  = @{NSParagraphStyleAttributeName:paragraphStyle};
    [attribute addAttributes:dic range:NSMakeRange(0, summary.length)];
    self.summaryLab.attributedText = attribute;
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
