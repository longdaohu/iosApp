//
//  MyofferWeakTimer.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/14.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "MyofferWeakTimer.h"

@implementation MyofferWeakTimer

+ (NSTimer *)timerWithTimeInterval:(NSInteger)interval  selector:(void (^)(void))action{
   
    MyofferWeakTimer *obj = [[MyofferWeakTimer alloc] init];
    obj.MyofferWeakTimerBlock = action;
    obj.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:obj selector:@selector(time:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:obj.timer forMode:NSRunLoopCommonModes];
    return obj.timer;
}

- (void)time:(id)sender{
    
    if (self.MyofferWeakTimerBlock) {
        self.MyofferWeakTimerBlock();
    }
}


+ (instancetype)objWithTimeInterval:(NSInteger)interval target:(id)target selector:(SEL)aSelector{
    
    MyofferWeakTimer *obj = [[MyofferWeakTimer alloc] init];
    obj.target = target;
    obj.selector = aSelector;
    obj.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:obj selector:@selector(send) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:obj.timer forMode:NSRunLoopCommonModes];
    
    return obj;
}
- (void)send{
    
    if (self.selector && self.target) {
        [self.target performSelector:self.selector withObject:nil afterDelay:0];
    }
}


@end


