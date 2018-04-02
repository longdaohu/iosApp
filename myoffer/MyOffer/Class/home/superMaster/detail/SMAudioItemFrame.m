//
//  SMAudioItemFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMAudioItemFrame.h"

@implementation SMAudioItemFrame

+ (instancetype)frameWitAudioItem:(SMAudioItem *)item{
    
    SMAudioItemFrame *itemFrame = [[SMAudioItemFrame alloc] init];
    
    itemFrame.item = item;
    
    return itemFrame;
}

- (void)setItem:(SMAudioItem *)item{

    _item = item;
    
    CGFloat Margin = 20;
    
    
    CGFloat play_w =  20;
    CGFloat play_h =  play_w;
    CGFloat play_x =  Margin;
    CGFloat play_y =  15;
    self.play_Frame = CGRectMake(play_x, play_y, play_w, play_h);
    
    
    CGFloat icon_x = 10;
    CGFloat icon_y = CGRectGetMaxY(self.play_Frame) + 2;
    CGFloat icon_w = 40;
    CGFloat icon_h = 14;
    self.icon_Frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
    
    
    CGFloat line_x = play_x;
    CGFloat line_y = CGRectGetMaxY(self.icon_Frame) + play_y;
    CGFloat line_w = XSCREEN_WIDTH - play_x * 2;
    CGFloat line_h = LINE_HEIGHT;
    self.bottom_line_Frame = CGRectMake(line_x, line_y, line_w, line_h);
    
    
    self.cell_height = CGRectGetMaxY(self.bottom_line_Frame);
    
    
    CGFloat name_h = 20;
    CGFloat name_x = CGRectGetMaxX(self.play_Frame) + Margin * 0.5;
    CGFloat name_w = XSCREEN_WIDTH - name_x - play_x;
    
    CGFloat time_x = name_x;
    CGFloat time_h = 16;
    CGFloat time_w = name_w;
    
    CGFloat name_y = (self.cell_height - name_h - time_h) * 0.5;
    self.name_Frame = CGRectMake(name_x, name_y, name_w, name_h);
    
    CGFloat time_y =  CGRectGetMaxY(self.name_Frame);
    self.time_Frame = CGRectMake(time_x, time_y, time_w, time_h);
    
}


@end
