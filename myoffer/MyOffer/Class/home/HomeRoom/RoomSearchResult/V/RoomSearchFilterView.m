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
@end

@implementation RoomSearchFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_RANDOM;
        
        MyOfferButton *cityBtn = [MyOfferButton new];
        [cityBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
        [cityBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        cityBtn.titleLabel.font = XFONT(14);
        [cityBtn setTitle:@"城市" forState:UIControlStateNormal];
        cityBtn.type = MyofferButtonTypeImageRight;
        cityBtn.margin = 5;
        [cityBtn setImage:XImage(@"Triangle_Black_Down") forState:UIControlStateNormal];
        self.cityBtn = cityBtn;
        [self addSubview:cityBtn];
        [cityBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *priceBtn = [UIButton new];
        [priceBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
        [priceBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        priceBtn.titleLabel.font = XFONT(14);
        [priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        self.priceBtn = priceBtn;
        [self addSubview:priceBtn];
        [priceBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        MyOfferButton *filterBtn = [MyOfferButton new];
        [filterBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
        [filterBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        filterBtn.titleLabel.font = XFONT(14);
        filterBtn.type = MyofferButtonTypeImageRight;
        filterBtn.margin = 5;
        [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [filterBtn setImage:XImage(@"check-icons-yes") forState:UIControlStateNormal];
        self.filterBtn = filterBtn;
        [self addSubview:filterBtn];
        [filterBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.items = @[cityBtn,priceBtn,filterBtn];
    }
    return self;
}

- (void)onClick:(UIButton *)sender{
 
    if (self.RoomSearchFilterViewBlock) {
        self.RoomSearchFilterViewBlock();
    }
    
    
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
    
}

@end
