//
//  MBProgressHUD+XJ.h
//  myOffer
//
//  Created by xuewuguojie on 2017/5/11.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (XJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
+ (MBProgressHUD *)showSuccessWithMessage:(NSString *)message ToView:(UIView *)view;


@end
