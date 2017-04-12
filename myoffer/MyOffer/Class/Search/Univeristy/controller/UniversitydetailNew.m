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

- (NSString *)address_long{
    
    return [NSString stringWithFormat:@"%@ | %@ | %@",self.country,self.state,self.city];
}

- (NSString *)address_short{
    
    return [NSString stringWithFormat:@"%@ | %@",self.country,self.city];
}

@end
