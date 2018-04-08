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
@property (weak, nonatomic) IBOutlet UIView *shadowView;


@end


@implementation PayHeaderView

-(void)awakeFromNib{

    [super awakeFromNib];

    self.bgView.backgroundColor = XCOLOR_BG;
    self.backgroundColor = XCOLOR_BG;

    self.shadowView.layer.shadowColor = XCOLOR_BLACK.CGColor;
    self.shadowView.layer.shadowOpacity = 0.1;
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    
}

-(void)setOrder:(OrderItem *)order{
 
    _order = order;
 
    self.productNameLab.text = order.SKU;
    self.orderNoLab.text =   order.order_id;
    self.payCountLab.text = [NSString stringWithFormat:@"￥%@", order.total_fee];
    
}





@end
