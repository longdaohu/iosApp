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
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *orderTitleLab;
@property(nonatomic,strong)UILabel *orderStatusLab;
@property(nonatomic,strong)UILabel *orderNoLab;
@property(nonatomic,strong)UILabel *orderPriceLab;
@property(nonatomic,strong)UIButton  *cancelBtn;
@property(nonatomic,strong)UIButton  *editBtn;
@property(nonatomic,strong)UIButton  *payBtn;
@property(nonatomic,strong)NSIndexPath  *indexPath;

@end

@implementation OrderCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"order"];
    
    if (!cell) {
        
        cell =[[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"order"];
    }
    
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    
    return cell;
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.editBtn = [[UIButton alloc] init];
        self.editBtn.backgroundColor = XCOLOR_WHITE;
        [self.editBtn setImage:[UIImage imageNamed:@"check-icons-yes"] forState:UIControlStateSelected];
        [self.editBtn setImage:[UIImage imageNamed:@"check-icons"] forState:UIControlStateNormal];
        self.editBtn.tag = 12;
        [self.editBtn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.editBtn];
        
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = XCOLOR_WHITE;
        [self.contentView addSubview:self.bgView];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self.bgView addGestureRecognizer:tap];
        
        self.orderTitleLab = [UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.orderTitleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.bgView addSubview:self.orderTitleLab];
        
        self.orderStatusLab =[UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR_LIGHTBLUE TextAlignment:NSTextAlignmentRight];
        [self.bgView addSubview:self.orderStatusLab];
        
        self.orderNoLab =[UILabel labelWithFontsize:KDUtilSize(13)  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
        [self.bgView addSubview:self.orderNoLab];
        
        self.orderPriceLab =[UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.bgView addSubview:self.orderPriceLab];
        
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
        [self.bgView addSubview:self.cancelBtn];
        
        self.payBtn = [[UIButton alloc] init];
        [self.payBtn setTitleColor:XCOLOR_WHITE  forState:UIControlStateNormal];
        self.payBtn.titleLabel.font = [UIFont systemFontOfSize:KDUtilSize(16)];
        [self.payBtn setTitle:@"去支付"  forState:UIControlStateNormal];
        self.payBtn.backgroundColor = XCOLOR_RED;
        self.payBtn.layer.cornerRadius =2;
        self.payBtn.tag = 10;
        [self.payBtn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.payBtn];
        
        self.contentView.backgroundColor = XCOLOR_BG;
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
    
    CGFloat editX = 0;
    CGFloat editY = 0;
    CGFloat editW = 50;
    CGFloat editH =  contentSize.height - editY;
    self.editBtn.frame = CGRectMake(editX, editY, editW, editH);

    
    CGFloat bgX =  self.cellEdit ? 50 : 0;
    CGFloat bgY = editY;
    CGFloat bgW = contentSize.width;
    CGFloat bgH = editH;
    self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
    
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
    CGFloat payH = bgH  * 0.3;
    CGFloat payX = contentSize.width  - payW  - 10;
    CGFloat payY = CGRectGetHeight(self.bgView.frame) - 10 - payH;
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


-(void)onclick:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(cellIndexPath:sender:)]) {
        
        [self.delegate cellIndexPath:self.indexPath sender:sender];
    }
    
}

-(void)tap{

    [self onclick:nil];
}

@end
