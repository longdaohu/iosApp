//
//  HelpViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/25.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpDetailViewController.h"

@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *helpTableView;
@property(nonatomic,strong)NSArray *helpItems;


@end

@implementation HelpViewController

-(NSArray *)helpItems
{
    if (!_helpItems) {
        _helpItems = @[@"平台网站",@"如何申请",@"申请条件",@"递交申请",@"Offer管理",@"操作疑问"];
    }
    return _helpItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];


    self.title = GDLocalizedString(@"Left-helpCenter");
    self.helpTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, APPSIZE.height)];
    self.helpTableView.dataSource = self;
    self.helpTableView.delegate = self;
    self.helpTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.helpTableView];
 }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.helpItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.helpItems[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HelpDetailViewController *helpDetail = [[HelpDetailViewController alloc] initWithNibName:@"HelpDetailViewController" bundle:nil];
    helpDetail.index = indexPath.row;
    [self.navigationController pushViewController:helpDetail animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
