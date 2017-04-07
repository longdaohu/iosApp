//
//  ServiceItemCellFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceItemCellFrame.h"

@interface ServiceItemCellFrame ()
@property(nonatomic,assign)CGFloat maxWidth;
@property(nonatomic,assign)CGFloat cell_Top;
@end

@implementation ServiceItemCellFrame

+ (instancetype)cellWithAttribute:(ServiceItemAttribute *)attribute maxWidth:(CGFloat)maxWidth cellTop:(CGFloat)cell_Top{

    ServiceItemCellFrame *item = [[ServiceItemCellFrame alloc] init];
    
    item.maxWidth = maxWidth;
    
    item.cell_Top = cell_Top;
    
    item.attribute = attribute;
    
    return item;
}



- (void)setAttribute:(ServiceItemAttribute *)attribute{

    _attribute = attribute;
    
    CGFloat margin_big = 15;
    CGFloat margin_min = 10;
    
    CGFloat title_X = 0;
    CGFloat title_Y = margin_big;
    CGFloat title_W = self.maxWidth;
    CGFloat title_H = 20;
    CGRect title_frame = CGRectMake(title_X, title_Y, title_W, title_H);
    self.title_frame = [NSValue valueWithCGRect:title_frame];

    
    self.cell_items_frames  =  [self frameWithOptions:attribute.options];
    
    CGFloat itemBg_X = 0;
    CGFloat itemBg_Y = CGRectGetMaxY(title_frame) + margin_min;
    CGFloat itemBg_W = title_W;
    CGFloat itemBg_H = 0;
    
    if (self.cell_items_frames.count > 0) {
        
        NSValue *lastItem_frame = self.cell_items_frames.lastObject;
        itemBg_H = CGRectGetMaxY(lastItem_frame.CGRectValue);
     }
    
    CGRect  itemBg_frame = CGRectMake(itemBg_X, itemBg_Y, itemBg_W, itemBg_H);
    self.itemBg_frame = [NSValue valueWithCGRect:itemBg_frame];
    
    
    CGFloat cell_X = 0;
    CGFloat cell_Y = self.cell_Top;
    CGFloat cell_W = title_W;
    CGFloat cell_H = CGRectGetMaxY(itemBg_frame) + margin_big;
    CGRect cell_frame = CGRectMake(cell_X, cell_Y, cell_W, cell_H);
    self.cell_frame = [NSValue valueWithCGRect:cell_frame];
    
    
}


- (NSArray *)frameWithOptions:(NSArray *)options{
    
    NSMutableArray *temp_Arr = [NSMutableArray array];
    
    //第一个 label的起点
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat itemW = 0;
    CGFloat itemH = 40;
    //间距
    CGFloat padding = 10.0;
    
    CGFloat MAXWidth = self.maxWidth;
    
    CGFloat MinWidth =  self.maxWidth * 0.25;
    
    for (int i = 0; i < options.count; i ++) {
        
        
        NSDictionary *option = options[i];
        
        itemW = [option[@"value"]  KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16]].width + padding;
        
        itemW = itemW <  MinWidth ? MinWidth : itemW;
        
        itemW = itemW > MAXWidth ? MAXWidth : itemW;
        
        if (MAXWidth - itemX < itemW) {
            
            itemY += (itemH + padding);
            
            itemX = 0;
        }
        
        CGRect  optionFrame =  CGRectMake(itemX, itemY, itemW, itemH);
        
        [temp_Arr addObject:[NSValue valueWithCGRect:optionFrame]];
        
        itemX += (itemW + padding);   //起点 增加
        
    }
    
    
    return  [temp_Arr copy];
}



@end
