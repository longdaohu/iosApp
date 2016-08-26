//
//  UniversityNew.m
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/24.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "UniversitydetailNew.h"

@implementation UniversitydetailNew
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"NO_id" : @"_id"};
    
}

- (NSString *)address_detail{
    
    return [NSString stringWithFormat:@"%@ | %@ | %@",self.country,self.state,self.city];
}

@end
