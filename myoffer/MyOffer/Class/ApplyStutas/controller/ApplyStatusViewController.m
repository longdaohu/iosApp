//
//  ApplySubmitViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
// 申请状态

#import "ApplyStatusViewController.h"
#import "ApplyStatusRecord.h"
#import "ApplyStatusRecordGroup.h"
#import "UniversityNew.h"
#import "UniItemFrame.h"
#import "UniversityCell.h"
#import "ApplyStatusCell.h"

 #define STATUSPAGE @"page申请状态"

@interface ApplyStatusViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) DefaultTableView *tableView;
//申请记录数组
@property(nonatomic,strong)NSArray *Record_Groups;


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
    self.tableView                 = [[DefaultTableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.backgroundColor = XCOLOR_BG;
    [self.view addSubview:self.tableView];

    //上拉刷新
    MJRefreshNormalHeader *header      = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header           = header;

}



-(void)makeOther
{
    
    self.title = GDLocalizedString(@"Me-002");
    
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
    
        [weakSelf makeUIConfigrationWith:response];
        
    }];
   
}


//根据请求数据配置UI
-(void)makeUIConfigrationWith:(id)response{

    
    [self.tableView.mj_header endRefreshing];
    
    NSMutableArray *groups = [NSMutableArray array];
    
    for (NSDictionary *record in response[@"records"]) {
        
        [groups addObject:[ApplyStatusRecordGroup ApplyRecourseGroupWithDictionary:record]];
        
    }
    
    self.Record_Groups = [groups copy];
 
    if (self.Record_Groups.count > 0){
    
        [self.tableView emptyViewWithHiden:YES];
        
    }else{
    
         [self.tableView emptyViewWithError:GDLocalizedString(@"ApplicationStutasVC-noData")];
    }
        
    
    
    [self.tableView reloadData];
    
    if (!groups.count) {
        
        [self.tableView.mj_header removeFromSuperview];
    }
    
}



#pragma mark ——— UITableViewDelegate  UITableViewDataSoure
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return PADDING_TABLEGROUP;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  Uni_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 60;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UniversityCell *uni_cell =[UniversityCell cellWithTableView:tableView];
    ApplyStatusRecordGroup *group      = self.Record_Groups[section];
    uni_cell.userInteractionEnabled = NO;
    uni_cell.itemFrame = group.universityFrame;
    
    return (UIView *)uni_cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return self.Record_Groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyStatusCell *cell =[ApplyStatusCell cellWithTableView:tableView];
    ApplyStatusRecordGroup *group = self.Record_Groups[indexPath.section];
    cell.record = group.record;
    
    return cell;
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
