//
//  YSCourseModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/29.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

// 过期: 'EXPIRED', 完成: 'FINISHED',进行中: 'IN_PROGRESS',   NOT_START 没开始    NO_COURSE  == YSCourseModelVideoStateDefault
typedef NS_ENUM(NSInteger,YSCourseModelVideoState) {
    YSCourseModelVideoStateDefault = 0,
    YSCourseModelVideoStateINPROGRESS,
    YSCourseModelVideoStateEXPIRED,
    YSCourseModelVideoStateNOTSTART,
    YSCourseModelVideoStateFINISHED
};

@interface YSCourseModel : NSObject

@property(nonatomic,copy)NSString *classId; //班级id，如果为空，则为未分班
@property(nonatomic,copy)NSString *count;//上过课时
@property(nonatomic,copy)NSString *label;//时间标签
@property(nonatomic,copy)NSString *name; //课程名
@property(nonatomic,copy)NSString *status;//课程状态：
//NO_COURSE|NOT_START|IN_PROGRESS|FINISHED|EXPIRED
@property(nonatomic,copy)NSString *total;//总课时
@property(nonatomic,copy)NSString *endTime;//结束日期
@property(nonatomic,copy)NSString *startTime;//开始日期
@property(nonatomic,copy)NSString *nextCourseStartTime;//下一堂课开始时间
@property(nonatomic,copy)NSString *nextCourseEndTime;//下一堂课结束时间
@property(nonatomic,assign)BOOL isLiving; //是否正在上课：true|false
@property(nonatomic,copy)NSString *productImg;//商品图片地址

@property(nonatomic,copy)NSString *nextCourseTime;
@property(nonatomic,copy)NSString *tips;
@property(nonatomic,copy)NSString *date_label;
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,assign)YSCourseModelVideoState  courseState;

@end




