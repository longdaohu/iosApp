//
//  YSCalendarCourseModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/9/4.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSCalendarCourseModel.h"
#import "YSScheduleModel.h"

@implementation YSCalendarCourseModel
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
                @"courses" : @"YSScheduleModel"
             };
}
@end
