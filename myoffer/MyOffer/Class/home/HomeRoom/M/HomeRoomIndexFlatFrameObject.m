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
        self.city_font_size = 10;
        self.name_font_size = 14;
        self.price_font_size = 16;
        self.margin =  10;

    }
    return self;
}

- (void)setItem:(HomeRoomIndexFlatsObject *)item{
    _item = item;
 
    //图片
    CGFloat icon_x = 0;
    CGFloat icon_y = 0;
    CGFloat icon_w = self.item_width;
    CGFloat icon_h = 158;
    switch (self.type) {
        case HomeRoomIndexFlatTypeVertical:
        {
            icon_x = 20;
            icon_h = self.item_height;
            icon_w = icon_h;
        }
            break;
        default:
            break;
    }
    self.icon_Frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);

    //城市
    CGSize city_size = [item.city stringWithfontSize:self.city_font_size];
    CGFloat city_y = 13;
    CGFloat city_w =  city_size.width + 10;
    CGFloat city_h = city_size.height + 4;
    CGFloat city_x =self.item_width - city_w - 13;
    self.city_frame = CGRectMake(city_x, city_y, city_w, city_h);
    
    //标题
    CGFloat title_x = 0;
    CGFloat title_y = 0;//tag_y + tag_h + 2;
    CGFloat title_w = icon_w;
    CGFloat title_h = [item.name sizeWithfontSize:self.name_font_size maxWidth:title_w].height;
    UIFont *title_font = XFONT(self.name_font_size);
    if (title_h > title_font.lineHeight * 2) {
        title_h = title_font.lineHeight * 2;
    }
    switch (self.type) {
        case HomeRoomIndexFlatTypeHorizontal:
        {
            title_y = CGRectGetMaxY(self.icon_Frame)+ 2;
        }
            break;
        case HomeRoomIndexFlatTypeVertical:{
            title_x = CGRectGetMaxX(self.icon_Frame) + 10;
            title_w = self.item_width - title_x - icon_x;
            title_h = [item.name sizeWithfontSize:self.name_font_size maxWidth:title_w].height;
        }
            break;
        default:
            break;
    }
    self.name_frame = CGRectMake(title_x, title_y, title_w, title_h);
 
    //标签
    CGFloat tag_x = 0;
    CGFloat tag_h = 15;
    CGFloat tag_y =  CGRectGetMaxY(self.icon_Frame) + 5;
    switch (self.type) {
        case HomeRoomIndexFlatTypeHorizontal:
        { //公寓推荐
            tag_x = self.item_width;
            tag_y = self.item_height - tag_h;
        }
            break;
        case HomeRoomIndexFlatTypeVertical:
        {//地图
            
        }
            break;
        default:
            break;
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
        switch (self.type) {
            case HomeRoomIndexFlatTypeHorizontal:
            {
                tag_x -= tag_w;
            }
                break;
            case HomeRoomIndexFlatTypeVertical:
            {
                
            }
                break;
            default:
                break;
        }
                
        CGRect tag_f = CGRectMake(tag_x, tag_y, tag_w, tag_h);
        [tag_temp addObject:[NSValue valueWithCGRect:tag_f]];
        switch (self.type) {
            case HomeRoomIndexFlatTypeHorizontal:
            {
                tag_x -= 10;
            }
                break;
            case HomeRoomIndexFlatTypeVertical:
            {
                
            }
                break;
            default:{
                tag_x += (tag_w + 10);
            }
                break;
        }
        
    }
   self.tag_frames = [tag_temp mutableCopy];
    
    //修改标题  精选民宿
    if (self.type == HomeRoomIndexFlatTypeDefault) {
        title_y = tag_y + tag_h + 2;
        if (self.item.feature.count == 0) {
            title_y = CGRectGetMaxY(self.icon_Frame) + 5;
        }
        self.name_frame = CGRectMake(title_x, title_y, title_w, title_h);
    }
 
            //价格
            CGFloat price_x = 0;
            CGFloat price_h = 20;
            CGFloat price_y = CGRectGetMaxY(self.name_frame) + 2;
            CGFloat price_w = icon_w;
            switch (self.type) {
                case HomeRoomIndexFlatTypeHorizontal:
                {
                    price_y = self.item_height - price_h;
                }
                    break;
                case HomeRoomIndexFlatTypeVertical:
                {
                    
                }
                    break;
                default:
                    break;
            }
            self.price_frame = CGRectMake(price_x, price_y, price_w, price_h);
 
            self.item_height  = CGRectGetMaxY(self.price_frame);
 
}

@end



