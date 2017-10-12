//
//  ServiceProtocolViewController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/30.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItem.h"
#import "ServiceItemFrame.h"

@interface ServiceProtocolViewController : BaseViewController

@property(nonatomic,strong)ServiceItemFrame *itemFrame;

/*
 * showProtocalViw 显示
 * HidenProtocalView 不显示
 */
//- (void)showProtocalViw;
//- (void)HidenProtocalView;
- (void)protocalShow:(BOOL)show;

- (void)productDescriptionShow:(BOOL)show;

@end
