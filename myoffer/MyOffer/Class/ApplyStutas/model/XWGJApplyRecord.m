//
//  ApplyStatus.m
//  myOffer
//
//  Created by sara on 16/2/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJApplyRecord.h"
#import "Applycourse.h"

@implementation XWGJApplyRecord
+(instancetype)ApplyStatusWithDictionary:(NSDictionary *)recordDic
{
    return [[self alloc] initWithDictionary:recordDic];
}
-(instancetype)initWithDictionary:(NSDictionary *)recordDic
{
    self =[super  init];
    if (self) {
        
           self.Status = recordDic[@"state"];
        
           self.Course = [Applycourse applyCourseWithDictionary:recordDic[@"course"]];
    }
    
    return self;
}


@end
