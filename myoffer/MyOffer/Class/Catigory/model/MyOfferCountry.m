//
//  MyOfferCountry.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferCountry.h"
#import "MyOfferCountryState.h"

@implementation MyOfferCountry

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"country_id" : @"id"};
    
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"states" : NSStringFromClass([MyOfferCountryState class])};
}


@end
