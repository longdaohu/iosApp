//
//  myofferBaseTableViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "myofferBaseTableViewController.h"
#import "PersonCell.h"
#import "HomeSectionHeaderView.h"

@interface myofferBaseTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation myofferBaseTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
    tableView.backgroundColor = XCOLOR_BG;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    myofferGroupModel *group = self.datas[section];
    
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    PersonCell *cell =[PersonCell cellWithTableView:tableView];
    
    myofferGroupModel *group = self.datas[indexPath.section];
    [cell bottomLineShow:(indexPath.row != (group.items.count - 1))];
    cell.item = group.items[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    myofferGroupModel *group = self.datas[section];
    
    return   group.section_header_height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    myofferGroupModel *group = self.datas[section];
    
    return   group.section_footer_height;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.datas[section];

    HomeSectionHeaderView *sectionView = [HomeSectionHeaderView sectionHeaderViewWithTitle:group.header_title];
    
    return sectionView;
}










@end
