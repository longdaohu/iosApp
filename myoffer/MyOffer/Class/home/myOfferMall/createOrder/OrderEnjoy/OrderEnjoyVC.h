///Users/xuewuguojie/Desktop/iosApp/myoffer/MyOffer/Class
//  OrderEnjoyVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderEnjoyVC : BaseViewController
@property(nonatomic,copy)void(^enjoyBlock)(NSDictionary *);
@property(nonatomic,strong)NSNumber *price;

@end




