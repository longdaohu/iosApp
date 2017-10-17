//
//  SearchPromptView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/5/2.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SearchPromptView.h"
@interface SearchPromptView ()
@property(nonatomic,strong)UILabel *promptLab;
@property(nonatomic,strong)UIView *shadowView;

@end


@implementation SearchPromptView

+ (instancetype)promptViewInsertInView:(UIView *)bottomView{
    
    
    CGFloat top = CGRectGetMinY(bottomView.frame);
    CGFloat p_x = 0;
    if ([bottomView isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)bottomView;
        top += tableView.contentInset.top;
         p_x = tableView.frame.origin.x;
    }
    
    
    CGFloat p_h =  50;
    CGFloat p_w =  XSCREEN_WIDTH;
    CGFloat p_y =  top - p_h;
    SearchPromptView *promptView = [[SearchPromptView alloc] initWithFrame:CGRectMake(p_x, p_y, p_w, p_h)];
    promptView.alpha = 0;

    [bottomView.superview insertSubview:promptView aboveSubview:bottomView];

    
    return promptView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIView *shadowView = [UIView new];
        shadowView.backgroundColor = XCOLOR_LIGHTBLUE;
        [self addSubview:shadowView];
        shadowView.layer.shadowColor = XCOLOR_LIGHTBLUE.CGColor;
        shadowView.layer.shadowOffset = CGSizeMake(0, 3);
        shadowView.layer.shadowOpacity = 0.5;
        shadowView.layer.cornerRadius = 15;
        self.shadowView = shadowView;
        
        _promptLab = [[UILabel alloc] init];
        _promptLab.textAlignment = NSTextAlignmentCenter;
        _promptLab.textColor = XCOLOR_WHITE;
        _promptLab.layer.cornerRadius = 15;
        _promptLab.layer.masksToBounds = YES;
        _promptLab.backgroundColor = XCOLOR_LIGHTBLUE;
        _promptLab.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:_promptLab];
        
        
    }
    return self;
}



- (void)showWithTitle:(NSString *)title{

    _promptLab.text = title;
    
    [_promptLab sizeToFit];
    
    CGFloat prompt_H = 30;
    CGFloat prompt_W = _promptLab.bounds.size.width + 40;
    CGFloat prompt_X = (self.bounds.size.width - prompt_W) * 0.5;
    CGFloat prompt_Y = 10;
    
    self.promptLab.frame = CGRectMake(prompt_X, prompt_Y, prompt_W, prompt_H);
    self.shadowView.frame = CGRectMake(prompt_X, prompt_Y, prompt_W, prompt_H);
    
    
    
    
    //每次点击时 清空动画
    [self.layer removeAllAnimations];
    self.alpha = 0;
    self.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.alpha = 1;
        self.transform = CGAffineTransformTranslate( self.transform, 0, self.mj_h);
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:ANIMATION_DUATION delay:2 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            
            self.transform = CGAffineTransformIdentity;
            
            self.alpha = 0;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
}


@end
