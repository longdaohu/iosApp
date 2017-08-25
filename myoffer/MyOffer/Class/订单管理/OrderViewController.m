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
#import "OrderItemFrame.h"

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,assign)NSInteger nextPage;

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
        
         [self.tableView emptyViewWithError:GDLocalizedString(@"NetRequest-noNetWork")];
         
         return ;
    }
    
     [self.tableView.mj_header beginRefreshing];
    
}


-(NSMutableArray *)groups{
    
    if (!_groups) {
        
        _groups = [NSMutableArray array];
    }
    return _groups;
}


-(void)makeDataSourse:(NSInteger)page{
    
    XWeakSelf
  
    [self startAPIRequestWithSelector:kAPISelectorOrderList parameters:@{KEY_PAGE:@(page),KEY_SIZE:@(Parameter_Size)} expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];


}

- (void)loadNewData{
    
    self.nextPage = 0;

    [self makeDataSourse:self.nextPage];
    
}

- (void)loadMoreData{
    
    [self makeDataSourse:self.nextPage];
}


- (void)updateUIWithResponse:(NSDictionary *)response{
    
    //1 判断是否是第一页
    if (0 == self.nextPage) {
      
        [self.groups removeAllObjects];
        
        self.nextPage = 0;
    }
    self.nextPage += 1;
    
    
    //2 数据转模型
    NSArray *orders =  [OrderItem mj_objectArrayWithKeyValuesArray:response[@"orders"]];

    for (OrderItem *order in orders) {
        
        OrderItemFrame *order_frame = [[OrderItemFrame alloc] initWithOrder:order];
        
        [self.groups addObject:@[order_frame]];

    }
    [self.tableView reloadData];

    
     //3 结束刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (self.tableView.mj_footer) {
        
        if ( orders.count < Parameter_Size) {
            
            self.tableView.mj_footer =  nil;
        }
        
    }else{
        
        self.tableView.mj_footer =  [self makeMJ_footer];
        
    }
    
    
    //4 判断是否有数据，做相关提示
    if(self.groups.count == 0 ){
    
        [self.tableView emptyViewWithError:@"还没有购买服务！！！"];

    }else{
    
        [self.tableView emptyViewWithHiden:YES];
        
    }
 
    
}

- (void)makeUI{
    
    self.title = @"订单中心";
    
    [self makeTableView];
}


-(void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XNAV_HEIGHT, 0);
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



#pragma mark : UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *orders = self.groups[section];
    
    return orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    OrderCell *cell =[OrderCell cellWithTableView:tableView];
    
    NSArray *orders_frame = self.groups[indexPath.section];

    OrderItemFrame *orderFrame = orders_frame[indexPath.row];
    
    cell.orderFrame = orderFrame;
    XWeakSelf
    cell.orderBlock = ^(OrderCellType type) {
        
        switch (type) {
            case OrderCellTypeDelete:
                [weakSelf cancelOrder:indexPath order:orderFrame.order];
                break;
            case OrderCellTypePay:
                [weakSelf payOrder:indexPath order:orderFrame.order];
                break;
            default:
                break;
        }
        
    };
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Section_footer_Height_nomal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return   HEIGHT_ZERO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
     NSArray *orders_frame = self.groups[indexPath.section];
    
    OrderItemFrame *order_Frame = orders_frame[indexPath.row];
    
    return order_Frame.cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *orders_frame = self.groups[indexPath.section];
    
     OrderItemFrame *order_Frame = orders_frame[indexPath.row];
    
    XWeakSelf
    OrderDetailViewController  *detail = [[OrderDetailViewController alloc] init];
    detail.order  =  order_Frame.order;
    detail.actionBlock = ^(BOOL isSuccess){
        
        if (isSuccess) {
            
            order_Frame.order.status_close = YES;
            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    
    [self.navigationController pushViewController:detail  animated:YES];
}


#pragma mark : 事件处理

//支付
-(void)payOrder:(NSIndexPath *)indexPath order:(OrderItem *)order{

     PayOrderViewController  *pay = [[PayOrderViewController alloc] init];
     pay.order  =  order;
    
     XWeakSelf
    pay.actionBlock = ^(BOOL isSuccess){
      
         if (isSuccess) {
            
            order.status_finish = YES;

            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    
    [self.navigationController pushViewController:pay  animated:YES];
}


//取消
-(void)cancelOrder:(NSIndexPath *)indexPath order:(OrderItem *)order{
    
    XWeakSelf
    NSString *path = [NSString stringWithFormat:kAPISelectorOrderClose,order.order_id];
    
    
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        if ([response[@"result"] isEqualToString:@"OK"]) {
            
             order.status_close = YES;
            
             [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         }
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    KDClassLog(@"订单中心 OrderViewController  dealloc");
    
}

@end
