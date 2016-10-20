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
     
        self.iconView =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.iconView.imageEdgeInsets = UIEdgeInsetsMake(-3, -20, 0, 0);
        [self.iconView  setImage:  XImage(@"menu_white")  forState:UIControlStateNormal];
        [self addSubview:self.iconView ];
        [self.iconView addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchDown];
        
        self.countLab =[[UILabel alloc] initWithFrame:CGRectMake(16, 0, 18, 18)];
        self.countLab.layer.cornerRadius   = 9;
        self.countLab.layer.masksToBounds  = YES;
        self.countLab.backgroundColor = [UIColor redColor];
        self.countLab.textColor       = [UIColor whiteColor];
        self.countLab.textAlignment   = NSTextAlignmentCenter;
        self.countLab.font            = [UIFont systemFontOfSize:13];
        self.countLab.hidden          = YES;
        [self addSubview:self.countLab];
        
    }

    return self;
}

+(instancetype)leftViewWithBlock:(LeftBarButtonItemViewBlock)actionBlock
{
    
    LeftBarButtonItemView *left =[[LeftBarButtonItemView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    left.actionBlock = ^(){
        
        actionBlock();
        
    };
    return left;
}


-(void)setCountStr:(NSString *)countStr{

    _countStr = countStr;
    
    self.countLab.hidden = countStr.integerValue == 0;
    self.countLab.text   = countStr.length >= 3 ? @"99+": countStr;
    
    if (self.countLab.text.length > 1) {
        CGSize countSize    = [self.countLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:13]];
        self.countLab.width = countSize.width + 8;
    }else{
        self.countLab.width = 18;
    
    }
    
}

-(void)left:(UIButton *)sender{

    if (self.actionBlock) {
        
        self.actionBlock();
        
    }
}

@end
