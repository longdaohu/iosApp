//
//  HomeRentCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRentCell.h"

@interface HomeRentCell ()
@property (weak, nonatomic) IBOutlet UIView *home_room_apartment_01;
@property (weak, nonatomic) IBOutlet UIView *home_room_apartment_02;
@property (weak, nonatomic) IBOutlet UIView *home_room_apartment_03;
@property (weak, nonatomic) IBOutlet UIView *home_room_apartment_04;
@property(nonatomic,assign)CGRect last_frame;
@property(nonatomic,strong)NSArray *projectViews;
@property(nonatomic,strong)CAShapeLayer *shadowLayer;

@end

@implementation HomeRentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.projectViews = @[self.home_room_apartment_01,self.home_room_apartment_02,self.home_room_apartment_03,self.home_room_apartment_04];
}

- (CAShapeLayer *)shadowLayer{
    if (!_shadowLayer) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor = XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 5);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.05;
        _shadowLayer = shaper;
        [self.contentView.layer insertSublayer:shaper below:self.home_room_apartment_01.layer];
    }
    
    return _shadowLayer;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if ( !self.shadowLayer.shadowPath) {
        
        UIBezierPath *path;
        for (NSInteger index = 0; index < self.projectViews.count; index++) {
            UIView *item =  self.projectViews[index];
            CGRect frame = item.frame;
            frame.size.width = self.bounds.size.width - frame.origin.x * 2;
            if (index == 0) {
                path = [UIBezierPath bezierPathWithRect:frame];
            }else{
                [path appendPath: [UIBezierPath bezierPathWithRect:frame]];
            }
        }
        self.shadowLayer.shadowPath = path.CGPath;
        
    }
 
    
}


@end
