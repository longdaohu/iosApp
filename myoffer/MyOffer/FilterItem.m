//
//  FilterItem.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/16.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "FilterItem.h"

@implementation FilterItem
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
         self.courseName = dict[@"name"];
        self.courseID = (NSString *)dict[@"id"];
        
    }
    return self;
}
+ (instancetype)FilterItemWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];

}

 
@end
