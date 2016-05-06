//
//  XWGJHotCity.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWGJHotCity : NSObject
@property(nonatomic,copy)NSString *city_id;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *IconName;


+(instancetype)CityItemInitWithCityDictionary:(NSDictionary *)cityDic;
-(instancetype)initWithCityDictionary:(NSDictionary *)cityDic;

@end
