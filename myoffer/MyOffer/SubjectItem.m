//
//  SubjectItem.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/18.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "SubjectItem.h"

@implementation SubjectItem
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        self.subjectName = [dict valueForKey:@"name"];
        self.NOid = [dict valueForKey:@"id"];

    }
    return self;
}

+ (instancetype)subjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];

}



@end
