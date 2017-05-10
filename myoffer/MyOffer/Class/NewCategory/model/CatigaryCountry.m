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

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"hot_cities" : @"CatigaryHotCity"};
}


@end
