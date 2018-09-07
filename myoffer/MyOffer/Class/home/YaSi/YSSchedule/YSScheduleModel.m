//
//  YSScheduleModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSScheduleModel.h"

@implementation YSScheduleModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"item_id" : @"id"
             };
    
}
/*
 过期: 'EXPIRED',
 完成: 'FINISHED',
 进行中: 'IN_PROGRESS',
 */
- (void)setStatus:(NSString *)status{
    
    _status = status;
    
    if ([status isEqualToString:@"IN_PROGRESS"]) {
        self.state = @"1";
    }else if ([status isEqualToString:@"FINISHED"]){
        self.state = @"3";
    }else{
        self.state = @"0";
    }
}

// 0 过期  1 直播ing  2 未直播  3 回放
- (YSScheduleVideoState)type{
 
    switch (self.state.integerValue) {
        case 1:
            return YSScheduleVideoStateLiving;
            break;
        case 2:
            return YSScheduleVideoStateBefore;
            break;
        case 3:
            return YSScheduleVideoStateAfter;
            break;
        default:
            return YSScheduleVideoStateDefault;
            break;
    }
}


- (NSString *)stateName{
    
    switch (self.state.integerValue) {
        case 1:
            return @"立即听课";
            break;
        case 2:
            return @"未直播";
            break;
        case 3:
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
        case YSScheduleVideoStateBefore: case YSScheduleVideoStateDefault:
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
 
    NSString *text = @"正在直播";
    if ([self.status isEqualToString:@"IN_PROGRESS"]) {
        text = [NSString stringWithFormat:@"正在直播 %@ %@",self.teacherName,self.topic];
    }else if ([self.status isEqualToString:@"FINISHED"]){
        text = @"今天没有新课程，复习一下学完的课程吧";
    }else if ([self.status isEqualToString:@"EXPIRED"]){
        text = @"今天没有新课程，复习一下学完的课程吧";
    }else{
        text = [NSString stringWithFormat:@"直播课 %@ %@",self.teacherName,self.topic];
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

@end


