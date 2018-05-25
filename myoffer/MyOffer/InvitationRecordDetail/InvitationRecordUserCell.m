//
//  InvitationRecordUserCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "InvitationRecordUserCell.h"

@interface InvitationRecordUserCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong) CAShapeLayer *shaper_dash;

@end

@implementation InvitationRecordUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(1000, 0)];
    
    CAShapeLayer *shaper = [CAShapeLayer layer];
    self.shaper_dash = shaper;
    shaper.strokeColor = XCOLOR(152, 152, 152, 1).CGColor;
    shaper.lineWidth = 2;
    shaper.lineDashPattern = @[@3];
    shaper.path = path.CGPath;
    shaper.masksToBounds = YES;
    [self.bgView.layer addSublayer:shaper];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
 
    CGFloat  sh_x  = 12;
    CGFloat  sh_y  = 0;
    CGFloat  sh_h  = 1;
    CGFloat  sh_w  = self.bgView.mj_w - sh_x * 2;
    self.shaper_dash.frame = CGRectMake(sh_x, sh_y,sh_w,sh_h);
}

- (void)setItem:(RewardDetailCelltem *)item{
    _item = item;
    self.titleLab.text = item.title;
    self.detailLab.text = item.sub;
}

- (void)cellSeparatorHiden:(BOOL)hiden{
    
    self.shaper_dash.hidden = hiden;
}

@end

