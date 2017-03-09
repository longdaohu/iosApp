//
//  OrderTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import "OrderItem.h"
#import "OrderCell.h"
@interface OrderCell ()
//订单名称
@property(nonatomic,strong)UILabel *orderTitleLab;
//订单状态
@property(nonatomic,strong)UILabel *orderStatusLab;
//订单编号
@property(nonatomic,strong)UILabel *orderNoLab;
//订单价格
@property(nonatomic,strong)UILabel *orderPriceLab;
//取消按钮
@property(nonatomic,strong)UIButton  *cancelBtn;
//支付按钮
@property(nonatomic,strong)UIButton  *payBtn;
@property(nonatomic,strong)NSIndexPath  *indexPath;

@end

@implementation OrderCell


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    OrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"order"];
    
    if (!cell) {
        
        cell =[[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"order"];
    }
    
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    NSIndexPath *path = [tableView indexPathForCell:cell];
    
    cell.indexPath = path;
    
    return cell;
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.orderTitleLab = [UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.orderTitleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.orderTitleLab];
        
        
        self.orderStatusLab =[UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR_LIGHTBLUE TextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.orderStatusLab];
        
        
        self.orderNoLab =[UILabel labelWithFontsize:KDUtilSize(13)  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.orderNoLab];
        
        
        self.orderPriceLab =[UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.orderPriceLab];
        
        
        self.cancelBtn = [[UIButton alloc] init];
        [self.cancelBtn setTitle:@"取消订单"  forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:KDUtilSize(16)];
        [self.cancelBtn setTitleColor:XCOLOR_LIGHTGRAY  forState:UIControlStateNormal];
        self.cancelBtn.backgroundColor = XCOLOR_WHITE;
        self.cancelBtn.layer.cornerRadius =2;
        self.cancelBtn.layer.borderWidth = 1;
        self.cancelBtn.layer.borderColor = XCOLOR_LIGHTGRAY.CGColor;
        self.cancelBtn.tag = 11;
        [self.cancelBtn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelBtn];
        
        
        self.payBtn = [[UIButton alloc] init];
        [self.payBtn setTitleColor:XCOLOR_WHITE  forState:UIControlStateNormal];
        self.payBtn.titleLabel.font = [UIFont systemFontOfSize:KDUtilSize(16)];
        [self.payBtn setTitle:@"去支付"  forState:UIControlStateNormal];
        self.payBtn.backgroundColor = XCOLOR_RED;
        self.payBtn.layer.cornerRadius =2;
        self.payBtn.tag = 10;
        [self.payBtn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.payBtn];
        
        self.contentView.backgroundColor = XCOLOR_BG;
        
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self.contentView addGestureRecognizer:tap];
        
    }
     return self;
}





-(void)setOrder:(OrderItem *)order{
 
    _order = order;
    
    NSDictionary *sku = [order.SKUs firstObject];
    self.orderTitleLab.text = sku[@"name"] ;
    self.orderNoLab.text = [NSString stringWithFormat:@"订单号：%@",order.order_id];
    self.orderPriceLab.text = [NSString stringWithFormat:@"价格：%@",order.total_fee];
    
    self.cancelBtn.hidden = order.cancelBtn_hiden;
    self.payBtn.enabled = order.cancelBtn_hiden ?  NO :  YES;
    self.payBtn.backgroundColor = self.payBtn.enabled ? XCOLOR_RED : XCOLOR_LIGHTGRAY;
    self.orderStatusLab.text =  order.status_order;
    [self.payBtn setTitle: order.status_pay forState:UIControlStateNormal];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;

    CGFloat titleX = 15;
    CGFloat titleY = 15;
    CGFloat titleH = KDUtilSize(16);
    CGSize orderSize =[self.orderTitleLab.text  KD_sizeWithAttributeFont:[UIFont systemFontOfSize:KDUtilSize(16)]];
    CGFloat titleW = self.orderTitleLab.text ? orderSize.width :contentSize.width - 120;
    titleW = titleW > contentSize.width - 120 ? contentSize.width - 120 : titleW;
    self.orderTitleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    
    
    CGFloat statusW = 100;
    CGFloat statusX =  contentSize.width - statusW - 10;
    CGFloat statusY = titleY;
    CGFloat statusH = titleH;
    self.orderStatusLab.frame = CGRectMake(statusX, statusY, statusW, statusH);
    
    
    
    CGFloat noX = titleX;
    CGFloat noY = CGRectGetMaxY(self.orderTitleLab.frame) + 5;
    CGFloat noW = contentSize.width;
    CGFloat noH = KDUtilSize(13);
    self.orderNoLab.frame = CGRectMake(noX, noY, noW, noH);

    
    
    CGFloat payW = contentSize.width * 0.3;
    CGFloat payH = contentSize.height  * 0.3;
    CGFloat payX = contentSize.width  - payW  - 10;
    CGFloat payY = contentSize.height - 10 - payH;
    self.payBtn.frame = CGRectMake(payX, payY, payW, payH);
    
    
    CGFloat cancelW = payW;
    CGFloat cancelH = payH;
    CGFloat cancelX = payX  - cancelW  - 10;
    CGFloat cancelY = payY;
    self.cancelBtn.frame = CGRectMake(cancelX, cancelY, cancelW, cancelH);
    
    
    CGFloat priceX = titleX;
    CGFloat priceH = KDUtilSize(16);
    CGFloat priceY = CGRectGetMaxY(self.orderNoLab.frame) + 5;
    CGFloat priceW = contentSize.width ;
    self.orderPriceLab.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    
}


-(void)onclick:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(cellIndexPath:sender:)]) {
        
        [self.delegate cellIndexPath:self.indexPath sender:sender];
    }
}

-(void)tap{

    [self onclick:nil];
}

@end
