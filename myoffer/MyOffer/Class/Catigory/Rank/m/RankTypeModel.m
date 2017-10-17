//
//  RankTypeModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "RankTypeModel.h"
#import "MyOfferUniversityModel.h"

@implementation RankTypeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"descrpt" : @"description"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"universities" : NSStringFromClass([MyOfferUniversityModel class])};
}


@end
