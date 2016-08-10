//
//  ServiceItemView.m
//  myOffer
//
//  Created by xuewuguojie on 16/7/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "ServiceItemView.h"

@interface ServiceItemView ()
@property(nonatomic,strong)UIView *bgView;              //1、背景
@property(nonatomic,strong)UIImageView *recommentView;  //2、推荐图标
@property(nonatomic,strong)UILabel *titleLab;           //3、套餐名称
@property(nonatomic,strong)UILabel *priceLab;           //4、套餐价格
@property(nonatomic,strong)UIImageView *priceIconView;  //5、套餐价格
@property(nonatomic,strong)UILabel *subTittleLab;       //6、套餐小标题
@property(nonatomic,strong)UIButton *selectBtn;         //7、选择边框

@end

@implementation ServiceItemView

+(instancetype)View{
 
    return [[ServiceItemView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //1、背景
        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor = XCOLOR_WHITE;
        [self addSubview:self.bgView];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.borderColor =  XCOLOR(204, 204, 204).CGColor;
        self.bgView.layer.borderWidth = 0.5;
        
        //2、推荐图标
        self.recommentView =[[UIImageView alloc] init];
        self.recommentView.image = [UIImage imageNamed:@"TJ_recoment"];
        [self addSubview:self.recommentView];
        
        //3、套餐名称
        self.titleLab =[UILabel labelWithFontsize:KDUtilSize(16) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.bgView addSubview:self.titleLab];
        
        //4、套餐价格
        self.priceLab =[UILabel labelWithFontsize:KDUtilSize(20) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentRight];
        self.priceLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:KDUtilSize(22)];
        [self.bgView addSubview:self.priceLab];
         
         //5、套餐价格
//        self.priceIconView =[[UIImageView alloc] init];
//        self.priceIconView.contentMode =  UIViewContentModeScaleAspectFit;
//        [self.bgView addSubview:self.priceIconView];
        
        //6、套餐小标题
        self.subTittleLab =[UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentRight];
//        self.subTittleLab.text = @"*仅为押金，拿到offer并留学成功后返还";
        [self.bgView addSubview:self.subTittleLab];
        
         //7、选择边框
        self.selectBtn =[[UIButton alloc] init];
        [self.selectBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        self.selectBtn.layer.cornerRadius = 5;
        self.selectBtn.layer.borderColor = XCOLOR_RED.CGColor;
        [self addSubview:self.selectBtn];
    }
    return self;
}


-(void)setServiceDict:(NSDictionary *)serviceDict{
   
    _serviceDict = serviceDict;
    
    

     self.titleLab.text = serviceDict[@"name"];
    
    self.subTittleLab.text = serviceDict[@"note"] ? serviceDict[@"note"]: @"";
    
    self.recommentView.hidden = !serviceDict[@"recommended"];
    
    NSString *price  =[NSString stringWithFormat:@"￥%@元",serviceDict[@"total_fee"]];
    
     NSMutableAttributedString *attribStr = [[NSMutableAttributedString alloc] initWithString:price];
    [attribStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:KDUtilSize(16)] range:NSMakeRange(price.length - 1, 1)];
    [attribStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:KDUtilSize(16)] range:NSMakeRange(0, 1)];
    [attribStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:156/255.0 green:132/255.0 blue:63/255.0 alpha:1] range:NSMakeRange(0, 1)];
    self.priceLab.attributedText = attribStr;
    

    CGSize priceSize = [self.priceLab.text  KD_sizeWithAttributeFont:[UIFont fontWithName:@"Helvetica-Bold" size:KDUtilSize(20)]];
    CGFloat priceX = 0;
    CGFloat priceY = 0.5 * (self.bgView.height - priceSize.height);
    CGFloat priceW = self.subTittleLab.width;
    CGFloat priceH = priceSize.height;
    self.priceLab.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
}





-(void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat bgX = 15;
    CGFloat bgY = 2;
    CGFloat bgW = self.bounds.size.width - 2 * bgX;
    CGFloat bgH = self.bounds.size.height - 4;
    self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
    
    
    CGFloat selectX = 13;
    CGFloat selectY = 0;
    CGFloat selectW = self.bounds.size.width - 2 * selectX;
    CGFloat selectH = self.bounds.size.height;
    self.selectBtn.frame = CGRectMake(selectX, selectY, selectW, selectH);
    
    CGFloat rmX = 14;
    CGFloat rmY = 0;
    CGFloat rmW = bgH * 0.6;
    CGFloat rmH = rmW;
    self.recommentView.frame = CGRectMake(rmX, rmY, rmW, rmH);
    
    CGFloat titleX = 15;
    CGFloat titleH = 20;
    CGFloat titleY = 0.5 * (self.bounds.size.height - titleH);
    CGFloat titleW = bgW * 0.6;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat subTitleX = 0;
    CGFloat subTitleH = 15;
    CGFloat subTitleY = bgH - 25;
    CGFloat subTitleW = bgW - bgX;
    self.subTittleLab.frame = CGRectMake(subTitleX, subTitleY, subTitleW, subTitleH);

  

    
    
}

-(void)onClick:(UIButton *)sender{

    sender.selected =  !sender.selected;
    sender.layer.borderWidth = sender.selected ? 1 : 0;
    
    if (self.actionBlock) {
        
        self.actionBlock(sender,self.serviceDict[@"_id"]);
        
    }
    
}

-(void)click{

    self.selectBtn.selected =  NO;
    self.selectBtn.layer.borderWidth =  self.selectBtn.selected ? 1 : 0;
}



@end
