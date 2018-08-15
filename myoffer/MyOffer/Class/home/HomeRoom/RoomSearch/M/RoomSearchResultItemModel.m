//
//  RoomSearchResultItemModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomSearchResultItemModel.h"

@implementation RoomSearchResultItemModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"item_id" : @"id"};
}
@end

