//
//  GuideItemCell.m/Users/xuewuguojie/Desktop/iosApp/myoffer/MyOffer/Class/home/XiaoBai/View/GuideItemCell.xib
//  MyOffer
//
//  Created by xuewuguojie on 2017/11/15.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "GuideItemCell.h"

@interface GuideItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation GuideItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = true;
    self.tagLab.layer.cornerRadius = 2;
    self.tagLab.layer.masksToBounds = true;
    self.contentView.layer.shadowOffset = CGSizeMake(3, 6);
    self.contentView.layer.shadowOpacity = 0.1;
    self.contentView.layer.shadowRadius = 4;
}

- (void)setItem:(GuideItem *)item{
    
    _item = item;
    
    self.tagLab.text = item.tag;
    self.titleLab.text = item.title;
    [self.iconView  sd_setImageWithURL:[NSURL URLWithString:item.imgUrl] placeholderImage:nil];
    
}


@end

