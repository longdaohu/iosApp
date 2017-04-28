//
//  filterContentFrame.h
//  myOffer
//
//  Created by sara on 16/5/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//
typedef enum {
    FilterCellStateRealHeight = 0,
    FilterCellStateBaseHeight,
    FilterCellStateHeightZero
} FilterCellState;


#import <Foundation/Foundation.h>
#import "FiltContent.h"

@interface FilterContentFrame : NSObject
//title图片
@property(nonatomic,assign)CGRect iconFrame;
//title
@property(nonatomic,assign)CGRect titleFrame;
//subtitle
@property(nonatomic,assign)CGRect subtitleFrame;

@property(nonatomic,assign)CGRect upFrame;
@property(nonatomic,assign)CGRect bgFrame;
//选择子项Frames
@property(nonatomic,strong)NSArray *itemFrames;
//cell高度
@property(nonatomic,assign)CGFloat cellHeigh;
//cell的状态
@property(nonatomic,assign)FilterCellState cellState;

@property(nonatomic,strong)FiltContent *filter;
//@property(nonatomic,strong)NSArray *optionItems;

+ (instancetype)filterFrameWithFilter:(FiltContent *)filter;



@end
