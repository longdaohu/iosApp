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
#import "MenuItem.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *TableView;
@property(nonatomic,strong)NSArray *items;
@end

@implementation SetViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

    [MobClick beginLogPageView:@"page设置中心"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page设置中心"];
    
}


-(NSArray *)items{
    
    if (!_items) {
        
        MenuItem *profile        = [MenuItem menuItemInitWithName:GDLocalizedString(@"Setting-001") icon:@"me_profile" count:@""];
        MenuItem *feedBack       = [MenuItem menuItemInitWithName:GDLocalizedString(@"Setting-003") icon:@"me_feedback" count:@""];
        MenuItem *about          = [MenuItem menuItemInitWithName:GDLocalizedString(@"Setting-004") icon:@"me_about" count:@""];
//      MenuItem *changeLanguage = [MenuItem menuItemInitWithName:GDLocalizedString(@"Setting-005") icon:@"language_39" count:@""];
        _items                   =  @[profile,feedBack,about];
    }
    return _items;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = GDLocalizedString(@"Setting-000");
    
    [self makeTableView];
    
}


-(void)makeTableView
{
    self.TableView                     = [[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight) style:UITableViewStyleGrouped];
    self.TableView.delegate            = self;
    self.TableView.dataSource          = self;
    self.TableView.tableFooterView     = [[UIView alloc] init];
    [self.view addSubview:self.TableView];
}


#pragma mark —————— UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.items.count;
}

static NSString *identify = @"set";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    MenuItem *item       = self.items[indexPath.row];
    cell.textLabel.text  = item.name;
    cell.imageView.image = [UIImage imageNamed:item.icon];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self caseProfile];
             break;
        case 1:
            [self caseFeedBack];
            break;
        case 2:
            [self caseAbout];
            break;
        default:
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}


//个人信息
-(void)caseProfile{
    
    RequireLogin
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//反馈
-(void)caseFeedBack{
    
    RequireLogin
    [MobClick event:@"changeUserFeedback"];
    FeedbackViewController *vc = [[FeedbackViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//关于
-(void)caseAbout{
    
    [MobClick event:@"aboutItemClick"];
    XWGJAboutViewController *About =[[XWGJAboutViewController alloc] init];
    [self.navigationController pushViewController:About animated:YES];
}

//语言切换
-(void)caseChangeLanguage{
    
    [MobClick event:@"changeUserLanguage"];
     ChangeLanguageViewController *vc = [[ChangeLanguageViewController alloc] initWithNibName:@"ChangeLanguageViewController" bundle:nil];
     [self.navigationController pushViewController:vc animated:YES];
}



@end
