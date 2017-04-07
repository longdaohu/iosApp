//
//  ServiceItemCellFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/4/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceItemAttribute.h"

@interface ServiceItemCellFrame : NSObject
@property(nonatomic,strong)ServiceItemAttribute *attribute;

@property(nonatomic,strong)NSValue *cell_frame;
@property(nonatomic,strong)NSValue *title_frame;
@property(nonatomic,strong)NSValue *line_frame;
@property(nonatomic,strong)NSValue *itemBg_frame;
@property(nonatomic,strong)NSArray  *cell_items_frames;

+ (instancetype)cellWithAttribute:(ServiceItemAttribute *)attribute maxWidth:(CGFloat)maxWidth cellTop:(CGFloat)cell_Top;

@end
