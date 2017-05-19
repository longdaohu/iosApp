//
//  NotificationViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/30.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#define PageSize 20
#import "NotificationViewController.h"
#import "TongzhiCell.h"
#import "NotiItem.h"


@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;
//网络请求结果
@property(nonatomic,strong)NSMutableArray *results;
//请求数据第几页
@property(nonatomic,assign)int nextPage;

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

-(NSMutableArray *)results
{
    if (!_results) {
        
        _results = [NSMutableArray array];
    }
    return _results;
}

-(void)makeTableView
{
    self.tableView = [[MyOfferTableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = mj_header;
    
}



-(MJRefreshBackNormalFooter *)makeMJ_footer{

    return [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}



-(void)makeUI
{
    [self makeTableView];
    
     self.title  = GDLocalizedString(@"Left-noti");
}


//数据源请求
-(void)getDataSourse:(int)page
{
  
     NSString *path = [NSString stringWithFormat:kAPISelectorTongZhiList,page,PageSize];
    
    XWeakSelf
    
    [self
     startAPIRequestWithSelector:path
     parameters:nil
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

    [self.results removeAllObjects];
    [self.tableView reloadData];
    [self endMJ_Fresh];
    [self.tableView emptyViewWithError:GDLocalizedString(@"NetRequest-noNetWork")];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}

//配置页面控件
- (void)updateUIWithResponse:(id)response{
    
    //每次刷新，选删除原有数据
    if (self.nextPage == 0) [self.results removeAllObjects];
    
    NSArray *messages = [NotiItem mj_objectArrayWithKeyValuesArray:response[@"messages"]];
    
    [self.results addObjectsFromArray:messages];
    
    //结束刷新
    [self endMJ_Fresh];
    
    //判断是否显示上拉刷新
    if( PageSize > messages.count) self.tableView.mj_footer =  nil;
    
    //是否提示无数据状态
    [self updateTableViewStatusWithResultes:self.results];
    
    
    [self.tableView reloadData];
    
    self.nextPage += 1;

    
}

// mj_header  mj_footer 结束刷新
-(void)endMJ_Fresh{

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)updateTableViewStatusWithResultes:(NSArray *)resultes{

    //是否提示无数据状态
    if (resultes.count == 0) {
        
        [self.tableView emptyViewWithError:@"没有通知消息哦！"];
        self.tableView.mj_header = nil;
        self.tableView.mj_footer = nil;
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TongzhiCell *cell = [TongzhiCell cellWithTableView:tableView];
    cell.noti         = self.results[indexPath.row];
    [cell separatorLineShow:(self.results.count - 1 == indexPath.row)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    NotiItem *noti  = self.results[indexPath.row];
    noti.state      = @"Read";
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    WebViewController *detail = [[WebViewController alloc] init];
    detail.path    = [NSString stringWithFormat:@"%@account/message/%@?client=app",DOMAINURL,noti.NO_id];
    [self.navigationController pushViewController:detail animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    return HEIGHT_ZERO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return HEIGHT_ZERO;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NotiItem *noti  = self.results[indexPath.row];
        NSString *path  = [NSString stringWithFormat:kAPISelectorDeleteTongZhi,noti.NO_id];
        
        
        //提交删除项到服务器
        XWeakSelf
        [self startAPIRequestWithSelector:path
                               parameters:nil
                                success:^(NSInteger statusCode, id response) {
                                      
            [weakSelf.results removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf updateTableViewStatusWithResultes:weakSelf.results];
                                    
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
