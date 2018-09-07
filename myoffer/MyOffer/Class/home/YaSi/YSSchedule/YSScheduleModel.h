//
//  YSScheduleModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

// 0 过期  1 直播ing  2 未直播  3 回放
typedef NS_ENUM(NSInteger,YSScheduleVideoState) {
    YSScheduleVideoStateDefault = 0,
    YSScheduleVideoStateLiving,
    YSScheduleVideoStateBefore,
    YSScheduleVideoStateAfter
};
@interface YSScheduleModel : NSObject
@property(nonatomic,copy) NSString *item_id ;
@property(nonatomic,copy) NSString *mode ;
@property(nonatomic,strong)NSDictionary *teacher;
@property(nonatomic,copy) NSString *startTime ;
@property(nonatomic,copy) NSString *teacherImage ;
@property(nonatomic,copy) NSString *teacherName ;
@property(nonatomic,copy) NSString *topic ;

/*
  0 过期  1 直播ing  2 未直播  3 回放
 */
@property(nonatomic,copy) NSString *state ;

/*
 过期: 'EXPIRED', 完成: 'FINISHED',进行中: 'IN_PROGRESS',   NOT_START 没开始
 */
@property(nonatomic,copy) NSString *status ;
@property(nonatomic,copy) NSString *inClassTime;
@property(nonatomic,copy) NSString *stateName;
@property(nonatomic,assign) BOOL livelogoState;
@property(nonatomic,assign) BOOL playButtonState;
@property(nonatomic,assign)YSScheduleVideoState type;

@property(nonatomic,copy)NSString *living_text;
@end

/*
 date = "2018-09-04";
 endTime = "2018-09-04T13:00:00.000Z";
 id = 5b9100839dfc0085c965e20e;
 mode = LIVING;
 startTime = "2018-09-04T09:00:00.000Z";
 status = FINISHED;
 teacher =     {
 "_id" = 5b8384889bf2d90943b7ead2;
 avatar = "http://myoffer-test.oss-cn-shenzhen.aliyuncs.com/ielts/sheji37.jpg";
 intro = "\U8d44\U6df1\U8001\U5e08";
 name = "\U674e\U56db";
 };
 topic = "\U82f1\U8bed\U8bcd\U6c47";
 */

