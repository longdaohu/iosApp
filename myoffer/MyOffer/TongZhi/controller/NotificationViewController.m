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
@property(nonatomic,strong)UITableView *ListTableView;
@property(nonatomic,strong)NSMutableArray *NotiList;
@property(nonatomic,strong)MJRefreshNormalHeader *mj_header;
@property(nonatomic,assign)int nextPage;
@property(nonatomic,strong)XWGJnodataView *NDataView;


@end

@implementation NotificationViewController

-(NSMutableArray *)NotiList
{
    if (!_NotiList) {
        
        _NotiList = [NSMutableArray array];
    }
    return _NotiList;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.navigationController.navigationBarHidden = NO;
    
    if (self.NotiList.count) {
        
        [self.ListTableView reloadData];

    }
    
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
    [self getDataSourse:0];
}



-(void)makeTableView
{
    self.ListTableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.ListTableView.contentInset =  UIEdgeInsetsMake(0, 0, 64, 0);
    self.ListTableView.dataSource = self;
    self.ListTableView.delegate = self;
    self.ListTableView.rowHeight = 100;
    self.ListTableView.tableFooterView =[[UIView alloc] init];
    self.ListTableView.backgroundColor = BACKGROUDCOLOR;
    [self.view addSubview:self.ListTableView];
    
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    self.ListTableView.mj_header = mj_header;
    self.mj_header = mj_header;
    self.ListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}


-(void)makeOtherView
{
    self.title = GDLocalizedString(@"Left-noti");
    self.nextPage = 0;
    
    self.NDataView =[XWGJnodataView noDataView];
    self.NDataView.hidden = YES;
    self.NDataView.contentLabel.text = GDLocalizedString(@"Left-noNoti");
    [self.view insertSubview:self.NDataView  aboveSubview:self.ListTableView];

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
         
         if ([self.ListTableView.mj_header isRefreshing]) {
             
             [self.NotiList removeAllObjects];
             
             [self.ListTableView reloadData];
         }
         

        
         for (NSDictionary *info in  response[@"messages"]) {
             
             XWGJNoti *noti = [XWGJNoti notiCreateWithDic:info];
             
             [self.NotiList addObject:noti];
             
         }
         
         
         [self.ListTableView.mj_header endRefreshing];
         
         [self.ListTableView.mj_footer endRefreshing];
         
         
         
         
         if (PageSize > [response[@"messages"] count]) {
             
             [self.ListTableView.mj_footer endRefreshingWithNoMoreData];
             
         }
         
         
         if ([response[@"messages"] count] == 0 && self.NotiList.count == 0) {
             
             self.NDataView.hidden = NO;
          
             return ;
         }
         
          [self.ListTableView reloadData];
         

     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
         [self.ListTableView.mj_header endRefreshing];
         [self.ListTableView.mj_footer endRefreshing];
         
         self.NDataView.hidden = NO;
         self.NDataView.contentLabel.text = GDLocalizedString(@"NetRequest-noNetWork");
         
     }];
}

-(void)loadNewData{
    
     self.nextPage = 0;
    [self getDataSourse:0];
}


-(void)loadMoreData
{
    
     [self getDataSourse:self.nextPage];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.NotiList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NotiTableViewCell *cell = [NotiTableViewCell cellWithTableView:tableView];
    
    cell.noti = self.NotiList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
     XWGJNoti *noti  = self.NotiList[indexPath.row];
    
    noti.state = @"Read";
    
     DetailWebViewController *detailVC =[[DetailWebViewController alloc] init];
    
    detailVC.notiID = noti.NO_id;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        XWGJNoti *noti  = self.NotiList[indexPath.row];
        
        NSString *path = [NSString stringWithFormat:@"DELETE api/account/message/%@",noti.NO_id];
        
        [self startAPIRequestWithSelector:path
                               parameters:nil
                                success:^(NSInteger statusCode, id response) {
                                      
            [self.NotiList removeObjectAtIndex:indexPath.row];
                                      
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                    
             self.NDataView.hidden = self.NotiList.count == 0 ? NO : YES;
                                      
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
