//
//  ApplyStatus.m
//  myOffer
//
//  Created by sara on 16/2/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "ApplyStatusRecord.h"
#import "Applycourse.h"
#import "MyOfferUniversityModel.h"

@implementation ApplyStatusRecord

/*
 + (NSDictionary *)mj_replacedKeyFromPropertyName{
 
 return @{@"record_id" : @"_id"};
 
 }
 */

- (void)setUniversity:(MyOfferUniversityModel *)university{

    _university = university;
    
    self.uniFrame = [UniversityFrameNew universityFrameWithUniverstiy:university];
}




@end
