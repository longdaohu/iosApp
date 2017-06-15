//
//  ServiceItemBottomView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/30.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceItemBottomView.h"

@interface ServiceItemBottomView ()
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UIView *left_line;
@property(nonatomic,strong)UIView *right_line;
@property(nonatomic,strong)UIButton *submit;
@property(nonatomic,strong)UIButton *call_btn;
@property(nonatomic,strong)UILabel *zi_Lab;
@property(nonatomic,strong)UIView *top_line;
@end

@implementation ServiceItemBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    if (self) [self makeUI];
    
    return self;
}

- (void)makeUI{
    
    self.backgroundColor = XCOLOR_WHITE;
 
    //0 line
    UIView *top_line = [UIView new];
    top_line.backgroundColor = XCOLOR_line;
    [self addSubview:top_line];
    self.top_line = top_line;
    
    //1 价格
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.font = [UIFont boldSystemFontOfSize:18];
    priceLab.textAlignment = NSTextAlignmentCenter;
    self.priceLab = priceLab;
    [self addSubview:priceLab];
    
    
    //2 line
    UIView *left_line = [UIView new];
    left_line.backgroundColor = XCOLOR_line;
    [self addSubview:left_line];
    self.left_line = left_line;
    
    //3
    UIButton *call_btn = [UIButton new];
    self.call_btn = call_btn;
    [self addSubview:call_btn];
    [call_btn setImage:[UIImage imageNamed:@"QQService"] forState:UIControlStateNormal];
    call_btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [call_btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *zi_Lab = [[UILabel alloc] init];
    zi_Lab.font = [UIFont boldSystemFontOfSize:14];
    zi_Lab.textAlignment = NSTextAlignmentCenter;
    self.zi_Lab = zi_Lab;
    zi_Lab.text = @"咨 询";
    [self addSubview:zi_Lab];
    
    //4 line
    UIView *right_line = [UIView new];
    right_line.backgroundColor = XCOLOR_line;
    [self addSubview:right_line];
    self.right_line = right_line;
    
    
    //5 提交按钮
    UIButton *sender = [UIButton new];
    self.submit = sender;
    sender.backgroundColor = XCOLOR_RED;
    sender.layer.cornerRadius = CORNER_RADIUS;
    [self addSubview:sender];
    [sender setTitle:@"购买" forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)setPrice:(NSString *)price{

    _price = price;
    
    self.priceLab.text = price;
    
    [self.priceLab sizeToFit];
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    
    CGSize contentSize = self.bounds.size;
    
    
    CGFloat margin_min = 10;
    CGFloat margin = contentSize.width > 350 ? 20 : 10;
    
    CGFloat top_X = 0;
    CGFloat top_Y = 0;
    CGFloat top_H = LINE_HEIGHT;
    CGFloat top_W = contentSize.width;
    self.top_line.frame = CGRectMake(top_X, top_Y, top_W, top_H);

    
    CGRect priceFrame =  self.priceLab.frame;
    priceFrame.size.height = contentSize.height;
    priceFrame.size.width = contentSize.width * 0.35;
    self.priceLab.frame = priceFrame;
    
    CGFloat left_X = CGRectGetMaxX(self.priceLab.frame);
    CGFloat left_H = 50;
    CGFloat left_W = LINE_HEIGHT;
    CGFloat left_Y = 0.5 * (contentSize.height - left_H);
    self.left_line.frame = CGRectMake(left_X, left_Y, left_W, left_H);
    
    CGFloat call_X = CGRectGetMaxX(self.left_line.frame);
    CGFloat call_Y = left_Y - margin_min;
    CGFloat call_W = 50;
    CGFloat call_H = call_W;
    self.call_btn.frame = CGRectMake(call_X, call_Y, call_W, call_H);
  
    CGFloat zi_X = call_X;
    CGFloat zi_Y = call_Y + call_H - margin_min;
    CGFloat zi_W = call_W;
    CGFloat zi_H =  20;
    self.zi_Lab.frame = CGRectMake(zi_X, zi_Y, zi_W, zi_H);
    
    
    CGFloat right_W = left_W;
    CGFloat right_X = CGRectGetMaxX(self.call_btn.frame);
    CGFloat right_Y = left_Y;
    CGFloat right_H = left_H;
    self.right_line.frame = CGRectMake(right_X, right_Y, right_W, right_H);
    
    CGFloat submit_X = CGRectGetMaxX(self.right_line.frame) + margin;
    CGFloat submit_W = contentSize.width - submit_X - margin;
    CGFloat submit_H = 50;
    CGFloat submit_Y = left_Y;
    self.submit.frame = CGRectMake(submit_X, submit_Y, submit_W, submit_H);
  
    
    
}

- (void)onClick:(UIButton *)sender{

    if (self.acitonBlock) self.acitonBlock(sender);
    
}


- (void)dealloc{
    
    KDClassLog(@"dealloc 留学 服务 详情 ServiceItemBottomView");
}

@end
