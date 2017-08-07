//
//  SMAudioItem.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMAudioItem.h"

@implementation SMAudioItem

- (void)setSeconds_duration:(NSString *)seconds_duration{
    
    _seconds_duration = seconds_duration;
    
    
    NSInteger time_second = self.seconds_duration.integerValue;
    
    _duration = [NSString stringWithFormat:@"时长：%ldm%lds",(long)time_second/60,(long)time_second%60];
    
    
}



- (NSString *)play_imageName{
    
    
    //如果播放按钮可用，判断播放按钮的当前是否正在播放状态
    NSString *imageName = @"play";
    if (self.isCanPlay){
        
        imageName = self.inPlaying ? @"pause" : @"play";
        
    }else{
        imageName = @"play_lock";
    }
    
    
    return imageName;
}


- (NSString *)status_title{
    
    NSString *title = self.isCanPlay ? (LOGIN ? @"播放" : @"试听") : @"";
    
    return title;
}

@end
