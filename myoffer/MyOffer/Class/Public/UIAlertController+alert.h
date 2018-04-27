//
//  UIAlertController+alert.h
//  newOffer
//
//  Created by xuewuguojie on 2018/4/27.
//  Copyright © 2018年 徐金辉. All rights reserved.
//



@interface UIAlertController (alert)


/**
 默认 alert快捷方式
 @param title 标题
 @param message 显示内容信息
 @param cancelTitle 默认取消，也可以不显示
 @param doneTitle  自定义按钮标题，默认取消，也可以不显示
 @param cancelAction 取消按钮事件
 @param doneAction  自定义按钮事件
 @return  alertVC
 */
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message
           actionWithCancelTitle:(NSString *)cancelTitle
           actionWithCancelBlock:(void (^)(void))cancelAction
           actionWithDoneTitle:(NSString *)doneTitle
           actionWithDoneHandler:(void (^)(void))handler;

/**
 添加点击按钮
 @param title 按钮标题
 @param style 类型
 @param click 点击事件
 */
- (void)addButtonWithTitle:(NSString *)title  style:(UIAlertActionStyle)style onClick:(void (^)(void))click;
- (void)alertShow:(UIViewController *)vc;

@end


