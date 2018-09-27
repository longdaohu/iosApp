//
//  RoomAppointSuccesView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomAppointSuccesView.h"

@interface RoomAppointSuccesView ()
@property (weak, nonatomic) IBOutlet UIButton *meiqiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *keepBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong) CAShapeLayer *shaper;

@end

@implementation RoomAppointSuccesView


- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.keepBtn.backgroundColor = XCOLOR_RED;
    self.backgroundColor = XCOLOR_BG;
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
    
    CAShapeLayer *shaper = [CAShapeLayer layer];
    shaper.shadowColor = XCOLOR_BLACK.CGColor;
    shaper.shadowOffset = CGSizeMake(0, 5);
    shaper.shadowRadius = 5;
    shaper.shadowOpacity = 0.3;
    [self.layer insertSublayer:shaper below:self.bgView.layer];
    self.shaper = shaper;
    
    [self.meiqiaBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
    NSDictionary *attribtDic = @{ NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribt_look = [[NSMutableAttributedString alloc] initWithString:self.meiqiaBtn.currentTitle];
    [attribt_look addAttributes:attribtDic range:NSMakeRange(0, self.meiqiaBtn.currentTitle.length)];
    [ self.meiqiaBtn  setAttributedTitle:attribt_look forState:UIControlStateNormal];
}


- (void)caseMeiqia{
    [self caseMeiqia:nil];
}

- (IBAction)caseMeiqia:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock(sender, nil, nil);
    }
}

- (IBAction)caseBack:(UIButton *)sender {
 
    if (self.actionBlock) {
        self.actionBlock(nil, sender, nil);
    }

}
- (IBAction)caseKeepLook:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock(nil, nil, sender);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bgView.frame cornerRadius:8];
    self.shaper.path = path.CGPath;
}

- (void)dealloc{
    
    KDClassLog(@"预约表单成功提示 + RoomAppointSuccesView + dealloc");
}


@end

