//
//  RoomCityModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/10.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomCityModel.h"

@implementation RoomCityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"item_id" : @"id",
             };
}

- (NSString *)cityName{
    
    if(!_cityName){
        
        _cityName = [NSString stringWithFormat:@"%@ - %@",self.name_cn,self.name];
    }
    
    return _cityName;
}

@end
