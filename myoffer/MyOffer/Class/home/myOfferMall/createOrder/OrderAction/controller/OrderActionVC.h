//
//  OrderActionVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/4.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "BaseViewController.h"
@class DiscountItem;
@interface OrderActionVC : BaseViewController
@property(nonatomic,copy)void(^actBlock)(DiscountItem *);

@property(nonatomic,strong)NSArray *items;

@end
