//
//  RoomNavigationView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/14.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomNavigationView.h"
#import "Masonry.h"

@interface RoomNavigationView ()
@property(nonatomic,strong)CAGradientLayer *gradient;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *titleBtn;
@property(nonatomic,strong)UIButton *rightItemBtn;

@end

@implementation RoomNavigationView

+ (instancetype)nav{

    RoomNavigationView *nav = [[RoomNavigationView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XNAV_HEIGHT)];
    
    return nav;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alpha_height = XNAV_HEIGHT;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        self.gradient = gradient;
        gradient.colors           = [NSArray arrayWithObjects:
                                     (id)[UIColor  colorWithWhite:0 alpha:0].CGColor,
                                     (id)[UIColor colorWithWhite:0 alpha:0.6].CGColor,
                                     nil];
        gradient.locations  = @[@(0.2), @(1.0)];
        gradient.startPoint = CGPointMake(0, 1.0);
        gradient.endPoint = CGPointMake(0, 0);
        [self.layer addSublayer:gradient];
 
        UIView *bgView = [UIView new];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(self);
        }];
        self.bgView = bgView;
 
        UIButton *backBtn = [[UIButton alloc] init];
        self.backBtn = backBtn;
        [backBtn addTarget:self action:@selector(casePop) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:XImage(@"back_arrow") forState:UIControlStateNormal];
        [bgView addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-4);
        }];
        
        UIButton *rightItemBtn = [[UIButton alloc] init];
        self.rightItemBtn = rightItemBtn;
        [rightItemBtn addTarget:self action:@selector(casePop) forControlEvents:UIControlEventTouchUpInside];
        rightItemBtn.backgroundColor = XCOLOR_RANDOM;
        [bgView addSubview:rightItemBtn];
        [rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(backBtn.mas_bottom);
        }];
        
        UIButton *titleBtn = [[UIButton alloc] init];
        self.titleBtn = titleBtn;
        [bgView addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backBtn.mas_right);
            make.right.mas_equalTo(rightItemBtn.mas_left);
            make.top.mas_equalTo(self.backBtn.mas_top);
            make.bottom.mas_equalTo(self.backBtn.mas_bottom);
        }];
        
    }
    
    return self;
}


- (void)setTitle:(NSString *)title{
    
    _title = title;
    
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}

- (void)casePop{
 
    if (self.acitonBlock) {
        self.acitonBlock(YES);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat alp = scrollView.mj_offsetY/self.alpha_height;
    if (alp < 0) alp  = 0;
    self.bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:alp];
    if (alp <= 0) {
        self.backBtn.alpha = 1;
        self.titleBtn.alpha = 1;
        [self.backBtn setImage:XImage(@"back_arrow") forState:UIControlStateNormal];
        [self.titleBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    }else{
        [self.backBtn setImage:XImage(@"back_arrow_black") forState:UIControlStateNormal];
        self.backBtn.alpha = alp;
        
        [self.titleBtn setTitleColor:XCOLOR_BLACK forState:UIControlStateNormal];
        self.titleBtn.alpha = alp;
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
     self.gradient.frame = self.bounds;
}

@end
