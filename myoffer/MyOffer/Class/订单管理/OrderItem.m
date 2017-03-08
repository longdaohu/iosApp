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

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"order_id" : @"_id",@"orderDescription":@"description"};
    
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

 
