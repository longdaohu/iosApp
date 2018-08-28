//
//  YasiHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YasiHeaderView.h"

@interface YasiHeaderView ()
@property(nonatomic,strong)UIButton *onliveBtn;
@property(nonatomic,strong)UIButton *livedBtn;

@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bottomView;

@end

@implementation YasiHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_WHITE;
        
        UIButton  *onliveBtn = [UIButton new];
        self.onliveBtn = onliveBtn;
        onliveBtn.titleLabel.font = XFONT(12);
        [onliveBtn setTitle:@"进行中" forState:UIControlStateNormal];
        [onliveBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        [onliveBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateSelected];
        [self addSubview:onliveBtn];
        [onliveBtn addTarget:self action:@selector(caseOnliving:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton  *livedBtn = [UIButton new];
        self.livedBtn = livedBtn;
        livedBtn.titleLabel.font = XFONT(12);
        [livedBtn setTitle:@"已结课" forState:UIControlStateNormal];
        [livedBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        [livedBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateSelected];
        [self addSubview:livedBtn];
       [livedBtn addTarget:self action:@selector(caseLived:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *topView = [UIView new];
        topView.backgroundColor = XCOLOR_line;
        [self addSubview:topView];
        self.topView = topView;
 
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = XCOLOR_line;
        [self addSubview:bottomView];
        self.bottomView = bottomView;
    }
    return self;
}

- (void)caseOnliving:(UIButton *)sender{
    
}

- (void)caseLived:(UIButton *)sender{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGSize content_size = self.bounds.size;

    CGFloat dt_x = 20;
    CGFloat dt_w = 41;
    CGFloat dt_h = content_size.height;
    CGFloat dt_y = 0;
    self.onliveBtn.frame = CGRectMake(dt_x, dt_y, dt_w, dt_h);
    
    CGFloat led_x = dt_x + dt_w + 36;
    CGFloat led_w = dt_w;
    CGFloat led_h = dt_h;
    CGFloat led_y =  dt_y;
    self.livedBtn.frame = CGRectMake(led_x, led_y, led_w, led_h);
    

    CGFloat top_x  = 0;
    CGFloat top_y  = 0;
    CGFloat top_w  = content_size.width;
    CGFloat top_h  = 0.5;
    self.topView.frame = CGRectMake(top_x, top_y, top_w, top_h);
    
    CGFloat btm_x  = 0;
    CGFloat btm_y  = content_size.height - top_h;
    CGFloat btm_w  = top_w;
    CGFloat btm_h  = top_h;
    self.bottomView.frame = CGRectMake(btm_x, btm_y, btm_w, btm_h);
}

@end
