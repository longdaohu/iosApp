//
//  YSScheduleModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSScheduleModel.h"

@implementation YSScheduleModel

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

//- (NSString *)stateBgImageName{
//
//    switch (self.state.integerValue) {
//        case 1:
//            return @"button_blue_nomal";
//            break;
//        case 2:
//            return @"";
//            break;
//        case 3:
//            return @"button_blue_nomal";
//            break;
//        default:
//            return @"button_light_unable";
//            break;
//    }
//}

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

@end
