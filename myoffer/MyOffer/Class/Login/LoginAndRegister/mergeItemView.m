//
//  mergeItemView.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/10.
//  Copyright © 2016年 UVIC. All rights reserved.
//


#import "mergeItemView.h"


@interface mergeItemView ()
@property(nonatomic,strong)UIView *bgView;              //1、背景
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *subtitleLab;
@property(nonatomic,strong)UIButton *selectBtn;         //7、选择边框

@end

@implementation mergeItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        //1、背景
        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor = XCOLOR_WHITE;
        [self  addSubview:self.bgView];
        self.bgView.layer.cornerRadius = CORNER_RADIUS;
        self.bgView.layer.borderColor =  XCOLOR(204, 204, 204 , 1).CGColor;
        self.bgView.layer.borderWidth = 0.5;
        
        //1、推荐图标
        self.logoView =[[UIImageView alloc] init];
        self.logoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.bgView addSubview:self.logoView];
        
        //2、名称
        self.titleLab =[UILabel labelWithFontsize:16 TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentCenter];
        [self.bgView addSubview:self.titleLab];
        
        //3、描述
        self.subtitleLab =[UILabel labelWithFontsize:13 TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentCenter];
        [self.bgView addSubview:self.subtitleLab];

        
        //7、选择边框
        self.selectBtn =[[UIButton alloc] init];
        [self.selectBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        self.selectBtn.layer.cornerRadius = CORNER_RADIUS;
        self.selectBtn.layer.borderColor = XCOLOR_RED.CGColor;
        [self addSubview:self.selectBtn];
        
    }
    return self;
}




- (void)onClick:(UIButton *)sender{
    
        if (self.actionBlock) {
            
            self.actionBlock(self.itemAccout[@"_id"]);
            
         }
    
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat bgX = 2;
    CGFloat bgY = 2;
    CGFloat bgW = contentSize.width - 2 * bgX;
    CGFloat bgH = contentSize.height - 2 * bgY;
    self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
    
    CGFloat selectX = 0;
    CGFloat selectY = 0;
    CGFloat selectW = contentSize.width - 2 * selectX;
    CGFloat selectH = contentSize.height;
    self.selectBtn.frame = CGRectMake(selectX, selectY, selectW, selectH);
    
    
    CGFloat rmX = XSCREEN_WIDTH <= 320 ? 5 : 20;
    CGFloat rmY =   0;
    CGFloat rmW =  40;
    CGFloat rmH =  contentSize.height;
    self.logoView.frame = CGRectMake(rmX, rmY, rmW, rmH);
    
    CGFloat titleX =  0;
    CGFloat titleH = 20;
    CGFloat titleW = bgW;
    CGFloat subTitleX = titleX;
    CGFloat subTitleW = titleW;
    CGFloat subTitleH = 13;
    
    CGFloat titleY = 0.5 * (bgH - titleH - subTitleH - 5);
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat subTitleY = CGRectGetMaxY(self.titleLab.frame) + 5;
    self.subtitleLab.frame = CGRectMake(subTitleX, subTitleY, subTitleW, subTitleH);
    
    
}


- (void)mergeItemViewInSelected:(BOOL)selected{
    
    self.selectBtn.selected =  selected;
    self.selectBtn.layer.borderWidth = selected ? 1 : 0;
    
}


- (void)setItemAccout:(NSDictionary *)itemAccout{

    _itemAccout = itemAccout;
   
    NSString *hadPaid = @"已购买付费项";
    NSString *hadApplied = @"申请中心已使用；";
    
    NSString *paid = itemAccout[@"paid"] ? hadPaid : @"未购买付费项";
    NSString *applied = itemAccout[@"applied"] ? hadApplied : @"申请中心未使用；";
    
    NSString *displayname;
    if (itemAccout[@"displayname"]) {
        
        displayname = itemAccout[@"displayname"];
    }
    
    if (itemAccout[@"phonenumber"]) {
        
        displayname = itemAccout[@"phonenumber"];
    }
    
    self.titleLab.text = displayname;
    
    NSString *subString = [NSString stringWithFormat:@"%@%@",applied,paid];
    NSRange paidRange = [subString rangeOfString:hadPaid];
    NSRange appliedRange = [subString rangeOfString:hadApplied];
    NSMutableAttributedString *AtributeStr = [[NSMutableAttributedString alloc] initWithString:subString];
    [AtributeStr addAttribute:NSForegroundColorAttributeName value:XCOLOR_RED range: paidRange];
    [AtributeStr addAttribute:NSForegroundColorAttributeName value:XCOLOR_RED range: appliedRange];
    self.subtitleLab.attributedText = AtributeStr;
 
}


@end

