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
        
          self.countryName =  [countryDic[@"country"] isEqualToString:GDLocalizedString(@"CategoryVC-AU")] ? GDLocalizedString(@"CategoryNew-hotAU") : GDLocalizedString(@"CategoryNew-hotUK") ;
        
        NSMutableArray *cityM = [NSMutableArray array];
        
        for (NSDictionary *cityDic in countryDic[@"hot_cities"]) {
          
            CatigaryHotCity *city =[CatigaryHotCity CityItemInitWithCityDictionary:cityDic];
  
            [cityM addObject:city];
        }
        self.HotCities = [cityM copy];
        
     }
    
    return self;
}

@end
