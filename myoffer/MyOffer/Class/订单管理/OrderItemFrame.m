//
//  OrderItemFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/6/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "OrderItemFrame.h"

@implementation OrderItemFrame

- (instancetype)initWithOrder:(OrderItem *)order{

    self = [super init];
    
    if (self) {
        
        self.order = order;
    }
    
    
    return self;
}


- (void)setOrder:(OrderItem *)order{
    
    _order = order;
    
    CGFloat title_X = 14;
    CGFloat title_Y = 15;
    CGFloat title_H_Nomal = 36;
    CGFloat title_H = title_H_Nomal;
    CGFloat title_W = XSCREEN_WIDTH -2 * title_X;
    CGSize orderSize =[order.SKU  KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]];
    title_H = orderSize.width > title_W ? title_H : 16;
    
    self.SKU_frame = CGRectMake(title_X, title_Y, title_W, title_H);
    
    CGFloat no_X = title_X;
    CGFloat no_Y = title_Y + title_H_Nomal + title_Y;
    CGFloat no_W = title_W;
    CGFloat no_H = 12;
    self.order_id_frame = CGRectMake(no_X, no_Y, no_W, no_H);
    
    CGFloat status_X =  title_X;
    CGFloat status_Y = no_Y;
    CGFloat status_H = no_H;
    CGFloat status_W = title_W;
    self.status_frame = CGRectMake(status_X, status_Y, status_W, status_H);
  
    
    CGFloat line_X =  title_X;
    CGFloat line_Y =  CGRectGetMaxY(self.order_id_frame) + title_Y;
    CGFloat line_H =  LINE_HEIGHT;
    CGFloat line_W =  title_W;
    self.line_frame = CGRectMake(line_X, line_Y, line_W, line_H);
    
    
    CGFloat fee_X = title_X;
    CGFloat fee_H = 30;
    CGFloat fee_Y = CGRectGetMaxY(self.line_frame) + 20;
    CGFloat fee_W = title_W * 0.4;
    self.total_fee_frame = CGRectMake(fee_X, fee_Y, fee_W, fee_H);
    
    
    CGFloat price_H = fee_H;
    CGFloat price_Y = fee_Y;
    CGFloat price_W = (title_W - fee_W - 10) * 0.5;
    CGFloat price_X = CGRectGetMaxX(self.SKU_frame) - price_W;
    self.pay_frame = CGRectMake(price_X, price_Y, price_W, price_H);
    
    
    CGFloat cancel_Y = price_Y;
    CGFloat cancel_W = price_W;
    CGFloat cancel_H = price_H;
    CGFloat cancel_X = price_X - cancel_W - 10;
    self.cancel_frame = CGRectMake(cancel_X, cancel_Y, cancel_W, cancel_H);
    
    
    self.cell_Height = CGRectGetMaxY(self.total_fee_frame) + 20;

    
}

@end
