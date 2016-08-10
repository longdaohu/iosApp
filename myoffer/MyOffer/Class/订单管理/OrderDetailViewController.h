//
//  OrderDetailViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^OrderDetailViewControllerBlock)(BOOL);

@class OrderItem;
@interface OrderDetailViewController : BaseViewController
@property(nonatomic,strong)OrderItem *order;
@property(nonatomic,copy)OrderDetailViewControllerBlock actionBlock;

@end
