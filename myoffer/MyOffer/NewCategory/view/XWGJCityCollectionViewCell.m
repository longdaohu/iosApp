//
//  XWGJCityCollectionViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJCityCollectionViewCell.h"
#import "XWGJHotCity.h"

@interface XWGJCityCollectionViewCell ()
//蒙版
@property(nonatomic,strong)UIImageView *MengView;
//图片
@property(nonatomic,strong)UIImageView *IconView;
//标题
@property(nonatomic,strong)UILabel *TitleLab;

@end

@implementation XWGJCityCollectionViewCell

- (void)awakeFromNib {
  
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = XCOLOR_WHITE;
    
    
    self.IconView =[[UIImageView alloc] init];
    self.IconView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.IconView];
    
    
    
    UIImage *norImage = [UIImage imageNamed:@"Menu_Mask"];
    
    self.MengView =[[UIImageView alloc] init];
    self.MengView.alpha = 0.7;
    self.MengView.contentMode = UIViewContentModeScaleAspectFill;
    self.MengView.image = norImage;
    [self.contentView addSubview:self.MengView];
    
    self.TitleLab = [UILabel labelWithFontsize:20 TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentLeft];
    self.TitleLab.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.TitleLab];
    
}
-(void)setCity:(XWGJHotCity *)city
{
    _city = city;
    
    self.TitleLab.text =city.cityName;
    
 
    [self.IconView sd_setImageWithURL:[NSURL URLWithString:city.IconName]  placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat iconx = 0;
    CGFloat icony = 0;
    CGFloat iconw = FLOWLAYOUT_CityW;
    CGFloat iconh = iconw;
    self.IconView.frame =CGRectMake(iconx, icony, iconw, iconh);
    
    
    CGFloat Titlex = margin;
    CGFloat Titley = iconw * 0.8;
    CGFloat Titlew = iconw;
    CGFloat Titleh = iconw * 0.2;
    self.TitleLab.frame =CGRectMake(Titlex, Titley, Titlew, Titleh);
 
    self.TitleLab.font = [UIFont systemFontOfSize:0.12 *FLOWLAYOUT_CityW];

    CGFloat mengx = 0;
    CGFloat mengy = iconh * 0.5;
    CGFloat mengw = Titlew;
    CGFloat mengh = iconh * 0.5;
    self.MengView.frame =CGRectMake(mengx, mengy, mengw, mengh);
    
    
}



@end
