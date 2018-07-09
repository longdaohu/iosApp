//
//  CreateOrderUserInformationVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrderUserInformationVC : BaseViewController
@property(nonatomic,strong)NSDictionary *item;
@property(nonatomic,copy)void(^actionBlock)(void);

@end
