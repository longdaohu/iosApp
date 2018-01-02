//
//  MyOfferInputView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/5/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYLXGroup.h"
@class MyOfferInputView;

@protocol MyOfferInputViewDelegate   <NSObject>

@optional
//开始输入
- (void)cell:(MyOfferInputView *)cell textFieldDidBeginEditing:(UITextField *)textField;
//结束输入
- (void)cell:(MyOfferInputView *)cell textFieldDidEndEditing:(UITextField *)textField;
//回车键
- (void)cell:(MyOfferInputView *)cell  textFieldShouldReturn:(UITextField *)textField;
//监听输入
- (void)cell:(MyOfferInputView *)cell  shouldChangeCharacters:(NSString *)content;
//发送验证码
- (void)sendVertificationCodeWithCell:(MyOfferInputView *)cell;
//输入框辅助工具条点击事件
- (void)inputAccessoryViewClickWithCell:(MyOfferInputView *)cell;


@end
@interface MyOfferInputView : UIView
//数据源
@property(nonatomic,strong)WYLXGroup *group;
@property(nonatomic,strong)UITextField *inputTF;
@property(nonatomic,weak)id<MyOfferInputViewDelegate> delegate;

//当点击提交按钮时添加数据到 模型中
- (void)checKTextFieldWithGroupValue;
//更新获取验证码的状态
- (void)changeVertificationCodeButtonEnable:(BOOL)enable;
//是否显示倒计时
- (void)vertificationTimerShow:(BOOL)show;

@end
