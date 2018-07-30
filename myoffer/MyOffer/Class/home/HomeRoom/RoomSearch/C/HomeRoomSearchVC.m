//
//  HomeRoomSearchVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomSearchVC.h"
#import "FiltContent.h"
#import "FilterContentFrame.h"
#import "FilterTableViewCell.h"
#import "RoomSearchResultVC.h"

@interface HomeRoomSearchVC ()<UITableViewDelegate,UITableViewDataSource,FilterTableViewCellDelegate>
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITableView *search_tb;

@end

@implementation HomeRoomSearchVC
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"page新版首页"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page新版首页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self makeDara];
}


- (NSMutableArray *)groups{
    
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    
    return _groups;
}

- (void)makeUI{
 
    [self makeNavigationView];
    [self makeTableView];
}

- (void)makeNavigationView{
    
    UIView *left_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_view];
    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [one setImage:XImage(@"home_room_uk") forState:UIControlStateNormal];
    [left_view addSubview:one];
    [one addTarget:self action:@selector(countryOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *two = [[UIImageView alloc] initWithFrame:CGRectMake(35, 0, 15, 30)];
    two.contentMode = UIViewContentModeScaleAspectFit;
    [two setImage:XImage(@"Triangle_Black_Down")];
    [left_view addSubview:two];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(pageDismiss)];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH , 26)];
    searchTF.font = XFONT(10);
    searchTF.backgroundColor = XCOLOR(243, 246, 249, 1);
    searchTF.layer.cornerRadius = 13;
    searchTF.layer.masksToBounds = YES;
    searchTF.placeholder = @"输入关键字搜索城市，大学，公寓";
    self.navigationItem.titleView = searchTF;
    searchTF.clearButtonMode =  UITextFieldViewModeWhileEditing;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView setImage:XImage(@"home_application_search_icon")];
    searchTF.leftView = leftView;
    searchTF.leftViewMode =  UITextFieldViewModeAlways;
}

-(void)makeDara{
 
    FiltContent  *historyHot = [FiltContent filterWithIcon:nil  title:@"热门搜索" subtitlte:@"" filterOptionItems:nil];
    FilterContentFrame *historyHotFrame = [FilterContentFrame filterFrameWithFilter:historyHot];
    WeakSelf
    //请求推荐数据
    [self startAPIRequestWithSelector:kAPISelectorSearchRecommand parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSArray *items = (NSArray *)response;
        historyHot.optionItems = items;
        historyHotFrame.filter = historyHot;
         [weakSelf.groups addObject:historyHotFrame];
    
        [weakSelf.tableView reloadData];
    }];
    
    
    if (!LOGIN)return; //未登录不加载下一步
    
    FiltContent  *history = [FiltContent filterWithIcon:nil   title:@"历史搜索" subtitlte:@"" filterOptionItems:nil];
    FilterContentFrame *historyFrame = [FilterContentFrame filterFrameWithFilter:history];
 
    //请求历史数据
    [self startAPIRequestWithSelector:kAPISelectorhistorySearch parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSArray *text_arr =  [response valueForKeyPath:@"text"];
        history.optionItems = text_arr;
        historyFrame.filter = history;
 
        [weakSelf.groups addObject:historyFrame];
        [weakSelf.tableView reloadData];
    }];
 
}

-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    FilterTableViewCell *cell =[FilterTableViewCell cellInitWithTableView:tableView];
    cell.upButton.hidden = YES;
    cell.delegate   = self;
    cell.indexPath   = indexPath;
    cell.filterFrame  = self.groups[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterContentFrame *fileritem = self.groups[indexPath.row];
    
    return fileritem.cellHeigh;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark: FilterTableViewCellDelegate
-(void)FilterTableViewCell:(FilterTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender WithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",sender.currentTitle);
    
    RoomSearchResultVC *vc = [[RoomSearchResultVC alloc] init];
    PushToViewController(vc);
}


#pragma mark : 事件处理
-  (void)pageDismiss{
    
    [self dismiss];
}

- (void)countryOnClick{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
