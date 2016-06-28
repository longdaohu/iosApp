//
//  PayHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PayHeaderView.h"
#import "OrderItem.h"

@interface PayHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *notiLab;
@property (weak, nonatomic) IBOutlet UILabel *productLab;
@property (weak, nonatomic) IBOutlet UILabel *productNameLab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *payLab;
@property (weak, nonatomic) IBOutlet UILabel *payCountLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *upView;

@end


@implementation PayHeaderView

-(void)awakeFromNib{

    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.shadowColor = XCOLOR_BLACK.CGColor;
    self.bgView.layer.shadowOpacity = 0.2;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.backgroundColor = BACKGROUDCOLOR;
    
    self.upView.layer.cornerRadius = 5;
    self.upView.layer.shadowColor = XCOLOR_BLACK.CGColor;
    self.upView.layer.shadowOpacity = 0.2;
    self.upView.layer.shadowOffset = CGSizeMake(0, 0);
    
}

-(void)setOrder:(OrderItem *)order{
 
    _order = order;
    NSDictionary *sku = [order.SKUs firstObject];
    self.productNameLab.text = sku[@"name"] ;
    self.orderNoLab.text =   order.orderId;
    self.payCountLab.text = [NSString stringWithFormat:@"￥%@", order.total_fee];
    
}





@end