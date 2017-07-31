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
    
    _duration = [NSString stringWithFormat:@"%ld:%ld",time_second/60,time_second%60];
    
    
}


@end
