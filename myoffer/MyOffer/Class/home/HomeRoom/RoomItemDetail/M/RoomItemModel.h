//
//  RoomItemModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomItemModel : NSObject
@property(nonatomic,copy)NSString *room_id;
@property(nonatomic,copy)NSString *mark_shortterm;
@property(nonatomic,copy)NSString *mark_hide;
@property(nonatomic,copy)NSString *description_en;
@property(nonatomic,copy)NSString *source_id;
@property(nonatomic,copy)NSString *currency;
@property(nonatomic,copy)NSString *source_url;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *mark_sold;
@property(nonatomic,copy)NSString *thumbnails;
@property(nonatomic,copy)NSString *country_id;
@property(nonatomic,strong)NSArray *pics;
@property(nonatomic,strong)NSArray *amenities;
@property(nonatomic,strong)NSArray *ameniti_arr;
@property(nonatomic,strong)NSArray *roomtypes;
@property(nonatomic,strong)NSArray *feature;

@property(nonatomic,copy)NSString *mark_student;
@property(nonatomic,copy)NSString *unit; // 租期单位
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *minimap; //地图图片
@property(nonatomic,copy)NSString *provider_id;
@property(nonatomic,copy)NSString *mark_roomtype;
@property(nonatomic,copy)NSString *bathroom;
@property(nonatomic,copy)NSString *bedroom;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *thumbnail;
@property(nonatomic,copy)NSString *rent;
@property(nonatomic,copy)NSString *max_rent;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *postcode;
@property(nonatomic,copy)NSString *lease;
@property(nonatomic,copy)NSString *lat;//纬度
@property(nonatomic,copy)NSString *lng;//经度
@property(nonatomic,copy)NSString *promotion;//优惠活动
@property(nonatomic,copy)NSString *process;//预订须知
@property(nonatomic,copy)NSString *mark_summerlet;
@property(nonatomic,copy)NSString *mark_new;
@property(nonatomic,copy)NSString *city_id;
@property(nonatomic,copy)NSString *avaliable_date;
@property(nonatomic,copy)NSString *sq;
@property(nonatomic,copy)NSString *update_date;
@property(nonatomic,copy)NSString *intro; //介绍
//自定义
@property(nonatomic,copy)NSString *price;
@property(nonatomic,strong)NSArray *imageURLs;
@property(nonatomic,copy)NSString *roomCode;

@end

