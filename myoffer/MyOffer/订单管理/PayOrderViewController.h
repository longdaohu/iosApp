//
//  PayOrderViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^PayOrderViewControllerBlock)(BOOL);
@class OrderItem;
@interface PayOrderViewController : BaseViewController
@property(nonatomic,strong)OrderItem *order;
@property(nonatomic,copy)PayOrderViewControllerBlock actionBlock;
@property(nonatomic,strong)NSDictionary *orderDict;


@end
