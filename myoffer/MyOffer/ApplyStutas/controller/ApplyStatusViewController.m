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
#import "XWGJApplyRecord.h"
#import "XWGJApplyRecordGroup.h"
#import "XSearchSectionHeaderView.h"

@interface ApplyStatusViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *TableView;
//没有数据时显示
@property (strong, nonatomic) XWGJnodataView *noDataView;
 //申请记录数组
@property(nonatomic,strong)NSArray *ApplyRecordGroups;


@end
   
@implementation ApplyStatusViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page申请状态"];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page申请状态"];
    
}

-(void)makeUI
{
    
    self.title = GDLocalizedString(@"Me-002");
    
    [self makeTableView];
    
    //没有数量是显示提示
    [self makeNodataView];
  
}


-(void)makeTableView
{
    self.TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - 20) style:UITableViewStyleGrouped];
    self.TableView.dataSource =self;
    self.TableView.delegate = self;
    self.TableView.backgroundColor = BACKGROUDCOLOR;
    [self.view addSubview:self.TableView];
    
    //上拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.TableView.mj_header = header;

}

-(void)makeNodataView
{
    self.noDataView =[XWGJnodataView noDataView];
    self.noDataView.contentLabel.text = GDLocalizedString(@"ApplicationStutasVC-noData");
    self.noDataView.hidden = YES;
    [self.view insertSubview:self.noDataView aboveSubview:self.TableView];
    
}

-(void)loadNewData
{
     [self RequestDataSourse:YES];
}


- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    [self makeUI];
    
    [self RequestDataSourse:NO];
}


//网络数据请求
- (void)RequestDataSourse:(BOOL)refresh
{
    
    if (![self checkNetworkState]) {
        
        self.noDataView.contentLabel.text = GDLocalizedString(@"NetRequest-noNetWork") ;
        self.noDataView.hidden = NO;

        if (refresh) {
            
            [self.TableView.mj_header endRefreshing];
         }
        return; 
    }
    
    XJHUtilDefineWeakSelfRef
    [self startAPIRequestWithSelector:@"GET api/account/checklist" parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSArray *records = response[@"records"];
        
        NSMutableArray *groups = [NSMutableArray array];
         for (NSDictionary *record in records) {
             XWGJApplyRecordGroup *group =[XWGJApplyRecordGroup ApplyRecourseGroupWithDictionary:record];
             [groups addObject:group];
        }
 
        weakSelf.ApplyRecordGroups = [groups copy];
        
        [weakSelf.TableView reloadData];
        
        
        weakSelf.noDataView.hidden = records.count == 0 ? NO : YES;

        if (refresh) {
            
              [weakSelf.TableView.mj_header endRefreshing];
         }
        
     }];
  
}


#pragma mark ————UItableDelegate uitabledatasourse
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  University_HEIGHT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XSearchSectionHeaderView *sectionHeader =[XSearchSectionHeaderView SectionHeaderViewWithTableView:tableView];
    sectionHeader.RecommendMV.hidden = YES;
    XWGJApplyRecordGroup *group = self.ApplyRecordGroups[section];
    UniversityObj *uni =group.universityFrame.uniObj;
     sectionHeader.IsStar = [uni.countryName isEqualToString:GDLocalizedString(@"CategoryVC-AU")];
    sectionHeader.RANKTYPE = RANKTI;
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
    XWGJApplyRecordGroup *group = self.ApplyRecordGroups[indexPath.section];
    cell.record = group.record;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)dealloc
{
    KDClassLog(@" ApplyStatusViewController --- dealloc");
}


@end
