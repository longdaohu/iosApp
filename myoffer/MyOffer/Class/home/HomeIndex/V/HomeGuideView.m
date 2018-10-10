//
//  HomeGuideView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeGuideView.h"
@interface HomeGuideView ()
@property(nonatomic,strong)CAShapeLayer *shaper;
@property(nonatomic,strong)UIImageView *finger;
@property(nonatomic,strong)UIImageView *finger_right;
@property(nonatomic,strong)UIButton *okBtn;
@property(nonatomic,strong)UIImageView *noteView;

@end

@implementation HomeGuideView

+ (instancetype)guideView{
    
    HomeGuideView *guide = [[HomeGuideView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
 
    return guide;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR(0, 0, 0, 0);
        self.alpha = 0;

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = XCOLOR(0, 0, 0, 0.65).CGColor;
        [self.layer addSublayer:shapeLayer];
        self.shaper = shapeLayer;
        
        UIImage *icon_a = [UIImage imageNamed:@"home_guide_a"];
        UIImage *icon_b = [UIImage imageNamed:@"home_guide_b"];
        UIImage *icon_btn = [UIImage imageNamed:@"home_guide_btn"];
        UIImage *icon_finger = [UIImage imageNamed:@"home_guide_finger"];

        UIImageView *view_a = [[UIImageView alloc] init];
        view_a.contentMode = UIViewContentModeScaleToFill;
        view_a.image = icon_a;
        [self addSubview:view_a];
        self.noteView = view_a;

        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:icon_btn forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(caseHide) forControlEvents:UIControlEventTouchUpInside];
        self.okBtn = btn;
        

        UIImageView *finger = [[UIImageView alloc] init];
        finger.contentMode = UIViewContentModeScaleToFill;
        finger.image = icon_finger;
        [self addSubview:finger];
        self.finger = finger;
        
        UIImageView *bView = [[UIImageView alloc] init];
        bView.contentMode = UIViewContentModeScaleToFill;
        bView.image = icon_b;
        [self addSubview:bView];
        self.finger_right = bView;
        
    }
    return self;
}

- (void)setIsYsPage:(BOOL)isYsPage{
    
    _isYsPage = isYsPage;
 
    
}


- (void)show{
    
    self.alpha = 1;
}

- (void)hide{
    
    self.alpha = 0;
}

- (void)caseHide{
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [self checkAPPVersion];
}

//检查版本更新
-(void)checkAPPVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *value = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *key  = @"APPVersion";
    if (self.isYsPage) {
        value = [NSString stringWithFormat:@"%@ys",value];
        key = [NSString stringWithFormat:@"%@ys",key];
    }
    [USDefault setValue:value  forKey:key];
    [USDefault synchronize];
}


- (void)layoutSubviews{
    [super layoutSubviews];

    if (self.isYsPage) {
        UIImage *icon_ys_a = [UIImage imageNamed:@"home_guide_ys_a"];
        UIImage *icon_ys_b = [UIImage imageNamed:@"home_guide_ys_b"];
        self.finger_right.image = icon_ys_b;
        self.noteView.image = icon_ys_a;
        self.noteView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    CGSize content_size = self.bounds.size;

    CGFloat  path_x = 65;
    CGFloat  path_y = XStatusBar_Height;
    CGFloat  path_h = HOME_MENU_HEIGHT - path_y  - 5;
    if (!self.shaper.path) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, content_size.width, content_size.height)];
        [path appendPath: [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(path_x, path_y, content_size.width, path_h) cornerRadius: path_h * 0.5] bezierPathByReversingPath]];
        if (self.isYsPage) {
            
            CGFloat path_w = 100;
            path_h = path_w;
            path_x = (content_size.width - path_w) * 0.5;
            path_y = XSCREEN_HEIGHT * 0.77 - 20;
            path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, content_size.width, content_size.height)];
            [path appendPath: [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(path_x, path_y, path_w, path_h) cornerRadius: path_h * 0.5] bezierPathByReversingPath]];
        }
        self.shaper.path = path.CGPath;

    }
    
    CGFloat a_x = path_x + 30;
    CGFloat a_y = path_h + path_y + 5;
    CGFloat a_w = 197;
    CGFloat a_h = a_w * self.noteView.image.size.height/self.noteView.image.size.width;
    if (self.isYsPage) {
        a_w =  283;
        a_x = (content_size.width - a_w) * 0.5;
        a_y =  path_y + path_h + 10;
        a_h = 20;
    }
    self.noteView.frame = CGRectMake(a_x, a_y, a_w, a_h);

    
    CGFloat btn_w = 113;
    CGFloat btn_h = 34;
    CGFloat btn_x = a_x + 10;
    CGFloat btn_y = a_y + a_h + 13;
    if (self.isYsPage) {
        btn_x = (content_size.width - btn_w) * 0.5;
        btn_y = content_size.height  * 0.4;
    }
    self.okBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    
    CGFloat fg_x = a_x;
    CGFloat fg_y = btn_y + btn_h + 290;
    CGFloat fg_w = 36;
    CGFloat fg_h = 53;
    
    CGFloat ib_x = fg_x + fg_w + 10;
    CGFloat ib_y = fg_y;
    CGFloat ib_w = 181;
    CGFloat ib_h = 40;
    if (self.isYsPage) {
        ib_x = btn_x;
        ib_y = btn_y - ib_h - 20;
        
        fg_x =  ib_x - 10 - fg_w;
        fg_y =  ib_y;

    }
    self.finger.frame = CGRectMake(fg_x, fg_y, fg_w, fg_h);
    self.finger_right.frame = CGRectMake(ib_x, ib_y, ib_w, ib_h);
    
    
}

@end
