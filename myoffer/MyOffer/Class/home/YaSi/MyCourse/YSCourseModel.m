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
        NSDate *nextCourseEndTime = [help getDataFromStrFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" String:self.nextCourseEndTime];
        NSString *endTime =  [help getStrFromDateFormat:@"HH:mm" Date:nextCourseEndTime];
        
        
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
            _nextCourseTime = [NSString stringWithFormat:@"今天 %@:%@ - %@", hour, minute,endTime];
        }else if (nextCourseStartTime.isTomorrow) {
            _nextCourseTime = [NSString stringWithFormat:@"明天 %@:%@ - %@", hour,minute,endTime];
        }else{
            _nextCourseTime = [NSString stringWithFormat:@"%ld-%@-%@ %@:%@ - %@", nextCourseStartTime.year, month, day,hour,minute,endTime];
        }
    }
    
    return _nextCourseTime;
}

- (void)setStatus:(NSString *)status{
    _status = status;
 
    if ([status isEqualToString:@"IN_PROGRESS"]) {
        self.courseState = YSCourseModelVideoStateINPROGRESS;
    }else if ([status isEqualToString:@"FINISHED"]) {
        self.courseState =  YSCourseModelVideoStateFINISHED;
    }else if ([status isEqualToString:@"NOT_START"]) {
       self.courseState =  YSCourseModelVideoStateNOTSTART;
    }else if ([status isEqualToString:@"EXPIRED"]) {
        self.courseState =  YSCourseModelVideoStateEXPIRED;
    }else{
        self.courseState =  YSCourseModelVideoStateDefault;
    }
    
}


@end



