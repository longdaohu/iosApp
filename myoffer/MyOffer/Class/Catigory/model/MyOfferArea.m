//
//  MyOfferArea.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/26.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferArea.h"

@implementation MyOfferArea

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"area_id" : @"id"};
    
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"subjects" : @"MyOfferSubjecct"};
}

@end
