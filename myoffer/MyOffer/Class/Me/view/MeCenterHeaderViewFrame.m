//
//  MeCenterHeaderViewFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MeCenterHeaderViewFrame.h"

@implementation MeCenterHeaderViewFrame

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CGFloat item_Width = XSCREEN_WIDTH / 3;
        
        self.item_Width = item_Width;
        
        CGFloat icon_X = 0;
        CGFloat icon_Y = 0;
        CGFloat icon_W = item_Width;
        CGFloat icon_H = 34;
        
        CGFloat titleX = 0;
        CGFloat titleY = icon_H + XFONT_SIZE(11);
        CGFloat titleW = icon_W;
        CGFloat titleH = XFONT_SIZE(18);
        
        CGFloat countX = 0;
        CGFloat countY = titleY + titleH + 2;
        CGFloat countW = icon_W;
        CGFloat countH = XFONT_SIZE(14);
        
        
        CGFloat margin = XPERCENT * 17;
        icon_Y += margin;
        self.icon_frame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);
        
        titleY  += margin;
        self.title_frame = CGRectMake(titleX, titleY, titleW, titleH);
        
        countY += margin;
        self.count_frame = CGRectMake(countX, countY, countW, countH);
        
        self.section_Height = countH + countY + margin;
        
        
    }
    return self;
}



@end
