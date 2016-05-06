//
//  XWGJNavigationController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/15.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "XWGJNavigationController.h"

@interface XWGJNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation XWGJNavigationController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.tintColor = [UIColor blackColor];
    self.interactivePopGestureRecognizer.delegate =  self;
    
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    //    self.interactivePopGestureRecognizer.enabled = NO;
    if (self.viewControllers.count > 1) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-50"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    
    
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.viewControllers.count <= 1 ) {
        
        return NO;
    }
    
    return YES;
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
