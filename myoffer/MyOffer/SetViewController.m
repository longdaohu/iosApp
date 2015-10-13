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
#import "EngAboutViewController.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *setTableView;

@end

@implementation SetViewController



- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSString *settingString = GDLocalizedString(@"Setting-000");//@"设置"

    self.title = settingString;
    
    self.setTableView.tableFooterView = [[UIView alloc] init];
    
    
    ActionTableViewCell *(^newCell)(NSString *text, UIImage *icon, void (^action)(void)) = ^ActionTableViewCell*(NSString *text, UIImage *icon, void (^action)(void)) {
        ActionTableViewCell *cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = text;
        cell.imageView.image = icon;
        cell.action = action;
        
        return cell;
    };
    NSString *personInfoString = GDLocalizedString(@"Setting-001");//个人信息
    NSString *uniString = GDLocalizedString(@"Setting-002");//我的关注院校
    NSString *feedBackString = GDLocalizedString(@"Setting-003");//用户反馈
    NSString *aboutString = GDLocalizedString(@"Setting-004");//关于
    NSString *useLanString = GDLocalizedString(@"Setting-005");//切换语言
    
    self.cells = @[@[newCell(personInfoString, [UIImage imageNamed:@"me_profile"],
                             ^{
                                 RequireLogin
                                 ProfileViewController *vc = [[ProfileViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                     newCell(uniString, [UIImage imageNamed:@"me_like"],
                             ^{
                                 RequireLogin
                                 FavoriteViewController *vc = [[FavoriteViewController alloc] init];
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
                                 
                                 NSString *lang =  [InternationalControl userLanguage];
                                 if ([lang containsString:@"en"]) {
                                     NSLog(@"sdfsfasfasfasfsa");
                                   
                                     EngAboutViewController *xengAbout =[[EngAboutViewController alloc] initWithNibName:@"EngAboutViewController" bundle:nil];
                                     [self.navigationController pushViewController:xengAbout animated:YES];
                                     
                                 }else {
                                     
                                     AboutViewController *vc = [[AboutViewController alloc] init];
                                     [self.navigationController pushViewController:vc animated:YES];
                                 }
                              
                             }),
                       newCell(useLanString, [UIImage imageNamed:@"language_39"],
                       ^{
                           ChangeLanguageViewController *vc = [[ChangeLanguageViewController alloc] initWithNibName:@"ChangeLanguageViewController" bundle:nil];
                           [self.navigationController pushViewController:vc animated:YES];
                       })]];
}

@end