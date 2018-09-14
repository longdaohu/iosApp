//
//  YSScheduleModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSScheduleModel.h"
#import "YXDateHelpObject.h"

@implementation YSScheduleModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"item_id" : @"id"
             };
    
}


- (YSScheduleVideoState)type{
 
    if ([self.status isEqualToString:@"IN_PROGRESS"]) {
        return YSScheduleVideoStateLiving;
    }
    
    if ([self.status isEqualToString:@"FINISHED"]) {
        return YSScheduleVideoStateAfter;
    }
    
    if ([self.status isEqualToString:@"NOT_START"]) {
        return YSScheduleVideoStateBefore;
    }
    
    if ([self.status isEqualToString:@"EXPIRED"]) {
        return YSScheduleVideoStateExpred;
    }else{
        return YSScheduleVideoStateDefault;
    }
 
}

- (NSString *)stateName{
    
    switch (self.type) {
        case YSScheduleVideoStateLiving:
            return @"立即听课";
            break;
        case YSScheduleVideoStateBefore:
            return @"未直播";
            break;
        case YSScheduleVideoStateAfter:
            return @"观看回放";
            break;
        default:
            return @"已过期";
            break;
    }
}

- (BOOL)livelogoState{
    
    switch (self.type) {
        case YSScheduleVideoStateLiving:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

- (BOOL)playButtonState{
    
    switch (self.type) {
        case YSScheduleVideoStateBefore: case YSScheduleVideoStateDefault: case YSScheduleVideoStateExpred:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}
//过期: 'EXPIRED', 完成: 'FINISHED',进行中: 'IN_PROGRESS',   NOT_START 没开始
//直播课 17:00-18:30 张三 口语精讲   // 正在直播 老师名 课程名称   //录播课 老师名 课程名称
- (NSString *)living_text{
 
    NSString *text = @"今天没有新课程，复习一下学完的课程吧";
    if ([self.status isEqualToString:@"IN_PROGRESS"]) {
        text = [NSString stringWithFormat:@"正在直播 %@ %@",self.teacherName,self.topic];
    }else if ([self.status isEqualToString:@"FINISHED"] || [self.status isEqualToString:@"EXPIRED"]){
        text = [NSString stringWithFormat:@"录播课 %@ %@",self.teacherName,self.topic];
    }else if ([self.status isEqualToString:@"NOT_START"]){
        
        YXDateHelpObject  *help = [YXDateHelpObject manager];
        NSDate *nextCourseStartTime = [help getDataFromStrFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" String:self.startTime];
        NSDate *nextCourseEndTime = [help getDataFromStrFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" String:self.endTime];
        NSString *next_start = [help getStrFromDateFormat:@"HH:mm" Date:nextCourseStartTime];
        NSString *next_end = [help getStrFromDateFormat:@"HH:mm" Date:nextCourseEndTime];
        text = [NSString stringWithFormat:@"直播课 %@-%@ %@ %@",next_start,next_end,self.teacherName,self.topic];
    }
 
    return  text;
}


- (NSString *)teacherName{
    if (!_teacherName) {
        _teacherName = [self.teacher valueForKey:@"name"];
    }
    return _teacherName;
}

- (NSString *)teacherImage{
    if (!_teacherImage) {
        _teacherImage = [self.teacher valueForKey:@"avatar"];
    }
    return _teacherImage;
}



- (NSString *)nextCourseTime{
    
    if (!_nextCourseTime) {
        
        if (self.startTime.length == 0 || !self.startTime) {
            
            return @"";
        }
        YXDateHelpObject  *help = [YXDateHelpObject manager];
        NSDate *nextCourseStartTime = [help getDataFromStrFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" String:self.startTime];
        NSDate *nextCourseEndTime = [help getDataFromStrFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" String:self.endTime];
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
            NSDate *now = [NSDate date];
            if ((nextCourseStartTime.hour > now.hour) || (nextCourseStartTime.hour == now.hour  && nextCourseStartTime.minute <= now.minute )) {
                _nextCourseTime = [NSString stringWithFormat:@"今天 %@:%@ - %@", hour, minute,endTime];
            }
            
        }else if (nextCourseStartTime.isTomorrow) {
            _nextCourseTime = [NSString stringWithFormat:@"明天 %@:%@ - %@", hour,minute,endTime];
        }else{
            _nextCourseTime = [NSString stringWithFormat:@"%ld-%@-%@ %@:%@ - %@", nextCourseStartTime.year, month, day,hour,minute,endTime];
        }
    }
    
    return _nextCourseTime;
}



@end


