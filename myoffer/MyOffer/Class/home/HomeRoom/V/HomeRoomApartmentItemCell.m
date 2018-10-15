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
@property(nonatomic,strong)UIButton *cityLab;
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

        UIButton *cityLab = [UIButton new];
        [cityLab setTitleColor:XCOLOR(179, 179, 179, 1) forState:UIControlStateNormal];
        cityLab.titleLabel.font = XFONT(10);
        cityLab.backgroundColor = XCOLOR_WHITE;
        [self.contentView addSubview:cityLab];
        self.cityLab = cityLab;
        cityLab.layer.cornerRadius = 2;
        cityLab.userInteractionEnabled = NO;
        
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
 
    
    if (flatFrameObject.item.feature.count > 0){
        
        NSValue *tagValue =  flatFrameObject.tag_frames.firstObject;
        NSValue *wifiValue = flatFrameObject.tag_frames.lastObject;
        self.tagLab.frame = tagValue.CGRectValue;
        self.wifiLab.frame = wifiValue.CGRectValue;
        self.tagLab.text = flatFrameObject.item.feature.firstObject;
        self.wifiLab.text = flatFrameObject.item.feature.lastObject;
        
    }else{
        self.tagLab.frame = CGRectZero;
        self.wifiLab.frame = CGRectZero;
    }
}

- (void)setItem:(HomeRoomIndexFlatsObject *)item{
    
    _item = item;
    
    UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:item.image];
    if (thumbnailImage) {
        self.iconView.image = thumbnailImage;
    }else{
        NSString *path = [item.image toUTF8WithString];
        NSURL *url = [NSURL URLWithString:path];
        [self.iconView sd_setImageWithURL:url placeholderImage:PLACE_HOLDER_IMAGE options:SDWebImageRetryFailed];
    }
    self.titleLab.text = item.name;
    self.priceLab.attributedText = item.priceAttribue;
    [self.cityLab setTitle:item.city forState:UIControlStateNormal];
    
    if (item.feature.count >= 2){
        self.wifiLab.text = item.feature.firstObject;
        self.tagLab.text = item.feature.lastObject;
    }
    
    if (item.feature.count == 1) {
        self.tagLab.text = item.feature.firstObject;
        self.wifiLab.text = @"";
    }
 
 }




@end
