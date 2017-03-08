//
//  OrderViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderCell.h"
#import "PayOrderViewController.h"
#import "OrderDetailViewController.h"
#import "OrderItem.h"
#import "XWGJnodataView.h"

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,OrderTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *orderGroup;
@property(nonatomic,assign)NSInteger nextPage;
@property(nonatomic,strong)XWGJnodataView *nodataView;

@end

@implementation OrderViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page订单中心"];
    
    self.navigationController.navigationBarHidden = NO;
    
    if (self.refresh) {
        
        [self loadNewData];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page订单中心"];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
     if (![self checkNetWorkReaching]) {
        
         self.nodataView.hidden = NO;
         
         return ;
    }
    
     [self.tableView.mj_header beginRefreshing];
    
}

-(XWGJnodataView *)nodataView{

    if (!_nodataView) {
       
        _nodataView =[XWGJnodataView noDataView];
        
        [self.view insertSubview:_nodataView aboveSubview:self.tableView];
    }
    
    return _nodataView;
}


-(NSMutableArray *)orderGroup{
    
    if (!_orderGroup) {
        
        _orderGroup = [NSMutableArray array];
    }
    return _orderGroup;
}


-(void)makeDataSourse:(NSInteger)page{

    XWeakSelf
    NSString *path =[NSString stringWithFormat:kAPISelectorOrderList,(long)page];
  
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        if ( 200 == statusCode && 0 == page) {
             weakSelf.nextPage =0;
             [weakSelf.orderGroup removeAllObjects];
        }
        
        weakSelf.nextPage += 1;
        [weakSelf configrationUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];


}

- (void)loadNewData{
    
    [self makeDataSourse:0];
    
}

- (void)loadMoreData{
    
    [self makeDataSourse:self.nextPage];
}


- (void)configrationUIWithResponse:(id)response{

    for (NSDictionary *dict in  response[@"orders"]) {
        
        OrderItem *order = [OrderItem  mj_objectWithKeyValues:dict];
        [self.orderGroup addObject:order];
    }
    
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer = 10 > [response[@"orders"] count] ? nil : [self makeMJ_footer];
    
    [self.tableView reloadData];
    
    self.nodataView.hidden = self.orderGroup.count > 0;
    self.nodataView.errorStr = @"还没有购买服务！！！";
    
}

- (void)makeUI{
    
    self.title = @"订单中心";
    [self makeTableView];
}

-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = mj_header;
    
}

- (MJRefreshBackNormalFooter *)makeMJ_footer{
    
    return [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}



#pragma mark —————— UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderGroup.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    OrderCell *cell =[OrderCell cellWithTableView:tableView indexPath:indexPath];
  
    cell.order = self.orderGroup[indexPath.section];
    
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return PADDING_TABLEGROUP;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return   HEIGHT_ZERO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return Uni_Cell_Height + 25;
}

#pragma mark ----- OrderTableViewCellDelegate
-(void)cellIndexPath:(NSIndexPath *)indexPath sender:(UIButton *)sender
{
    switch (sender.tag) {
        case 11:
            [self cancelOrder:indexPath];
            break;
        case 10:
            [self payOrder:indexPath];
            break;
        default:
            [self OrderDetal:indexPath];
             break;
    }
  
}

//详情
-(void)OrderDetal:(NSIndexPath *)indexPath{

    XWeakSelf
    OrderDetailViewController  *detail = [[OrderDetailViewController alloc] init];
    detail.order  =  self.orderGroup[indexPath.section];
    detail.actionBlock = ^(BOOL isSuccess){
        OrderItem *order = self.orderGroup[indexPath.section];
        if (isSuccess) {
            order.status = @"ORDER_CLOSED";
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    [self.navigationController pushViewController:detail  animated:YES];
}

//支付
-(void)payOrder:(NSIndexPath *)indexPath{

    XWeakSelf
    PayOrderViewController  *pay = [[PayOrderViewController alloc] init];
    pay.order  =  self.orderGroup[indexPath.section];
    pay.actionBlock = ^(BOOL isSuccess){
      
        OrderItem *order = self.orderGroup[indexPath.section];
        if (isSuccess) {
             order.status = @"ORDER_FINISHED";
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    
    [self.navigationController pushViewController:pay  animated:YES];
}


//取消
-(void)cancelOrder:(NSIndexPath *)indexPath{
    
    OrderItem *order = self.orderGroup[indexPath.section];
    XWeakSelf
    NSString *path = [NSString stringWithFormat:kAPISelectorOrderClose,order.order_id];
    
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        if ([response[@"result"] isEqualToString:@"OK"]) {
            
              order.status = @"ORDER_CLOSED";
            
             [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         }
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    KDClassLog(@"订单中心  dealloc");
    
}

@end
