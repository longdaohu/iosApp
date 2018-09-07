//
//  TKBaseView.m
//  EduClass
//
//  Created by lyy on 2018/4/27.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKBaseView.h"

@interface TKBaseView()

@property (nonatomic, strong) UIView       * backView;
@property (nonatomic, strong) UIButton *xButton;
@property (nonatomic, assign) CGFloat tabarH ; //  标题栏高度

@end

@implementation TKBaseView

- (instancetype)initWithFrame:(CGRect)frame from:(NSString *)from
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat screenWidth = [TKUtil isiPhoneX]?ScreenW-60:ScreenW;
        CGFloat weight1 = (screenWidth-10*(7+1))/7;
        CGFloat height1 =  weight1/4.0*3.0+weight1/4*3/7;
        
        CGFloat navH = height1 *0.4;
        self.tabarH = [TKUtil isiPhoneX]?(height1) * 0.4+17:height1 * 0.4;
        
        
        if(!self.backView){
            if ([from isEqualToString:@"TKOneToMoreRoomController"] || [from isEqualToString:@"TKOneToOneRoomController"]) {
                self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - _tabarH)];
            }else if ([from isEqualToString:@"RoomController"]) {
                self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            }
//            self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
            self.backView.alpha = 0;
//            self.backView.alpha = 1;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
//            [self.backView addGestureRecognizer: tap];
        }
        
        
        //背景图片
        if (!self.backImageView) {
            self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//            self.backImageView.sakura.image(@"TKListView.Library_frame");
            self.backImageView.image = [UIImage resizedImageWithName:@"TKListView.Library_frame"];
            self.backImageView.userInteractionEnabled = YES;
        }
        
        [self addSubview:self.backImageView];
        
       
        _contentView = [[UIView alloc]init];
        [self.backImageView addSubview:_contentView];
        
        _contentView.frame = CGRectMake(CGRectGetWidth(_backImageView.frame)*0.06, self.height*0.14, CGRectGetWidth(_backImageView.frame)*0.88, CGRectGetHeight(_backImageView.frame)*0.8);
        
        //关闭按钮
        _xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _xButton.sakura.image(@"TKListView.btn_close",UIControlStateNormal);
        CGFloat height = CGRectGetMinY(_contentView.frame)/2.0;
    
        _xButton.frame = CGRectMake(CGRectGetWidth(self.backImageView.frame)-height-height/4.0, height/4.0, height, height);
        [self.backImageView addSubview:_xButton];
        [_xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)touchOutSide{
    [self dismissAlert];
}

- (void)show
{
    [TKMainWindow addSubview:self.backView];
    [TKMainWindow addSubview:self];
    [UIView animateWithDuration: 0.25 animations:^{
        
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)show:(UIView *)view
{
    [view addSubview:self.backView];
    [view addSubview:self];
    [UIView animateWithDuration: 0.25 animations:^{
        
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)hidden{
    
    [self dismissAlert];
}
- (void)dismissAlert
{
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         self.backView.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self.backView removeFromSuperview];
                         [self removeFromSuperview];
                         if (self.dismissBlock) {
                             self.dismissBlock();
                         }
                     }];
    
    
   
}

- (void)setTitleText:(NSString *)titleText {
    self.titleH = 20.;
    if (titleText.length == 0) {
        return;
    }
    _titleText = titleText;

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(
                                                             0,
                                                             0,
                                                             self.backImageView.width,
                                                             self.titleH)];
    lbl.centerX = self.contentView.centerX;
    lbl.centerY = _xButton.centerY;
    
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.sakura.textColor(@"Alert.titleColor");
    lbl.text = _titleText;
    
    [self.backImageView addSubview:lbl];
    [self bringSubviewToFront:_xButton];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
