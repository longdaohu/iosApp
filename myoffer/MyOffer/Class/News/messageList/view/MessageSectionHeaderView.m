//
//  MessageSectionHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/7.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageSectionHeaderView.h"
#import "XWGJMessageCategoryItem.h"

@interface MessageSectionHeaderView ();

@property(nonatomic,strong)NSArray *ButtonImages;
@property(nonatomic,strong)NSArray *ButtonDisableImages;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,assign)NSInteger LastIndex;


@end
@implementation MessageSectionHeaderView

+ (instancetype)headerWithAction:(MessageBlock)actionBlock{
    
    MessageSectionHeaderView *header = [[MessageSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 120)];
    
    header.actionBlock = actionBlock;
    
    return header;
}


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
        
    }
    return self;
}



- (void)setItems:(NSArray *)items{
    
    
    _items = items;
    
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XWGJMessageCategoryItem *item = (XWGJMessageCategoryItem *)obj;
        
        UIButton *itemBtn = [[UIButton alloc] init];
        itemBtn.enabled = self.LastIndex == idx ? NO:YES;
        itemBtn.backgroundColor = self.LastIndex == idx ? XCOLOR_LIGHTBLUE:XCOLOR_CLEAR;
        itemBtn.tag = idx;
        itemBtn.layer.borderWidth  = 1;
        itemBtn.layer.masksToBounds = YES;
        itemBtn.layer.borderColor = XCOLOR_LIGHTBLUE.CGColor;
        [itemBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
        [itemBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateDisabled];
        itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        itemBtn.titleLabel.font =[UIFont systemFontOfSize:15];
        [itemBtn setTitle:item.name forState:UIControlStateNormal];
        [itemBtn setImage:[UIImage imageNamed:self.ButtonImages[idx]] forState:UIControlStateNormal];
        [itemBtn setImage:[UIImage imageNamed:self.ButtonDisableImages[idx]] forState:UIControlStateDisabled];
        [itemBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.bgView addSubview:itemBtn];
        
        
    }];
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat bgX = 0;
    CGFloat bgY = 0;
    CGFloat bgW = contentSize.width;
    CGFloat bgH = contentSize.height - margin;
    self.bgView.frame = CGRectMake(bgX, bgY, bgW,bgH);
    
    
    
    CGFloat lineX = 0;
    CGFloat lineY = bgH;
    CGFloat lineW = bgW;
    CGFloat lineH = 0.8;
    self.line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
    
    CGFloat w = (contentSize.width - 4 * margin) / 3.0;
    CGFloat h =   (bgH - margin) * 0.5 - margin;
    for (int i = 0 ; i < self.bgView.subviews.count ; i++) {
        UIButton *item =(UIButton *)self.bgView.subviews[i];
        item.layer.cornerRadius = h * 0.5;
        CGFloat x = (i % 3 + 1) * margin + i % 3 * w;
        CGFloat y = margin + (h +margin)* ( i / 3);
        item.frame = CGRectMake(x, y, w, h);
        
    }
}


- (void)onClick:(UIButton *)sender{
    
     if (sender.tag != self.LastIndex) {
        
        UIButton *item =(UIButton *)self.bgView.subviews[self.LastIndex];
        item.backgroundColor = XCOLOR_CLEAR;
        item.enabled = YES;
        sender.enabled = NO;
        sender.backgroundColor =  XCOLOR_LIGHTBLUE;
        self.LastIndex = sender.tag;
        
        if (self.actionBlock) {
            
            self.actionBlock(sender);
        }
    }
    
    
}
@end
