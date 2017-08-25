//
//  OrderDetailHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "OrderDetailHeaderView.h"
//#import "HMTitleButton.h"

@interface OrderDetailHeaderView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *orderTitleLab;
@property(nonatomic,strong)UILabel *orderNoLab;
//@property(nonatomic,strong)HMTitleButton *orderDetailBtn;

@end


@implementation OrderDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = XCOLOR_WHITE;
        [self addSubview:self.bgView];
        self.bgView.layer.shadowColor = XCOLOR_BLACK.CGColor;
        self.bgView.layer.shadowOpacity = 0.2;
        self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
        

        self.orderTitleLab =[UILabel labelWithFontsize:16  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.orderTitleLab.numberOfLines = 0;
        [self.bgView  addSubview:self.orderTitleLab];
        

        self.orderNoLab =[UILabel labelWithFontsize:KDUtilSize(13)  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
        [self.bgView  addSubview:self.orderNoLab];


    }
    return self;
}


-(void)onclick:(UIButton *)sender
{
    
    sender.selected = !sender.selected;
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
}

-(void)setOrder:(OrderItem *)order{
    
    
    _order = order;
    
    NSDictionary *sku       = [order.SKUs firstObject];
    self.orderTitleLab.text = [NSString stringWithFormat:@"*%@",sku[@"name"]];
    self.orderNoLab.text    = [NSString stringWithFormat:@"订单号 ： %@",order.order_id];

    CGFloat titleX = 10;
    CGFloat titleY = 10;
    CGFloat titleW = XSCREEN_WIDTH - titleX * 2;
    CGSize orderSize = [self.orderTitleLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16] maxWidth:titleW];
    CGFloat titleH = orderSize.height;
    self.orderTitleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    
    CGFloat noX = titleX;
    CGFloat noY = CGRectGetMaxY(self.orderTitleLab.frame) + 5;
    CGFloat noW = XSCREEN_WIDTH;
    CGFloat noH = 20;
    self.orderNoLab.frame = CGRectMake(noX, noY, noW, noH);
    

    CGFloat bgX = 0;
    CGFloat bgY = 15;
    CGFloat bgW = XSCREEN_WIDTH;
    CGFloat bgH = CGRectGetMaxY(self.orderNoLab.frame) + 10;
    self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
    self.headHeight = CGRectGetMaxY(self.bgView.frame);
    
}


- (void)headerSelectButtonHiden{
  
    self.orderTitleLab.text = [self.orderTitleLab.text substringWithRange:NSMakeRange(1, self.orderTitleLab.text.length - 1)];
}


@end
