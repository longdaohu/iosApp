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

/*
 classId = 5b83851c9bf2d90943b7ead3;
 count = 0;
 endTime = "2018-09-07";
 isLiving = 0;
 label = "2018-09-07 07:00:00";
 name = "\U6d4b\U8bd5\U5546\U54c1\U9ed8\U8ba4SKU";
 nextCourseEndTime = "2018-09-07T13:00:00.000Z";
 nextCourseStartTime = "2018-09-07T11:00:00.000Z";
 productImg = 444444;
 startTime = "2018-09-07";
 status = "IN_PROGRESS";
 tips = "";
 total = 1;
 */
