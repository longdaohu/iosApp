//
//  RankTypeItem.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "RankTypeItem.h"

@implementation RankTypeItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"type_id" : @"id"};
    
}

- (NSURL *)image_path{
    
    _image_path = [NSURL URLWithString:self.image_url];

    return _image_path;
}

@end
