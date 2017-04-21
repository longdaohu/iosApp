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

@end

@implementation CatigaryCityCollectionCell

- (void)awakeFromNib {
  
    [super awakeFromNib];
    
    self.cityLab.font = [UIFont boldSystemFontOfSize: XFONT_SIZE(22)];
    
}

-(void)setCity:(CatigaryHotCity *)city
{
    _city = city;
    
    self.cityLab.text =city.city;
    self.cityLab.textColor = XCOLOR_WHITE;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:city.image_path]  placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
}

- (void)setMoreCity:(BOOL)moreCity{

    if (moreCity) {
        
        self.cityLab.text = @"查看更多";
        self.cityLab.textColor = XCOLOR_SUBTITLE;
        self.iconView.image = [UIImage imageNamed:@"PlaceHolderImage"];
        
    }
 
    
}





@end
