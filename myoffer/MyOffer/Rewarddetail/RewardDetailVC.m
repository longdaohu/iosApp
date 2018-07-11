//
//  RewardDetailVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RewardDetailVC.h"
#import "RewardDetailItem.h"
#import "RewardDetailCelltem.h"
#import "InvitationRecordHeader.h"
#import "InvitationRecordUserCell.h"
#import "InvitationRecordDetailCell.h"
#import "RewardHeader.h"

@interface RewardDetailVC ()
@property(nonatomic,strong)NSArray *groups;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RewardDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeUI];
    [self makeData];
}

- (void)makeData{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",kAPISelectorUserCashApplyDetail,self.no_id];
    WeakSelf;
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
    }];
}

- (void)updateUIWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        [MBProgressHUD showMessage:NetRequest_ConnectError];
        return;
    }
    RewardDetailItem *detail = [RewardDetailItem mj_objectWithKeyValues:response[@"result"]];
    myofferGroupModel *one = [myofferGroupModel groupWithItems:detail.statusGroup header:@""];
    myofferGroupModel *two = [myofferGroupModel groupWithItems:detail.userGroup header:@"收款账户信息"];
    myofferGroupModel *three = [myofferGroupModel groupWithItems:detail.stateHistory header:@"进度详情"];
    self.groups = @[one,two,three];
    
    RewardHeader *header = (RewardHeader *)self.tableView.tableHeaderView;
    header.isMoney = YES;
    header.dollor = detail.amount;
    
    [self.tableView reloadData];
    
}

- (void)makeUI{
    
    self.title = @"详情";
    [self makeTableView];
}

- (void)makeTableView
{
    RewardHeader *header = [[RewardHeader alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 158)];
    header.title = @"到账金额（元）";
    [header bottomLineHiden:YES];
    self.tableView.tableHeaderView = header;
    self.tableView.tableFooterView =[[UIView alloc] init];
 
    UINib *user_xib = [UINib nibWithNibName:@"InvitationRecordUserCell" bundle:nil];
    [self.tableView registerNib:user_xib forCellReuseIdentifier:@"InvitationRecordUserCell"];
    UINib *detail_xib = [UINib nibWithNibName:@"InvitationRecordDetailCell" bundle:nil];
    [self.tableView registerNib:detail_xib forCellReuseIdentifier:@"InvitationRecordDetailCell"];
    self.tableView.estimatedRowHeight = 100;//很重要保障滑动流畅性
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myofferGroupModel *group  = self.groups[indexPath.section];
    if (indexPath.section == 0 || indexPath.section == 1 ) {
        InvitationRecordUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationRecordUserCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.item = group.items[indexPath.row];
        [cell cellSeparatorHiden:(indexPath.row == 0)];
        
        return cell;
    }

    InvitationRecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationRecordDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIColor *clr = indexPath.row % 2 ?  XCOLOR(235, 236, 237, 1) : XCOLOR(245, 247, 249, 1);
    cell.contentView.backgroundColor = clr;
    cell.item = group.items[indexPath.row];
 
    return cell;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return (self.groups.count - 1 == section) ? HEIGHT_ZERO : 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return   Bundle(@"InvitationRecordUserFooter");
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.groups[section];
    return group.header_title.length ? 57 : HEIGHT_ZERO;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    myofferGroupModel *group  = self.groups[section];
    InvitationRecordHeader *header =  Bundle(@"InvitationRecordHeader");
    header.title = group.header_title;
    
    return header;
}

- (void)dealloc{
    
    KDClassLog(@"奖励详情 + RewardDetailVC + dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
