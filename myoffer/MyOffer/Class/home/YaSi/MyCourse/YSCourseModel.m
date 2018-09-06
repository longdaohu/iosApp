//
//  YSCourseModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/29.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSCourseModel.h"
#import "YXDateHelpObject.h"


@implementation YSCourseModel

- (CGFloat)progress{
    
    if (!_progress) {
        
        _progress = self.count.floatValue / self.total.floatValue;
    }
    
    return _progress;
}


- (NSString *)date_label{
    
    if (!_date_label) {
        
        NSArray *startTime =  [self.startTime componentsSeparatedByString:@"T"];
        NSArray *endTime =  [self.endTime componentsSeparatedByString:@"T"];
        
        if (startTime.count > 0 && endTime.count > 0) {
            _date_label = [NSString stringWithFormat:@"%@ —— %@  |  %@课时",startTime.firstObject,endTime.firstObject,self.total];
        }else{
            _date_label = [NSString stringWithFormat:@"%@课时",self.total];
        }
    }
    
    return _date_label;
}

- (NSString *)nextCourseTime{
    
    if (!_nextCourseTime) {
      
        if (self.nextCourseStartTime.length == 0 || !self.nextCourseStartTime) {
            
            return @"";
        }
        YXDateHelpObject  *help = [YXDateHelpObject manager];
        NSDate *nextCourseStartTime = [help getDataFromStrFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" String:self.nextCourseStartTime];
        
        NSString *month = [NSString stringWithFormat:@"%ld",nextCourseStartTime.month];
        if (month.length < 2) {
            month = [NSString stringWithFormat:@"0%ld",nextCourseStartTime.month];
        }
        NSString *day = [NSString stringWithFormat:@"%ld",nextCourseStartTime.day];
        if (day.length < 2) {
             day = [NSString stringWithFormat:@"0%ld",nextCourseStartTime.day];
        }
        NSString *hour = [NSString stringWithFormat:@"%ld",nextCourseStartTime.hour];
        if (hour.length < 2) {
            hour = [NSString stringWithFormat:@"0%ld",nextCourseStartTime.hour];
        }
        NSString *minute = [NSString stringWithFormat:@"%ld",nextCourseStartTime.minute];
        if (minute.length < 2) {
            minute = [NSString stringWithFormat:@"0%ld",nextCourseStartTime.minute];
        }
        if (nextCourseStartTime.isToday) {
            _nextCourseTime = [NSString stringWithFormat:@"今天 %@:%@", hour, minute];
        }else if (nextCourseStartTime.isTomorrow) {
            _nextCourseTime = [NSString stringWithFormat:@"明天 %@:%@", hour,minute];
        }else{
            _nextCourseTime = [NSString stringWithFormat:@"%ld-%@-%@ %@:%@", nextCourseStartTime.year, month, day,hour,minute];
        }
    }
    
    return _nextCourseTime;
}

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


@end

