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
#import "IntelligentViewController.h"
@interface XWGJTabBarController ()

@end

@implementation XWGJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DiscoverViewController *dvc = [[DiscoverViewController alloc] init];
    dvc.title = GDLocalizedString(@"DiscoverTitle");//@"发现";
    CategoryViewController *cvc = [[CategoryViewController alloc] init];
    cvc.title = GDLocalizedString(@"CategoryTitle");//@"分类";
//    EvaluateViewController *evc = [[EvaluateViewController alloc] init];
//    IntelligentViewController *evc = [[IntelligentViewController alloc] init];
//    evc.title = GDLocalizedString(@"EvaluateTitle");//@"评估";
//    evc.tabBarItem.image = [UIImage imageNamed:@"tabbar_evaluate"];
    MeViewController *mvc = [[MeViewController alloc] initWithNibName:NSStringFromClass([MeViewController class]) bundle:nil];
    mvc.title = GDLocalizedString(@"MeViewControllerTitle"); //@"我";
    
    self.viewControllers = @[[[XWGJNavigationController alloc] initWithRootViewController:dvc],
                                         [[XWGJNavigationController alloc] initWithRootViewController:cvc],
//                                         [[XWGJNavigationController alloc] initWithRootViewController:evc],
                                         [[XWGJNavigationController alloc] initWithRootViewController:mvc]];
    

    [self tabbaritem:0 nomalImage:@"search_nomal" selectImage:@"search_select"];
    [self tabbaritem:1 nomalImage:@"catigory_nomal" selectImage:@"catigory_select"];
    [self tabbaritem:2 nomalImage:@"center_nomal" selectImage:@"center_select"];

    self.tabBar.tintColor = [UIColor colorWithRed:43.0/255 green:193.0/255 blue:245.0/255 alpha:1];
}

-(void)tabbaritem:(NSInteger)index nomalImage:(NSString *)nomalName  selectImage:(NSString *)selectName
{
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *item = [tabBar.items objectAtIndex:index];
    UIImage *NomalImage = [UIImage imageNamed:nomalName];//@"catigory_nomal"];
    UIImage *SelectImage = [UIImage imageNamed:selectName];//@"catigory_select"];
    item.image  =[NomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [SelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
