//
//  YSCourseModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/29.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCourseModel : NSObject
@property(nonatomic,copy)NSString *classId;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *label;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *total;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *nextCourseStartTime;
@property(nonatomic,copy)NSString *nextCourseEndTime;
@property(nonatomic,copy)NSString *nextCourseTime;
@property(nonatomic,copy)NSString *tips;
@property(nonatomic,copy)NSString *productImg;
@property(nonatomic,assign)BOOL isLiving;

@property(nonatomic,copy)NSString *date_label;
@property(nonatomic,assign)CGFloat progress;

@end


