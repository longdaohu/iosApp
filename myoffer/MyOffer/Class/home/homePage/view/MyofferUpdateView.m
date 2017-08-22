//
//  MyofferUpdateView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/3.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyofferUpdateView.h"

@interface MyofferUpdateView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIButton *dis_Btn;
@property(nonatomic,strong)UIButton *update_Btn;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *iconView;
 @end

@implementation MyofferUpdateView

+ (instancetype)updateView{
    

    MyofferUpdateView *updateView = [[MyofferUpdateView  alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:updateView];


    return updateView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];

        
        CGFloat bg_Width =  320;
        CGFloat bg_X =  (frame.size.width - bg_Width) * 0.5;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bg_X, 0, bg_Width, 0)];
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        self.bgView = bgView;
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update_Icon"]];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView = iconView;
        [self.bgView addSubview:iconView];

        CGFloat icon_Width =  bg_Width;
        CGFloat icon_X =   0;
        CGFloat icon_Height =  icon_Width * iconView.image.size.height / iconView.image.size.width ;
        CGFloat icon_Y =  0;
        self.iconView.frame = CGRectMake(icon_X, icon_Y, icon_Width, icon_Height);
        iconView.transform = CGAffineTransformScale(iconView.transform, 0.1, 0.1);
        
        
        bgView.mj_h = icon_Height;
        
        
        UIButton *dis_Btn = [[UIButton alloc] init];
        [bgView addSubview:dis_Btn];
        [dis_Btn setTitle:@"下次再说" forState:UIControlStateNormal];
        [dis_Btn sizeToFit];
        [dis_Btn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
        [dis_Btn addTarget:self action:@selector(updateViewDismiss) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat dis_H = dis_Btn.bounds.size.height;
        CGFloat dis_W = dis_Btn.bounds.size.width;
        CGFloat dis_X =  -bg_Width;
        CGFloat dis_Y = icon_Height - dis_Btn.mj_h - 25;
        dis_Btn.frame = CGRectMake(dis_X, dis_Y, dis_W, dis_H);
        self.dis_Btn = dis_Btn;
        
        UIButton *update_Btn = [[UIButton alloc] init];
        [bgView addSubview:update_Btn];
        [update_Btn setTitle:@"立即升级" forState:UIControlStateNormal];
        [update_Btn addTarget:self action:@selector(toAppStore) forControlEvents:UIControlEventTouchUpInside];
        update_Btn.layer.cornerRadius = 20;
        update_Btn.layer.masksToBounds = true;
        update_Btn.backgroundColor = XCOLOR_RED;
        
        CGFloat update_W =  100;
        CGFloat update_H =  40;
        CGFloat update_X =  bg_Width;
        CGFloat update_Y =   dis_Y - update_H - 5;
        update_Btn.frame = CGRectMake(update_X, update_Y, update_W, update_H);
        self.update_Btn = update_Btn;
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = XCOLOR_TITLE;
        titleLab.font  = [UIFont systemFontOfSize:16];
        titleLab.text = @"发现新版本\n还不快点升级你的留学申请体验";
        titleLab.numberOfLines = 0;
        [bgView addSubview:titleLab];
        NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
        [descStyle setLineSpacing:10];//行间距
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:titleLab.text];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:descStyle range:NSMakeRange(0, [titleLab.text length])];
        titleLab.attributedText = attributedString;
        
        titleLab.textAlignment = NSTextAlignmentCenter;

        
        CGFloat t_W =  icon_Width - 30;
        CGFloat t_H =  90;
        CGFloat t_X =  (bg_Width - t_W) * 0.5;
        CGFloat t_Y =   update_Y - t_H;
        titleLab.frame = CGRectMake(t_X, t_Y, t_W, t_H);
        self.titleLab = titleLab;
        
        self.titleLab.alpha = 0;
        
    }
    
    return self;
}

- (void)show{
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        self.iconView.transform = CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.dis_Btn.mj_x = (self.bgView.mj_w - self.dis_Btn.width) * 0.5;
            
            self.update_Btn.mj_x = (self.bgView.mj_w - self.update_Btn.width) * 0.5;
            
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
                self.titleLab.alpha = 1;
                
            }];
        }];
        
        
        
    }];
    
    

    
}



- (void)updateViewDismiss{
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
 
}

//跳转到appstore下载页面

- (void)toAppStore{

    NSString *appid = @"1016290891";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:
                                                                     
                                                                     @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", appid]]];
    
}



@end
