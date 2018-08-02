//
//  HomeRoomIndexCityObject.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomIndexCityObject.h"

@implementation HomeRoomIndexCityObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"no_id" : @"_id"
             };
}

- (NSString *)fullName{
    
    if (!_fullName) {
        _fullName = [NSString stringWithFormat:@"%@\n%@",self.name_cn,self.name];
    }
    return _fullName;
}

@end
