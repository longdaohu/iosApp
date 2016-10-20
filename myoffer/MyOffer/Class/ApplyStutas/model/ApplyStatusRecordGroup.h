//
//  ApplyRecordGroup.h
//  myOffer
//
//  Created by sara on 16/2/16.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UniversityObj;
@class ApplyStatusRecord;
@class UniversityFrameObj;
@interface ApplyStatusRecordGroup : NSObject
@property(nonatomic,strong)UniversityObj *university;   //学校模型数据
@property(nonatomic,strong)UniversityFrameObj *universityFrame;   //学校模型数据
@property(nonatomic,strong)ApplyStatusRecord *record;

+(instancetype)ApplyRecourseGroupWithDictionary:(NSDictionary *)recordDic;


@end
