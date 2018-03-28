//
//  ApplyStatus.h
//  myOffer
//
//  Created by sara on 16/2/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Applycourse;
@class MyOfferUniversityModel;
#import "UniversityFrameNew.h"
@interface ApplyStatusRecord : NSObject
@property(nonatomic,copy)NSString *state;
@property(nonatomic,strong)UniversityFrameNew *uniFrame;
@property(nonatomic,strong)MyOfferUniversityModel *university;
@property(nonatomic,strong)Applycourse *course;


@end
 
