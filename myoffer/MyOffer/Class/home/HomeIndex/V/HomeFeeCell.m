//
//  HomeFeeCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeFeeCell.h"

@interface HomeFeeCell ()
@property (weak, nonatomic) IBOutlet UIView *home_fee_pay_01;
@property (weak, nonatomic) IBOutlet UIView *home_fee_pay_02;
@property (weak, nonatomic) IBOutlet UIView *home_fee_pay_03;
@property (weak, nonatomic) IBOutlet UIView *home_fee_pay_04;
@property (weak, nonatomic) IBOutlet UIView *home_fee_pay_05;
@property (weak, nonatomic) IBOutlet UIView *home_fee_pay_06;

@property(nonatomic,assign)CGRect last_frame;
@property(nonatomic,strong)NSArray *oneViews;
@property(nonatomic,strong)NSArray *twoViews;
@property(nonatomic,strong)CAShapeLayer *shadowLayer;
@property(nonatomic,strong)CAShapeLayer *shaper;
@end

@implementation HomeFeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.oneViews = @[self.home_fee_pay_01,self.home_fee_pay_02,self.home_fee_pay_03];
    self.twoViews = @[self.home_fee_pay_01,self.home_fee_pay_02,self.home_fee_pay_03];
    
}


- (CAShapeLayer *)shadowLayer{
    if (!_shadowLayer) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor = XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 0);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.05;
        _shadowLayer = shaper;
        
        [self.home_fee_pay_01.superview.layer insertSublayer:shaper below:self.home_fee_pay_01.layer];
        
    }
    
    return _shadowLayer;
}

- (CAShapeLayer *)shaper{
    if (!_shaper) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor = XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 0);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.05;
        _shaper = shaper;
        [self.self.home_fee_pay_04.superview.layer insertSublayer:shaper below:self.home_fee_pay_04.layer];
        
    }
    
    return _shaper;
}



- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
        UIBezierPath *path;
        for (NSInteger index = 0; index < self.oneViews.count; index++) {
            UIView *item =  self.oneViews[index];
            if (index == 0) {
                path = [UIBezierPath bezierPathWithRect:item.frame];
            }else{
                [path appendPath: [UIBezierPath bezierPathWithRect:item.frame]];
            }
        }
        self.shadowLayer.shadowPath = path.CGPath;

 

        UIBezierPath *path_b;
        for (NSInteger index = 0; index < self.twoViews.count; index++) {
            UIView *item =  self.twoViews[index];
            if (index == 0) {
                path_b = [UIBezierPath bezierPathWithRect:item.frame];
            }else{
                [path_b appendPath: [UIBezierPath bezierPathWithRect:item.frame]];
            }
        }
        self.shaper.shadowPath = path_b.CGPath;

    
}

@end
