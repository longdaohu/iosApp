//
//  MyOfferWhiteNV.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/7.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "MyOfferWhiteNV.h"

@interface MyOfferWhiteNV ()<UIGestureRecognizerDelegate>

@end

@implementation MyOfferWhiteNV

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate =  self;
    UIImage *icon = XImage(@"nav_bg_white");
    self.navigationBar.tintColor = XCOLOR_TITLE;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:XCOLOR_TITLE,NSFontAttributeName :[UIFont boldSystemFontOfSize:17] };
    [self.navigationBar setBackgroundImage:icon forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    
}

/**   ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count > 1) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    }
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
}


- (void)back{
    
    [self popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end

