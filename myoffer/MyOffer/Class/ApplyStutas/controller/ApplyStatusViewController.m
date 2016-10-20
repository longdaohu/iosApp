//
//  ApplySubmitViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
// 申请状态

#import "ApplyStatusViewController.h"
#import "ApplySection.h"
#import "XWGJApplyStatusView.h"
#import "UniversityObj.h"
#import "XWGJApplyStatusTableViewCell.h"
#import "ApplyStatusRecord.h"
#import "ApplyStatusRecordGroup.h"
#import "XSearchSectionHeaderView.h"
#define STATUSPAGE @"page申请状态"

@interface ApplyStatusViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
//没有数据时显示
@property (strong, nonatomic) XWGJnodataView *noDataView;
//申请记录数组
@property(nonatomic,strong)NSArray *ApplyRecordGroups;


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
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - XNav_Height) style:UITableViewStyleGrouped];
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


-(XWGJnodataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView =[XWGJnodataView noDataView];
        _noDataView.contentLabel.text = GDLocalizedString(@"ApplicationStutasVC-noData");
        _noDataView.hidden = YES;
        [self.view insertSubview:_noDataView aboveSubview:self.tableView];
    }
    
    return _noDataView;
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
        
        self.noDataView.contentLabel.text = GDLocalizedString(@"NetRequest-noNetWork") ;
        self.noDataView.hidden = NO;

        if (refresh) [self.tableView.mj_header endRefreshing];
          
        return; 
    }
    
    XWeakSelf
    
    NSString *path = @"GET api/account/checklist";
    [self startAPIRequestWithSelector:path parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
    
        [weakSelf makeUIConfigrationWith:response];
        
        if (refresh) {[weakSelf.tableView.mj_header endRefreshing];}
            
          
    }];
    

  
}

//根据请求数据配置UI
-(void)makeUIConfigrationWith:(id)response{

    NSArray *records       = response[@"records"];
    
    NSMutableArray *groups = [NSMutableArray array];
    
    for (NSDictionary *record in records) {
        
        [groups addObject:[ApplyStatusRecordGroup ApplyRecourseGroupWithDictionary:record]];
        
    }
    
    self.ApplyRecordGroups = [groups copy];
    
    self.noDataView.hidden = records.count == 0 ? NO : YES;
   
    [self.tableView reloadData];

}



#pragma mark ——— UITableViewDelegate  UITableViewDataSoure
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return PADDING_TABLEGROUP;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  University_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XSearchSectionHeaderView *sectionHeader =[XSearchSectionHeaderView SectionHeaderViewWithTableView:tableView];
    sectionHeader.RecommendMV.hidden = YES;
    ApplyStatusRecordGroup *group      = self.ApplyRecordGroups[section];
    UniversityObj *uni      = group.universityFrame.uniObj;
    sectionHeader.IsStar    = [uni.countryName isEqualToString:GDLocalizedString(@"CategoryVC-AU")];
    sectionHeader.RANKTYPE  = RANKTI;
    sectionHeader.uni_Frame = group.universityFrame;
    
    return sectionHeader;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return self.ApplyRecordGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWGJApplyStatusTableViewCell *cell =[XWGJApplyStatusTableViewCell CreateCellWithTableView:tableView];
    ApplyStatusRecordGroup *group = self.ApplyRecordGroups[indexPath.section];
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
