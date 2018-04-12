//
//  MBProgressHUD+XJ.m
//  myOffer
//
//  Created by xuewuguojie on 2017/5/11.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MBProgressHUD+XJ.h"
#import "UIImage+GIF.h"

@implementation MBProgressHUD (XJ)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.label.text = text;
    hud.label.numberOfLines = 2;
    hud.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:2];
    
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    
    [self show:error icon:@"hud_fail" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"hud_success" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.animationType = MBProgressHUDAnimationZoomOut;
    
    hud.label.text = message;
    
    hud.label.numberOfLines = 2;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //    hud.dimBackground = YES;
    hud.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    return hud;
    
}


+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:message toView:nil];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:2];
    
    return hud;
}

+ (MBProgressHUD *)showSuccessWithMessage:(NSString *)message ToView:(UIView *)view{
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.label.text = message;
    hud.label.numberOfLines = 2;
    hud.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_success"]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:2];
    
    
    
    return  hud;
}


@end

