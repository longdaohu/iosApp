//
//  MyOfferServiceMallHeaderFrame.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/5.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferServiceMallHeaderFrame.h"
#define AutoScroll_Height   AdjustF(160.f)

@implementation MyOfferServiceMallHeaderFrame

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        CGFloat margin = 10;
        
        CGFloat auto_X = 0;
        CGFloat auto_Y = 0;
        CGFloat auto_W = XSCREEN_WIDTH;
        CGFloat auto_H = AutoScroll_Height;
        self.autoScroller_frame = CGRectMake(auto_X, auto_Y, auto_W, auto_H);
        
        
        CGFloat icon_X = 0;
        CGFloat icon_Y = 0;
        CGFloat icon_W = XSCREEN_WIDTH / 3;
        CGFloat icon_H = 45 + XFONT_SIZE(1) * 15;
        self.icon_frame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);
        
        CGFloat titleX = 0;
        CGFloat titleY = CGRectGetMaxY(self.icon_frame) + margin;
        CGFloat titleW = icon_W;
        CGFloat titleH = 14;
        self.title_frame = CGRectMake(titleX, titleY, titleW, titleH);
        
        
        CGFloat item_W = XSCREEN_WIDTH / 3;
        CGFloat item_H = CGRectGetMaxY(self.title_frame) + margin;
        CGFloat item_Y  =  0;
        NSMutableArray *temps = [NSMutableArray array];
        for (NSInteger index = 0; index < 3; index++) {
            
            CGFloat item_X  =  (index % 3) * item_W;
            CGRect itemRect  = CGRectMake(item_X, item_Y, item_W, item_H);
            [temps addObject:[NSValue valueWithCGRect:itemRect]];
            
        }
        self.headerItem_frames = [temps copy];
        
        
        CGFloat down_X = 0;
        CGFloat down_Y = CGRectGetMaxY(self.autoScroller_frame) + margin;
        CGFloat down_W = auto_W;
        CGFloat down_H = item_H;
        self.downView_frame = CGRectMake(down_X, down_Y, down_W, down_H);
        
        
        self.header_frame = CGRectMake(0, 0, XSCREEN_WIDTH,  CGRectGetMaxY(self.downView_frame));
        
        self.bottom_line_frame = CGRectMake(0, CGRectGetMaxY(self.downView_frame) - 1, XSCREEN_WIDTH, 1);
        
    }
    
    return self;
}


@end
