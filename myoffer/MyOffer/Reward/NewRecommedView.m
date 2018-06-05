//
//  NewRecommedView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "NewRecommedView.h"

@interface NewRecommedView ()
//@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *bgView;
@end

@implementation NewRecommedView

+ (NewRecommedView *)defaultView {
    static dispatch_once_t pred;
    __strong static id sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        
        sharedInstance = [[NewRecommedView alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
 
        

        self.bgView = [[UIImageView alloc] init];
        self.bgView.alpha = 0;
        self.bgView.image = XImage(@"newRecommend");
        
        CGFloat r_w = 183 * XSCREEN_WIDTH / 414;
        CGFloat r_h = r_w * 94/273;
        self.bgView.frame = CGRectMake( XSCREEN_WIDTH - r_w, XSCREEN_HEIGHT - r_h - XTabBarHeight + 10, r_w, r_h);
        self.bgView.contentMode =  UIViewContentModeScaleAspectFit;
//        self.bgView.backgroundColor = [UIColor redColor];
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        
    }
    return self;
}

- (void)showRecommend{
 
    if (self.hadBeenDone){
        self.bgView.alpha = 0;
        [self.bgView removeFromSuperview];
        return;
    };
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
         self.bgView.alpha = 1;
    }];
}
- (void)hidenAnimate:(BOOL)animate{
    
    if (!animate) {
        self.bgView.alpha = 0;
        if (self.hadBeenDone) {
            [self.bgView removeFromSuperview];
        }
        return;
    }
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.hadBeenDone) {
            [self.bgView removeFromSuperview];
        }
    }];

}

- (void)hadBeenSaw{
    
    self.hadBeenDone = YES;
    
    [self hidenAnimate:YES];
    
    [USDefault setValue:@"read" forKey:KEY_RECOMMEND];
    
}





@end
