//
//  OrderItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/23.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *status_order;
@property(nonatomic,copy)NSString *status_pay;
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *total_fee;
@property(nonatomic,copy)NSString *orderDescription;
@property(nonatomic,copy)NSString *create_at;
@property(nonatomic,strong)NSArray *SKUs;
@property(nonatomic,assign)BOOL cancelBtn_hiden;


@end
