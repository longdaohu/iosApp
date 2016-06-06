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
#import "XWGJAboutViewController.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *setTableView;

@end

@implementation SetViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page设置中心"];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page设置中心"];
    
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
 

    self.title = GDLocalizedString(@"Setting-000");
    
    self.setTableView.tableFooterView = [[UIView alloc] init];
     self.setTableView.backgroundColor = BACKGROUDCOLOR;
    
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
                     newCell(useLanString, [UIImage imageNamed:@"language_39"],
                             ^{
                                 [MobClick event:@"changeUserLanguage"];
                                 ChangeLanguageViewController *vc = [[ChangeLanguageViewController alloc] initWithNibName:@"ChangeLanguageViewController" bundle:nil];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                     
                    newCell(feedBackString, [UIImage imageNamed:@"me_feedback"],
                             ^{
                                 RequireLogin
                                 [MobClick event:@"changeUserFeedback"];
                                 FeedbackViewController *vc = [[FeedbackViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                     newCell(aboutString, [UIImage imageNamed:@"me_about"],
                             ^{
                                [MobClick event:@"aboutItemClick"];
                                XWGJAboutViewController *About =[[XWGJAboutViewController alloc] init];
                             [self.navigationController pushViewController:About animated:YES];
                               
                             })
                    ]];
}



@end
