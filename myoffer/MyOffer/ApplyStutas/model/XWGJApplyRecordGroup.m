//
//  ApplyRecordGroup.m
//  myOffer
//
//  Created by sara on 16/2/16.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJApplyRecordGroup.h"
#import "UniversityObj.h"
#import "UniversityFrameObj.h"
#import "XWGJApplyRecord.h"

@implementation XWGJApplyRecordGroup


+(instancetype)ApplyRecourseGroupWithDictionary:(NSDictionary *)recordDic
{
    return [[self alloc] initWithDictionary:recordDic];
}

-(instancetype)initWithDictionary:(NSDictionary *)recordDic
{
    self =[super  init];
    if (self) {
        
        self.university = [UniversityObj createUniversityWithUniversityInfo:recordDic[@"university"]];
        self.universityFrame =[[UniversityFrameObj alloc] init];
        self.universityFrame.uniObj = self.university;
        
        self.record = [XWGJApplyRecord ApplyStatusWithDictionary:recordDic];
        

    }
    
    return self;
}

@end