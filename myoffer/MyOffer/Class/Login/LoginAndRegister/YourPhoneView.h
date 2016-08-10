//
//  YourPhoneView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/23.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YourPhoneView;
@protocol YourPhoneViewDelegate <NSObject>
-(void)YourPhoneView:(YourPhoneView *)PhoneView WithButtonItem:(UIButton *)sender;

@end

@interface YourPhoneView : UIView
@property(nonatomic,weak)id<YourPhoneViewDelegate> delegate;
//直接进入编辑框 ———— 地区号选项
@property (weak, nonatomic)  XTextField *countryCode;
//直接进入编辑框 ———— 手机号
@property (weak, nonatomic)  UITextField *PhoneTF;
//直接进入编辑框 ———— 验证码
@property (weak, nonatomic)  UITextField *VerifyTF;
//直接进入编辑框 ———— 验证码发送按钮
@property (weak, nonatomic)  UIButton *SendCodeBtn;

@end
