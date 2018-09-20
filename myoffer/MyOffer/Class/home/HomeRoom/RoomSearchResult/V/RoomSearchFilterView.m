//
//  RoomSearchFilterView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomSearchFilterView.h"
#import "MyOfferButton.h"

@interface RoomSearchFilterView ()
@property(nonatomic,strong)UIButton *cityBtn;
@property(nonatomic,strong)UIButton *priceBtn;
@property(nonatomic,strong)UIButton *filterBtn;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)UIButton *lastBtn;
@property(nonatomic,strong)UIView *bottomLine;

@end

@implementation RoomSearchFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_WHITE;
        
        MyOfferButton *cityBtn = [MyOfferButton new];
        [cityBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        [cityBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        cityBtn.titleLabel.font = XFONT(14);
        [cityBtn setTitle:@"城市" forState:UIControlStateNormal];
        cityBtn.type = MyofferButtonTypeImageRight;
        cityBtn.margin = 3;
        [cityBtn setImage:XImage(@"Trp_Black_Down") forState:UIControlStateNormal];
        self.cityBtn = cityBtn;
        [self addSubview:cityBtn];
        [cityBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        cityBtn.tag = RoomFilterTypeCity;
        
        UIButton *priceBtn = [UIButton new];
        [priceBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        [priceBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        priceBtn.titleLabel.font = XFONT(14);
        [priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        self.priceBtn = priceBtn;
        [self addSubview:priceBtn];
        [priceBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        priceBtn.tag = RoomFilterTypePrice;
        
        MyOfferButton *filterBtn = [MyOfferButton new];
        [filterBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        [filterBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        filterBtn.titleLabel.font = XFONT(14);
        filterBtn.type = MyofferButtonTypeImageRight;
        filterBtn.margin = 3;
        [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [filterBtn setImage:XImage(@"filler") forState:UIControlStateNormal];
        self.filterBtn = filterBtn;
        [self addSubview:filterBtn];
        [filterBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        filterBtn.tag = RoomFilterTypefilte;

        self.items = @[cityBtn,priceBtn,filterBtn];
        
        UIView *line = [UIView new];
        [self addSubview:line];
        line.backgroundColor = XCOLOR_line;
        self.bottomLine = line;
    }
    return self;
}

- (void)onClick:(UIButton *)sender{
 
    if (self.RoomSearchFilterViewBlock) {
        self.RoomSearchFilterViewBlock(sender.tag);
    }
}
- (void)setCity:(NSString *)city{
    _city = city;
    
    NSString *title = city ? city : @"城市";
    [self.cityBtn setTitle:title forState:UIControlStateNormal];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize content_size  = self.bounds.size;
    CGFloat item_w = content_size.width * 0.3333;
    
    CGFloat item_x = 0;
    CGFloat item_y = 0;
    CGFloat item_h = content_size.height;
    for (NSInteger index  = 0 ; index < self.items.count; index++) {
        UIButton *item  = self.subviews[index];
        item_x  =  index *item_w;
        item.frame = CGRectMake(item_x, item_y, item_w, item_h);
    }
    
    CGFloat line_y = content_size.height;
    CGFloat line_w = content_size.width;
    CGFloat line_h = 1;
    self.bottomLine.frame = CGRectMake(0, line_y, line_w, line_h);
}

@end
