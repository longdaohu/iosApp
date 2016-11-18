//
//  PipeiSectionHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PipeiSectionHeaderView.h"

@implementation PipeiSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLab = [UILabel labelWithFontsize:16 TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat titleX = PADDING_TABLEGROUP;
    CGFloat titleH = 20;
    CGFloat titleY = self.bounds.size.height - titleH - PADDING_TABLEGROUP;
    CGFloat titleW = self.bounds.size.width - titleX;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
}


@end
