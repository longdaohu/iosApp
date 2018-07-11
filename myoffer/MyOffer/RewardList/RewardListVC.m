//
//  RewardListVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RewardListVC.h"
#import "RewardListCell.h"
#import "RewardDetailVC.h"
#import "RewardItem.h"

@interface RewardListVC ()
@property (weak, nonatomic) IBOutlet MyOfferTableView *tableView;
@property(nonatomic,strong)NSArray *items;
@end

@implementation RewardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self makeData];
}

-(void)makeUI{
    
    [self makeTableView];
    self.title = @"历史明细";
    
}

- (void)makeTableView{

    self.tableView.tableFooterView =[[UIView alloc] init];
    UINib *xib = [UINib nibWithNibName:@"RewardListCell" bundle:nil];
    [self.tableView registerNib:xib forCellReuseIdentifier:@"RewardListCell"];
    self.tableView.estimatedRowHeight = 75;//很重要保障滑动流畅性

}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RewardListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardListCell" forIndexPath:indexPath];
    cell.item  = self.items[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    RewardItem *item = self.items[indexPath.row];
    RewardDetailVC *vc = [RewardDetailVC new];
    vc.no_id = item.no_id;
    PushToViewController(vc);
}


- (void)makeData{
    
    WeakSelf;
    [self startAPIRequestWithSelector:kAPISelectorUserCashApplyItems parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
    }];
}

- (void)updateUIWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        [MBProgressHUD showMessage:NetRequest_ConnectError];
        [self.tableView emptyViewWithError:NetRequest_noNetWork];
        return;
    }
    NSDictionary *result = response[@"result"];
    self.items = [RewardItem  mj_objectArrayWithKeyValuesArray:result[@"items"]];
   
    [self.tableView emptyViewWithHiden:YES];
    if (self.items.count == 0) {
        [self.tableView emptyViewWithError:NetRequest_NoDATA];
    }
    [self.tableView reloadData];
 
}

- (void)dealloc{
    
    KDClassLog(@"奖励列表 + RewardListVC + dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
