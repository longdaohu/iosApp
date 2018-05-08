//
//  NotificationViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/30.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "NotificationViewController.h"
#import "TongzhiCell.h"
#import "NotiItem.h"


@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;
//网络请求结果
@property(nonatomic,strong)NSMutableArray *group;
//请求数据第几页
@property(nonatomic,assign)int nextPage;

@property(nonatomic,strong)MJRefreshBackNormalFooter *footer_mj;

@end

@implementation NotificationViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.navigationController.navigationBarHidden = NO;
  
    [MobClick beginLogPageView:@"page通知中心"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page通知中心"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self.tableView.mj_header beginRefreshing];
}

-(NSMutableArray *)group
{
    if (!_group) {
        
        _group = [NSMutableArray array];
    }
    return _group;
}

-(void)makeTableView
{
    self.tableView = [[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XNAV_HEIGHT, 0);
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 68;

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = mj_header;
   
    self.footer_mj = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = self.footer_mj;
    
    
}


-(void)makeUI
{
    [self makeTableView];
    
     self.title  = @"通知中心";

}


//数据源请求
-(void)getDataSourse:(int)page
{
  
    WeakSelf

    [self
     startAPIRequestWithSelector:kAPISelectorTongZhiList
     parameters:@{KEY_PAGE:@(page),KEY_SIZE:@(Parameter_Size),@"client":@"app"}
     expectedStatusCodes:nil
     showHUD:YES
     showErrorAlert:YES
     errorAlertDismissAction:nil
     additionalSuccessAction:^(NSInteger statusCode, id response) {
         
         [weakSelf updateUIWithResponse:response];

     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
         [weakSelf requestError];
         
     }];
}

- (void)requestError{

    [self.group removeAllObjects];
    [self.tableView reloadData];
    [self endMJ_Fresh];
    [self.tableView emptyViewWithError:GDLocalizedString(@"NetRequest-noNetWork")];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}

//配置页面控件
- (void)updateUIWithResponse:(id)response{
    
    //1 每次刷新，选删除原有数据
    if ( 0  == self.nextPage) {
        
        self.nextPage = 0;
        [self.group removeAllObjects];

    }
        
    self.nextPage += 1;
 
    //2 数据转模型
    NSArray *messages = [NotiItem mj_objectArrayWithKeyValuesArray:response[@"messages"]];
    [self.group addObjectsFromArray:messages];

    [self.tableView reloadData];

    //结束刷新
    [self endMJ_Fresh];
  
    //是否提示无数据状态
    [self updateTableViewStatus];
 
    //判断是否显示上拉刷新
    if( Parameter_Size > messages.count)
    {
        self.tableView.mj_footer =  nil;
        
    }else{
        
        if (!self.tableView.mj_footer) {
            
            self.tableView.mj_footer =  self.footer_mj;
        }
        
    }
    
}

// mj_header  mj_footer 结束刷新
-(void)endMJ_Fresh{

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)updateTableViewStatus{

    if (0 == self.group.count) {
        
        self.tableView.mj_header = nil;
        self.tableView.mj_footer = nil;
    }
    
    
    //是否提示无数据状态
    if (self.group.count == 0) {
        
        [self.tableView emptyViewWithError:@"没有通知消息哦！"];
        
    }else{
        
        [self.tableView emptyViewWithHiden:YES];
    }

}

 //加载新数据
- (void)loadNewData{
    
     self.nextPage = 0;
    
    [self getDataSourse:self.nextPage];
    
}

//加载更多数据
- (void)loadMoreData{
    
     [self getDataSourse:self.nextPage];
}

#pragma mark : UITableViewDelegate  UITableViewDataSoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TongzhiCell *cell = [TongzhiCell cellWithTableView:tableView];
    cell.noti         = self.group[indexPath.row];
    [cell separatorLineShow:(self.group.count - 1 == indexPath.row)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    NotiItem *noti  = self.group[indexPath.row];
    noti.state_read = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    WebViewController *detail = [[WebViewController alloc] init];
    detail.path    = [NSString stringWithFormat:@"%@account/message/%@?client=app",DOMAINURL,noti.NO_id];
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NotiItem *noti  = self.group[indexPath.row];
        NSString *path  = [NSString stringWithFormat:kAPISelectorDeleteTongZhi,noti.NO_id];
        
        //提交删除项到服务器
        WeakSelf
        [self startAPIRequestWithSelector:path parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
            
            [weakSelf.group removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf updateTableViewStatus];
        }];
        
     }
    
}

-(void)dealloc
{
    KDClassLog(@" 通知列表  dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
