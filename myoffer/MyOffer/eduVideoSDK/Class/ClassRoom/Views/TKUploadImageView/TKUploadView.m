//
//  TKUploadView.m
//  EduClass
//
//  Created by lyy on 2018/5/5.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKUploadView.h"

#define ThemeKP(args) [@"ClassRoom.TKUploadImageView." stringByAppendingString:args]
#define tWidth 66
#define tHeight 154

@interface TKUploadView()

@property (nonatomic, strong) UIView       * backView;

@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *picBtn;
@end

@implementation TKUploadView
- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        if (!self.backView) {
            self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
            self.backView.alpha = 0;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
            [self.backView addGestureRecognizer: tap];
            
        }
        
        [self initContent];
    }
    
    return self;
}
- (void)touchOutSide{
    if (self.dismiss) {
        self.dismiss();
    }
    [self dissMissView];
}

- (void)initContent
{
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    self.contentView = ({
        
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tWidth, tHeight)];
        [self addSubview:view];
        view.image = [UIImage resizedImageWithName:ThemeKP(@"camera_tool_toolbar")];
        view.userInteractionEnabled = YES;
        view;
        
        
    });
    
    
    self.cameraBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, tWidth, tHeight/2.0-0.5)];
        button.sakura.image(ThemeKP(@"choose_camera_pop"),UIControlStateNormal);
        button.imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:button];
        [button addTarget:self action:@selector(cameraBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        button;
    });
    
        
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(tWidth/3.0*0.5, CGRectGetMaxY(self.cameraBtn.frame), tWidth/3.0*2.0, 1)];
    lineView.sakura.backgroundColor(ThemeKP(@"cameraLineColor"));
    [self.contentView addSubview:lineView];
        
    
    self.picBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), tWidth, tHeight/2.0-0.5)];
        button.sakura.image(ThemeKP(@"choose_photo_pop"),UIControlStateNormal);
        button.imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:button];
        [button addTarget:self action:@selector(picBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        button;
    });
    
    
}
- (void)cameraBtnClick:(UIButton *)sender{
    
    if (self.dismiss) {
        self.dismiss();
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:sTakePhotosUploadNotification object:sTakePhotosUploadNotification];
    [self dissMissView];
    
}
- (void)picBtnClick:(UIButton *)sender{
    if (self.dismiss) {
        self.dismiss();
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:sChoosePhotosUploadNotification object:sChoosePhotosUploadNotification];
    [self dissMissView];
}
//展示从底部向上弹出的UIView（包含遮罩）
- (void)showOnView:(UIButton *)view
{
    CGRect absoluteRect = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
    
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    CGFloat x = (tWidth - absoluteRect.size.width)/2.0;
    
    [TKMainWindow addSubview:self.backView];
    [TKMainWindow addSubview:self];
    
    
    self.alpha = 1.0;
    self.frame = CGRectMake(absoluteRect.origin.x-x, relyPoint.y - tHeight- absoluteRect.size.height, tWidth, tHeight);
    [UIView animateWithDuration: 0.25 animations:^{
        
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
//移除从上向底部弹下去的UIView（包含遮罩）
- (void)dissMissView
{
   
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         self.backView.alpha = 0;
                        
                     }
                     completion:^(BOOL finished){
                         
                         [self.backView removeFromSuperview];
                         [self removeFromSuperview];
                         
                     }];
    
}



@end
