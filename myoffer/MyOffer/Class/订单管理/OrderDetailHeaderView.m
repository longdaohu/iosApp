//
//  OrderDetailHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "OrderDetailHeaderView.h"

@interface OrderDetailHeaderView ()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *orderNoLab;

@end


@implementation OrderDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];

        self.titleLab =[UILabel labelWithFontsize:16  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.titleLab.numberOfLines = 0;
        [self  addSubview:self.titleLab];

        self.orderNoLab =[UILabel labelWithFontsize:KDUtilSize(13)  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
        [self  addSubview:self.orderNoLab];


    }
    return self;
}



-(void)setOrder:(OrderItem *)order{
    
    
    _order = order;
    
    self.titleLab.text = order.SKU;
    self.orderNoLab.text    = [NSString stringWithFormat:@"订单号 ： %@",order.order_id];
  
    CGFloat titleX = 10;
    CGFloat titleY = 10;
    CGFloat titleW = XSCREEN_WIDTH - titleX * 2;
    CGFloat titleH =  0;
    if (self.titleLab.text.length > 0) {
        CGSize orderSize = [self.titleLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16] maxWidth:titleW];
        titleH = orderSize.height;
    }
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    
    CGFloat noX = titleX;
    CGFloat noY = CGRectGetMaxY(self.titleLab.frame) + 5;
    CGFloat noW = titleW;
    CGFloat noH = 20;
    self.orderNoLab.frame = CGRectMake(noX, noY, noW, noH);
    
    self.headHeight = CGRectGetMaxY(self.orderNoLab.frame) + 10;
    
}



@end
