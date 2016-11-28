//
//  OrderItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/23.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "OrderItem.h"
@interface OrderItem ()

@end


@implementation OrderItem

+(instancetype)orderWithDictionary:(NSDictionary *)orderDict{

    
    return [[self alloc] initWithDictionary:orderDict];
}


-(instancetype)initWithDictionary:(NSDictionary *)orderDict{
 
    self =[super init];
    
    if (self) {
        self.SKUs = orderDict[@"SKUs"];
        self.orderId = orderDict[@"_id"];
        self.total_fee = [NSString stringWithFormat:@"%@",orderDict[@"total_fee"]];
        self.orderDescription = orderDict[@"description"];
        self.create_at = orderDict[@"create_at"];
        self.status = orderDict[@"status"];
        [self statusWithTag:self.status];
         
    }
    
    return self;
}


-(void)statusWithTag:(NSString *)status
{
    self.cancelBtn_hiden = ![status isEqualToString:@"ORDER_PAY_PENDING"];
    
    if ([status isEqualToString:@"ORDER_FINISHED"]) {
        
        self.status_order = @"已付款";
        self.status_pay = @"已完成";
        
    }else   if ([status isEqualToString:@"ORDER_PAY_PENDING"]) {
        
        self.status_order = @"待付款";
        self.status_pay = @"去支付";
        
    }else  if ( [status isEqualToString:@"ORDER_CLOSED"]) {
        
        self.status_order = @"未付款";
        self.status_pay = @"已关闭";
        
    }else{
        
        self.status_order = @"已付款";
        self.status_pay = @"已退款";
    }
    
}


-(void)setStatus:(NSString *)status{

    _status = status;
    
    [self statusWithTag:status];
}

@end

 
