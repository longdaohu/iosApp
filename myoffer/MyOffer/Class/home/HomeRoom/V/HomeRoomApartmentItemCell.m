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
@property(nonatomic,strong)UIButton *cityLab;
@property(nonatomic,strong)NSMutableArray *tags;
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
        
        for (NSInteger index = 0; index < 2; index++) {
 
            UILabel *sender = [UILabel new];
            sender.textColor = XCOLOR_WHITE;
            sender.font = XFONT(9);
            sender.textAlignment = NSTextAlignmentCenter;
            sender.backgroundColor = index % 2 ? XCOLOR_RED :  XCOLOR_LIGHTBLUE;
            sender.layer.cornerRadius = 2;
            sender.layer.masksToBounds = YES;
            
            [self.contentView addSubview:sender];
            [self.tags addObject:sender];
        }
    }
    return self;
}

- (NSMutableArray *)tags{
    if(!_tags){
        _tags = [NSMutableArray array];
    }
    
    return _tags;
}

- (void)makeTagViewWithFeature{
 
    
    for (NSInteger index  = 0;  index < self.tags.count ; index++) {
        
        UILabel *sender = self.tags[index];
        if (index >= self.flatFrameObject.tag_frames.count) {
            sender.hidden = YES;
        }else{
            sender.hidden = NO;
            NSValue *value =  self.flatFrameObject.tag_frames[index];
            NSString *title = self.flatFrameObject.item.feature[index];
            sender.frame = value.CGRectValue;
            sender.text = title;
        }
    }
    
}

- (void)setFlatFrameObject:(HomeRoomIndexFlatFrameObject *)flatFrameObject{
    _flatFrameObject = flatFrameObject;
    
    self.iconView.frame = flatFrameObject.icon_Frame;
    self.titleLab.frame = flatFrameObject.name_frame;
    self.priceLab.frame = flatFrameObject.price_frame;
    self.cityLab.frame = flatFrameObject.city_frame;
 
    [self makeTagViewWithFeature];
    
    HomeRoomIndexFlatsObject *item = flatFrameObject.item;
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

}


@end
