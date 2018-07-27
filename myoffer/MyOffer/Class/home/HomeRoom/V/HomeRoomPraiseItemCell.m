//
//  HomeRoomPraiseItemCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/25.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomPraiseItemCell.h"

@interface HomeRoomPraiseItemCell ()
@property(nonatomic,strong)UIImageView *summarybgView;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIImageView *starView;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *subLab;
@property(nonatomic,strong)UILabel *summaryLab;

@end

@implementation HomeRoomPraiseItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
        iconView.image = XImage(@"Uni-au");
        self.iconView = iconView;
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:iconView];
        iconView.clipsToBounds = YES;
 
        UILabel *nameLab = [UILabel new];
        nameLab.textColor = XCOLOR_TITLE;
        nameLab.font = XFONT(14);
        nameLab.text = @"李同学";
        [self.contentView addSubview:nameLab];
        self.nameLab = nameLab;
        
        UILabel *subLab = [UILabel new];
        subLab.text = @"来自北京 英国伦敦大学UCL";
        subLab.textColor = XCOLOR_DESC;
        subLab.font = XFONT(10);
        [self.contentView addSubview:subLab];
        subLab.textAlignment = NSTextAlignmentLeft;
        self.subLab = subLab;
        
        UIImageView *starView = [UIImageView new];
        starView.image = XImage(@"five_star");
        self.starView = starView;
        starView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:starView];
        starView.clipsToBounds = YES;
        
        UIImageView *summarybgView = [UIImageView new];
        summarybgView.image = XImage(@"cell_Rectangle_l");
        summarybgView.backgroundColor = XCOLOR_WHITE;
        self.summarybgView = summarybgView;
        summarybgView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:summarybgView];
        summarybgView.clipsToBounds = YES;
        
        UILabel *summaryLab = [UILabel new];
        summaryLab.textColor = XCOLOR_TITLE;
        summaryLab.font = XFONT(12);
        summaryLab.numberOfLines = 0;
        summaryLab.text = @"之前實地看過很多美國的公寓，屋內只有電器沒有家具，住進去后，還需要添置很多東西，非常麻煩。這邊推介的公寓，室內家具、電器都非常齊全。客服也會幫我安排看房。入住后的煩惱少了很多。";
        summaryLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:summaryLab];
        self.summaryLab = summaryLab;
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize content_size = self.contentView.bounds.size;
    
    CGFloat icon_x = 0;
    CGFloat icon_y = 0;
    CGFloat icon_w = 50;
    CGFloat icon_h = icon_w;
    self.iconView.frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
    
    CGFloat name_x = CGRectGetMaxX(self.iconView.frame) + 8;
    CGFloat name_y = icon_y;
    CGFloat name_w = content_size.width;
    CGFloat name_h = 20;
    self.nameLab.frame = CGRectMake(name_x, name_y, name_w, name_h);
    
    CGFloat sub_x = name_x;
    CGFloat sub_y = CGRectGetMaxY(self.nameLab.frame);
    CGFloat sub_w = name_w;
    CGFloat sub_h = 20;
    self.subLab.frame = CGRectMake(sub_x, sub_y, sub_w, sub_h);
 
    CGFloat star_x = name_x;
    CGFloat star_y = CGRectGetMaxY(self.subLab.frame) + 5;
    CGFloat star_w = 160;
    CGFloat star_h = 15;
    self.starView.frame = CGRectMake(star_x, star_y, star_w, star_h);
 
    CGFloat sum_bg_w = content_size.width;
    CGFloat sum_bg_h = 152;
    CGFloat sum_bg_x = 0;
    CGFloat sum_bg_y = CGRectGetMaxY(self.starView.frame);
    self.summarybgView.frame = CGRectMake(sum_bg_x, sum_bg_y, sum_bg_w, sum_bg_h);

    CGFloat summary_x = sum_bg_x + 40;
    CGFloat summary_y = sum_bg_y + 20;
    CGFloat summary_w = sum_bg_w - summary_x - 20;
    CGFloat summary_h = content_size.height - summary_y;
    self.summaryLab.frame = CGRectMake(summary_x, summary_y, summary_w, summary_h);
    
}


@end
