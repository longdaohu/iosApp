//
//  CreateOrderWebVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/4.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrderWebVC : UIViewController
@property(nonatomic,copy)NSString *path;
@property(nonatomic,strong)NSDictionary *item;
@property(nonatomic,copy)void(^webSuccesedCallBack)(void);

@end
