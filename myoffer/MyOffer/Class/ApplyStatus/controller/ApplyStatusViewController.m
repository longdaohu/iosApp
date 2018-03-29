//
//  ApplySubmitViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
// 申请状态

#import "ApplyStatusViewController.h"
#import "ApplyStatusRecord.h"
#import "MyOfferUniversityModel.h"
#import "UniverstityTCell.h"
#import "ApplyStatusCell.h"

 #define STATUSPAGE @"page申请状态"

@interface ApplyStatusViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) MyOfferTableView *tableView;
//申请记录数组
@property(nonatomic,strong)NSArray *groups;


@end
   
@implementation ApplyStatusViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:STATUSPAGE];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:STATUSPAGE];
    
}

-(void)makeUI
{
    [self makeTableView];
    [self makeOther];
}


-(void)makeTableView
{
    self.tableView   = [[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource  = self;
    self.tableView.delegate   = self;
    self.tableView.backgroundColor = XCOLOR_BG;
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XNAV_HEIGHT, 0);
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.rowHeight = 60;
    self.tableView.sectionFooterHeight = Section_footer_Height_nomal;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
 
    //上拉刷新
    MJRefreshNormalHeader *header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header  = header;

}



-(void)makeOther
{
    self.title = @"审核状态";
    if (self.isBackRootViewController) {
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    }
    
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    [self makeUI];
    [self.tableView.mj_header beginRefreshing];
}

//加载新数据
-(void)loadNewData{
    
    [self RequestDataSourse:YES];
}


//网络数据请求
- (void)RequestDataSourse:(BOOL)refresh
{
    
    if (![self checkNetworkState]) {

        [self.tableView emptyViewWithError:GDLocalizedString(@"NetRequest-noNetWork")];
        if (refresh) [self.tableView.mj_header endRefreshing];
        return;
    }
    
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorApplyStutas parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithResponse:response];
    }];
   
}


//根据请求数据配置UI
-(void)updateUIWithResponse:(id)response{

    [self.tableView.mj_header endRefreshing];
     self.groups = [ApplyStatusRecord mj_objectArrayWithKeyValuesArray:response[@"records"]];
  
    if (self.groups.count > 0){
        [self.tableView emptyViewWithHiden:YES];
    }else{
         [self.tableView emptyViewWithError:@"Duang!您还没有提交申请哦！"];
         [self.tableView.mj_header removeFromSuperview];
    }
    
    [self.tableView reloadData];
}



#pragma mark : UITableViewDelegate  UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyStatusCell *cell =[ApplyStatusCell cellWithTableView:tableView];
    cell.record = self.groups[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    ApplyStatusRecord *record = self.groups[section];
    return  record.uniFrame.cell_Height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UniverstityTCell *uni_cell =[UniverstityTCell cellViewWithTableView:tableView];
    ApplyStatusRecord *record = self.groups[section];
    uni_cell.userInteractionEnabled = NO;
    uni_cell.uniFrame = record.uniFrame;
    
    return (UIView *)uni_cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//返回RootViewController
-(void)popBack{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dealloc
{
    KDClassLog(@" 申请状态  dealloc");
}


@end
