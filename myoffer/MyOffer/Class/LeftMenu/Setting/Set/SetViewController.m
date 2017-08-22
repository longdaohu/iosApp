//
//  SetViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "SetViewController.h"
#import "ProfileViewController.h"
#import "ApplyViewController.h"
#import "FeedbackViewController.h"
#import "XWGJAboutViewController.h"
#import "MenuItem.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong)NSArray *logout_group;
@end

@implementation SetViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

    [MobClick beginLogPageView:@"page设置中心"];
    
    [self change];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page设置中心"];
    
}

- (void)change{

    
    if (LOGIN) {
    
        if (self.groups.count == 1) {
            
            [self.groups addObject:self.logout_group];
            
            [self.tableView reloadData];

        }
        
        
    }else{
    
        if (self.groups.count > 1) {
            
            [self.groups removeLastObject];
            
            [self.tableView reloadData];
            
        }
        

    }
    
}


- (NSArray *)logout_group{

    if (!_logout_group) {
        
        //退出
        MenuItem *logout   = [MenuItem menuItemInitWithName:@"退出登录" icon:@"me_about"  classString: nil];
        logout.action = NSStringFromSelector(@selector(caseLogout));
        
        _logout_group = @[logout];

    }
    
    return _logout_group;
}



- (NSArray *)groups{

    if (!_groups) {
        
        //个人信息
        MenuItem *profile   = [MenuItem menuItemInitWithName:GDLocalizedString(@"Setting-001") icon:@"me_profile"    classString: NSStringFromClass([ProfileViewController class])];
        profile.action = NSStringFromSelector(@selector(caseProfile:));
        //反馈
        MenuItem *feedBack  = [MenuItem menuItemInitWithName:GDLocalizedString(@"Setting-003") icon:@"me_feedback"   classString: NSStringFromClass([FeedbackViewController class])];
        feedBack.action = NSStringFromSelector(@selector(caseFeed:));

        //关于
        MenuItem *about   = [MenuItem menuItemInitWithName:GDLocalizedString(@"Setting-004") icon:@"me_about"  classString: NSStringFromClass([XWGJAboutViewController class])];
        about.action = NSStringFromSelector(@selector(caseAbout:));
    

        NSArray *set = @[profile,feedBack,about];
  
        
        _groups   =  [NSMutableArray array];
        
        [_groups addObject:set];
        
    }
    
    
    return _groups;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = GDLocalizedString(@"Setting-000");
    
    [self makeTableView];
    
}


-(void)makeTableView
{
    UITableView *tableView    = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate    = self;
    tableView.dataSource     = self;
    tableView.tableFooterView     = [[UIView alloc] init];
    self.tableView =  tableView;
    [self.view addSubview:tableView];
}


#pragma mark ——— UITableViewDelegate  UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.groups[section] count];
}

static NSString *identify = @"set";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    if (indexPath.section == 1) {
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }else{
    
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    
    NSArray *items = self.groups[indexPath.section];
    MenuItem *item       = items[indexPath.row];
    cell.textLabel.text  = item.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *items = self.groups[indexPath.section];
    MenuItem *item       = items[indexPath.row];
    
    if (item.action.length > 0) {
        
        [self performSelector:NSSelectorFromString(item.action) withObject:item afterDelay:0];
    }
    
}

- (void)caseFeed:(MenuItem *)item{

    RequireLogin
    
    [self.navigationController pushViewController:[[NSClassFromString(item.classString) alloc] init] animated:YES];
}

- (void)caseProfile:(MenuItem *)item{

    RequireLogin
    [self.navigationController pushViewController:[[NSClassFromString(item.classString) alloc] init] animated:YES];

}

- (void)caseAbout:(MenuItem *)item{
    
    [self.navigationController pushViewController:[[NSClassFromString(item.classString) alloc] init] animated:YES];

}

-(void)caseLogout{
    
    [[AppDelegate sharedDelegate] logout];

    [self dismiss];
    
}





@end
