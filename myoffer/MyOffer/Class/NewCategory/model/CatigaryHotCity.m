//
//  XWGJHotCity.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CatigaryHotCity.h"

@implementation CatigaryHotCity

+(instancetype)CityItemInitWithCityDictionary:(NSDictionary *)cityDic{
    
    return [[self alloc] initWithCityDictionary:cityDic];
}

-(instancetype)initWithCityDictionary:(NSDictionary *)cityDic{
    
    self = [super init];
    
    if (self) {

        self.city_id = [NSString stringWithFormat:@"%@",cityDic[@"_id"]];
        
        self.cityName = cityDic[@"city"];
        
         self.IconName =[cityDic[@"image_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     }
    
    return self;
}


@end

