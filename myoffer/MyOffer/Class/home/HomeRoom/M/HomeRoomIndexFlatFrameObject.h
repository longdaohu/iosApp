//
//  HomeRoomIndexFlatFrameObject.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeRoomIndexFlatsObject.h"

@interface HomeRoomIndexFlatFrameObject : NSObject
@property(nonatomic,strong)HomeRoomIndexFlatsObject *item;
@property(nonatomic,assign)BOOL isHorizontal;
@property(nonatomic,assign)CGFloat item_width;
@property(nonatomic,assign)CGFloat item_height;
@property(nonatomic,assign)CGFloat margin;
@property(nonatomic,assign)CGFloat city_font_size;
@property(nonatomic,assign)CGFloat tag_font_size;
@property(nonatomic,assign)CGFloat name_font_size;
@property(nonatomic,assign)CGFloat price_font_size;
@property(nonatomic,strong)NSArray *tag_frames;

@property(nonatomic,assign)CGRect icon_Frame;
@property(nonatomic,assign)CGRect city_frame;
@property(nonatomic,assign)CGRect name_frame;
@property(nonatomic,assign)CGRect price_frame;

@end

