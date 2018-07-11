//
//  XWGJCatigoryViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CatigoryViewController.h"
#import "CatigaryCityCollectionCell.h"
#import "CatigorySubject.h"
#import "SearchViewController.h"
#import "CatigaryScrollView.h"
#import "XBTopToolView.h"
#import "TopNavView.h"
#import "NomalCollectionController.h"
#import "rankFilter.h"
#import "CatigoryCountryViewController.h"
#import "RankFilterViewController.h"
#import "RankTypeItem.h"
#import "RankTypeItemFrame.h"
#import "RankTypeCell.h"
#import "RankDetailViewController.h"
#import "SearchPromptView.h"

@interface CatigoryViewController ()<UIScrollViewDelegate,XTopToolViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)CatigaryScrollView *bgView;//背景scroller
@property(nonatomic,strong)RankFilterViewController *filterVC;//筛选工具
@property(nonatomic,strong)rankFilter *rankFilterModel;//排序筛选数据
@property(nonatomic,assign)NSInteger para_page;
@property(nonatomic,strong)TopNavView *topView;//自定义导航栏
@property(nonatomic,strong)XBTopToolView  *topToolView;//工具条
@property(nonatomic,strong)SearchPromptView *promptView;//提示框
@property(nonatomic,strong)MyOfferTableView *rank_tableView;//排名表格
@property(nonatomic,strong)NSMutableArray *rank_groups;//排名数据

@end

@implementation CatigoryViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    NavigationBarHidden(YES);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [MobClick beginLogPageView:@"page分类搜索"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page分类搜索"];
    
}

- (NSMutableArray *)rank_groups{
    
    if (!_rank_groups) {
        
        _rank_groups = [NSMutableArray array];
    }
    
    return _rank_groups;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeRankDataSource];
    
    [self makeFilterDataSource];
    
    
}

//网络请求筛选基础数据
- (void)makeFilterDataSource{
    WeakSelf
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorCatigoryBaseFilterData parameters:nil success:^(NSInteger statusCode, id response) {
         [weakSelf updateFilterDataWithResponse:response];
     }];
}

//网络请求获取排名数组
- (void)makeRankDataSource{
 
    NSMutableDictionary *para_tmp = [NSMutableDictionary dictionaryWithDictionary: @{KEY_PAGE :@(self.para_page)}];
    if (self.rankFilterModel) {
        [para_tmp setValuesForKeysWithDictionary:self.rankFilterModel.papa_m];
     }
    
    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorCatigoryRanks parameters:para_tmp expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil  additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateRankViewWithResponse:response];

    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        if (0 == weakSelf.rank_groups.count) {
             [weakSelf.rank_tableView emptyViewWithError:@"网络请求失败，点击重新加载"];
        }
    }];
    
}

- (void)updateFilterDataWithResponse:(id)response{
    
      self.rankFilterModel = [rankFilter mj_objectWithKeyValues:response];
    
      self.filterVC.rankFilterModel = self.rankFilterModel;
}


- (void)updateRankViewWithResponse:(id)response{
 
    NSNumber *page = response[@"page"];
    NSNumber *size = response[@"size"];
    NSNumber *count_all = response[@"count"];
    self.para_page = page.integerValue+1;
 
    if (page.integerValue == 0 && self.rank_groups.count > 0) {
 
        [self.rank_groups removeAllObjects];
    }
 
    NSArray *items = [RankTypeItem mj_objectArrayWithKeyValuesArray:response[@"items"]];
    
     for (RankTypeItem *item in items) {
         
        RankTypeItemFrame *itemFrame = [RankTypeItemFrame new];
        itemFrame.item = item;
        [self.rank_groups addObject:@[itemFrame]];
     }
    
    if (items.count < size.integerValue) {
        [self.rank_tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.rank_tableView.mj_footer endRefreshing];
    }
    
     [self.rank_tableView reloadData];
    
    if (0 == self.rank_groups.count) {
        [self.rank_tableView emptyViewWithError:NetRequest_NoDATA];
    }else{
        [self.rank_tableView emptyViewWithHiden:YES];
    }
    [self promptShowWithCount:count_all.integerValue];
    
    if (page.integerValue == 0 && self.rank_groups.count > 0) {
        
        [self.rank_tableView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
 
}

- (void)makeUI{
    
    [self makeTopView];
    
    [self makeTopToolView];
    
    [self makeBaseScorller];
    
}

//导航工具条
- (void)makeTopView{
    
    self.topView= [[TopNavView alloc] initWithFrame:CGRectMake(0,  0, XSCREEN_WIDTH, XNAV_HEIGHT)];
 
    [self.view addSubview:self.topView];
    
}

//滚动工具条
- (void)makeTopToolView{
    
    self.topToolView = [[XBTopToolView alloc] initWithFrame:CGRectMake(0,XStatusBar_Height + 6,XSCREEN_WIDTH, TOP_HIGHT)];
    self.topToolView.itemNames = @[@"地区",@"专业",@"排名"];
    self.topToolView.delegate  = self;
    [self.view addSubview: self.topToolView];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [self.view addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"search_icon"]  forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat search_W = 20;
    CGFloat search_H = search_W;
    CGFloat search_X = XSCREEN_WIDTH - search_W - 16;
    CGFloat search_Y = 0;
    searchBtn.frame =  CGRectMake(search_X, search_Y, search_W, search_H);
    searchBtn.center = CGPointMake(searchBtn.center.x, self.topToolView.center.y);
}

- (void)makeBaseScorller{
    
    CGFloat baseX = 0;
    CGFloat baseY = CGRectGetMaxY(self.topView.frame);
    CGFloat baseW = XSCREEN_WIDTH;
    CGFloat baseH = XSCREEN_HEIGHT - 49 - XNAV_HEIGHT;//49为底部导航高度
    self.bgView = [CatigaryScrollView viewWithFrame:CGRectMake(baseX, baseY, baseW,baseH)];
    self.bgView.bounces = NO;
    self.bgView.delegate = self;
    [self.view addSubview:self.bgView];
    self.bgView.backgroundColor = XCOLOR_WHITE;
    
    //热门城市
    [self makeHotCitywWithFrame:CGRectMake(baseW * 0, 0, baseW,baseH)];
    //热门专业
    [self makeSubjectCollectViewWithFrame:CGRectMake(baseW * 1, 0, baseW,baseH)];
    //排名版块
    [self makeRankWithFrame:CGRectMake(baseW * 2, 0, baseW,baseH)];

}

//热门城市
- (void)makeHotCitywWithFrame:(CGRect)frame{
    
    CatigoryCountryViewController  *hotCityVC  = [[CatigoryCountryViewController alloc] init];
    [self addChildViewController:hotCityVC];
    [self.bgView addSubview:hotCityVC.view];
    hotCityVC.view.frame = frame;
}


//热门专业
-(void)makeSubjectCollectViewWithFrame:(CGRect)frame
{
    NomalCollectionController *nomalCollectionVC  = [[NomalCollectionController alloc] init];
    [self addChildViewController:nomalCollectionVC];
    [self.bgView addSubview:nomalCollectionVC.view];
    nomalCollectionVC.view.frame = frame;
    
    NSDictionary *sub_finance = @{@"name" : @"经济与金融", @"icon" : @"sub_finance"};
    NSDictionary *sub_business = @{@"name" : @"商科", @"icon" : @"sub_business"};
    NSDictionary *sub_engineer = @{@"name" : @"工程学", @"icon" : @"sub_engineer"};
    NSDictionary *sub_humanit = @{@"name" : @"人文与社会科学", @"icon" : @"sub_humanit"};
    NSDictionary *sub_sciencee = @{@"name" : @"理学", @"icon" : @"sub_sciencee"};
    NSDictionary *sub_built = @{@"name" : @"建筑与规划", @"icon" : @"sub_built"};
    NSDictionary *sub_art = @{@"name" : @"艺术与设计", @"icon" : @"sub_art"};
    NSDictionary *sub_medicine = @{@"name" : @"医学", @"icon" : @"sub_medicine"};
    NSDictionary *sub_farm = @{@"name" : @"农学", @"icon" : @"sub_farm"};
    NSArray *sub_Arr = @[sub_finance,sub_business,sub_engineer,sub_humanit,sub_sciencee,sub_built,sub_art,sub_medicine,sub_farm];
    NSMutableArray *subject_temps = [NSMutableArray array];
    for (NSDictionary *sub_dic in sub_Arr) {
        CatigorySubject *sub_item =[CatigorySubject subjectItemInitWithIcon:sub_dic[@"icon"]  title:sub_dic[@"name"] ];
        [subject_temps addObject:sub_item];
    }
    nomalCollectionVC.items = [subject_temps copy];;
    nomalCollectionVC.type = CollectionTypeSubject;
}

//排名版块
-(void)makeRankWithFrame:(CGRect)frame
{
    WeakSelf
    self.rank_tableView =[[MyOfferTableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.rank_tableView.actionBlock = ^{
        [weakSelf makeRankDataSource];
    };
    self.rank_tableView.delegate = self;
    self.rank_tableView.dataSource = self;
    self.rank_tableView.estimatedSectionHeaderHeight = 0;
    self.rank_tableView.estimatedSectionFooterHeight = 0;
    [self.bgView addSubview:self.rank_tableView];
    self.rank_tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    RankFilterViewController  *filterVC  = [[RankFilterViewController alloc] init];
    filterVC.actionBlock = ^{
        weakSelf.para_page = 0;
        [weakSelf makeRankDataSource];
    };
    [self addChildViewController:filterVC];
    filterVC.view.frame = CGRectMake(frame.origin.x, 0, XSCREEN_WIDTH, 50);
    [self.bgView addSubview:filterVC.view];
    self.filterVC = filterVC;
    self.rank_tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
}

#pragma mark :  UITableViewDelegate,UITableViewDataSourc
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.rank_groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *items  = self.rank_groups[section];
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RankTypeCell *cell = [RankTypeCell  cellWithTableView:tableView];
    NSArray *items = self.rank_groups[indexPath.section];
    cell.itemFrame = items[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [UIView new];
    header.backgroundColor = XCOLOR_WHITE;
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footer = [UIView new];
    footer.backgroundColor = XCOLOR_WHITE;
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.rank_tableView) {
        
        NSArray *items = self.rank_groups[indexPath.section];
        RankTypeItemFrame *itemFrame = items[indexPath.row];
        RankDetailViewController *rankVC  = [[RankDetailViewController alloc] init];
        rankVC.type_id = itemFrame.item.type_id;
        PushToViewController(rankVC);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *items = self.rank_groups[indexPath.section];
    RankTypeItemFrame *itemFrame = items[indexPath.row];
    
    return  itemFrame.cell_frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Section_footer_Height_nomal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat height =  (section == (self.rank_groups.count -1)) ? Section_footer_Height_nomal : HEIGHT_ZERO;
    
    return  height;
}


#pragma mark : UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.bgView.isDragging) {
        
        //监听滚动，实现顶部工具条按钮切换
        
        CGFloat offsetX = scrollView.contentOffset.x;
        
        CGFloat width = scrollView.frame.size.width;
        
        NSInteger pageNum =  (offsetX + .5f *  width) / width;
        
        [self.topToolView setSelectedIndex:pageNum];
        // 限制y轴不动
        self.bgView.contentSize =  CGSizeMake(3 * XSCREEN_WIDTH, 0);
    }
    
}


#pragma mark : XTopToolViewDelegate

- (void)XTopToolView:(XBTopToolView *)topToolView andButtonItem:(UIButton *)sender{
    
    [self.bgView setContentOffset:CGPointMake(XSCREEN_WIDTH * sender.tag, 0) animated:YES];
}

#pragma mark : 事件处理
//打开搜索
-(void)searchButtonPressed:(UIBarButtonItem *)barButton {
    
    MyofferNavigationController *nav = [[MyofferNavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]];
    [self presentViewController:nav  animated:YES completion:nil];
}

//从首页跳转到热门留学目的地
- (void)jumpToHotCity{
    [self.bgView setContentOffset:CGPointZero animated:YES];
    [self.topToolView setSelectedIndex:0];
}

//从首页跳转到热门留学目的地
- (void)jumpToRank{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMATION_DUATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.bgView setContentOffset:CGPointMake(2 * XSCREEN_WIDTH , 0) animated:YES];
        [self.topToolView setSelectedIndex:2];
        
    });
    
}


//显示提示新加载数据
- (void)promptShowWithCount:(NSInteger )count{
    
    if (count == 0) return;
    if (!_promptView) {
        _promptView = [SearchPromptView promptViewInsertInView:self.rank_tableView];
    }
    [self.promptView showWithTitle:[NSString stringWithFormat:@"共 %ld 个排名",count]];
}

//网络请求更多
- (void)loadMoreData{
    
    [self makeRankDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
