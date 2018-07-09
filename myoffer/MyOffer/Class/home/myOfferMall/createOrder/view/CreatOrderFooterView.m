//
//  CreatOrderFooterView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "CreatOrderFooterView.h"

@interface CreatOrderFooterView()
@property(nonatomic,strong)UIButton *optionBtn;
@property(nonatomic,strong)UILabel *itemLab;

@end

@implementation CreatOrderFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//
////        CGFloat footer_h = 30;
////        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, footer_h)];
//        UIButton *optionBtn = [UIButton new]; //initWithFrame:CGRectMake( 15, 0, footer_h, footer_h)];
//        [optionBtn setImage:[UIImage imageNamed:@"protocol_nomal"] forState:UIControlStateNormal];
//        [optionBtn setImage:[UIImage imageNamed:@"protocol_select"] forState:UIControlStateSelected];
//        [self addSubview:optionBtn];
//        optionBtn.selected = YES;
//        [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        self.optionBtn = optionBtn;
//
//        UIButton *protocolBtn = [[UIButton alloc] init];
//        self.protocolBtn = protocolBtn;
//        [protocolBtn setTitle:@"购买条款与协议，买家须知" forState:UIControlStateNormal];
//        [protocolBtn.titleLabel setFont:XFONT(14)];
//        [protocolBtn sizeToFit];
//        [footer addSubview:protocolBtn];
//        [protocolBtn addTarget:self action:@selector(protocolClick:) forControlEvents:UIControlEventTouchUpInside];
//        CGFloat sub_y = 0;
//        CGFloat sub_h = footer_h;
//        CGFloat sub_x = CGRectGetMaxX(optionBtn.frame) + 5;
//        CGFloat sub_w = protocolBtn.mj_w;
//        protocolBtn.frame = CGRectMake(sub_x, sub_y, sub_w, sub_h);
//        [self protocolAttribute:NO];// 下划线
    }
    return self;
}



@end
