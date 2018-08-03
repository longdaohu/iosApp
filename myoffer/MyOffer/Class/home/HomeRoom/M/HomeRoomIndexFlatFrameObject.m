//
//  HomeRoomIndexFlatFrameObject.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomIndexFlatFrameObject.h"

@implementation HomeRoomIndexFlatFrameObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.tag_font_size = 9;
        self.city_font_size = 9;
        self.name_font_size = 14;
        self.price_font_size = 16;
        self.margin =  10;
        self.item_width =  (XSCREEN_WIDTH - 40  - self.margin) * 0.5;

    }
    return self;
}

- (void)setItem:(HomeRoomIndexFlatsObject *)item{
    _item = item;
 
    CGFloat icon_x = 0;
    CGFloat icon_y = 0;
    CGFloat icon_w = self.item_width;
    CGFloat icon_h = 158;
    self.icon_Frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
    

    CGSize city_size = [item.city stringWithfontSize:self.city_font_size];
    CGFloat city_y = 13;
    CGFloat city_w =  city_size.width + 6;
    CGFloat city_h = city_size.height;
    CGFloat city_x =self.item_width - city_w - 13;
    self.city_frame = CGRectMake(city_x, city_y, city_w, city_h);
 
    
            CGFloat tag_x = 0;
            CGFloat tag_h = 15;
            CGFloat tag_y =  CGRectGetMaxY(self.icon_Frame) + 5;
            if (self.isHorizontal) {
                tag_x = self.item_width;
                tag_y = self.item_height - tag_h;
            }
            CGFloat tag_w = 0;
            NSMutableArray *tag_temp = [NSMutableArray array];
            for (NSInteger index  = 0; index < 2 ; index++) {
                
                if (index >= item.feature.count) {
                    [tag_temp addObject:[NSValue valueWithCGRect:CGRectZero]];
                    continue;
                }
                
                NSString *tag = item.feature[index];
                CGSize tag_size = [tag stringWithfontSize:self.tag_font_size];
                tag_w = (tag_size.width + 10);
                if (self.isHorizontal) {
                    tag_x -= tag_w;
                }
                CGRect tag_f = CGRectMake(tag_x, tag_y, tag_w, tag_h);
                [tag_temp addObject:[NSValue valueWithCGRect:tag_f]];
                if (self.isHorizontal) {
                    tag_x -= 10;
                }else{
                    tag_x += (tag_w + 10);
                }
            }
            self.tag_frames = [tag_temp mutableCopy];
    
    
            CGFloat title_x = 0;
            CGFloat title_w = icon_w;
            CGFloat title_y = tag_y + tag_h + 2;
            CGFloat title_h = [item.name sizeWithfontSize:self.name_font_size maxWidth:title_w].height;
            UIFont *title_font = XFONT(self.name_font_size);
            if (title_h > title_font.lineHeight * 2) {
                title_h = title_font.lineHeight * 2;
            }
    
            if (self.item.feature.count == 0) {
                title_y = CGRectGetMaxY(self.icon_Frame) + 5;
            }
    
            if (self.isHorizontal) {
                   title_y = CGRectGetMaxY(self.icon_Frame)+ 2;
            }
            self.name_frame = CGRectMake(title_x, title_y, title_w, title_h);
 
            CGFloat price_x = 0;
            CGFloat price_h = 20;
            CGFloat price_y = CGRectGetMaxY(self.name_frame) + 2;
            CGFloat price_w = icon_w;
            if (self.isHorizontal) {
                price_y = self.item_height - price_h;
            }
            self.price_frame = CGRectMake(price_x, price_y, price_w, price_h);
 
            self.item_height  = CGRectGetMaxY(self.price_frame);
    
    
}

@end


/*
 
 

CGFloat price_x = 0;
CGFloat price_h = 20;
CGFloat price_y = content_size.height - price_h;
CGFloat price_w = icon_w;
self.priceLab.frame = CGRectMake(price_x, price_y, price_w, price_h);

CGFloat wifi_w = [self.wifiLab.text stringWithfontSize:9].width;
if (wifi_w > 0) {
    wifi_w += 10;
}
CGFloat wifi_h = 15;
CGFloat wifi_x = icon_w - wifi_w;
CGFloat wifi_y =  content_size.height - wifi_h;
self.wifiLab.frame = CGRectMake(wifi_x, wifi_y, wifi_w, wifi_h);

CGFloat tag_w = [self.tagLab.text stringWithfontSize:9].width;
if (tag_w > 0) {
    tag_w += 10;
}
CGFloat tag_x = wifi_x - 10 - tag_w;
if (wifi_w == 0) {
    tag_x += wifi_x;
}
CGFloat tag_y = wifi_y;
CGFloat tag_h = wifi_h;
self.tagLab.frame = CGRectMake(tag_x, tag_y, tag_w, tag_h);
*/


