//
//  InvitationRecordDetailVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "InvitationRecordDetailVC.h"
#import "InvitationRecordUserCell.h"
#import "InvitationRecordHeader.h"
#import "InvitationRecordDetailCell.h"
#import "RewardDetailItem.h"

@interface InvitationRecordDetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *groups;
@end

@implementation InvitationRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeData];
}

- (void)makeUI{
    
    self.title = @"详情";
    [self makeTableView];
}

- (void)makeTableView
{

    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
 
    UINib *user_xib = [UINib nibWithNibName:@"InvitationRecordUserCell" bundle:nil];
    [self.tableView registerNib:user_xib forCellReuseIdentifier:@"InvitationRecordUserCell"];
    UINib *detail_xib = [UINib nibWithNibName:@"InvitationRecordDetailCell" bundle:nil];
    [self.tableView registerNib:detail_xib forCellReuseIdentifier:@"InvitationRecordDetailCell"];
    
    self.tableView.estimatedRowHeight = 100;//很重要保障滑动流畅性
    

 
    
//    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
//        self.tableView.contentInset = UIEdgeInsetsMake(Nav_Height, 0, 0, 0);
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)makeData{
    
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"%@%@",kAPISelectorPromotionItemDetail,self.no_id];
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
    }];
}

- (void)updateUIWithResponse:(id)response{
    
    //网络请求出错
    if (!ResponseIsOK) {
        [MBProgressHUD showMessage:NetRequest_ConnectError];
         return;
    }
    RewardDetailItem  *detail = [RewardDetailItem mj_objectWithKeyValues:response[@"result"]];
    myofferGroupModel *two = [myofferGroupModel groupWithItems:detail.otherGroup header:@"被推荐人个人信息"];
    myofferGroupModel *three = [myofferGroupModel groupWithItems:detail.stateHistory header:@"进度详情"];
    self.groups = @[two,three];
    [self.tableView reloadData];
}

//- (NSArray *)groups{
//
//    if (!_groups) {
//        myofferGroupModel *cash = [myofferGroupModel groupWithItems:nil header:@"消耗的现金券"];
//        myofferGroupModel *progress = [myofferGroupModel groupWithItems:nil header:@"进度详情"];
//
//        _groups = @[cash,progress];
//    }
//
//    return   _groups;
//}

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
    if (indexPath.section == 0) {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return   Bundle(@"InvitationRecordUserFooter");
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 57;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    myofferGroupModel *group  = self.groups[section];
    InvitationRecordHeader *header =  Bundle(@"InvitationRecordHeader");
    header.title = group.header_title;
    
    return header;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    KDClassLog(@"邀请用户详情 + InvitationRecordDetailVC + dealloc");

}



@end
