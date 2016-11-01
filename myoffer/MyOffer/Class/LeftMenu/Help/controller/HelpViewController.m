//
//  HelpViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/25.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "HelpViewController.h"
@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
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
    self.tableView                   = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
    self.tableView.dataSource        = self;
    self.tableView.delegate          = self;
    self.tableView.tableFooterView   = [[UIView alloc] init];
    self.tableView.backgroundColor   = XCOLOR_BG;
    [self.view addSubview:self.tableView];

}

#pragma mark ——— UITableViewDelegate  UITableViewDataSoure
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


-(void)dealloc
{
    KDClassLog(@"帮助中心  dealloc");   //可以释放
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
