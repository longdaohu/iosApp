//
//  HomeGuideView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeGuideView.h"
@interface HomeGuideView ()

@end
@implementation HomeGuideView

+ (instancetype)guideView{
    
    HomeGuideView *guide = [[HomeGuideView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
 
    return guide;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR(0, 0, 0, 0);
        self.alpha = 0;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        CGFloat  path_x = 65;
        CGFloat  path_y = XStatusBar_Height;
        CGFloat  path_h = HOME_MENU_HEIGHT - path_y  - 5;
        [path appendPath: [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(path_x, path_y, frame.size.width, path_h) cornerRadius: path_h * 0.5] bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = XCOLOR(0, 0, 0, 0.65).CGColor;
        [self.layer addSublayer:shapeLayer];
        
        UIImage *icon_a = [UIImage imageNamed:@"home_guide_a"];
        UIImage *icon_b = [UIImage imageNamed:@"home_guide_b"];
        UIImage *icon_btn = [UIImage imageNamed:@"home_guide_btn"];
        UIImage *icon_finger = [UIImage imageNamed:@"home_guide_finger"];
 
        CGFloat a_x = path_x + 30;
        CGFloat a_y = path_h + path_y + 5;
        CGFloat a_w = 197;
        CGFloat a_h = a_w * icon_a.size.height/icon_a.size.width;
        UIImageView *view_a = [[UIImageView alloc] initWithFrame:CGRectMake(a_x, a_y, a_w, a_h)];
        view_a.contentMode = UIViewContentModeScaleToFill;
        view_a.image = icon_a;
        [self addSubview:view_a];
        
        CGFloat btn_x = a_x + 10;
        CGFloat btn_y = a_y + a_h + 13;
        CGFloat btn_w = 113;
        CGFloat btn_h = 34;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btn_x, btn_y, btn_w, btn_h)];
        [btn setImage:icon_btn forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(caseHide) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat fg_x = a_x;
        CGFloat fg_y = btn_y + btn_h + 290;
        CGFloat fg_w = 36;
        CGFloat fg_h = 53;
        UIImageView *finger = [[UIImageView alloc] initWithFrame:CGRectMake(fg_x, fg_y, fg_w, fg_h)];
        finger.contentMode = UIViewContentModeScaleToFill;
        finger.image = icon_finger;
        [self addSubview:finger];
        
        CGFloat ib_x = fg_x + fg_w + 10;
        CGFloat ib_y = fg_y;
        CGFloat ib_w = 181;
        CGFloat ib_h = 40;
        UIImageView *bView = [[UIImageView alloc] initWithFrame:CGRectMake(ib_x, ib_y, ib_w, ib_h)];
        bView.contentMode = UIViewContentModeScaleToFill;
        bView.image = icon_b;
        [self addSubview:bView];
        
    }
    return self;
}


- (void)show{
    
    self.alpha = 1;
}

- (void)hide{
    
    self.alpha = 0;
}

- (void)caseHide{
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
//        if (finished) [self removeFromSuperview];
    }];
    [USDefault setValue:@"HomeGuideView" forKey:@"HomeGuideView"];
    [USDefault synchronize];
}

- (void)layoutSubviews{
    [super layoutSubviews];
 
}

@end
