//
//  UIAlertController+alert.m
//  newOffer
//
//  Created by xuewuguojie on 2018/4/27.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "UIAlertController+alert.h"

@implementation UIAlertController (alert)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message
           actionWithCancelTitle:(NSString *)cancelTitle
           actionWithCancelBlock:(void (^)(void))cancelAction
           actionWithDoneTitle:(NSString *)doneTitle
           actionWithDoneHandler:(void (^)(void))handler {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title  message:message preferredStyle:UIAlertControllerStyleAlert];
 
    if (cancelTitle.length > 0) {
        [alertVC addButtonWithTitle:cancelTitle  style:UIAlertActionStyleCancel onClick:cancelAction];
    }
    if (doneTitle.length > 0) {
        [alertVC addButtonWithTitle:doneTitle  style:UIAlertActionStyleDefault onClick:handler];
    }

    return alertVC;
}

- (void)addButtonWithTitle:(NSString *)title  style:(UIAlertActionStyle)style onClick:(void (^)(void))click{
    
    if (title.length > 0) {
        
        UIAlertAction *sender = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            if (click)  click();
        }];
        
        [self addAction:sender];
    }
}

- (void)alertShow:(UIViewController *)vc{
    
    [vc presentViewController:self animated:YES completion:^{
    }];
}





@end
