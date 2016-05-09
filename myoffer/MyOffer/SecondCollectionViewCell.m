//
//  SecondCollectionViewCell.m
//  myOffer
//
//  Created by sara on 16/3/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//


#import "SecondCollectionViewCell.h"

@implementation SecondCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.iconView = [[UIImageView alloc] init];
        self.iconView.image = [UIImage imageNamed:@"PlaceHolderImage"];
        self.iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.iconView];
        
        self.mengView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Menu_Mask"]];
        self.mengView.alpha = 0.7;
        self.mengView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.mengView];
        
        self.titleLab = [UILabel labelWithFontsize:KDUtilSize(15)  TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentLeft];
        self.titleLab.numberOfLines = 2;
        [self.contentView addSubview:self.titleLab];
        
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
 
        self.backgroundColor =  BACKGROUDCOLOR;

    }
    return self;
}



-(void)setItemInfo:(NSDictionary *)itemInfo
{
    _itemInfo = itemInfo;
    
      self.titleLab.text = itemInfo[@"title"];
      NSString *iconStr = [itemInfo[@"cover_url"]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconStr]];
  
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iconx = 0;
    CGFloat icony = 0;
    CGFloat iconw = self.bounds.size.width;
    CGFloat iconh = self.bounds.size.height;
    
    self.iconView.frame = CGRectMake(iconx, icony, iconw, iconh);
    
    CGFloat mengx = 0;
    CGFloat mengy = iconh * 0.5;
    CGFloat mengw = iconw;
    CGFloat mengh = iconh * 0.5;
    self.mengView.frame =CGRectMake(mengx, mengy, mengw, mengh);
    
    
    if (self.titleLab.text) {
        
        CGFloat titlex = 10;
        CGFloat titlew = self.bounds.size.width - 2 * ITEM_MARGIN;
        CGSize  titleSize = [self.titleLab.text KD_sizeWithAttributeFont:FontWithSize(KDUtilSize(15))];
        CGFloat titleh =  titleSize.width > titlew  ? titleSize.height * 2 :titleSize.width;
        CGFloat titley = self.bounds.size.height - titleh - 10;
        self.titleLab.frame = CGRectMake(titlex, titley, titlew, titleh);
        
     }

}


@end
