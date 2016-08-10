//
//  ApplySection.h
//  myOffer
//
//  Created by sara on 15/12/7.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  UniversityFrameApplyObj;

@interface ApplySection : NSObject
@property(nonatomic,strong)NSDictionary *universityInfo;
@property(nonatomic,strong) UniversityFrameApplyObj *uniFrame;
@property(nonatomic,strong)NSMutableArray *subjects;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)applySectionWithDictionary:(NSDictionary *)dict;


@end
