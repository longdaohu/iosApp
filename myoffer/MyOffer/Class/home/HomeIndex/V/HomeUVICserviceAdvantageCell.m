//
//  HomeUVICserviceAdvantageCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/25.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeUVICserviceAdvantageCell.h"

@interface HomeUVICserviceAdvantageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation HomeUVICserviceAdvantageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconView.layer.cornerRadius = CORNER_RADIUS;
    self.iconView.layer.masksToBounds = true;
 
}

- (void)setItem:(NSDictionary *)item{
    _item = item;
    
    [self.iconView setImage:XImage(item[@"icon"])];
    self.titleLab.text = item[@"title"];
}

@end
