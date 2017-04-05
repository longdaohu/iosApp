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
@property(nonatomic,strong)UIView *callView;
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
    if (self) {
        
        [self makeUI];
    }
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
    self.priceLab = priceLab;
    [self addSubview:priceLab];
    
    
    //2 line
    UIView *left_line = [UIView new];
    left_line.backgroundColor = XCOLOR_line;
    [self addSubview:left_line];
    self.left_line = left_line;
    
    //3
    UIView *callView = [UIView new];
    [self addSubview:callView];
    self.callView = callView;
    
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
    [sender setTitle:@"立即购买" forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *call_btn = [UIButton new];
    self.call_btn = call_btn;
    [callView addSubview:call_btn];
    [call_btn setImage:[UIImage imageNamed:@"QQService"] forState:UIControlStateNormal];
    call_btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [call_btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //6 价格
    UILabel *zi_Lab = [[UILabel alloc] init];
    zi_Lab.font = [UIFont systemFontOfSize:12];
    self.zi_Lab = zi_Lab;
    zi_Lab.text  = @"咨询";
    zi_Lab.textAlignment = NSTextAlignmentCenter;
    [callView addSubview:zi_Lab];
    
}


- (void)setPrice:(NSString *)price{

    _price = price;
    
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",price];
    
    [self.priceLab sizeToFit];
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat margin = 20;
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat top_X = 0;
    CGFloat top_Y = 0;
    CGFloat top_H = 1;
    CGFloat top_W = contentSize.width;
    self.top_line.frame = CGRectMake(top_X, top_Y, top_W, top_H);

    
    CGRect priceFrame =  self.priceLab.frame;
    priceFrame.origin.x = margin;
    priceFrame.size.height = contentSize.height;
    priceFrame.size.width = self.priceLab.frame.size.width < 70 ? 70 : self.priceLab.frame.size.width;
    self.priceLab.frame = priceFrame;
    
    
    CGFloat left_X = CGRectGetMaxX(self.priceLab.frame) + margin;
    CGFloat left_Y = margin;
    CGFloat left_H = contentSize.height - left_Y * 2;
    CGFloat left_W = 1;
    self.left_line.frame = CGRectMake(left_X, left_Y, left_W, left_H);
    
    CGFloat call_X = CGRectGetMaxX(self.left_line.frame);
    CGFloat call_Y = margin * 0.5;
    CGFloat call_W = 80;
    CGFloat call_H = call_W;
    self.callView.frame = CGRectMake(call_X, call_Y, call_W, call_H);
    
    CGFloat right_W = left_W;
    CGFloat right_X = CGRectGetMaxX(self.callView.frame);
    CGFloat right_Y = left_Y;
    CGFloat right_H = left_H;
    self.right_line.frame = CGRectMake(right_X, right_Y, right_W, right_H);
    
    CGFloat submit_X = CGRectGetMaxX(self.right_line.frame) + margin;
    CGFloat submit_W = contentSize.width - submit_X - margin;
    CGFloat submit_Y = margin;
    CGFloat submit_H = 50;
    self.submit.frame = CGRectMake(submit_X, submit_Y, submit_W, submit_H);
    
    
    CGFloat call_btn_X = 0;
    CGFloat call_btn_Y = 0;
    CGFloat call_btn_W = call_W;
    CGFloat call_btn_H = submit_H - 10;
    self.call_btn.frame = CGRectMake(call_btn_X, call_btn_Y, call_btn_W, call_btn_H);
    
    CGFloat zi_X = 0;
    CGFloat zi_Y = call_btn_H;
    CGFloat zi_W = call_W;
    CGFloat zi_H = 12;
    self.zi_Lab.frame = CGRectMake(zi_X, zi_Y, zi_W, zi_H);

    
}

- (void)onClick:(UIButton *)sender{

    if (self.acitonBlock) {
        
        self.acitonBlock(sender);
    }
}


- (void)dealloc{
    
    KDClassLog(@"dealloc 留学 服务 详情 ServiceItemBottomView");
}

@end
