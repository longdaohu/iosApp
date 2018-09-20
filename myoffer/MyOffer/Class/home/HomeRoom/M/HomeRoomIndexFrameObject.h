//
//  HomeRoomIndexFrameObject.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeRoomIndexObject.h"

@interface HomeRoomIndexFrameObject : NSObject
@property(nonatomic,strong)HomeRoomIndexObject *item;
//热门城市
@property(nonatomic,assign)CGSize  hot_city_item_size;
@property(nonatomic,assign)CGFloat hot_city_Section_Height;

//热门活动
@property(nonatomic,assign)CGSize  event_item_size;
@property(nonatomic,assign)CGFloat event_Section_Height;

//客户好评
@property(nonatomic,assign)CGFloat comment_Section_Height;
@property(nonatomic,assign)CGSize  comment_item_size;

@property(nonatomic,assign)CGFloat minimumLineSpacing;
@property(nonatomic,assign)CGFloat minimumInteritemSpacing;

//精选民宿
@property(nonatomic,strong)NSArray *flatsFrames;
@property(nonatomic,assign)CGFloat flat_Section_Height;

//公寓推荐
@property(nonatomic,strong)NSArray *accommodationsFrames;
@property(nonatomic,assign)CGFloat accommodation_Section_Height;

@end
