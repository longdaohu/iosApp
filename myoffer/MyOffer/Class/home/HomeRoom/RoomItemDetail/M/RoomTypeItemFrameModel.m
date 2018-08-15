//
//  RoomTypeItemFrameModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomTypeItemFrameModel.h"

@implementation RoomTypeItemFrameModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.tag_font_size = 10;
        self.price_font_size = 16;
        self.unit_font_size = 14;
        self.pin_font_size = 10;
        self.title_font_size = 14;
 
    }
    return self;
}

- (void)setItem:(RoomTypeItemModel *)item{
    _item = item;
 
    
    CGFloat padding = 10;
    CGFloat left_margin = 20;
    CGFloat width_max = XSCREEN_WIDTH - left_margin * 2;

    CGFloat icon_x = 20;
    CGFloat icon_y = 10;
    CGFloat icon_w = 100;
    CGFloat icon_h = icon_w;
    self.icon_frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
    
    CGFloat title_x = CGRectGetMaxX(self.icon_frame) + padding;
    CGFloat title_y = icon_y;
    CGFloat title_w = XSCREEN_WIDTH - title_x - left_margin;
    CGFloat title_h = [item.name sizeWithfontSize:self.title_font_size maxWidth:title_w].height;
    UIFont *title_font = XFONT(self.title_font_size);
    if (title_h > title_font.lineHeight * 2) {
        title_h = title_font.lineHeight * 2;
    }
    self.title_frame = CGRectMake(title_x, title_y, title_w, title_h);
 
 
    NSLog(@"RoomTypeItemFrameModel  =  [%@]",self.item.firstPrice.priceCurrency);
    CGFloat price_x = title_x;
    CGSize price_size = [self.item.firstPrice.priceCurrency stringWithfontSize:self.price_font_size];
    CGFloat price_h = price_size.height;
    CGFloat price_w = price_size.width;
    CGFloat price_y = CGRectGetMaxY(self.icon_frame) - price_h;
    self.price_frame = CGRectMake(price_x, price_y, price_w, price_h);
    
    CGSize  unit_size = [self.item.firstPrice.priceCurrency stringWithfontSize:self.unit_font_size];
    CGFloat unit_w = unit_size.width;
    CGFloat unit_h = unit_size.height;
    CGFloat unit_x = CGRectGetMaxX(self.price_frame)+5;
    CGFloat unit_y = CGRectGetMaxY(self.icon_frame) - unit_h;
    self.unit_frame = CGRectMake(unit_x, unit_y, unit_w,unit_h);
    
    CGFloat pin_w = 55;
    CGFloat pin_h = 18;
    CGFloat pin_x = left_margin + width_max - pin_w;
    CGFloat pin_y = CGRectGetMaxY(self.icon_frame) - pin_h;
    self.pin_frame = CGRectMake(pin_x, pin_y, pin_w, pin_h);
    
    CGFloat line_x = left_margin;
    CGFloat line_y = 0;
    CGFloat line_h = 1;
    CGFloat line_w = width_max;
    self.line_frame = CGRectMake(line_x, line_y, line_w, line_h);
}

@end
