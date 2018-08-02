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
@property(nonatomic,strong)NSArray *tags;
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
        iconView.layer.cornerRadius = 4;
        iconView.layer.masksToBounds = YES;

        UILabel *cityLab = [UILabel new];
        cityLab.textColor = XCOLOR(179, 179, 179, 1);
        cityLab.font = XFONT(9);
        cityLab.text = @"伦敦";
        cityLab.textAlignment = NSTextAlignmentCenter;
        cityLab.backgroundColor = XCOLOR_WHITE;
        [self.contentView addSubview:cityLab];
        self.cityLab = cityLab;
        cityLab.layer.cornerRadius = 2;
        cityLab.layer.masksToBounds = YES;
        
        UILabel *titleLab = [UILabel new];
        titleLab.textColor = XCOLOR_TITLE;
        titleLab.font = XFONT(14);
        titleLab.numberOfLines = 2;
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        
        UILabel *priceLab = [UILabel new];
        priceLab.textColor = XCOLOR(50, 50, 50, 1);
        priceLab.font = XFONT(14);
        [self.contentView addSubview:priceLab];
        priceLab.textAlignment = NSTextAlignmentLeft;
        self.priceLab = priceLab;
        
        UILabel *tagLab = [UILabel new];
        tagLab.textColor = XCOLOR_WHITE;
        tagLab.font = XFONT(9);
        tagLab.backgroundColor = XCOLOR_LIGHTBLUE;
        [self.contentView addSubview:tagLab];
        self.tagLab = tagLab;
        tagLab.textAlignment = NSTextAlignmentCenter;
        tagLab.layer.cornerRadius = 2;
        tagLab.layer.masksToBounds = YES;
        
        UILabel *wifiLab = [UILabel new];
        wifiLab.textColor = XCOLOR_WHITE;
        wifiLab.font = XFONT(9);
        wifiLab.textAlignment = NSTextAlignmentCenter;
        wifiLab.backgroundColor = XCOLOR_RED;
        [self.contentView addSubview:wifiLab];
        wifiLab.layer.cornerRadius = 2;
        wifiLab.layer.masksToBounds = YES;
        self.wifiLab = wifiLab;
        
        self.tags = @[tagLab,wifiLab];

    }
    return self;
}

- (void)setFlatFrameObject:(HomeRoomIndexFlatFrameObject *)flatFrameObject{
    _flatFrameObject = flatFrameObject;
    self.item = flatFrameObject.item;
    
    self.iconView.frame = flatFrameObject.icon_Frame;
    self.titleLab.frame = flatFrameObject.name_frame;
    self.priceLab.frame = flatFrameObject.price_frame;
    self.cityLab.frame = flatFrameObject.city_frame;
    
    NSValue *tagValue =  flatFrameObject.tag_frames.firstObject;
    NSValue *wifiValue = flatFrameObject.tag_frames.lastObject;
    self.tagLab.frame = tagValue.CGRectValue;
    self.wifiLab.frame = wifiValue.CGRectValue;
    self.tagLab.text = flatFrameObject.item.feature.firstObject;
    self.wifiLab.text = flatFrameObject.item.feature.lastObject;
}

- (void)setItem:(HomeRoomIndexFlatsObject *)item{
    _item = item;
    
    NSString *path = [item.image toUTF8WithString];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
    self.titleLab.text = item.name;
    self.priceLab.attributedText = item.priceAttribue;
    
    if (item.feature.count >= 2){
        self.wifiLab.text = item.feature.firstObject;
        self.tagLab.text = item.feature.lastObject;
    }
    
    if (item.feature.count == 1) {
        self.tagLab.text = item.feature.firstObject;
        self.wifiLab.text = @"";
    }
 
 }



- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.flatFrameObject) return;
    
    CGSize content_size = self.contentView.bounds.size;

    CGFloat icon_x = 0;
    CGFloat icon_y = 0;
    CGFloat icon_w = content_size.width;
    CGFloat icon_h = 158;
    self.iconView.frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
 
    CGFloat city_y = 13;
    CGFloat city_w = 33;
    CGFloat city_h = 13;
    CGFloat city_x = content_size.width - city_w - 13;
    self.cityLab.frame = CGRectMake(city_x, city_y, city_w, city_h);
    
 
    CGFloat title_x = 0;
    CGFloat title_y = CGRectGetMaxY(self.iconView.frame)+ 2;
    CGFloat title_w = icon_w;
    CGSize title_size = [self.titleLab.text stringWithfontSize:14];
    CGFloat title_h = title_size.width > icon_w ? title_size.height * 2 : title_size.height;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);

    CGFloat price_x = 0;
    CGFloat price_h = 20;
    CGFloat price_y = content_size.height - price_h;
    CGFloat price_w = icon_w;
    self.priceLab.frame = CGRectMake(price_x, price_y, price_w, price_h);

    CGFloat wifi_w = [self.wifiLab.text stringWithfontSize:9].width;
    if (wifi_w > 0) {
        wifi_w += 10;
    }
    CGFloat wifi_h = 15;
    CGFloat wifi_x = icon_w - wifi_w;
    CGFloat wifi_y =  content_size.height - wifi_h;
    self.wifiLab.frame = CGRectMake(wifi_x, wifi_y, wifi_w, wifi_h);
 
    CGFloat tag_w = [self.tagLab.text stringWithfontSize:9].width;
    if (tag_w > 0) {
        tag_w += 10;
    }
    CGFloat tag_x = wifi_x - 10 - tag_w;
    if (wifi_w == 0) {
        tag_x += wifi_x;
    }
    CGFloat tag_y = wifi_y;
    CGFloat tag_h = wifi_h;
    self.tagLab.frame = CGRectMake(tag_x, tag_y, tag_w, tag_h);

}


@end
