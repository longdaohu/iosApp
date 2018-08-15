//
//  RoomTypeItemFrameModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomTypeItemModel.h"

@interface RoomTypeItemFrameModel : NSObject

@property(nonatomic,strong)RoomTypeItemModel *item;

@property(nonatomic,assign)CGFloat title_font_size;
@property(nonatomic,assign)CGFloat tag_font_size;
@property(nonatomic,assign)CGFloat price_font_size;
@property(nonatomic,assign)CGFloat unit_font_size;
@property(nonatomic,assign)CGFloat pin_font_size;

@property(nonatomic,assign)CGRect icon_frame;
@property(nonatomic,assign)CGRect title_frame;
@property(nonatomic,assign)CGRect tag_frame;
@property(nonatomic,assign)CGRect price_frame;
@property(nonatomic,assign)CGRect unit_frame;
@property(nonatomic,assign)CGRect pin_frame;
@property(nonatomic,assign)CGRect line_frame;

@end
