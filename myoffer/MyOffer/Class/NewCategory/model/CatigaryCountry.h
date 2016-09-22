//
//  CatigaryCountry.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatigaryCountry : NSObject
//城市数组
@property(nonatomic,strong)NSArray *HotCities;
//国家
@property(nonatomic,copy)NSString *countryName;

+(instancetype)ContryItemInitWithCountryDictionary:(NSDictionary *)countryDic;
-(instancetype)initWithCountryDictionary:(NSDictionary *)countryDic;

@end

