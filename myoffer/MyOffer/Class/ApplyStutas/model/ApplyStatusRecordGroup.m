//
//  ApplyRecordGroup.m
//  myOffer
//
//  Created by sara on 16/2/16.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "ApplyStatusRecordGroup.h"
#import "UniversityObj.h"
#import "UniversityFrameObj.h"
#import "ApplyStatusRecord.h"

@implementation ApplyStatusRecordGroup


+(instancetype)ApplyRecourseGroupWithDictionary:(NSDictionary *)recordDic
{
    return [[self alloc] initWithDictionary:recordDic];
}

-(instancetype)initWithDictionary:(NSDictionary *)recordDic
{
    self =[super  init];
    if (self) {
        
        self.university      = [UniversityObj createUniversityWithUniversityInfo:recordDic[@"university"]];
        self.universityFrame = [UniversityFrameObj UniversityFrameWithUniversity:self.university];
        self.record          = [ApplyStatusRecord ApplyStatusWithDictionary:recordDic];
 
    }
    
    return self;
}

@end
