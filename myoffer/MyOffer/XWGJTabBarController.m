//
//  XWGJTabBarController.m
//  MyOffer
//
//  Created by sara on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "XWGJTabBarController.h"
#import "CategoryViewController.h"
#import "EvaluateViewController.h"
#import "MeViewController.h"
#import "DiscoverViewController.h"

@interface XWGJTabBarController ()

@end

@implementation XWGJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DiscoverViewController *dvc = [[DiscoverViewController alloc] init];
    dvc.title = GDLocalizedString(@"DiscoverTitle");//@"发现";
    dvc.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
    CategoryViewController *cvc = [[CategoryViewController alloc] init];
    cvc.title = GDLocalizedString(@"CategoryTitle");//@"分类";
    cvc.tabBarItem.image = [UIImage imageNamed:@"tabbar_category"];
    EvaluateViewController *evc = [[EvaluateViewController alloc] init];
    evc.title = GDLocalizedString(@"EvaluateTitle");//@"评估";
    evc.tabBarItem.image = [UIImage imageNamed:@"tabbar_evaluate"];
    MeViewController *mvc = [[MeViewController alloc] initWithNibName:NSStringFromClass([MeViewController class]) bundle:nil];
    mvc.title = GDLocalizedString(@"MeViewControllerTitle"); //@"我";
    mvc.tabBarItem.image = [UIImage imageNamed:@"tabbar_me"];
    
    self.viewControllers = @[[[XWGJNavigationController alloc] initWithRootViewController:dvc],
                                         [[XWGJNavigationController alloc] initWithRootViewController:cvc],
                                         [[XWGJNavigationController alloc] initWithRootViewController:evc],
                                         [[XWGJNavigationController alloc] initWithRootViewController:mvc]];
    
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
//    NSLog(@"deallocdeallocdeallocdeallocdealloc----------XWGJTabBarController");
}

@end
