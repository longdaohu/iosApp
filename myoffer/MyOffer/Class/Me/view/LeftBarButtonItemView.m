//
//  LeftButtonView.m
//  NewFeatureProject
//
//  Created by xuewuguojie on 16/7/18.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "LeftBarButtonItemView.h"

@implementation LeftBarButtonItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.iconView =[[UIButton alloc] init];
        self.iconView.imageEdgeInsets = UIEdgeInsetsMake(-3, -20, 0, 0);
        [self addSubview:self.iconView];
        [self.iconView addTarget:self action:@selector(leftButtonOnClick:) forControlEvents:UIControlEventTouchDown];
        
        self.countLab =[[UILabel alloc] init];
        self.countLab.layer.cornerRadius   = REDSPOT_HEIGHT  * 0.5;
        self.countLab.layer.masksToBounds  = YES;
        self.countLab.backgroundColor = [UIColor whiteColor];
        self.countLab.textColor       = XCOLOR_LIGHTBLUE;
        self.countLab.textAlignment   = NSTextAlignmentCenter;
        self.countLab.font            = [UIFont systemFontOfSize:12];
        self.countLab.hidden          = YES;
        [self addSubview:self.countLab];
        
    }

    return self;
}


+ (instancetype)leftViewWithBlock:(LeftBarButtonItemViewBlock)actionBlock
{
    
    LeftBarButtonItemView *left =[[LeftBarButtonItemView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    left.actionBlock = actionBlock;
    return left;
}

- (void)setIcon:(NSString *)icon{
    _icon = icon;
    [self.iconView setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
}


-(void)setCountStr:(NSString *)countStr{

    _countStr = countStr;
    
    self.countLab.hidden = countStr.integerValue == 0;
    self.countLab.text   = countStr.length >= 3 ? @"99+": countStr;
    [self layoutSubviews];
}

-(void)leftButtonOnClick:(UIButton *)sender{

    if (self.actionBlock) {self.actionBlock();}
 
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat icon_w = contentSize.width;
    CGFloat icon_h = contentSize.height;
    self.iconView.frame = CGRectMake(0, 0, icon_w, icon_h);
    
    
    CGFloat count_x = 16;
    CGFloat count_y = 0;
    CGFloat count_h = REDSPOT_HEIGHT;
    CGFloat count_w = count_h;

    if (self.countLab.text.length > 1) {
        CGSize countSize    = [self.countLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:12]];
        count_w = countSize.width + 8;
    }else{
        count_w = REDSPOT_HEIGHT;
    }
    self.countLab.frame = CGRectMake(count_x, count_y, count_w, count_h);

    
 
}

@end
