//
//  RankTypeItemFrame.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "RankTypeItemFrame.h"

@implementation RankTypeItemFrame


- (void)setItem:(RankTypeItem *)item{
    
    _item = item;
    
//    CGFloat  logow = 90 * SCREEN_SCALE;
//    CGFloat icon_W =  80 + XFONT_SIZE(1) * 5;
    
    CGFloat  margin  = 10;
    CGFloat  cell_w  = XSCREEN_WIDTH;
    
    CGFloat  icon_x = margin * 0.5;
    CGFloat  icon_y = icon_x;
    CGFloat  icon_w = 80;
    CGFloat  icon_h = icon_w;
    self.icon_frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
    
    CGFloat  bg_x =  margin;
    CGFloat  bg_y =  margin * 0.5;
    CGFloat  bg_w =  cell_w - 2 *  bg_x;
    CGFloat  bg_h =  icon_h  + icon_y * 2;
    self.bg_frame =  CGRectMake(bg_x, bg_y, bg_w, bg_h);
    
    self.bgimage_frame = CGRectMake(0, 0, bg_w, bg_h);
    
    CGFloat  cn_x =  margin + icon_w + icon_x;
    CGFloat  cn_y = icon_y;
    CGFloat  cn_w = bg_w - cn_x - margin;
    CGSize  cn_size = [item.name KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]];
    CGFloat  cn_h = cn_size.width> cn_w ? icon_h *  0.5 : icon_h *  0.25 ;
    self.cn_frame = CGRectMake(cn_x, cn_y, cn_w, cn_h);
    
    CGFloat  en_x = cn_x;
    CGFloat  en_y =  cn_y + icon_h * 0.5;
    CGFloat  en_w = cn_w;
    CGSize   en_size = [item.name_en KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]];
    CGFloat  en_h = en_size.width> en_w ? icon_h *  0.5 : icon_h *  0.25 ;
    self.en_frame = CGRectMake(en_x, en_y, en_w, en_h);
    
    CGFloat cell_h =  bg_h + bg_y * 2;
    
    self.cell_frame = CGRectMake(0, 0, cell_w, cell_h);
    
}

@end



