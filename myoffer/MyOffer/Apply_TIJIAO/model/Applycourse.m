//
//  Applycourse.m
//  myOffer
//
//  Created by sara on 15/12/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "Applycourse.h"

@implementation Applycourse
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.official_name = dict[@"official_name"];
        self.courseName = dict[@"name"];
        self.courseID = dict[@"_id"];
     }
    return self;
}
+ (instancetype)applyCourseWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
    
}
@end
