//
//  XWGJLXCountry.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CatigaryCountry.h"
#import "CatigaryHotCity.h"

@implementation CatigaryCountry

+(instancetype)ContryItemInitWithCountryDictionary:(NSDictionary *)countryDic
{

    return [[self alloc] initWithCountryDictionary:countryDic];
}

-(instancetype)initWithCountryDictionary:(NSDictionary *)countryDic{

    self = [super init];
    
    if (self) {
        
        self.countryName = countryDic[@"country"];
        self.HotCities = [CatigaryHotCity mj_objectArrayWithKeyValuesArray: countryDic[@"hot_cities"]];
        
        for (CatigaryHotCity *city in self.HotCities) {
            
            city.country = self.countryName;
        }
        
     }
    
    return self;
}

@end
