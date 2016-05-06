//
//  FilterSection.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/16.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "FilterSection.h"
#import "FilterItem.h"

@implementation FilterSection
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        self.subjectID = (NSString *)dict[@"id"];
        self.subjectName = dict[@"name"];
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSDictionary *courseInfo in dict[@"subjects"]) {
            FilterItem *item = [FilterItem FilterItemWithDictionary:courseInfo];
            [itemArray addObject:item];
        }
        self.subjectArray  = [itemArray copy];
        
    }
    return self;
}
+ (instancetype)FilterSectionWithDictionary:(NSDictionary *)dict;
{
    return [[self alloc] initWithDictionary:dict];
    
}


 

@end
