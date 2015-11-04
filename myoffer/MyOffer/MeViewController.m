
//
//  MeViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "MeViewController.h"
#import "ProfileViewController.h"
#import "FXBlurView.h"
#import "FavoriteViewController.h"
#import "ApplyViewController.h"
#import "ApplySubmitViewController.h"
#import "MyOfferViewController.h"
#import "ApplyMatialViewController.h"

@interface MeViewController ()  {
}

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
      //左侧菜单按钮
     self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BurgerMenu_39"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu:)];
 
    
    
    ActionTableViewCell *(^newCell)(NSString *text, UIImage *icon, void (^action)(void)) = ^ActionTableViewCell*(NSString *text, UIImage *icon, void (^action)(void)) {
        ActionTableViewCell *cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = text;
        cell.imageView.image = icon;
        cell.action = action;
        
        return cell;
    };
    
    NSString *list = GDLocalizedString(@"Me-001");//"我的申请意向";
    NSString *status = GDLocalizedString(@"Me-002");//"申请状态";
    NSString *material = GDLocalizedString(@"Me-003");//"申请材料";
    NSString *uniString = GDLocalizedString(@"Setting-002");//我的关注院校

    
    self.cells = @[@[ newCell(list, [UIImage imageNamed:@"list_39"],
                              ^{
                                  RequireLogin
                                  
                                  ApplyViewController *vc = [[ApplyViewController alloc] init];
                                  [self.navigationController pushViewController:vc animated:YES];
                              }),
                      newCell(status, [UIImage imageNamed:@"status_39"],
                              ^{
                                  RequireLogin
                                  ApplySubmitViewController *vc = [[ApplySubmitViewController alloc] initWithNibName:@"ApplySubmitViewController" bundle:nil];
                                  vc.hidesBottomBarWhenPushed = YES;
                                  [self.navigationController pushViewController:vc animated:YES];
                              }),
                      newCell(uniString, [UIImage imageNamed:@"me_like"],
                              ^{
                                  RequireLogin
                                  FavoriteViewController *vc = [[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:nil];
                                  [self.navigationController pushViewController:vc animated:YES];
                              }),
                      newCell(material, [UIImage imageNamed:@"materials_39"],
                              ^{
                                  RequireLogin
                                  ApplyMatialViewController *vc = [[ApplyMatialViewController alloc] initWithNibName:@"ApplyMatialViewController" bundle:nil];
                                  vc.hidesBottomBarWhenPushed = YES;
                                  [self.navigationController pushViewController:vc animated:YES];
                              }),
                      newCell(@"myOffer", [UIImage imageNamed:@"myoffer_39"],
                              ^{
                                  RequireLogin
                                  MyOfferViewController *vc = [[MyOfferViewController alloc] initWithNibName:@"MyOfferViewController" bundle:nil];
                                  vc.hidesBottomBarWhenPushed = YES;
                                  [self.navigationController pushViewController:vc animated:YES];
                              })] ];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
 }


- (IBAction)logout {
    NSString *cancelString = GDLocalizedString(@"Me-007"); //取消
    NSString *commintString = GDLocalizedString(@"Me-006"); //@"确认注销"
    KDActionSheet *as = [[KDActionSheet alloc] initWithTitle:nil cancelButtonTitle:cancelString cancelAction:nil destructiveButtonTitle:commintString destructiveAction:^{
        [[AppDelegate sharedDelegate] logout];
     }];
    [as showInView:self.view];
}



//打开左侧菜单
-(void)showLeftMenu:(UIBarButtonItem *)barButton
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}

@end
