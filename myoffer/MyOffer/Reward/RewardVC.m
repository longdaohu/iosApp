//
//  RewardVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RewardVC.h"
#import "PersonCell.h"
#import "RewardHeader.h"
#import "RewardListVC.h"
#import "ExtractionBVC.h"
#import "ExchangeAVC.h"

@interface RewardVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *group;
@property(nonatomic,copy)NSString *balance;

@end

@implementation RewardVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NavigationBarHidden(NO);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    [self makeUI];
}

- (NSArray *)group{
    
    if (!_group) {
        
        XWGJAbout *extract = [XWGJAbout cellWithLogo:@"recommend_dollor" title:@"兑换和提取"  sub_title:nil accessory_title: nil accessory_icon:nil] ;
        extract.action = NSStringFromSelector(@selector(caseExtract));
        extract.accessoryType = YES;
        XWGJAbout *history = [XWGJAbout cellWithLogo:@"recommend_history" title:@"历史明细"  sub_title:nil accessory_title: nil accessory_icon:nil] ;
        history.action = NSStringFromSelector(@selector(caseHistoryExtract));
        history.accessoryType = YES;
        
        _group = @[extract,history];
        
    }
    
    return _group;
}

- (void)makeUI{

    self.title = @"我的奖励";
    [self makeTableView];
}

- (void)makeTableView
{
    
    RewardHeader *header = [[RewardHeader alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 158)];
    self.tableView.tableHeaderView = header;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XWGJAbout *item =  self.group[indexPath.row];
    
    return  item.cell_height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.group.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XWGJAbout *item = self.group[indexPath.row];
    PersonCell *cell = [PersonCell cellWithTableView:tableView];
    cell.item = item;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    XWGJAbout *item = self.group[indexPath.row];
    if (item.action.length > 0) {
        [self performSelector:NSSelectorFromString(item.action) withObject:nil afterDelay:0.0];
    }
   
}

- (void)makeData{

    WeakSelf;
    [self startAPIRequestWithSelector:kAPISelectorUserCashBalance parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
    }];
}

- (void)updateUIWithResponse:(id)response{
    
    
    if (!ResponseIsOK) {
        [MBProgressHUD showMessage:NetRequest_ConnectError];
        return;
    }
    RewardHeader *header = (RewardHeader *)self.tableView.tableHeaderView;
    NSDictionary *result =  response[@"result"];
    self.balance =  [NSString stringWithFormat:@"%@",result[@"balance"]];
    header.dollor = self.balance;
}


- (void)caseExtract{
    
    if (self.balance.integerValue == 0) {
        [MBProgressHUD showMessage:@"您的余额不足无法发起该操作"];
        return;
    }
    ExchangeAVC *vc = [[ExchangeAVC alloc] init];
    vc.dollor = self.balance;
    PushToViewController(vc);
}

- (void)caseHistoryExtract{
    
    RewardListVC *vc =[[RewardListVC alloc] init];
    PushToViewController(vc);
}

- (void)dealloc{
    
    KDClassLog(@"我的奖励 + RewardVC + dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
