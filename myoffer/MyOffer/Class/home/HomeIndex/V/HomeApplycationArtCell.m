//
//  HomeApplycationArtCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/8.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeApplycationArtCell.h"

@interface HomeApplycationArtCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *viewLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property(nonatomic,strong)CAShapeLayer *shaper;

@end

@implementation HomeApplycationArtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
        self.bgView.layer.cornerRadius = 8;
        self.bgView.layer.masksToBounds = YES;
        self.tagLab.layer.cornerRadius = 4;
        self.tagLab.layer.masksToBounds = YES;
 
}

- (void)setItem:(NSDictionary *)item{

    _item = item;

    self.titleLab.text = item[@"title"];
    self.tagLab.text = item[@"category"];
    self.viewLab.text = [NSString stringWithFormat:@"%@",item[@"viewCount"]];
    self.timeLab.text = item[@"updateAt"];
    NSString *summary =  item[@"summary"];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:summary];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;
    NSDictionary *dic  = @{NSParagraphStyleAttributeName:paragraphStyle};
    [attribute addAttributes:dic range:NSMakeRange(0, summary.length)];
    self.subLab.attributedText = attribute;
    NSString *path =  [item[@"images"] toUTF8WithString];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
}

- (CAShapeLayer *)shaper{
    
    if (!_shaper) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.lineWidth = 5;
        shaper.shadowColor =  XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 3);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.05;
        _shaper = shaper;
        [self.contentView.layer insertSublayer:shaper below:self.bgView.layer];
    }
    
    return _shaper;
}





- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect sh_frame = self.bgView.frame;
    sh_frame.size.width = self.contentView.mj_w - ( self.bgView.mj_x * 2);
    if (!self.shaper.path) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:sh_frame];
        self.shaper.shadowPath = path.CGPath;
    }
 
}



@end
