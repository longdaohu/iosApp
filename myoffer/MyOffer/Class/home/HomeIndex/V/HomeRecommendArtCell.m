//
//  HomeRecommendArtCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/4.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeRecommendArtCell.h"
@interface HomeRecommendArtCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong)CAShapeLayer *shadow_layer;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *viewsLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation HomeRecommendArtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.bgView.layer.cornerRadius = 10;
//    self.bgView.layer.masksToBounds = YES;
//
    self.tagLab.layer.cornerRadius = 4;
    self.tagLab.layer.masksToBounds = YES;
}

- (void)setItem:(NSDictionary *)item{
    _item = item;
    
    self.titleLab.text = item[@"title"];
    self.tagLab.text = item[@"category"];
    self.viewsLab.text = [NSString stringWithFormat:@"%@",item[@"viewCount"]];
    self.timeLab.text = item[@"updateAt"];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
 
    CGRect sh_frame = self.bgView.frame;
    sh_frame.size.width = self.contentView.mj_w - ( self.bgView.mj_x * 2);
    if (!self.shadow_layer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:sh_frame];
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.lineWidth = 5;
        shaper.shadowPath = path.CGPath;
        shaper.shadowColor = XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 3);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.1;
        self.shadow_layer = shaper;
        [self.contentView.layer insertSublayer:shaper below:self.bgView.layer];
    }
  
    
}


@end
