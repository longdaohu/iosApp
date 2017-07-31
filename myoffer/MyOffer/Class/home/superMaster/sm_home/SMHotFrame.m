//
//  SMHotFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMHotFrame.h"

@implementation SMHotFrame

+ (instancetype)frameWithHot:(SMHotModel *)hot{

    SMHotFrame *hotFrame = [[SMHotFrame alloc] init];
    hotFrame.hot = hot;
    
    return hotFrame;
}

- (void)setHot:(SMHotModel *)hot{

    _hot = hot;
    
    CGFloat Margin = 10;
    
    CGFloat icon_x = Margin;
    CGFloat icon_y = Margin;
    CGFloat icon_w = 90 * SCREEN_SCALE;
    CGFloat icon_h = icon_w * 184 / 270.0;
    self.icon_Frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
    
    
    CGFloat tag_x = icon_x + 2;
    CGFloat tag_y = icon_y + 2;
    CGFloat tag_w =  0;
    CGFloat tag_h =  0;
    self.tag_Frame = CGRectMake(tag_x, tag_y, tag_w, tag_h);
    
    if ([hot.type isEqualToString:@"offline"]) {
        
        self.play_Frame = CGRectZero;
        
    }else{
 
        CGFloat play_w =  30;
        CGFloat play_h =  play_w;
        CGFloat play_x =  icon_x + (icon_w - play_w) * 0.5;
        CGFloat play_y = icon_y + (icon_h - play_h) * 0.5;
        self.play_Frame = CGRectMake(play_x, play_y, play_w, play_h);
    }

    
    CGFloat title_x =  CGRectGetMaxX(self.icon_Frame) + Margin;
    CGFloat title_y = icon_y;
    CGFloat title_w = XSCREEN_WIDTH - title_x - Margin;
    CGSize  title_Size = [hot.main_title KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16] maxWidth:title_w];
    CGFloat title_h = title_Size.height;
    self.title_Frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    CGFloat name_x = title_x;
    CGFloat name_h = 14;
    CGFloat name_y = CGRectGetMaxY(self.icon_Frame) - name_h;
    CGFloat name_w = [hot.guest_name KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]].width;
    self.name_Frame = CGRectMake(name_x, name_y, name_w, name_h);
    
    CGFloat uni_y = name_y;
    CGFloat uni_w = [hot.guest_university KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]].width;
    CGFloat uni_h = name_h;
    CGFloat uni_x = CGRectGetMaxX(self.title_Frame) - uni_w;
    self.uni_Frame = CGRectMake(uni_x, uni_y, uni_w, uni_h);
    
    
    CGFloat b_line_x = Margin;
    CGFloat b_line_y = CGRectGetMaxY(self.icon_Frame) + Margin;
    CGFloat b_line_w = XSCREEN_WIDTH - 2 * b_line_x;
    CGFloat b_line_h = LINE_HEIGHT;
    self.bottom_line_Frame = CGRectMake(b_line_x, b_line_y, b_line_w, b_line_h);
    
    self.cell_height = b_line_h + b_line_y;
    
}

@end
