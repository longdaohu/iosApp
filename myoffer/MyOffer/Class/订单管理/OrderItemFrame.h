//
//  OrderItemFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/6/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderItem.h"

@interface OrderItemFrame : NSObject
@property(nonatomic,strong)OrderItem *order;
@property(nonatomic,assign)CGRect status_frame;
@property(nonatomic,assign)CGRect SKU_frame;
@property(nonatomic,assign)CGRect line_frame;
@property(nonatomic,assign)CGRect order_id_frame;
@property(nonatomic,assign)CGRect total_fee_frame;
@property(nonatomic,assign)CGRect cancel_frame;
@property(nonatomic,assign)CGRect pay_frame;
@property(nonatomic,assign)CGFloat cell_Height;

- (instancetype)initWithOrder:(OrderItem *)order;


@end
