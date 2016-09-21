//
//  MessageHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJMessageButtonItemView.h"
@interface XWGJMessageButtonItemView ();
@property(nonatomic,strong)NSArray *ButtonImages;
@property(nonatomic,strong)NSArray *ButtonDisableImages;
@property(nonatomic,strong)NSArray *ButtonTitles;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *line;


@end
@implementation XWGJMessageButtonItemView

-(NSArray *)ButtonImages
{
    if (!_ButtonImages) {
        
        _ButtonImages =@[@"life_blue",@"application_blue",@"fee_blue",@"test_blue",@"news_blue",@"visa_blue"];
        
    }
    return _ButtonImages;
}

-(NSArray *)ButtonDisableImages
{
    if (!_ButtonDisableImages) {
        
        _ButtonDisableImages =@[@"life_white",@"application_white",@"fee_white",@"test_white",@"news_white",@"visa_white"];
    }
    return _ButtonDisableImages;
}

-(NSArray *)ButtonTitles
{
    if (!_ButtonTitles) {
        
        _ButtonTitles = @[@"留学生活",@"留学申请",@"留学费用",@"留学考试",@"留学新闻",@"留学签证"];
    }
    return _ButtonTitles;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.LastIndex = 0;
        
        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor = XCOLOR_WHITE;
        [self addSubview:self.bgView];
        
        self.line =[[UIView alloc] init];
        self.line.backgroundColor = XCOLOR_BG;
        [self addSubview:self.line];
        
        self.backgroundColor = XCOLOR_CLEAR;
        
        for (NSInteger i = 0; i < 6; i++) {
            
             UIButton *itemBtn = [[UIButton alloc] init];
            itemBtn.enabled = self.LastIndex ==i ? NO:YES;
            itemBtn.backgroundColor = self.LastIndex ==i ? XCOLOR_LIGHTBLUE:XCOLOR_CLEAR;
            itemBtn.tag = i;
            [itemBtn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
            itemBtn.layer.borderWidth  = 1;
            itemBtn.layer.masksToBounds = YES;
            itemBtn.layer.borderColor = XCOLOR_LIGHTBLUE.CGColor;
            
            [itemBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
            [itemBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateDisabled];
            
            
            itemBtn.titleLabel.font =[UIFont systemFontOfSize:15];
            
            [itemBtn setTitle:self.ButtonTitles[i] forState:UIControlStateNormal];
            
            [itemBtn setImage:[UIImage imageNamed:self.ButtonImages[i]] forState:UIControlStateNormal];
            [itemBtn setImage:[UIImage imageNamed:self.ButtonDisableImages[i]] forState:UIControlStateDisabled];
            itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
            
            [self.bgView addSubview:itemBtn];
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    CGFloat bgHeight = self.bounds.size.height - margin;
    
    self.bgView.frame = CGRectMake(0, 0, XScreenWidth,bgHeight);
    
    self.line.frame = CGRectMake(0, bgHeight, XScreenWidth, 0.8);
    
    
    
    CGFloat w = (XScreenWidth - 4 * margin) / 3.0;
    
    CGFloat bh =   (bgHeight - margin) * 0.5 - margin;
    
    
    for (int i = 0 ; i < 6 ; i++) {
        
        UIButton *item =(UIButton *)self.bgView.subviews[i];
        
        item.layer.cornerRadius = bh * 0.5;
        
        CGFloat x = (i % 3 + 1) * margin + i % 3 * w;
        
        CGFloat y = margin + (bh +margin)* ( i / 3);
        
        item.frame = CGRectMake(x, y, w, bh);
        
    }
}


-(void)tap:(UIButton *)sender
{
    
    NSString *item;
    if (sender.tag == 0) {
        item = @"news_lift";
    }else if (sender.tag == 1) {
        item = @"news_apply";
    }else if (sender.tag == 2) {
        item = @"news_fee";
    }else if (sender.tag == 3) {
        item = @"news_kaoshi";
    }else if (sender.tag == 4) {
        item = @"news_news";
    }else{
        item = @"news_visa";
    }
    [MobClick event:item];
    
    
    if (sender.tag != self.LastIndex) {
        
        UIButton *item =(UIButton *)self.bgView.subviews[self.LastIndex];
        item.backgroundColor = XCOLOR_CLEAR;
        item.enabled = YES;
        sender.enabled = NO;
        sender.backgroundColor =  XCOLOR_LIGHTBLUE;
        self.LastIndex = sender.tag;
        if (self.ActionBlock) {
            self.ActionBlock(sender);
        }
    }
    
    
}
@end
