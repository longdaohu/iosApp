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
@property(nonatomic,copy) NSString *mode;
@property(nonatomic,copy) NSString *startTime ;
@property(nonatomic,copy) NSString *teacherImage ;
@property(nonatomic,copy) NSString *teacherName ;
@property(nonatomic,copy) NSString *topic ;
@property(nonatomic,copy) NSString *state ;

@property(nonatomic,copy) NSString *stateName;
@property(nonatomic,assign) BOOL livelogoState;
@property(nonatomic,assign) BOOL playButtonState;
@property(nonatomic,assign)YSScheduleVideoState type;

@end
