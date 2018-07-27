//
//  HomeRoomApartmentItemCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomApartmentItemCell.h"

@interface HomeRoomApartmentItemCell ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *tagLab;
@property(nonatomic,strong)UILabel *wifiLab;
@property(nonatomic,strong)UILabel *cityLab;

@end

@implementation HomeRoomApartmentItemCell

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

        UILabel *cityLab = [UILabel new];
        cityLab.textColor = XCOLOR(179, 179, 179, 1);
        cityLab.font = XFONT(9);
        cityLab.text = @"伦敦";
        cityLab.textAlignment = NSTextAlignmentCenter;
        cityLab.backgroundColor = XCOLOR_WHITE;
        [self.contentView addSubview:cityLab];
        self.cityLab = cityLab;
        
        UILabel *titleLab = [UILabel new];
        titleLab.textColor = XCOLOR_TITLE;
        titleLab.font = XFONT(14);
        titleLab.text = @"公寓出租！！！！在一次偶然的地图相关资料搜索过程中发现了一个很神奇又很漂亮的地图";
        titleLab.numberOfLines = 2;
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        
        UILabel *priceLab = [UILabel new];
        priceLab.text = @"￥100/月";
        priceLab.textColor = XCOLOR(50, 50, 50, 1);
        priceLab.font = XFONT(14);
        [self.contentView addSubview:priceLab];
        priceLab.textAlignment = NSTextAlignmentLeft;
        self.priceLab = priceLab;
        
        UILabel *tagLab = [UILabel new];
        tagLab.textColor = XCOLOR_WHITE;
        tagLab.font = XFONT(9);
        tagLab.text = @"视频看房";
        tagLab.backgroundColor = XCOLOR_LIGHTBLUE;
        [self.contentView addSubview:tagLab];
        self.tagLab = tagLab;
        tagLab.textAlignment = NSTextAlignmentCenter;
        
        UILabel *wifiLab = [UILabel new];
        wifiLab.textColor = XCOLOR_WHITE;
        wifiLab.font = XFONT(9);
        wifiLab.text = @"wifi";
        wifiLab.textAlignment = NSTextAlignmentCenter;
        wifiLab.backgroundColor = XCOLOR_RED;
        [self.contentView addSubview:wifiLab];
        self.wifiLab = wifiLab;
 
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize content_size = self.contentView.bounds.size;

    CGFloat icon_x = 0;
    CGFloat icon_y = 0;
    CGFloat icon_w = content_size.width;
    CGFloat icon_h = 158;
    if (self.isHomestay) {
        icon_h = icon_w;
    }
    self.iconView.frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
 
    CGFloat city_y = 13;
    CGFloat city_w = 33;
    CGFloat city_h = 13;
    CGFloat city_x = content_size.width - city_w - 13;
    self.cityLab.frame = CGRectMake(city_x, city_y, city_w, city_h);
    
 
    CGFloat title_x = 0;
    CGFloat title_y = CGRectGetMaxY(self.iconView.frame)+ 2;
    if (self.isHomestay) {
        title_y = CGRectGetMaxY(self.iconView.frame)+ 22;
    }
    CGFloat title_w = icon_w;
    CGFloat title_h = 40;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);

    CGFloat price_x = 0;
    CGFloat price_h = 20;
    CGFloat price_y = content_size.height - price_h;
    CGFloat price_w = icon_w;
    self.priceLab.frame = CGRectMake(price_x, price_y, price_w, price_h);

    CGFloat wifi_w = 31;
    CGFloat wifi_h = 15;
    CGFloat wifi_x = icon_w - wifi_w;
    CGFloat wifi_y =  content_size.height - wifi_h;
    self.wifiLab.frame = CGRectMake(wifi_x, wifi_y, wifi_w, wifi_h);
 
    CGFloat tag_w = 53;
    CGFloat tag_x = wifi_x - 10 - tag_w;
    CGFloat tag_y = wifi_y;
    if (self.isHomestay) {
        tag_y = CGRectGetMaxY(self.iconView.frame)+ 4;
        tag_x = icon_x;
    }
    CGFloat tag_h = wifi_h;
    self.tagLab.frame = CGRectMake(tag_x, tag_y, tag_w, tag_h);
    
    if (self.isHomestay) {
        wifi_x = tag_x + tag_w + 10;
        wifi_y = tag_y;
        self.wifiLab.frame = CGRectMake(wifi_x, wifi_y, wifi_w, wifi_h);
    }

}


@end
