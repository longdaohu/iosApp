//
//  YSScheduleModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

// 过期: 'EXPIRED', 完成: 'FINISHED',进行中: 'IN_PROGRESS',   NOT_START 没开始    NO_COURSE  == YSScheduleVideoStateDefault
typedef NS_ENUM(NSInteger,YSScheduleVideoState) {
    YSScheduleVideoStateDefault = 0,
    YSScheduleVideoStateLiving,
    YSScheduleVideoStateBefore,
    YSScheduleVideoStateExpred,
    YSScheduleVideoStateAfter
};
@interface YSScheduleModel : NSObject
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy) NSString *item_id ;
@property(nonatomic,copy) NSString *mode ;// mode = REPLAY;

/*
 过期: 'EXPIRED', 完成: 'FINISHED',进行中: 'IN_PROGRESS',   NOT_START 没开始
 */
@property(nonatomic,copy) NSString *status ;
@property(nonatomic,copy) NSString *topic ;
@property(nonatomic,strong)NSDictionary *teacher;
/*
 "_id" = 5b90eeb6bc723d2579dbad88;
 avatar = "http://myoffer-test.oss-cn-shenzhen.aliyuncs.com/itles/Koala.jpg";
 intro = "\U96c5\U601d\U8bfe\U7a0b";
 name = "\U5468\U8d85\U7136";
 */
@property(nonatomic,copy) NSString *teacherImage ;
@property(nonatomic,copy) NSString *teacherName ;
@property(nonatomic,copy)NSString *nextCourseTime;
//----------------------------------------
@property(nonatomic,copy) NSString *stateName;
@property(nonatomic,assign) BOOL livelogoState;
@property(nonatomic,assign) BOOL playButtonState;
@property(nonatomic,assign)YSScheduleVideoState type;

/*
  0 过期  1 直播ing  2 未直播  3 回放
 */
@property(nonatomic,copy) NSString *state ;
@property(nonatomic,copy) NSString *inClassTime;

@property(nonatomic,copy)NSString *living_text;

@end


