//
//  XliusectionView.m
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "XliusectionView.h"

@implementation XliusectionView

+(instancetype)sectionView
{
    return [[XliusectionView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, 0)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLab =[[UILabel alloc] init];
        self.titleLab = titleLab;
        titleLab.font  = FontWithSize(FONTSIZE(15));
        [self addSubview:titleLab];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat titleX = 10;
    CGFloat titleY = 0;
    CGFloat titleW = XScreenWidth - titleX;
    CGFloat titleH = self.bounds.size.height;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
}

@end
