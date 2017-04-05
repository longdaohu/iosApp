//
//  ServiceProtocolViewController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/30.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceProtocolViewController : BaseViewController

@property(nonatomic,strong)NSArray *agreements;

@property(nonatomic,copy)NSString *service_id;


/*
 * showProtocalViw 显示
 * HidenProtocalView 不显示
 */
- (void)showProtocalViw;
- (void)HidenProtocalView;


@end
