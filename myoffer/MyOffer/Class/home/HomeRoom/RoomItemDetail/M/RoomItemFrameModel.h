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
@property(nonatomic,assign)CGFloat intro_font_size;
@property(nonatomic,assign)CGFloat tag_font_size;
@property(nonatomic,assign)CGRect intro_frame;
@property(nonatomic,assign)CGFloat intro_cell_hight;

@property(nonatomic,strong)NSArray *tagFrames;
@property(nonatomic,assign)CGRect tag_box_frame;
@property(nonatomic,assign)CGFloat faciliti_cell_hight;

@property(nonatomic,strong)NSArray *typeFrames;
@property(nonatomic,assign)CGFloat type_cell_hight;

//@property(nonatomic,assign)CGRect tag_box_frame;


@end

