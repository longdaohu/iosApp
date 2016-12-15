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
@property(nonatomic,strong)UITableView *tableView;
//网络请求结果
@property(nonatomic,strong)NSMutableArray *results;
//请求数据第几页
@property(nonatomic,assign)int nextPage;

@property(nonatomic,strong)XWGJnodataView *NDataView;
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = XCOLOR_BG;
    [self.view addSubview:self.tableView];
    
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
     self.tableView.mj_header = mj_header;
    
}



-(MJRefreshBackNormalFooter *)makeMJ_footer{

    return [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}



-(XWGJnodataView *)NDataView{
    
    if (!_NDataView) {
        
        _NDataView  = [XWGJnodataView noDataView];
        _NDataView.errorStr = GDLocalizedString(@"Left-noNoti");
        _NDataView.hidden = YES;
        [self.view insertSubview:_NDataView aboveSubview:self.tableView];
    }
    
    return _NDataView;
}


/**
 @param show    
 true : 隐藏
 faulse : 显示
 */
-(void)nodataViewHidden:(BOOL)hidden{

    self.NDataView.hidden = hidden;
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
         
         [weakSelf makeUIConfigrationWithResponse:response];
         

     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
         [weakSelf endMJ_Fresh];
         [weakSelf nodataViewHidden:NO];
         weakSelf.NDataView.errorStr = GDLocalizedString(@"NetRequest-noNetWork");
         
     }];
}

//配置页面控件
- (void)makeUIConfigrationWithResponse:(id)response{

    self.nextPage += 1;
    
    //每次刷新，选删除原有数据
    if ([self.tableView.mj_header isRefreshing]) [self.results removeAllObjects];
    
    
    [response[@"messages"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.results  addObject:[NotiItem mj_objectWithKeyValues:obj]];

    }];
    
    //结束刷新
    [self endMJ_Fresh];
    
    //判断是否显示上拉刷新
    self.tableView.mj_footer = PageSize > [response[@"messages"] count] ? nil : [self makeMJ_footer];
    
    //是否提示无数据状态
    if ([response[@"messages"] count] == 0 && self.results.count == 0) {
        
        [self nodataViewHidden:NO];
        
        return ;
    }
    
    [self.tableView reloadData];
   
}

// mj_header  mj_footer 结束刷新
-(void)endMJ_Fresh{

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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

#pragma mark ——— UITableViewDelegate  UITableViewDataSoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TongzhiCell *cell = [TongzhiCell cellWithTableView:tableView];
    cell.noti               = self.results[indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return Uni_Cell_Height;
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
            [weakSelf nodataViewHidden:weakSelf.results.count != 0];
                         
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
