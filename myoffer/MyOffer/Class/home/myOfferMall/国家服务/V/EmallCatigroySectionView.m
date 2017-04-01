//
//  EmallCatigroySectionView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/28.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "EmallCatigroySectionView.h"

@interface EmallCatigroySectionView ()
@property(nonatomic,strong)UIView *bannerView;
@property(nonatomic,strong)UIButton *lastBtn;
@property(nonatomic,strong)UIView *focusView;

@property(nonatomic,strong)NSArray *catigories;

@end

@implementation EmallCatigroySectionView
+ (instancetype)headerViewWithFrame:(CGRect)frame actionBlock:(ECatigroyBlock)action{
    
    
    EmallCatigroySectionView *headerView = [[EmallCatigroySectionView alloc] initWithFrame:frame];
    
    headerView.actionBlock = action;
    
    return headerView;
}


- (NSArray *)catigories{
    
    if (!_catigories) {
        
        _catigories = @[@"留学申请",@"签证服务",@"语言培训"];
    }
    
    return _catigories;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeUI];
    }
    return self;
}

- (void)makeUI{

    UIView *bannerView = [[UIView alloc] init];
    self.bannerView = bannerView;
    [self addSubview:bannerView];
    
    
    for (NSInteger index = 0 ; index < self.catigories.count; index++) {
        
        
        UIButton *item = [[UIButton alloc] init];
        [item setTitle:self.catigories[index] forState:UIControlStateNormal];
        [item setTitleColor:XCOLOR_LIGHTGRAY forState:UIControlStateNormal];
        [item setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        item.titleLabel.font = [UIFont systemFontOfSize:18];
        item.backgroundColor = XCOLOR_WHITE;
        item.titleLabel.textAlignment = NSTextAlignmentCenter;
        [bannerView addSubview:item];
        item.tag = index;
        [item addTarget:self action:@selector(itemOnclick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIView *focusView = [UIView new];
    self.focusView = focusView;
    focusView.backgroundColor = XCOLOR_LIGHTBLUE;
    [self addSubview:focusView];
    
    
    if (self.bannerView.subviews.count > 0) {
        
        self.lastBtn = (UIButton *)self.bannerView.subviews.firstObject;
        
        self.lastBtn.enabled = false;
    }

}


- (void)itemOnclick:(UIButton *)sender{
    
    
    
    self.lastBtn.enabled = true;
    sender.enabled = false;
    self.lastBtn = sender;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.focusView.mj_x = CGRectGetMinX(sender.frame);
        
    }];
    
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
    
    
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;

    CGFloat banX = 0;
    CGFloat banY = 0;
    CGFloat banW = contentSize.width;
    CGFloat banH = contentSize.height  - ITEM_MARGIN;
    self.bannerView.frame = CGRectMake(banX, banY, banW, banH);
    
    CGFloat itemW = banW / self.bannerView.subviews.count;
    
    for (NSInteger index = 0; index < self.bannerView.subviews.count; index++) {
        
        UIButton *item = (UIButton *)self.bannerView.subviews[index];
        
        item.frame = CGRectMake(itemW * index , 0, itemW ,banH);
        
    }
    
    CGFloat focusX = 0;
    CGFloat focusW = itemW;
    CGFloat focusH = 5;
    CGFloat focusY = banH - focusH;
    self.focusView.frame = CGRectMake(focusX, focusY, focusW, focusH);
}


@end
