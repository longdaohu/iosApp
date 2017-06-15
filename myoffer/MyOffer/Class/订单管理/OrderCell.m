//
//  OrderTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import "OrderItem.h"
#import "OrderCell.h"
#import "OrderItemFrame.h"

@interface OrderCell ()
//订单名称
@property(nonatomic,strong)UILabel *titleLab;
//订单状态
@property(nonatomic,strong)UILabel *statusLab;
//订单编号
@property(nonatomic,strong)UILabel *orderNoLab;

@property(nonatomic,strong)UIView  *line;
//订单价格
@property(nonatomic,strong)UILabel *feeLab;
//取消按钮
@property(nonatomic,strong)UIButton  *cancelBtn;
//支付按钮
@property(nonatomic,strong)UIButton  *payBtn;

@end

@implementation OrderCell


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    OrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"order"];
    
    if (!cell) {
        
        cell =[[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"order"];
    }
    
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLab = [UILabel labelWithFontsize:14  TextColor:XCOLOR_TITLE TextAlignment:NSTextAlignmentLeft];
        self.titleLab.numberOfLines = 0;
        [self.contentView addSubview:self.titleLab];
        
        self.orderNoLab =[UILabel labelWithFontsize:12  TextColor:XCOLOR_SUBTITLE TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.orderNoLab];
        
        self.statusLab =[UILabel labelWithFontsize:12  TextColor:XCOLOR_SUBTITLE TextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.statusLab];
        
        
        UIView *line = [UIView new];
        self.line = line;
        line.backgroundColor = XCOLOR_line;
        [self.contentView addSubview:line];
        
        
        self.feeLab =[UILabel labelWithFontsize:14  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.feeLab];
        
        
        self.cancelBtn = [[UIButton alloc] init];
        [self.cancelBtn setTitle:@"取消订单"  forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.cancelBtn setTitleColor:XCOLOR_SUBTITLE  forState:UIControlStateNormal];
        self.cancelBtn.backgroundColor = XCOLOR_WHITE;
        self.cancelBtn.layer.cornerRadius = CORNER_RADIUS;
        self.cancelBtn.layer.borderWidth = 1;
        self.cancelBtn.layer.borderColor = XCOLOR_SUBTITLE.CGColor;
        self.cancelBtn.tag = 11;
        [self.cancelBtn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelBtn];
        
        
        self.payBtn = [[UIButton alloc] init];
        [self.payBtn setTitleColor:XCOLOR_WHITE  forState:UIControlStateNormal];
        [self.payBtn setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_RED] forState:UIControlStateNormal];
        [self.payBtn setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_Disable] forState:UIControlStateDisabled];
        self.payBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.payBtn setTitle:@"去支付"  forState:UIControlStateNormal];
        self.payBtn.backgroundColor = XCOLOR_RED;
        self.payBtn.layer.cornerRadius = CORNER_RADIUS;
        self.payBtn.layer.masksToBounds = YES;
        self.payBtn.tag = 10;
        [self.payBtn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.payBtn];
        
 
        
    }
     return self;
}


-(void)setOrderFrame:(OrderItemFrame *)orderFrame{

    _orderFrame = orderFrame;
    
    self.titleLab.frame = orderFrame.SKU_frame;
    self.orderNoLab.frame = orderFrame.order_id_frame;
    self.statusLab.frame = orderFrame.status_frame;
    self.line.frame = orderFrame.line_frame;
    self.feeLab.frame = orderFrame.total_fee_frame;
    self.cancelBtn.frame = orderFrame.cancel_frame;
    self.payBtn.frame = orderFrame.pay_frame;
    
    
    OrderItem *order = orderFrame.order;
    self.titleLab.text = order.SKU;
    self.orderNoLab.text = order.order_id_str;
    self.feeLab.text = order.total_fee_str;
    self.statusLab.text =  order.status_order;

    self.cancelBtn.hidden = order.cancelBtn_hiden;
    self.payBtn.enabled = order.cancelBtn_hiden ?  NO :  YES;
    
    [self.payBtn setTitle: order.status_pay forState:UIControlStateNormal];
    
}


-(void)onclick:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(cellIndexPath:sender:)]) {
        
        [self.delegate cellIndexPath:self.indexPath sender:sender];
    }
}



@end
