//
//  SetViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "SetViewController.h"
#import "ProfileViewController.h"
#import "FXBlurView.h"
#import "FavoriteViewController.h"
#import "ApplyViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "ChangeLanguageViewController.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *setTableView;

@end

@implementation SetViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = @"设置";
    
    self.setTableView.tableFooterView = [[UIView alloc] init];
    
    
    ActionTableViewCell *(^newCell)(NSString *text, UIImage *icon, void (^action)(void)) = ^ActionTableViewCell*(NSString *text, UIImage *icon, void (^action)(void)) {
        ActionTableViewCell *cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = text;
        cell.imageView.image = icon;
        cell.action = action;
        
        return cell;
    };
    
    self.cells = @[@[newCell(@"个人信息", [UIImage imageNamed:@"me_profile"],
                             ^{
                                 RequireLogin
                                 ProfileViewController *vc = [[ProfileViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                     newCell(@"我的关注院校", [UIImage imageNamed:@"me_like"],
                             ^{
                                 RequireLogin
                                 FavoriteViewController *vc = [[FavoriteViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                    newCell(@"用户反馈", [UIImage imageNamed:@"me_feedback"],
                             ^{
                                 RequireLogin
                                 FeedbackViewController *vc = [[FeedbackViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                     newCell(@"关于", [UIImage imageNamed:@"me_about"],
                             ^{
                                 AboutViewController *vc = [[AboutViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                       newCell(@"切换语言", [UIImage imageNamed:@"language_39"],
                       ^{
                           ChangeLanguageViewController *vc = [[ChangeLanguageViewController alloc] initWithNibName:@"ChangeLanguageViewController" bundle:nil];
                           [self.navigationController pushViewController:vc animated:YES];
                       })]];
    

}

@end
