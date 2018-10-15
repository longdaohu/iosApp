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
@property(nonatomic,strong)UIView *contactView;
@property(nonatomic,strong)UILabel *contact_titleLab;
@property(nonatomic,strong)UILabel *contact_subLab;
@property(nonatomic,strong)UIButton *lookBtn;
@property(nonatomic,strong)UIButton *downloadBtn;
@property(nonatomic,strong)UIButton *orderServiceBtn;//售后服务按钮hdr

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
        
        //售后服务按钮hdr
        UIButton *orderServiceBtn = [[UIButton alloc]init];
        orderServiceBtn.titleLabel.font = XFONT(12);
        NSMutableAttributedString *serviceStr = [[NSMutableAttributedString alloc]initWithString:@"售后服务"];
        NSRange strRange = NSMakeRange(0, [serviceStr length]);
        [serviceStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:strRange];
        [serviceStr addAttribute:NSForegroundColorAttributeName value:XCOLOR(5, 203, 249, 1) range:strRange];
        [orderServiceBtn setAttributedTitle:serviceStr forState:UIControlStateNormal];
        orderServiceBtn.tag = 100;
        [orderServiceBtn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:orderServiceBtn];
        self.orderServiceBtn = orderServiceBtn;
        
        [self makeContactView];
    }
    
    
    return self;
}

- (void)makeContactView{
 
    UIView *bgView = [UIView new];
    bgView.backgroundColor = XCOLOR_WHITE;
    [self insertSubview:bgView belowSubview:self.bgView];
    bgView.hidden = YES;
    self.contactView = bgView;
    
    UILabel *contact_titleLab =[UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR(78, 78, 78, 1) TextAlignment:NSTextAlignmentLeft];
    [bgView addSubview:contact_titleLab];
    contact_titleLab.text = @"合同信息";
    self.contact_titleLab = contact_titleLab;
    
    
    UILabel *contact_subLab =[UILabel labelWithFontsize:KDUtilSize(12)  TextColor:XCOLOR(187, 187, 187, 1) TextAlignment:NSTextAlignmentLeft];
    [bgView addSubview:contact_subLab];
    contact_subLab.text = @"合同名称:《产品合同》";
    self.contact_subLab = contact_subLab;
    
    UIButton *lookBtn = [[UIButton alloc] init];
    [lookBtn setTitleColor:XCOLOR(51, 51, 51, 1)   forState:UIControlStateNormal];
    lookBtn.titleLabel.font = XFONT(12);
    [lookBtn setTitle:@"查看"  forState:UIControlStateNormal];
    [lookBtn addTarget:self action:@selector(lookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:lookBtn];
    self.lookBtn = lookBtn;
    
    UIButton *downloadBtn = [[UIButton alloc] init];
    [downloadBtn setTitleColor:XCOLOR(51, 51, 51, 1)   forState:UIControlStateNormal];
    downloadBtn.titleLabel.font = XFONT(12);
    [downloadBtn setTitle:@"下载"  forState:UIControlStateNormal];
    [downloadBtn setTitle:@"下载中"  forState:UIControlStateSelected];
    [downloadBtn setTitle:@"下载完成"  forState:UIControlStateDisabled];
    [downloadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:downloadBtn];
    self.downloadBtn = downloadBtn;

}

- (void)setType:(OrderDetailDownloadStyle)type{
 
    _type = type;
    
    switch (type) {
      case  OrderDetailDownloadStyleLoaded:
            [self.downloadBtn setTitle:@"下载完成"  forState:UIControlStateNormal];
            self.downloadBtn.enabled = NO;
            break;
       case OrderDetailDownloadStyleLoading:
            self.downloadBtn.selected = YES;
            break;
        default:
            self.downloadBtn.selected = NO;
            break;
    }
    
}

- (void)downloadBtnClick:(UIButton *)sender{
    
    //下载中 、 下载完成都不可以再点击
    if (self.type != OrderDetailDownloadStyleNomal) return;
    
    if (self.orderDetailActionBlock) {
        self.orderDetailActionBlock(YES);
    }
}

- (void)lookBtnClick:(UIButton *)sender{
    if (self.orderDetailActionBlock) {
        self.orderDetailActionBlock(NO);
    }
}

-(void)setOrderDict:(NSDictionary *)orderDict{

    _orderDict = orderDict;
    
    NSString *price = [NSString stringWithFormat:@"%@",orderDict[@"total_fee"]];
    NSString *payStr = [NSString stringWithFormat:@"￥%@元",[price toDecimalStyleString]];
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
    NSString *create_at = [self makeTime:log[@"create_at"]];
    NSString *sub_title = @"订单创建成功";
    self.NoOneRecordLab.text = [NSString stringWithFormat:@"%@ %@",create_at,sub_title];
 
    if ([orderDict[@"status"] isEqualToString:@"ORDER_FINISHED"]) {
        
        NSArray *trades =orderDict[@"trades"];
        NSDictionary *trade  = trades[0];
    
        NSString *temp;
        NSString *payTime = [self makeTime:trade[@"create_at"]];
        // sub_title = @"完成订单";  Dead store: Value stored to 'sub_title' is never read
        
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
        
        NSDate *endDate=[formatter dateFromString:[self makeTime:orderDict[@"expired_at"]]];
        NSDate *endLocalDate=[self localDate:endDate];
  
        
        NSDate *currentDate = [NSDate date];
        NSDate *currentLocaleDate = [self localDate:currentDate];
        CGFloat len =[endLocalDate timeIntervalSinceDate:currentLocaleDate] - 30;
  
        
        NSInteger hour = (NSInteger)len / 3600;
        NSInteger min =  (NSInteger)len%3600/60;
        self.TimeLab.text = (min <= 9 && hour <=0)? @"订单即将关闭，请尽快完成支付！":[NSString stringWithFormat:@"%ld小时%ld分",(long)hour,(long)min];
        
    }else  if ([orderDict[@"status"] isEqualToString:@"ORDER_CLOSED"]) {
 
          NSDictionary *log1  = logs[1];
          NSString *operator = [log1[@"operator"] isEqualToString:@"BUYER"] ? @"手动取消订单。": @"支付超时，订单关闭。";
          self.NoTwoRecordLab.text = [NSString stringWithFormat:@"%@ %@",[self makeTime:log1[@"create_at"]],operator];
    }
    //售后服务hdr
    //    if([orderDict[@"sign"]isEqualToString:@"0"])
    //    {
    //        self.orderServiceBtn.hidden = YES;
    //    }else
    //    {
    //        self.orderRecordLab.hidden = NO;
    //    }
    
}
-(void)setAfterServiceDict:(NSDictionary *)afterServiceDict
{
    
    
}
-(NSDate *)localDate:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
   return  [date  dateByAddingTimeInterval: interval];
}


-(NSString *)makeTime:(NSString *)time
{
   
    NSString *temp =[time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSRange fromRange = [time rangeOfString:@"."];
    NSString *dateString = [temp substringToIndex:fromRange.location];
    
    
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate=[formatter dateFromString: dateString];
    NSDate *currentLocalDate=[self localDate:currentDate];
    
    NSString *currentDateString = [formatter stringFromDate:currentLocalDate];
    
 
    return currentDateString;
}



-(void)statusWithTag:(NSString *)status
{
    
    self.cancelBtn.hidden = ![status isEqualToString:@"ORDER_PAY_PENDING"];
    
    self.payBtn.enabled = [status isEqualToString:@"ORDER_PAY_PENDING"];
    
    NSString *payString;
    
    if ([status isEqualToString:@"ORDER_FINISHED"]) {
        
        payString  = @"已付款";
        
    }else   if ([status isEqualToString:@"ORDER_PAY_PENDING"]) {
        
        payString = @"待付款";
        
    }else  if ( [status isEqualToString:@"ORDER_CLOSED"]) {
        
        payString = @"订单关闭";
        
    }else  if ( [status isEqualToString:@"ORDER_REFUNDED"]) {
        
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


- (void)setContracturls_result:(NSDictionary *)contracturls_result{
    _contracturls_result = contracturls_result;
    NSArray *imgUrls = contracturls_result[@"imgUrls"];
    if (imgUrls.count > 0) {
        self.contactView.hidden = NO;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
 
    
        CGSize content_size  = self.bounds.size;
        CGFloat contact_bg_x  = 0;
        CGFloat contact_bg_w  = content_size.width;
        CGFloat contact_bg_h  = 71;
        CGFloat contact_bg_y  = CGRectGetMaxY(self.bgView.frame);
        self.contactView.frame = CGRectMake(contact_bg_x, contact_bg_y,contact_bg_w, contact_bg_h);
        
        
        CGFloat title_x = 10;
        CGFloat title_y = 15;
        CGFloat title_w = XSCREEN_WIDTH;
        CGFloat title_h = 20;
        self.contact_titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
        
        CGFloat sub_x = title_x;
        CGFloat sub_w = 170;
        CGFloat sub_h = 17;
        CGFloat sub_y = title_y + title_h + 5;
        self.contact_subLab.frame = CGRectMake(sub_x, sub_y, sub_w, sub_h);
        
        
        CGFloat down_w = 80;
        CGFloat down_x = content_size.width - down_w;
        CGFloat down_h = 27;
        CGFloat down_y = sub_y - 5;
        self.downloadBtn.frame = CGRectMake(down_x, down_y, down_w, down_h);
        
        
        CGFloat look_w = 80;
        CGFloat look_x = down_x - look_w;
        CGFloat look_h = down_h;
        CGFloat look_y = down_y;
        self.lookBtn.frame = CGRectMake(look_x, look_y, look_w, look_h);
    
        //售后服务按钮hdr
        CGFloat service_x = kScreenWidth - 80;
        CGFloat service_y = CGRectGetMaxY(self.contactView.frame)+13.5;
        CGFloat service_w = 80;
        CGFloat service_h = 27;
        self.orderServiceBtn.frame = CGRectMake(service_x, service_y, service_w, service_h);
}

@end
