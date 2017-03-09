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
//标题
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
//蒙版
@property(nonatomic,strong)CAGradientLayer *gradientLayer;

@end

@implementation CatigaryCityCollectionCell

- (void)awakeFromNib {
  
    [super awakeFromNib];
 
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    UIColor *colorOne = [UIColor colorWithWhite:0 alpha:0];
    UIColor *colorTwo = [UIColor colorWithWhite:0 alpha:0.6];
    gradientLayer.colors           = [NSArray arrayWithObjects:
                                 (id)colorOne.CGColor,
                                 (id)colorTwo.CGColor,
                                 nil];
    gradientLayer.locations  = @[@(0.2), @(0.8)];

    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    self.gradientLayer = gradientLayer;
    [self.contentView.layer insertSublayer:gradientLayer below:self.cityLab.layer];
    
    
    self.cityLab.font = [UIFont systemFontOfSize: XPERCENT * 16];
    
    
 }
-(void)setCity:(CatigaryHotCity *)city
{
    _city = city;
    
    self.cityLab.text =city.city;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:city.image_path]  placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
   
    CGFloat mengx = 0;
    CGFloat mengy = contentSize.height * 0.5;
    CGFloat mengw = contentSize.width;
    CGFloat mengh = contentSize.height  * 0.5;
    self.gradientLayer.frame = CGRectMake(mengx, mengy, mengw, mengh);
 
}



@end
