//
//  UniversityCourse.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/12.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityCourse.h"

@implementation UniversityCourse
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"NO_id" : @"_id"};
    
}

- (NSArray *)items{

    NSMutableArray *item_temps = [NSMutableArray array];
    
    if (self.level) [item_temps addObject:self.level];
    
    [item_temps addObjectsFromArray:self.areas];
    
  
    return  [item_temps copy];
}


@end
