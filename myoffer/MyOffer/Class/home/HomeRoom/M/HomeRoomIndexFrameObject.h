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
@property(nonatomic,assign)CGFloat flat_Section_Height;
@property(nonatomic,assign)CGFloat accommodation_Section_Height;
@property(nonatomic,assign)CGFloat hot_city_Section_Height;
@property(nonatomic,assign)CGFloat comment_Section_Height;
@property(nonatomic,assign)CGSize  hot_city_item_size;
@property(nonatomic,assign)CGSize  comment_item_size;
@property(nonatomic,assign)CGFloat minimumLineSpacing;
@property(nonatomic,assign)CGFloat minimumInteritemSpacing;
@property(nonatomic,strong)NSArray *flatsFrames;
@property(nonatomic,strong)NSArray *accommodationsFrames;

@end
