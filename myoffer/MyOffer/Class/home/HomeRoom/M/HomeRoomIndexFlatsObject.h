//
//  HomeRoomIndexFlatsObject.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeRoomIndexFlatsObject : NSObject
@property(nonatomic,copy)NSString *currency;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSAttributedString *priceAttribue;
@property(nonatomic,strong)NSDictionary *pic;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *city_id;

//查询结果数据显示 propertyList/1/1?type=city&type_id=19
@property(nonatomic,copy)NSString *thumbnail;
@property(nonatomic,copy)NSString *thumb;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *rent;
@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *lng;
@property(nonatomic,copy)NSString *no_id;
@property(nonatomic,strong)NSArray *feature;

@end


