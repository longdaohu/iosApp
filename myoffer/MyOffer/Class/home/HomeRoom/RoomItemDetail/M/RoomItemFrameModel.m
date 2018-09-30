//
//  RoomItemFrameModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemFrameModel.h"
#import "RoomTypeItemModel.h"
#import "RoomTypeItemFrameModel.h"

static const CGFloat Left_Margin = 20;
static const CGFloat Bottom_Margin = 30;
static const CGFloat Top_Margin = 30;

@implementation RoomItemFrameModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.intro_font_size = 13;
        self.promotion_font_size = 13;
        self.process_font_size = 13;
        self.tag_font_size = 14;
        self.header_title_font_size = 18;
        self.header_price_font_size = 22;
        self.header_unit_font_size = 11;
        self.header_unit_font_size = 11;
        self.header_id_font_size = 11;
        self.header_address_font_size = 12;
    }
    return self;
}

- (NSMutableArray *)groups{
    
    if (!_groups) {
        
        _groups = [NSMutableArray array];
        
        myofferGroupModel *promotion = [myofferGroupModel groupWithItems:nil header:@"优惠活动"];
        promotion.type = SectionGroupTypeRoomDetailPromotion;
        if (self.item.process.length > 0) {
            promotion.items = @[self.item.promotion];
            promotion.cell_height_set = self.promotion_cell_hight;
            [_groups addObject:promotion];
         }
        
        myofferGroupModel *type = [myofferGroupModel groupWithItems:nil header:@"房间类型"];
        type.type = SectionGroupTypeRoomDetailRoomType;
        if(self.typeFrames.count > 0 ){
            type.items = self.typeFrames;
            type.cell_height_set = self.type_cell_hight;
            [_groups addObject:type];
        }
        
        myofferGroupModel *intro = [myofferGroupModel groupWithItems:nil header:@"公寓介绍"];
        intro.type  = SectionGroupTypeRoomDetailTypeIntroduction;
        if (self.item.intro.length > 0) {
            intro.items = @[self.item.intro];
            intro.cell_height_set = self.intro_cell_hight;
            [_groups addObject:intro];
        }
 
        myofferGroupModel *facilities = [myofferGroupModel groupWithItems:nil header:@"公寓设施"];
        facilities.type = SectionGroupTypeRoomDetailTypeFacility;
        if(self.item.ameniti_arr.count > 0 ){
            facilities.items = @[self.item.ameniti_arr];
            facilities.cell_height_set = self.faciliti_cell_hight;
            [_groups addObject:facilities];
        }
 
        myofferGroupModel *process = [myofferGroupModel groupWithItems:nil header:@"预订须知"];
        process.type = SectionGroupTypeRoomDetailTypeProcess;
        if(self.item.process.length > 0 ){
            process.items = @[self.item.process];
            process.cell_height_set = self.process_cell_hight;
            [_groups addObject:process];
        }
   
    }
    
    return  _groups;
}


- (void)setItem:(RoomItemModel *)item{
    _item = item;
    
    for (RoomTypeItemModel *sp  in item.roomtypes) {
        for (RoomTypeBookItemModel *sn in sp.prices) {
            sn.currency = item.currency;
            sn.unit = item.unit;
         }
    }
 
    CGFloat line_x = Left_Margin;
    CGFloat line_y = 0;
    CGFloat line_w = XSCREEN_WIDTH - line_x * 2;
    CGFloat line_h = LINE_HEIGHT;
    self.top_line_frame = CGRectMake(line_x, line_y, line_w, line_h);
 
 
    [self makeRoomHeaderFrame];
    //优惠
    [self makePromotionFrame];
    //房子类型
    [self makeRoomTypeFrame];
    //公寓介绍
    [self makeIntroductionFrame];
    //公寓设施
    [self makeFacilityFrame];
    //需知
    [self makeProcessFrame];
}

- (void)makeIntroductionFrame{
    
    CGFloat intr_x = Left_Margin;
    CGFloat intr_y = Top_Margin;
    CGFloat intr_h = 0;
    CGFloat intr_w = XSCREEN_WIDTH - 2 * intr_x;
    CGSize intr_size = [self.item.intro sizeWithfontSize:self.intro_font_size maxWidth:intr_w];
    intr_h = intr_size.height;
    
    self.intro_frame = CGRectMake(intr_x, intr_y, intr_w, intr_h);
    self.intro_cell_hight = CGRectGetMaxY(self.intro_frame) + Bottom_Margin;
    
}

- (void)makeProcessFrame{
 
    CGFloat process_x = Left_Margin;
    CGFloat process_y = Top_Margin;
    CGFloat process_h = 0;
    CGFloat process_w = XSCREEN_WIDTH - 2 * process_x;
    CGSize process_size = [self.item.process sizeWithfontSize:self.process_font_size maxWidth:process_w];
    process_h = process_size.height;
 
    self.process_frame = CGRectMake(process_x, process_y, process_w, process_h);
    self.process_cell_hight = CGRectGetMaxY(self.process_frame) + Bottom_Margin;
    
}

- (void)makePromotionFrame{
 
    CGFloat sp_x = Left_Margin;
    CGFloat sp_y = Top_Margin;
    CGFloat sp_w = 6;
    CGFloat sp_h = 20;
    self.promotion_spod_frame = CGRectMake(sp_x, sp_y, sp_w, sp_h);
 
    CGFloat intr_x = CGRectGetMaxX(self.promotion_spod_frame) + 6;
    CGFloat intr_y = Top_Margin;
    CGFloat intr_h = 0;
    CGFloat intr_w = XSCREEN_WIDTH - 2 * intr_x;
    CGSize intr_size = [self.item.promotion sizeWithfontSize:self.promotion_font_size maxWidth:intr_w];
    intr_h = intr_size.height;
    
    self.promotion_frame = CGRectMake(intr_x, intr_y, intr_w, intr_h);
    self.promotion_cell_hight = CGRectGetMaxY(self.promotion_frame) + Bottom_Margin;
}

- (void)makeFacilityFrame{
    
 
    NSArray *items = self.item.ameniti_arr;
    NSMutableArray *temps =[NSMutableArray array];
    //第一个 label的起点
    CGSize startSize = CGSizeMake(0, 0);
    //间距
    CGFloat padding = 10.0;
    CGFloat item_height = 25.0;
    CGFloat MAXWidth = XSCREEN_WIDTH - 2 * Left_Margin;
    for (int i = 0; i < items.count; i ++) {
        
        CGFloat keyWordWidth = [items[i] KD_sizeWithAttributeFont:[UIFont systemFontOfSize:self.tag_font_size]].width +15;
        
        if (keyWordWidth > MAXWidth) {
            keyWordWidth = MAXWidth;
        }
        
        if (MAXWidth - startSize.width < keyWordWidth) {
            
            startSize.height +=  (item_height + padding);
            startSize.width = 0;
        }
        
        CGRect itemRect = CGRectMake(startSize.width, startSize.height, keyWordWidth, item_height);
        [temps addObject:[NSNumber valueWithCGRect:itemRect]];
        //起点 增加
        startSize.width += keyWordWidth + padding;
    }
    
    self.tagFrames = [temps copy];
    
    if (items.count) {
        startSize.height +=35;
    }
    
    CGFloat box_x = Left_Margin;
    CGFloat box_y = Bottom_Margin;
    CGFloat box_h = startSize.height - padding;
    CGFloat box_w = MAXWidth;
    self.tag_box_frame = CGRectMake(box_x, box_y, box_w, box_h);
    
    self.faciliti_cell_hight = CGRectGetMaxY(self.tag_box_frame) + Bottom_Margin;
    
}

- (void)makeRoomTypeFrame{
 
    
    NSMutableArray *type_arr = [NSMutableArray array];
    for (NSInteger index = 0; index < self.item.roomtypes.count; index++) {
 
        RoomTypeItemFrameModel *typeFrameModel = [[RoomTypeItemFrameModel alloc] init];
        typeFrameModel.item = self.item.roomtypes[index];
        [type_arr addObject:typeFrameModel];
     }
    
    
    self.typeFrames = [type_arr mutableCopy];
    self.type_cell_hight = 125;
    
}

- (void)makeRoomHeaderFrame{
    
    
    CGFloat cross_x = 0;
    CGFloat cross_y = 0;
    CGFloat cross_w = XSCREEN_WIDTH;
    CGFloat cross_h = cross_w;
    self.cross_frame = CGRectMake(cross_x, cross_y, cross_w, cross_h);
    
    
    CGFloat up = 40;
    CGFloat box_x = Left_Margin;
    CGFloat box_y = cross_h - up;
    if (self.item.imageURLs.count ==  0) {
        box_y = 0;
    }
    CGFloat box_w = XSCREEN_WIDTH - 2 * box_x;
    CGFloat box_h = 0;
 
    CGFloat title_x = Left_Margin;
    CGFloat title_y = 20;
    CGFloat title_w = box_w - 2 * title_x;
    CGSize title_size = [self.item.name sizeWithfontSize:self.header_title_font_size maxWidth:title_w];
    CGFloat title_h = title_size.height;
    self.title_frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    CGFloat tag_x = Left_Margin;
    CGFloat tag_y = CGRectGetMaxY(self.title_frame) + 12;
    CGFloat tag_h = 0;
    CGFloat tag_w = 0;
    CGFloat padding = 10;
    NSMutableArray *tag_arr = [NSMutableArray array];
    for (NSInteger index = 0; index < self.item.feature.count; index++) {
        
        NSString *tag = self.item.feature[index];
        CGSize tag_size = [tag stringWithfontSize:self.tag_font_size];
        tag_w = tag_size.width + padding;
        tag_h = tag_size.height + 6;
        if (tag_w + tag_x > title_w) {
            tag_w = 0;
        }
        
        NSValue *tag_value = [NSValue valueWithCGRect:CGRectMake(tag_x, tag_y, tag_w, tag_h)];
        [tag_arr addObject:tag_value];
        tag_x += (tag_w + padding);
    }
    self.headerTagFrames = [tag_arr mutableCopy];
    
    CGFloat price_x = title_x;
    CGFloat price_y = tag_y + tag_h + 15;
    if (self.item.feature.count == 0) {
        price_y = tag_y ;
    }
    CGSize price_size = [self.item.price stringWithfontSize:self.header_price_font_size];
    CGFloat price_w = price_size.width + 6;
    CGFloat price_h = price_size.height;
    self.price_frame = CGRectMake(price_x, price_y, price_w, price_h);
    
    CGFloat unit_x  = CGRectGetMaxX(self.price_frame) + 5;
    CGSize unit_size = [self.item.unit stringWithfontSize:self.header_unit_font_size];
    CGFloat unit_w  = unit_size.width;
    CGFloat unit_h  = unit_size.height;
    CGFloat unit_y  = price_y + price_h - unit_h-3;
    self.unit_frame = CGRectMake(unit_x, unit_y, unit_w, unit_h);
    
    CGFloat id_x = title_x;
    CGFloat id_y = unit_y;
    CGFloat id_w = title_w;
    CGFloat id_h = unit_h;
    self.id_frame = CGRectMake(id_x, id_y, id_w, id_h);
    
    CGFloat line_x = title_x;
    CGFloat line_y = CGRectGetMaxY(self.price_frame) + 20;
    CGFloat line_w = title_w;
    CGFloat line_h = LINE_HEIGHT;
    self.line_frame = CGRectMake(line_x, line_y, line_w, line_h);
 
    
    CGFloat add_x  = title_x;
    CGSize  add_size = [self.item.address sizeWithfontSize:self.header_address_font_size maxWidth:line_w];
    CGFloat add_w  = add_size.width;
    CGFloat add_h  = add_size.height;
    CGFloat add_y  =  CGRectGetMaxY(self.line_frame) + 20;
    self.address_frame = CGRectMake(add_x, add_y, add_w, add_h);
 
    CGFloat map_x  = title_x;
    CGFloat map_w  = title_w;
    CGFloat map_h  = 80;
    CGFloat map_y  =  CGRectGetMaxY(self.address_frame) + 5;
    self.map_frame = CGRectMake(map_x, map_y, map_w, map_h);
    
    box_h = CGRectGetMaxY(self.map_frame) + 20;
    self.header_box_frame = CGRectMake(box_x, box_y, box_w, box_h);
 
    
    CGFloat bg_x = 0;
    CGFloat bg_y = cross_h;
    CGFloat bg_w = XSCREEN_WIDTH;
    CGFloat bg_h = box_h - 20;
    self.header_bg_frame = CGRectMake(bg_x, bg_y, bg_w, bg_h);
    
    CGFloat h_x = 0;
    CGFloat h_y = 0;
    CGFloat h_w = bg_w;
    CGFloat h_h = CGRectGetMaxY(self.header_bg_frame);
    self.header_frame = CGRectMake(h_x, h_y, h_w, h_h);
 
    CGFloat count_w = 50;
    CGFloat count_x = box_w + box_x - count_w;
    CGFloat count_y = box_y - up;
    CGFloat count_h = 20;
    self.count_frame = CGRectMake(count_x, count_y, count_w, count_h);
    
}


@end
