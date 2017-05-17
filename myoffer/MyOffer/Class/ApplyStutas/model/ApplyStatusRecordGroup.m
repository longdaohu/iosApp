//
//  ApplyRecordGroup.m
//  myOffer
//
//  Created by sara on 16/2/16.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "ApplyStatusRecordGroup.h"
#import "ApplyStatusRecord.h"
#import "MyOfferUniversityModel.h"
#import "UniversityFrameNew.h"

@implementation ApplyStatusRecordGroup


+(instancetype)ApplyRecourseGroupWithDictionary:(NSDictionary *)recordDic
{
    return [[self alloc] initWithDictionary:recordDic];
}

-(instancetype)initWithDictionary:(NSDictionary *)recordDic
{
    self =[super  init];
    if (self) {
        
        
       MyOfferUniversityModel *uni = [MyOfferUniversityModel mj_objectWithKeyValues:recordDic[@"university"]];
         
        self.universityFrame = [UniversityFrameNew universityFrameWithUniverstiy: uni];
     
        self.record   = [ApplyStatusRecord mj_objectWithKeyValues:recordDic];
 
    }
    
    return self;
}

@end
