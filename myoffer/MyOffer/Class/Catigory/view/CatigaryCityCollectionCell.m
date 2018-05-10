//
//  XWGJCityCollectionViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CatigaryCityCollectionCell.h"
#import "CatigaryHotCity.h"

@interface CatigaryCityCollectionCell ()
//图片
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation CatigaryCityCollectionCell


- (void)setCity:(CatigaryHotCity *)city
{
    _city = city;
    
    if (city.imageName) {
        self.iconView.image = XImage(city.imageName);
        return;
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:city.image_url]  placeholderImage:XImage(@"PlaceHolderImage")];
}

- (void)setTopic:(MessageHotTopicMedel *)topic{

    _topic = topic;
    NSURL *url_path = [NSURL URLWithString:topic.cover_path];
    [self.iconView sd_setImageWithURL:url_path  placeholderImage:XImage(@"PlaceHolderImage")];
}




@end
