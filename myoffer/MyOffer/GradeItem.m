//
//  GradeItem.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/18.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "GradeItem.h"

@implementation GradeItem
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        self.gradeName = [dict valueForKey:@"name"];
        
        self.NOid = (NSString *)[dict valueForKey:@"id"];
        
    }
    return self;
}

+ (instancetype)gradeWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];

}

@end
