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
@property(nonatomic,strong)CAShapeLayer *shaper;

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
        
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        self.shaper = shaper;
        [self.layer addSublayer:shaper];
        shaper.shadowColor = XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 0);
        shaper.shadowOpacity = 0.5;
        shaper.opacity = 0;
        
        UIView *bgView = [UIView new];
        [self addSubview:bgView];
        self.bgView = bgView;
 
        UIButton *backBtn = [[UIButton alloc] init];
        self.backBtn = backBtn;
        [backBtn addTarget:self action:@selector(casePop) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:XImage(@"back_arrow_white") forState:UIControlStateNormal];
        [backBtn setImage:XImage(@"back_arrow_black") forState:UIControlStateSelected];
        [bgView addSubview:backBtn];
 
 
        UIButton *titleBtn = [[UIButton alloc] init];
        titleBtn.titleLabel.font = XFONT(17);
        [titleBtn setTitleColor:XCOLOR_WHITE  forState:UIControlStateNormal];
        [titleBtn setTitleColor:XCOLOR_BLACK  forState:UIControlStateSelected];
        titleBtn.userInteractionEnabled = NO;
        self.titleBtn = titleBtn;
        [bgView addSubview:titleBtn];
 
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
//    self.bgView.alpha = alp;
    for (UIView *item in self.bgView.subviews) {
        if ([item isMemberOfClass:[UIButton class]]) {
            UIButton *sender =(UIButton *)item;
            sender.selected = (alp > 0);
        }
    }
    
    self.shaper.opacity =  alp ;
    
}

- (void)setRightView:(UIView *)rightView{
    
    _rightView = rightView;
    
     [self.bgView addSubview:rightView];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    self.gradient.frame = self.bounds;

    CGSize  content_size = self.bounds.size;
    CGFloat left_margin = 10;
    CGFloat right_margin = left_margin;
    CGSize  itemSize  = CGSizeMake(30, 40);
    
    CGFloat back_x = left_margin;
    CGFloat back_w = itemSize.width;
    CGFloat back_h = itemSize.height;
    CGFloat back_y = content_size.height - back_h - 4;
    self.backBtn.frame = CGRectMake(back_x,back_y, back_w, back_h);
 

    CGFloat right_w = itemSize.width;
    CGFloat right_h = itemSize.height;
    CGFloat right_y = back_y;
    CGFloat right_x = content_size.width - right_w - right_margin;
    if (self.rightView) {
        right_h = self.rightView.mj_h;
        right_w = self.rightView.mj_w;
        right_x = content_size.width - right_w - right_margin;
        self.rightView.frame = CGRectMake(right_x, right_y, right_w, right_h);
    }
    
    CGFloat title_h = back_h;
    CGFloat title_y = back_y;
    CGFloat title_x = back_x + back_w;
    CGFloat title_w = right_x - title_x;

    CGSize title_size = [self.title stringWithfontSize:17];
    if (title_size.width < title_w) {
       
        title_w = title_size.width;
        CGFloat tmp_right = right_x - content_size.width * 0.5;
        if (tmp_right < title_w * 0.5) {
            title_x =  content_size.width * 0.5  - title_w + tmp_right;
        }else{
            title_w = tmp_right * 2;
            title_x = content_size.width * 0.5 - tmp_right;
        }
    }
    
    self.titleBtn.frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    if (!self.shaper.shadowPath) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bgView.frame];
        self.shaper.shadowPath = path.CGPath;
    }
 
}




@end

 


