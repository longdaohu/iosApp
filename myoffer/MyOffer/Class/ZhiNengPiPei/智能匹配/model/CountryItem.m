//
//  CountryItem.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/18.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "CountryItem.h"

@implementation CountryItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        
         self.CountryName = dict[@"name"];
         self.NOid = [NSString stringWithFormat:@"%@",dict[@"id"]];
        
    }
    return self;
}
+ (instancetype)CountryWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
    
}
@end
