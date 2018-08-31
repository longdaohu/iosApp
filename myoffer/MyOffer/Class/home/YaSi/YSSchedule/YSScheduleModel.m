//
//  YSScheduleModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSScheduleModel.h"

@implementation YSScheduleModel

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

@end
