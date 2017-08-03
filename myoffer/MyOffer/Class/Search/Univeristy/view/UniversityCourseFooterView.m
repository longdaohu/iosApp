//
//  UniversityCourseFooterView.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "UniversityCourseFooterView.h"
@interface UniversityCourseFooterView ()
@property(nonatomic,strong) UILabel *count_lab;
@property(nonatomic,strong) UIButton *submitBtn;
@property(nonatomic,strong) CALayer *line;
@end

@implementation UniversityCourseFooterView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_WHITE;
        
        UILabel *count_lab = [UILabel new];
        count_lab.textColor = XCOLOR_LIGHTBLUE;
        [self addSubview:count_lab];
        count_lab.font = XFONT(14);
        self.count_lab = count_lab;
        count_lab.textAlignment = NSTextAlignmentCenter;
        self.count_lab.text= @"已选择：0";

        
        UIButton *submitBtn = [UIButton new];
        self.submitBtn = submitBtn;
        [self addSubview:submitBtn];
        submitBtn.layer.cornerRadius = CORNER_RADIUS;
        submitBtn.layer.masksToBounds = YES;
        submitBtn.backgroundColor = XCOLOR_BG;
        [submitBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        self.submitBtn.enabled = NO;
        [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
        submitBtn.titleLabel.font = XFONT(14);
        [submitBtn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = XCOLOR_line.CGColor;
        [self.layer addSublayer:line];
        self.line = line;
        
    }
    
    return self;
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    
    CGSize contentSize = self.bounds.size;
    
    self.line.frame = CGRectMake(0, 0, contentSize.width, LINE_HEIGHT);
    
    
    CGFloat button_hight = 50;
    CGFloat margin = (contentSize.height - button_hight) * 0.5;
    
    CGFloat count_X = margin;
    CGFloat count_Y = margin;
    CGFloat count_W = (contentSize.width - margin * 3) * 0.5;
    CGFloat count_H = button_hight;
    self.count_lab.frame = CGRectMake(count_X, count_Y, count_W, count_H);

    
    CGFloat submit_X = CGRectGetMaxX(self.count_lab.frame) + margin;
    CGFloat submit_Y = count_Y;
    CGFloat submit_W = count_W;
    CGFloat submit_H = count_H;
    self.submitBtn.frame = CGRectMake(submit_X, submit_Y, submit_W, submit_H);
   
    
}

- (void)setCount:(NSInteger)count{

    _count = count;
    
    self.count_lab.text= [NSString stringWithFormat:@"已选择：%ld",(long)count];
    
    self.submitBtn.backgroundColor = count > 0 ? XCOLOR_RED : XCOLOR_BG;
    
    self.submitBtn.enabled = count > 0;
    
    
}


- (void)onClick{

    if (self.actionBlock) self.actionBlock();
    
}


@end

