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
@property (weak, nonatomic) IBOutlet UILabel *contactLab;

@end

@implementation HomeRentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.projectViews = @[self.home_room_apartment_01,self.home_room_apartment_02,self.home_room_apartment_03,self.home_room_apartment_04];
    
    NSString *web = @"www.51room.com访问官网查看更多";
    NSDictionary *attribtDic = @{ NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.contactLab.attributedText];
    [attribtStr addAttributes:attribtDic range:NSMakeRange(5, web.length)];
    self.contactLab.attributedText = attribtStr;
    
}

- (CAShapeLayer *)shadowLayer{
    if (!_shadowLayer) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor = XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 0);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.05;
        _shadowLayer = shaper;
        [self.home_room_apartment_01.superview.layer insertSublayer:shaper below:self.home_room_apartment_01.layer];
    }
    
    return _shadowLayer;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
        UIBezierPath *path;
        for (NSInteger index = 0; index < self.projectViews.count; index++) {
            UIView *item =  self.projectViews[index];
            CGRect frame = item.frame;
            frame.size.width = self.bounds.size.width - 40;
            if (index == 0) {
                path = [UIBezierPath bezierPathWithRect:frame];
            }else{
                [path appendPath: [UIBezierPath bezierPathWithRect:frame]];
            }
        }
        self.shadowLayer.shadowPath = path.CGPath;
 
}
- (IBAction)webOnClicked:(id)sender {
    
//    NSLog(@"www.51room.com");
    if (self.actionBlock) {
        self.actionBlock(@"https://www.51room.com");
    }
}


@end
