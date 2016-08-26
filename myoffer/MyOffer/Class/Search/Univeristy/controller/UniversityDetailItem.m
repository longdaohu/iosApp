//
//  UniversityDetailItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityDetailItem.h"

@implementation UniversityDetailItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *tilteLab = [UILabel labelWithFontsize:XPERCENT * 12 TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentCenter];
        [self addSubview:tilteLab];
        self.titleLab = tilteLab;

        UILabel *subLab  = [UILabel labelWithFontsize:XPERCENT * 13 TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentCenter];
        [self addSubview:subLab];
        self.subtitleLab = subLab;

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize itemSize = self.bounds.size;
    
    CGFloat iconX = 0;
    CGFloat iconY = 0;
    CGFloat iconW = itemSize.width;
    CGFloat iconH = itemSize.height * 0.4;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat titleX = 0;
    CGFloat titleY = CGRectGetMaxY(self.iconView.frame) + 3;
    CGFloat titleW = itemSize.width;
    CGFloat titleH = XPERCENT * 12;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    

    CGFloat subX = 0;
    CGFloat subY = CGRectGetMaxY(self.titleLab.frame) + 3;
    CGFloat subW = itemSize.width;
    CGFloat subH =  XPERCENT * 13;
    self.subtitleLab.frame = CGRectMake(subX, subY, subW, subH);
    
}

+ (instancetype)ViewWithImage:(NSString *)imageName title:(NSString *)titleName subtitle:(NSString *)subName
{

    UniversityDetailItem *item = [[UniversityDetailItem alloc] init];
    item.iconView.image = [UIImage imageNamed:imageName];
    item.titleLab.text = titleName;
    item.subtitleLab.text = subName;
    
    return item;
}


@end
