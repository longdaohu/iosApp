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

- (void)setItem:(RoomItemModel *)item{
    _item = item;
 
    self.intro_font_size = 13;
    self.tag_font_size = 14;
    CGFloat line_x = Left_Margin;
    CGFloat line_y = 0;
    CGFloat line_w = XSCREEN_WIDTH - line_x * 2;
    CGFloat line_h = 1;
    self.top_line_frame = CGRectMake(line_x, line_y, line_w, line_h);
    
    [self makeIntroductionFrame];
    [self makeFacilityFrame];
    [self makeRoomTypeFrame];
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

- (void)makeFacilityFrame{
    
 
    NSArray *items = self.item.amenities;
    
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
        
        RoomTypeItemModel *type = self.item.roomtypes[index];
        type.currency = self.item.currency;
        RoomTypeItemFrameModel *typeFrameModel = [[RoomTypeItemFrameModel alloc] init];
        typeFrameModel.item = type;
        
        [type_arr addObject:typeFrameModel];
     }
    
    
    self.typeFrames = [type_arr mutableCopy];
    self.type_cell_hight = 125;
    
}






@end
