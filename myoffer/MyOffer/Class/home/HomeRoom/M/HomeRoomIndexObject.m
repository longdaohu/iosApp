//
//  HomeRoomIndexObject.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomIndexObject.h"
#import "HomeRoomIndexCityObject.h"
#import "HomeRoomIndexCommentsObject.h"
#import "HomeRoomIndexEventsObject.h"
#import "HomeRoomIndexFlatsObject.h"

@implementation HomeRoomIndexObject

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
                 @"events" : @"HomeRoomIndexEventsObject",
                 @"hot_city" : @"HomeRoomIndexCityObject",
                 @"accommodations" : @"HomeRoomIndexFlatsObject",
                 @"flats" : @"HomeRoomIndexFlatsObject",
                 @"comments" : @"HomeRoomIndexCommentsObject"
             };
}

@end

