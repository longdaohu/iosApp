//
//  ApplySection.h
//  myOffer
//
//  Created by sara on 15/12/7.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  UniversityFrameNew;

@interface ApplySection : NSObject
@property(nonatomic,strong)NSDictionary *universityInfo;
@property(nonatomic,strong) UniversityFrameNew *uniFrame;
@property(nonatomic,strong)NSMutableArray *subjects;

+ (instancetype)applySectionWithDictionary:(NSDictionary *)dict;


@end
