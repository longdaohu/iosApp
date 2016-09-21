//
//  HelpViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/25.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "HelpViewController.h"
@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate>
/*
 */
@property(nonatomic,strong)UITableView *helpTableView;
@property(nonatomic,strong)NSArray *helpList;


@end

@implementation HelpViewController

-(NSArray *)helpList
{
    if (!_helpList) {
        _helpList = @[@"平台网站",@"如何申请",@"申请条件",@"递交申请",@"Offer管理",@"操作疑问"];
    }
    return _helpList;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

    [MobClick beginLogPageView:@"page帮助中心"];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page帮助中心"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
  
}

-(void)makeUI
{
    self.title                           = GDLocalizedString(@"Left-helpCenter");
    self.helpTableView                   = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, APPSIZE.height)];
    self.helpTableView.dataSource        = self;
    self.helpTableView.delegate          = self;
    self.helpTableView.tableFooterView   = [[UIView alloc] init];
    self.helpTableView.backgroundColor   = XCOLOR_BG;
    [self.view addSubview:self.helpTableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.helpList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text   = self.helpList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WebViewController *help = [[WebViewController alloc] init];
    help.path    = [NSString stringWithFormat:@"%@faq#index=%ld",DOMAINURL,(long)indexPath.row];
    [self.navigationController pushViewController:help animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
