//
//  OrderDetailFooterView.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "OrderDetailFooterView.h"

@interface OrderDetailFooterView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *orderDescriptionLab;
@property(nonatomic,strong)UILabel *orderRecordLab;
@property(nonatomic,strong)UILabel *NoOneRecordLab;
@property(nonatomic,strong)UILabel *NoTwoRecordLab;
@property(nonatomic,strong)UILabel *orderPriceLab;
@property(nonatomic,strong)UILabel *payTimeLab;
@property(nonatomic,strong)UILabel *TimeLab;
@property(nonatomic,strong)UIButton  *cancelBtn;
@property(nonatomic,strong)UIButton  *payBtn;

@end

@implementation OrderDetailFooterView

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
        
        
        self.orderDescriptionLab =[UILabel labelWithFontsize:KDUtilSize(12.5)  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
        [self.bgView addSubview:self.orderDescriptionLab];
        self.orderDescriptionLab.numberOfLines = 2;
        
        self.orderRecordLab =[UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.bgView addSubview:self.orderRecordLab];
        self.orderRecordLab.text = @"状态记录";
        
        
        self.NoOneRecordLab =[UILabel labelWithFontsize:KDUtilSize(12.5)  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
        [self.bgView addSubview:self.NoOneRecordLab];
 
        
        self.NoTwoRecordLab =[UILabel labelWithFontsize:KDUtilSize(12.5)  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
        [self.bgView addSubview:self.NoTwoRecordLab];
        
        
        self.orderPriceLab =[UILabel labelWithFontsize:KDUtilSize(20)  TextColor:XCOLOR_RED TextAlignment:NSTextAlignmentRight];
        [self.bgView addSubview:self.orderPriceLab];
        self.orderPriceLab.textColor = [UIColor colorWithRed:156.0/255 green:132.0/255 blue:63.0/255 alpha:1];
        
        self.payTimeLab =[UILabel labelWithFontsize:KDUtilSize(13)  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
        [self.bgView addSubview:self.payTimeLab];
        self.payTimeLab.text =  @"剩余支付时间";
        
        self.TimeLab =[UILabel labelWithFontsize:KDUtilSize(13)  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
        [self.bgView addSubview:self.TimeLab];
        self.TimeLab.hidden = YES;
        self.payTimeLab.hidden = YES;
        
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
    }
    
    
    return self;
}


-(void)setOrderDict:(NSDictionary *)orderDict{

    _orderDict = orderDict;
    
    NSString *payStr = [NSString stringWithFormat:@"￥%@元",orderDict[@"total_fee"]];
    NSMutableAttributedString *attribStr = [[NSMutableAttributedString alloc] initWithString:payStr];
    [attribStr addAttribute:NSForegroundColorAttributeName value:XCOLOR_BLACK range:NSMakeRange(1, payStr.length - 1)];
    [attribStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KDUtilSize(13)] range:NSMakeRange(payStr.length - 1, 1)];
    [attribStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:KDUtilSize(16)] range:NSMakeRange(0, 1)];
    self.orderPriceLab.attributedText = attribStr;
    [self statusWithTag:orderDict[@"status"]];
    
    
    NSString *description  = [NSString stringWithFormat:@"* %@",[orderDict[@"SKUs"][0] valueForKey:@"description"]];
    CGSize descriptionSize = [description KD_sizeWithAttributeFont:[UIFont systemFontOfSize:KDUtilSize(12.5)]];
    
    CGFloat descriptionX = 10;
    CGFloat descriptionY = 10;
    CGFloat descriptionW = XSCREEN_WIDTH - descriptionX * 2;
    CGFloat descriptionH = descriptionSize.width > descriptionW ? descriptionSize.height * 2 + 5 : descriptionSize.height;
    self.orderDescriptionLab.frame = CGRectMake(descriptionX, descriptionY, descriptionW, descriptionH);
    self.orderDescriptionLab.text  = description;
    
    BOOL SKUsEmpty = [orderDict[@"SKUs"][0] valueForKey:@"description"];
    self.orderDescriptionLab.hidden = !SKUsEmpty;
    
    
    CGFloat recordX = 10;
    CGFloat recordY =  self.orderDescriptionLab.hidden ?  10 : CGRectGetMaxY(self.orderDescriptionLab.frame)  + 10;
    CGFloat recordW = XSCREEN_WIDTH;
    CGFloat recordH = 20;
    self.orderRecordLab.frame = CGRectMake(recordX, recordY, recordW, recordH);
    
    CGFloat oneX =  recordX;
    CGFloat oneW = XSCREEN_WIDTH;
    CGFloat oneY = CGRectGetMaxY(self.orderRecordLab.frame)  +5;
    CGFloat oneH = 15;
    self.NoOneRecordLab.frame = CGRectMake(oneX, oneY, oneW, oneH);
    
    
    CGFloat twoX = oneX;
    CGFloat twoY = CGRectGetMaxY(self.NoOneRecordLab.frame);
    CGFloat twoW = XSCREEN_WIDTH;
    CGFloat twoH =  [orderDict[@"status"] isEqualToString:@"ORDER_PAY_PENDING"] ?0:oneH;
    self.NoTwoRecordLab.frame = CGRectMake(twoX, twoY, twoW, twoH);
    
    
    CGFloat priceX =  0;
    CGFloat priceY = CGRectGetMaxY(self.NoTwoRecordLab.frame) + 10;
    CGFloat priceW = XSCREEN_WIDTH - 10;
    CGFloat priceH =  30 ;
    self.orderPriceLab.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    
    CGFloat payW = XSCREEN_WIDTH * 0.3;
    CGFloat payH = 40;
    CGFloat payX = priceW - payW;
    CGFloat payY = CGRectGetMaxY(self.orderPriceLab.frame) + 10;
    self.payBtn.frame = CGRectMake(payX, payY, payW, payH);
    
    CGFloat cancelW = payW;
    CGFloat cancelH = payH;
    CGFloat cancelX = payX  - cancelW  - 10;
    CGFloat cancelY = payY;
    self.cancelBtn.frame = CGRectMake(cancelX, cancelY, cancelW, cancelH);
    
    
    CGFloat payTimeX = recordX;
    CGFloat payTimeY = payY;
    CGFloat payTimeW = cancelX - payTimeX;
    CGFloat payTimeH = payH * 0.5;
    self.payTimeLab.frame = CGRectMake(payTimeX, payTimeY, payTimeW, payTimeH);
    
    
    CGFloat TimeX = recordX;
    CGFloat TimeY = CGRectGetMaxY(self.payTimeLab.frame);
    CGFloat TimeW = payTimeW;
    CGFloat TimeH = payTimeH;
    self.TimeLab.frame = CGRectMake(TimeX, TimeY, TimeW, TimeH);
    
    
    CGFloat bgX = 0;
    CGFloat bgY = 0;
    CGFloat bgW = XSCREEN_WIDTH;
    CGFloat bgH = CGRectGetMaxY(self.payBtn.frame) + 10;
    self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
    
    
    self.headHeight = CGRectGetMaxY(self.bgView.frame);
 
    
    NSArray *logs =orderDict[@"logs"];
    NSDictionary *log  = logs[0];
    NSString *create_at =[self makeTime:log[@"create_at"] andStatus:@"创建订单："];
    self.NoOneRecordLab.text = create_at;

    
    if ([orderDict[@"status"] isEqualToString:@"ORDER_FINISHED"]) {
        
        NSArray *trades =orderDict[@"trades"];
        NSDictionary *trade  = trades[0];
    
        NSString *temp;
        NSString *payTime = [self makeTime:trade[@"create_at"] andStatus:@"完成订单："];
        if([orderDict[@"status"] isEqualToString:@"ORDER_FINISHED"]){
            NSString *system = @"支付成功";
            if ([trade[@"system"] isEqualToString:@"wechat_pay"] ) {
                system = @"使用微信支付成功";
            }else if ([trade[@"system"] isEqualToString:@"alipay"] ) {
                system = @"使用支付宝支付成功";
            }else if ([trade[@"system"] isEqualToString:@"qq_pay"] ) {
                system =  @"使用QQ支付成功";
            }else if ([trade[@"system"] isEqualToString:@"tenpay"] ) {
                system =  @"使用财付通支付成功";
            }
            temp = [NSString stringWithFormat:@"%@ %@",payTime,system];
        }
         self.NoTwoRecordLab.text =  temp;
        
    }else  if ([orderDict[@"status"] isEqualToString:@"ORDER_PAY_PENDING"]) {
      
        self.TimeLab.hidden = NO;
        self.payTimeLab.hidden = NO;
        
        //设置转换格式
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *endDate=[formatter dateFromString:[self makeTime:orderDict[@"expired_at"]  andStatus:@""]];
        NSDate *endLocalDate=[self localDate:endDate];
  
        
        NSDate *currentDate = [NSDate date];
        NSDate *currentLocaleDate = [self localDate:currentDate];
        CGFloat len =[endLocalDate timeIntervalSinceDate:currentLocaleDate] - 30;
  
        
        NSInteger hour = (NSInteger)len / 3600;
        NSInteger min =  (NSInteger)len%3600/60;
//        NSInteger second =  (NSInteger)len % 60;
        self.TimeLab.text = (min <= 9 && hour <=0)? @"订单即将关闭，请尽快完成支付！":[NSString stringWithFormat:@"%ld小时%ld分",(long)hour,(long)min];
        
    }else  if ([orderDict[@"status"] isEqualToString:@"ORDER_CLOSED"]) {
 
          NSDictionary *log1  = logs[1];
          NSString *operator = [log1[@"operator"] isEqualToString:@"BUYER"] ? @"手动取消订单。":@"支付超时，订单关闭。";
          self.NoTwoRecordLab.text = [NSString stringWithFormat:@"%@ %@",[self makeTime:log1[@"create_at"] andStatus:@"关闭订单："],operator];

    }else {
        
 
    }
    
}

-(NSDate *)localDate:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
   return  [date  dateByAddingTimeInterval: interval];
}

-(NSString *)makeTime:(NSString *)time andStatus:(NSString *)status
{
   
    NSString *temp =[time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSRange fromRange = [time rangeOfString:@"."];
    NSString *dateString = [temp substringToIndex:fromRange.location];
    
    
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate=[formatter dateFromString: dateString];
    
    NSDate *currentLocalDate=[self localDate:currentDate];
    
    NSString *currentDateString = [formatter stringFromDate:currentLocalDate];
    
 
    return [NSString stringWithFormat:@"%@%@",status,currentDateString];
}



-(void)statusWithTag:(NSString *)status
{
    
    self.cancelBtn.hidden = ![status isEqualToString:@"ORDER_PAY_PENDING"];
    self.payBtn.enabled = [status isEqualToString:@"ORDER_PAY_PENDING"];
    
    NSString *payString;
    if ([status isEqualToString:@"ORDER_FINISHED"]) {
        
        
         payString = @"已完成";
    }else  if ([status isEqualToString:@"ORDER_PAY_PENDING"]) {
        
        payString = @"去支付";
        
    }else  if ([status isEqualToString:@"ORDER_CLOSED"]) {
        
         payString = @"已关闭";
        
    }else{
        
         payString = @"已退款";
    }
    
    [self.payBtn setTitle:payString  forState:UIControlStateNormal];
    
     self.payBtn.backgroundColor = self.payBtn.enabled ? XCOLOR_RED : XCOLOR_LIGHTGRAY;

}

-(void)onclick:(UIButton *)sender
{
    if (self.actionBlock) {
        
        self.actionBlock(sender);
     }
}

@end
