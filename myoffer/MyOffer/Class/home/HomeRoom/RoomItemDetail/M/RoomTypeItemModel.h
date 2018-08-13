//
//  RoomTypeItemModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomTypeItemModel : NSObject
@property(nonatomic,copy)NSString *room_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *accommodation_id;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *bed;
@property(nonatomic,copy)NSString *size;
@property(nonatomic,copy)NSString *thumbnails;
@property(nonatomic,copy)NSString *source_id;
@property(nonatomic,strong)NSArray *prices;
@property(nonatomic,strong)NSArray *pics;

@property(nonatomic,copy)NSString *currency;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *pic;


@end
