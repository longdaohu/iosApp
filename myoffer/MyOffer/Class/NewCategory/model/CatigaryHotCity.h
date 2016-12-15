//
//  CatigaryHotCity.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatigaryHotCity : NSObject
//城市id
@property(nonatomic,copy)NSString *city_id;
//城市名称
@property(nonatomic,copy)NSString *cityName;
//城市图片
@property(nonatomic,copy)NSString *IconName;
+(instancetype)CityItemInitWithCityDictionary:(NSDictionary *)cityDic;

@end
