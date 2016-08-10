//
//  NotificationViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/30.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#define PageSize 10
#import "DetailWebViewController.h"
#import "NotificationViewController.h"
#import "NotiTableViewCell.h"
#import "XWGJNoti.h"

@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *results;
@property(nonatomic,strong)MJRefreshNormalHeader *mj_header;
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
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.contentInset    =  UIEdgeInsetsMake(0, 0, 64, 0);
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.rowHeight       = KDUtilSize(100);
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.backgroundColor = BACKGROUDCOLOR;
    [self.view addSubview:self.tableView];
    
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = mj_header;
    self.mj_header = mj_header;
    
}

-(MJRefreshBackNormalFooter *)makeMJ_footer{

    return [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


-(void)makeOtherView
{
    self.title            = GDLocalizedString(@"Left-noti");
    self.nextPage         = 0;
    self.NDataView        = [XWGJnodataView noDataView];
    self.NDataView.hidden = YES;
    self.NDataView.contentLabel.text = GDLocalizedString(@"Left-noNoti");
    [self.view insertSubview:self.NDataView  aboveSubview:self.tableView];

}



-(void)makeUI
{
    [self makeTableView];
    [self makeOtherView];
}


//数据源请求
-(void)getDataSourse:(int)page
{
  
 
     NSString *path = [NSString stringWithFormat:@"GET api/account/messagelist?client=app&page=%d&size=%d",page,PageSize];
    
    [self
     startAPIRequestWithSelector:path
     parameters:nil
     expectedStatusCodes:nil
     showHUD:YES
     showErrorAlert:YES
     errorAlertDismissAction:nil
     additionalSuccessAction:^(NSInteger statusCode, id response) {
         
 
          self.nextPage +=1;
         
         if ([self.tableView.mj_header isRefreshing]) {
             
             [self.results removeAllObjects];
             
         }
         

        
         for (NSDictionary *info in  response[@"messages"]) {
             
             XWGJNoti *noti = [XWGJNoti notiCreateWithDic:info];
             
             [self.results addObject:noti];
             
         }
         
         [self.tableView.mj_header endRefreshing];
         
         [self.tableView.mj_footer endRefreshing];
         
          self.tableView.mj_footer = PageSize > [response[@"messages"] count] ? nil : [self makeMJ_footer];
         
         
         if ([response[@"messages"] count] == 0 && self.results.count == 0) {
             
             self.NDataView.hidden = NO;
             
             return ;
         }
         
          [self.tableView reloadData];
         

     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         
         self.NDataView.hidden = NO;
         self.NDataView.contentLabel.text = GDLocalizedString(@"NetRequest-noNetWork");
         
     }];
}
//加载新数据
-(void)loadNewData{
    
     self.nextPage = 0;
    
    [self getDataSourse:0];
}

//加载更多数据
-(void)loadMoreData
{
    
     [self getDataSourse:self.nextPage];
    
}
#pragma mark  UITableViewDelegate UITableViewData
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NotiTableViewCell *cell = [NotiTableViewCell cellWithTableView:tableView];
    
    cell.noti = self.results[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
     XWGJNoti *noti  = self.results[indexPath.row];
    
    noti.state = @"Read";
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    DetailWebViewController *detailVC =[[DetailWebViewController alloc] init];
    
    detailVC.notiID = noti.NO_id;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        XWGJNoti *noti  = self.results[indexPath.row];
        
        NSString *path = [NSString stringWithFormat:@"DELETE api/account/message/%@",noti.NO_id];
        
        [self startAPIRequestWithSelector:path
                               parameters:nil
                                success:^(NSInteger statusCode, id response) {
                                      
            [self.results removeObjectAtIndex:indexPath.row];
                                      
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                    
             self.NDataView.hidden = self.results.count == 0 ? NO : YES;
                                      
      }];
        
     }
    
}



-(void)dealloc
{
    KDClassLog(@" NotificationViewController  dealloc");   //可以释放
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
