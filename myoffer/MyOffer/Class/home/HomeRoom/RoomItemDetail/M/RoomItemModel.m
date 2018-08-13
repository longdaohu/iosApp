//
//  RoomItemModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemModel.h"
#import "RoomTypeItemModel.h"

@implementation RoomItemModel

//- (NSArray *)feature{
//
//    return @[@"新闻",@"土耳其",@"埃氏政权",@"北约",@"维基解密",@"阿桑奇"];
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"room_id" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"roomtypes" :  NSStringFromClass([RoomTypeItemModel class])
             };
}


@end


