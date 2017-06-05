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
#import "XWGJAboutViewController.h"
#import "MenuItem.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *tableView;
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
        
        //个人信息
        MenuItem *profile   = [MenuItem menuItemInitWithName:GDLocalizedString(@"Setting-001") icon:@"me_profile"    classString: NSStringFromClass([ProfileViewController class])];
     
        //反馈
        MenuItem *feedBack  = [MenuItem menuItemInitWithName:GDLocalizedString(@"Setting-003") icon:@"me_feedback"   classString: NSStringFromClass([FeedbackViewController class])];
        
        //关于
        MenuItem *about   = [MenuItem menuItemInitWithName:GDLocalizedString(@"Setting-004") icon:@"me_about"  classString: NSStringFromClass([XWGJAboutViewController class])];
        
        
        _items   =  @[profile,feedBack,about];
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
    UITableView *tableView    = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate    = self;
    tableView.dataSource     = self;
    tableView.tableFooterView     = [[UIView alloc] init];
    self.tableView =  tableView;
    [self.view addSubview:tableView];
}


#pragma mark ——— UITableViewDelegate  UITableViewDataSoure

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
//    cell.imageView.image = [UIImage imageNamed:item.icon];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MenuItem *item  = self.items[indexPath.row];
   
    if ([item.classString isEqualToString: NSStringFromClass([ProfileViewController class])] || [item.classString isEqualToString:NSStringFromClass([FeedbackViewController class])] ) {
        
        RequireLogin
    }
    
    [self.navigationController pushViewController:[[NSClassFromString(item.classString) alloc] init] animated:YES];
    
}








@end
