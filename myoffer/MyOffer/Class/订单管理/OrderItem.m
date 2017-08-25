//
//  OrderItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/23.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"order_id" : @"_id",@"order_description":@"description"};
    
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


- (NSString *)SKU{

    NSString *str = @"";
    
    if (_SKUs.count > 0) {
        
        str = _SKUs.firstObject[@"name"];
    }
    
    return str;
}

- (NSString *)order_id_str{

    return [NSString stringWithFormat:@"订单号：%@",self.order_id];
}

- (NSString *)total_fee_str{

    return [NSString stringWithFormat:@"价格：%@元",self.total_fee];
}

- (void)setStatus_finish:(BOOL)status_finish{

    _status_finish = status_finish;
    
    self.status = status_finish ? @"ORDER_FINISHED" : @"ORDER_PAY_PENDING";
}


- (void)setStatus_close:(BOOL)status_close{
    
    _status_close = status_close;
    
    self.status = status_close ? @"ORDER_CLOSED" : @"ORDER_PAY_PENDING";

}



@end

 
