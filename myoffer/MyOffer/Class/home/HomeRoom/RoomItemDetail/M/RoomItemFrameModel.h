//
//  RoomItemFrameModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomItemModel.h"

@interface RoomItemFrameModel : NSObject
@property(nonatomic,strong)RoomItemModel *item;
@property(nonatomic,assign)CGRect top_line_frame;
@property(nonatomic,assign)CGFloat promotion_font_size;
@property(nonatomic,assign)CGFloat intro_font_size;
@property(nonatomic,assign)CGFloat process_font_size;
@property(nonatomic,assign)CGFloat tag_font_size;
@property(nonatomic,assign)CGFloat header_title_font_size;
@property(nonatomic,assign)CGFloat header_price_font_size;
@property(nonatomic,assign)CGFloat header_unit_font_size;
@property(nonatomic,assign)CGFloat header_id_font_size;
@property(nonatomic,assign)CGFloat header_address_font_size;

@property(nonatomic,assign)CGRect cross_frame;
@property(nonatomic,assign)CGRect count_frame;

@property(nonatomic,assign)CGRect intro_frame;
@property(nonatomic,assign)CGFloat intro_cell_hight;

@property(nonatomic,assign)CGRect process_frame;
@property(nonatomic,assign)CGFloat process_cell_hight;

@property(nonatomic,strong)NSArray *tagFrames;
@property(nonatomic,assign)CGRect tag_box_frame;
@property(nonatomic,assign)CGFloat faciliti_cell_hight;

@property(nonatomic,strong)NSArray *typeFrames;
@property(nonatomic,assign)CGFloat type_cell_hight;

@property(nonatomic,assign)CGRect promotion_frame;
@property(nonatomic,assign)CGRect promotion_spod_frame;
@property(nonatomic,assign)CGFloat promotion_cell_hight;

@property(nonatomic,assign)CGRect title_frame;
@property(nonatomic,assign)CGRect price_frame;
@property(nonatomic,assign)CGRect unit_frame;
@property(nonatomic,assign)CGRect id_frame;
@property(nonatomic,assign)CGRect line_frame;
@property(nonatomic,assign)CGRect address_frame;
@property(nonatomic,assign)CGRect map_frame;
@property(nonatomic,assign)CGRect map_anthor_frame;
@property(nonatomic,strong)NSArray *headerTagFrames;
@property(nonatomic,assign)CGRect header_box_frame;
@property(nonatomic,assign)CGRect header_bg_frame;
@property(nonatomic,assign)CGRect header_frame;

//数据源
@property(nonatomic,strong)NSMutableArray *groups;


@end

