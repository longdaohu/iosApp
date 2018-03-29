//
//  PromttViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/9.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "PromttViewController.h"

@interface PromttViewController ()

@end

@implementation PromttViewController
+ (instancetype)promptView{
    
    PromttViewController  *prompt  = [[PromttViewController alloc] initWithNibName:@"PromttViewController" bundle:nil];
    
    prompt.view.frame = CGRectMake(0, XSCREEN_HEIGHT, XSCREEN_WIDTH, XSCREEN_HEIGHT);

    [[UIApplication sharedApplication].windows.lastObject addSubview:prompt.view];
 
    
    return prompt;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
 
}

- (IBAction)promtViewOnClick:(id)sender {
    
    [self promptViewShow:NO];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self promptViewShow:NO];
}

//当没有数据时，出现智能匹配提示页面
- (void)promptViewShow:(BOOL)show{
    
    XWeakSelf
    CGFloat prompTop = show ? 0 : XSCREEN_HEIGHT;
    
    CGFloat prompAlpha = show ? 1 : 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        weakSelf.view.mj_y = prompTop;
        
        weakSelf.view.alpha = prompAlpha;
        
    } completion:^(BOOL finished) {
        
        if (!show) {
            
             [weakSelf.view removeFromSuperview];
            
        }
        
    }];
    
}


- (void)dealloc{

    KDClassLog(@" 提示信息 + PromttViewController + dealloc");
}



@end
