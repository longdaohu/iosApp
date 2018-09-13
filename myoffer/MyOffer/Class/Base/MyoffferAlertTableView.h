//
//  MyoffferAlertTableView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/9/12.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyoffferAlertTableView : UITableView
@property(nonatomic,assign)CGFloat footerHeight;
@property(nonatomic,copy)void(^actionBlock)(void);

- (void)alertViewHiden;
- (void)alertWithNotDataMessage:(NSString *)message;
- (void)alertWithRoloadMessage:(NSString *)message;

@end
