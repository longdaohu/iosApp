//
//  ApplySection.m
//  myOffer
//
//  Created by sara on 15/12/7.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ApplySection.h"
#import "Applycourse.h"
#import "UniversityFrameApplyObj.h"
#import "UniversityObj.h"

@implementation ApplySection
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        
        self.universityInfo = dict;
        
        
        UniversityObj *uniObj =[UniversityObj createUniversityWithUniversityInfo:dict];
        self.uniFrame = [[UniversityFrameApplyObj alloc] init];
        self.uniFrame.uniObj = uniObj;
        
         NSMutableArray *subjectArray = [NSMutableArray array];
        for (NSDictionary *courseInfo in dict[@"applies"]) {
              Applycourse *subject = [Applycourse applyCourseWithDictionary:courseInfo];
              [subjectArray addObject:subject];
         }
        self.subjects  = [subjectArray mutableCopy];

     }
    return self;
}

+ (instancetype)applySectionWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];

}


 

@end
