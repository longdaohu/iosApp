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
        iconView.layer.cornerRadius = 25;
        iconView.layer.masksToBounds = YES;
 
        UILabel *nameLab = [UILabel new];
        nameLab.textColor = XCOLOR_TITLE;
        nameLab.font = XFONT(14);
        [self.contentView addSubview:nameLab];
        self.nameLab = nameLab;
        
        UILabel *subLab = [UILabel new];
        subLab.textColor = XCOLOR_DESC;
        subLab.font = XFONT(10);
        [self.contentView addSubview:subLab];
        subLab.textAlignment = NSTextAlignmentLeft;
        self.subLab = subLab;
        
        UIImageView *starView = [UIImageView new];
        starView.image = XImage(@"five_star");
        self.starView = starView;
        starView.contentMode = UIViewContentModeScaleAspectFit;
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
        summaryLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:summaryLab];
        self.summaryLab = summaryLab;
        
    }
    return self;
}

- (void)setItem:(HomeRoomIndexCommentsObject *)item{
    
    _item = item;
 
    NSString *path = [item.avatar toUTF8WithString];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    self.nameLab.text = item.name;
    self.subLab.text = item.fromUni;
    self.summaryLab.text = item.comment;
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
    CGFloat star_h = 14;
    CGFloat star_w = star_h*self.starView.image.size.width/self.starView.image.size.height;
    self.starView.frame = CGRectMake(star_x, star_y, star_w, star_h);
 
    CGFloat sum_bg_w = content_size.width;
    CGFloat sum_bg_h = 152;
    CGFloat sum_bg_x = 0;
    CGFloat sum_bg_y = CGRectGetMaxY(self.starView.frame);
    self.summarybgView.frame = CGRectMake(sum_bg_x, sum_bg_y, sum_bg_w, sum_bg_h);

    CGFloat summary_x = sum_bg_x + 50;
    CGFloat summary_w = sum_bg_w - summary_x - 10;
    CGFloat summary_h = [self.summaryLab.text sizeWithfontSize:12 maxWidth:summary_w].height;
    CGFloat summary_y = sum_bg_y + 40;
    self.summaryLab.frame = CGRectMake(summary_x, summary_y, summary_w, summary_h);
    
}


@end
