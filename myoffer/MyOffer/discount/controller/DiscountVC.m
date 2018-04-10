//
//  DiscountVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/2.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "DiscountVC.h"
#import "DiscountCell.h"
#import "DiscountItem.h"
#import "MyOfferServerMallViewController.h"

@interface DiscountVC ()
@property (weak, nonatomic) IBOutlet MyOfferTableView *tableView;
@property(nonatomic,strong)NSArray *items;

@end

@implementation DiscountVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
 
    [MobClick beginLogPageView:@"page我的优惠"];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page我的优惠"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    [self makeUI];
}

- (void)makeData{
    
    NSString *path  = @"GET svc/marketing/coupons/get";
   XWeakSelf
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        [MBProgressHUD showError:@"网络请求失败！"];
    }];
}

- (void)updateWithResponse:(id)response{

    NSArray *result  = response[@"result"];
     self.items = [DiscountItem mj_objectArrayWithKeyValuesArray:result];

    if (self.items.count == 0) {
        self.tableView.empty_icon = @"discount_no";
        [self.tableView emptyViewWithError:@"亲，没有可使用的优惠券，快去参加活动吧！"];
    }
     [self.tableView reloadData];
    
}

- (void)makeUI{
    self.title = @"我的优惠";
    [self makeTableView];
}

- (void)makeTableView
{
    self.tableView.tableFooterView =[[UIView alloc] init];
    UINib *xib = [UINib nibWithNibName:@"DiscountCell" bundle:nil];
    [self.tableView registerNib:xib forCellReuseIdentifier:@"DiscountCell"];
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XWeakSelf;
    DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscountCell" forIndexPath:indexPath];
    cell.item = self.items[indexPath.section];
    cell.discountCellBlock = ^{
        MyOfferServerMallViewController  *vc = [[MyOfferServerMallViewController alloc] initWithNibName:@"MyOfferServerMallViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NSLog(@"优惠 + DiscountVC + dealloc");
}


@end
