//
//  filterContentFrame.m
//  myOffer
//
//  Created by sara on 16/5/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//



#import "FilterContentFrame.h"

@interface FilterContentFrame ()<NSCopying>
@property(nonatomic,assign)CGFloat originCellHeight;
@end

@implementation FilterContentFrame
+ (instancetype)filterFrameWithFilter:(FiltContent *)filter{

    FilterContentFrame *filerFrame = [[FilterContentFrame alloc] init];
    
    filerFrame.filter = filter;
    
    return filerFrame;
}

- (void)setFilter:(FiltContent *)filter{

    _filter = filter;
    
    
    CGSize titleSize = [filter.title KD_sizeWithAttributeFont:FontWithSize(16)];
    
    CGFloat logoX  = 15;
    CGFloat logoY  = 15;
    CGFloat logoW  = filter.icon.length > 0 ? 30 : 0;
    CGFloat logoH  = titleSize.height;
    self.iconFrame = CGRectMake(logoX, logoY, logoW, logoH);
    
    
    CGFloat titleX = CGRectGetMaxX(self.iconFrame);
    CGFloat titleY = 15;
    CGFloat titleW = titleSize.width;
    CGFloat titleH = 20;
    self.titleFrame  = CGRectMake(titleX,titleY,titleW, titleH);
    
    CGFloat detailX = CGRectGetMaxX(self.titleFrame)+5;
    CGFloat detailY = titleY;
    CGFloat detailW = XSCREEN_WIDTH - detailX - 60;
    CGFloat detailH = 20;
    self.subtitleFrame = CGRectMake(detailX,detailY,detailW, detailH);
    
    CGFloat upX = CGRectGetMaxX(self.subtitleFrame);
    CGFloat upY = 0;
    CGFloat upW = 60;
    CGFloat upH = 50;
    self.upFrame = CGRectMake(upX, upY, upW, upH);
    
    [self makeButtonItems:filter.optionItems];
  
 
    
}

//- (void)setOptionItems:(NSArray *)optionItems{
//
//    _optionItems = optionItems;
//    
//    [self makeButtonItems:optionItems];
//}


-(void)setCellState:(FilterCellState)cellState
{
    _cellState = cellState;
    
    switch (cellState) {
        case FilterCellStateRealHeight:
        {    //状态为0时，cell显示原始高度
            self.cellHeigh = self.originCellHeight;
        }
            break;
        case FilterCellStateBaseHeight:
        {   //状态为1时，cell显示高度50
            self.cellHeigh = 50;
        }
            break;
        case FilterCellStateHeightZero:
        {  //状态为2时，cell显示高度为0
            self.cellHeigh = 0;
        }
            break;
            
        default:
            break;
    }
}

-(void)makeButtonItems:(NSArray *)items
{
    
    NSMutableArray *temps =[NSMutableArray array];
    
    //第一个 label的起点
    CGSize startSize = CGSizeMake(0, 0);
    //间距
    CGFloat padding = 10.0;
    
    CGFloat MAXWidth = [UIScreen  mainScreen].bounds.size.width - 30;
    
    for (int i = 0; i < items.count; i ++) {
        
        CGFloat keyWordWidth = [items[i] KD_sizeWithAttributeFont:[UIFont systemFontOfSize:18]].width +15;
        
        if (keyWordWidth > MAXWidth) {
            
            keyWordWidth = MAXWidth;
        }
        
        if (MAXWidth - startSize.width < keyWordWidth) {
            
            startSize.height += 35.0;
            
            startSize.width = 0;
        }
        
        
        CGRect itemRect = CGRectMake(startSize.width, startSize.height, keyWordWidth, 35);
        
        [temps addObject:[NSNumber valueWithCGRect:itemRect]];
        
        //起点 增加
        startSize.width += keyWordWidth + padding;
        
    }
    
    self.itemFrames = [temps copy];
    
    if (items.count) {
        
        startSize.height +=35;
    }
    
    CGFloat bgH  = startSize.height;
    CGFloat bgX  = 15;
    CGFloat bgY  = 50;
    CGFloat bgW  = MAXWidth;
    self.bgFrame = CGRectMake(bgX, bgY, bgW, bgH);
    
    self.cellHeigh = items.count == 0 ? 0 : CGRectGetMaxY(self.bgFrame) + 10;
    
    self.originCellHeight = CGRectGetMaxY(self.bgFrame)+ 10;
    
    if (items.count == 0) {
        
        self.cellState =  FilterCellStateHeightZero;
    
    }else{
    
        self.cellState =  FilterCellStateRealHeight;
    }
 
}



- (id)copyWithZone:(nullable NSZone *)zone{
    
    FilterContentFrame *copy = [[FilterContentFrame allocWithZone:zone] init];
    
    copy.filter = [self.filter copy];
    copy.cellState = self.cellState;
    
    return copy;
    
}



@end
