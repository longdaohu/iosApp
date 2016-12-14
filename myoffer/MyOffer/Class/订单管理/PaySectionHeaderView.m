//
//  PaySectionHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PaySectionHeaderView.h"
@interface PaySectionHeaderView ()
@property(nonatomic,strong)UILabel *titleLab;
@end

@implementation PaySectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = XCOLOR_WHITE;
        
        self.titleLab =[UILabel labelWithFontsize:15 TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.titleLab.frame = CGRectMake(10, 0, XSCREEN_WIDTH, self.bounds.size.height);
        self.titleLab.text = @"选择支付方式";
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}


@end
