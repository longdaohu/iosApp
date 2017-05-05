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
    
//    self.cityLab.font = [UIFont boldSystemFontOfSize: XFONT_SIZE(22)];
    
}

-(void)setCity:(CatigaryHotCity *)city
{
    _city = city;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:city.image_path]  placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
}

- (void)setMoreCity:(BOOL)moreCity{

    if (moreCity) {
        
        NSString *imageName = @"ao_more.jpg";
        if ([self.city.country containsString:@"英"]) imageName = @"uk_more.jpg";
        if ([self.city.country containsString:@"美"]) imageName = @"usa_more.jpg";
        
        self.iconView.image = [UIImage imageNamed:imageName];
        
    }
 
    
}





@end
