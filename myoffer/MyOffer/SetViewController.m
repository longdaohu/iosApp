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
#import "ApplyViewController.h"
#import "FeedbackViewController.h"
#import "ChangeLanguageViewController.h"
#import "EngAboutViewController.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *setTableView;

@end

@implementation SetViewController



- (void)viewDidLoad {
    [super viewDidLoad];
 
    //左侧菜单按钮
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BurgerMenu_39"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu:)];
    self.title = GDLocalizedString(@"Setting-000");//@"设置"
     self.setTableView.tableFooterView = [[UIView alloc] init];
    
    
    ActionTableViewCell *(^newCell)(NSString *text, UIImage *icon, void (^action)(void)) = ^ActionTableViewCell*(NSString *text, UIImage *icon, void (^action)(void)) {
        ActionTableViewCell *cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = text;
        cell.imageView.image = icon;
        cell.action = action;
         return cell;
    };
    
    NSString *personInfoString = GDLocalizedString(@"Setting-001");//个人信息
    NSString *feedBackString = GDLocalizedString(@"Setting-003");//用户反馈
    NSString *aboutString = GDLocalizedString(@"Setting-004");//关于
    NSString *useLanString = GDLocalizedString(@"Setting-005");//切换语言
    
    self.cells = @[@[newCell(personInfoString, [UIImage imageNamed:@"me_profile"],
                             ^{
                                 RequireLogin
                                 ProfileViewController *vc = [[ProfileViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                    newCell(feedBackString, [UIImage imageNamed:@"me_feedback"],
                             ^{
                                 RequireLogin
                                 FeedbackViewController *vc = [[FeedbackViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                     newCell(aboutString, [UIImage imageNamed:@"me_about"],
                             ^{
                                 
                             EngAboutViewController *xengAbout =[[EngAboutViewController alloc] initWithNibName:@"EngAboutViewController" bundle:nil];
                             [self.navigationController pushViewController:xengAbout animated:YES];
                               
                             }),
                       newCell(useLanString, [UIImage imageNamed:@"language_39"],
                       ^{
                           ChangeLanguageViewController *vc = [[ChangeLanguageViewController alloc] initWithNibName:@"ChangeLanguageViewController" bundle:nil];
                           [self.navigationController pushViewController:vc animated:YES];
                       })]];
}

//打开左侧菜单
-(void)showLeftMenu:(UIBarButtonItem *)barButton
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}


@end
