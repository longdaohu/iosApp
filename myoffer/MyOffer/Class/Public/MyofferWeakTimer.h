//
//  MyofferWeakTimer.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/14.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 使用 消息传递 解决NSTimer内存泄漏问题
 创建一个对象，让NSTimer对这个对象进行强引用，而不对控制器进行强引用
 */
@interface MyofferWeakTimer : NSObject
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,weak)id target;
@property(nonatomic,assign)SEL selector;
@property(nonatomic,copy) void(^MyofferWeakTimerBlock)(void);

+ (NSTimer *)timerWithTimeInterval:(NSInteger)interval  selector:(void (^)(void))action;
+ (instancetype)objWithTimeInterval:(NSInteger)interval target:(id)target selector:(SEL)aSelector;

@end
