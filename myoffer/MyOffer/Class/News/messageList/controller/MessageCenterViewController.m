//
//  MessageCenterViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "messageCatigroyModel.h"
#import "XWGJMessageFrame.h"
#import "MessageTopicHeaderViewController.h"
#import "MessageHotTopicMedel.h"
#import "MessageTopiccGroup.h"
#import "MessageTopicModel.h"
#import "FSSegmentTitleView.h"
#import "FSBaseTableView.h"
#import "FSSScrollContentViewController.h"
#import "FSBottomTableViewCell.h"
#import "LeftBarButtonItemView.h"

@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource,FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) FSBaseTableView *tableView;
@property(nonatomic,strong)NSArray *catigroies;
@property(nonatomic,strong)NSArray *groups;
//表头
@property(nonatomic,strong)MessageTopicHeaderViewController *headerViewController;
//分区View
@property(nonatomic,strong)FSSegmentTitleView *titleView;
@property(nonatomic,assign)BOOL canScroll;
@property(nonatomic,strong)NSArray *childVCes;
@property(nonatomic,strong)FSSScrollContentViewController *child_current;
@property(nonatomic,strong)FSBottomTableViewCell *contentCell;
@property(nonatomic,strong)LeftBarButtonItemView *leftView;

@end

@implementation MessageCenterViewController
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page资讯中心"];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self leftViewMessage];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page资讯中心"];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeBaseData];
    
}

- (void)makeUI{
    
    [self makeTableView];
    
    self.canScroll = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    
    
    XWeakSelf
    self.leftView =[LeftBarButtonItemView leftViewWithBlock:^{
        
        [weakSelf showLeftMenu];
        
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:self.leftView];
    
}

- (void)makeBaseData{
  
    
    if (self.headerViewController.topices.count == 0) {
        
        [self startAPIRequestWithSelector:@"GET api/hot-article-topics"  parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
            
            NSArray *items = [MessageHotTopicMedel mj_objectArrayWithKeyValuesArray:response[@"items"]];
            
            self.canScroll = items.count > 0;
            
            if (items.count == 0) {
                
                self.tableView.tableHeaderView = [UIView new];
                
                return ;
            }
            
            self.tableView.tableHeaderView  =     self.headerViewController.view;
            self.headerViewController.topices  = items;
            
        } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
            
            self.tableView.tableHeaderView = [UIView new];
            
            self.canScroll = NO;
            
        }];
    }
    
    
    if (self.catigroies.count > 0) return;
    
    [self startAPIRequestWithSelector:kAPISelectorArticleCatigoryIndex  parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [self updateUIWithResponse:response];

    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
    // catigroies数据为空时，其他操作步骤没有意义
        self.catigroies = nil;
        [self.tableView emptyViewWithError:@"网络请求错误，点击页面重新加载！"];
        [self.tableView reloadData];
        
    }];
    
 
}

- (void)updateUIWithResponse:(id)response{
    
    [self.tableView emptyViewWithHiden:YES];
    
    //1  专题分类
    self.catigroies  = [messageCatigroyModel mj_objectArrayWithKeyValuesArray:response[@"items"]];
    
    if(self.catigroies.count == 0) // catigroies数据为空时，其他操作步骤没有意义
    {
       [self.tableView emptyViewWithError:@"没有数据！"];
        
       [self.tableView reloadData];
        
       return;
    }
    
    //2 添加子视图
    NSMutableArray *contentVCs = [NSMutableArray array];
    for (messageCatigroyModel *catigory in self.catigroies) {
        
        FSSScrollContentViewController *vc = [[FSSScrollContentViewController alloc]init];
        
        vc.title = catigory.name;
        
        [contentVCs addObject:vc];
    }
     self.childVCes = [contentVCs copy];
    
    
    //3 预添加数据
    NSMutableArray *temps = [NSMutableArray array];
    for (NSInteger index = 0; index < self.catigroies.count; index++) {
        messageCatigroyModel *catigory = self.catigroies[index];
        MessageTopiccGroup *group = [MessageTopiccGroup groupWithCatigroy:catigory index:index];
        [temps addObject:group];
    }
    
    self.groups = [temps copy];
    
    [self.tableView reloadData];
    
    //4 设置当前显示视图
    if (!self.child_current) [self makeDataWithCatigoryIndex:0];
    
}

- (void)makeDataWithCatigoryIndex:(NSInteger)index{
    
    //2  设置当前显示视图
    FSSScrollContentViewController *vc = self.childVCes[index];
    self.child_current = vc;
    
    //3  当前显示视图已有数据不再请求数据
    if (self.child_current.group.contents.count)  return;
    
    //4 请求当前主题视图数据
    messageCatigroyModel *catigory = self.catigroies[index];
    
    NSDictionary *pass = @{@"category" : catigory.code};
    
    [self startAPIRequestWithSelector:@"GET api/articles/index"  parameters:pass expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        MessageTopiccGroup *group = self.groups[index];
        
        group.contents = [MessageTopicModel mj_objectArrayWithKeyValuesArray:response];;
        
        self.child_current.group = group;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [self.child_current showError:nil];

    }];
    
    
}



-(void)makeTableView
{
    self.tableView =[[FSBaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    XWeakSelf
    self.tableView.actionBlock = ^{
        
        [weakSelf makeBaseData];
    };
    
    self.headerViewController = [[MessageTopicHeaderViewController alloc] init];
    [self addChildViewController:self.headerViewController];
    self.headerViewController.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, MASSAGE_HEADER_HIGHT);
    self.headerViewController.header_Height = MASSAGE_HEADER_HIGHT;
    self.tableView.tableHeaderView = self.headerViewController.view;
    
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.catigroies.count > 0 ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGRectGetHeight(self.view.bounds) + 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return    60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSArray *titles = [self.catigroies valueForKeyPath:@"name"];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 60) titles:titles delegate:self indicatorType:FSIndicatorTypeEqualTitle];
     
    return self.titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FSBottomTableViewCell  *contentCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!contentCell) {
        
        contentCell = [[FSBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        _contentCell = contentCell;
        
    }
    
    _contentCell.viewControllers = [self.childVCes mutableCopy];
    _contentCell.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - 64) childVCs:[self.childVCes mutableCopy] parentVC:self delegate:self];
    [_contentCell.contentView addSubview:_contentCell.pageContentView];
    
    return contentCell;
    
}



#pragma mark UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //1 数据为空时，其他步骤操作没有意义
    if (self.catigroies.count == 0) return;
    
    
    CGFloat bottomCellOffset = [_tableView rectForSection:0].origin.y;
    
    if (scrollView.contentOffset.y >= bottomCellOffset) {
        
        
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        
        
        if (self.canScroll) {
            
            self.canScroll = NO;
            
            self.contentCell.cellCanScroll = YES;
            
        }
        
        
    }else{
        
        if (!self.canScroll) {
            
            //子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            
        }
    }
    
    self.tableView.showsVerticalScrollIndicator = _canScroll ? YES : NO;
}




#pragma mark notify
- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    
    self.contentCell.cellCanScroll = NO;
}


#pragma mark FSSegmentTitleViewDelegate
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    
    self.contentCell.pageContentView.contentViewCurrentIndex = endIndex;
    
    [self makeDataWithCatigoryIndex:endIndex];
    
}


#pragma mark FSPageContentViewDelegate

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    
    self.titleView.selectIndex = endIndex;
    
    _tableView.scrollEnabled = YES;//此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动，或者通过手势监听或者kvo，这里只是提供一种实现方式
    
    [self makeDataWithCatigoryIndex:endIndex];
}

- (void)FSContentViewDidScroll:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress
{
    _tableView.scrollEnabled = NO;//pageView开始滚动主tableview禁止滑动
    
    progress = startIndex - endIndex > 0 ? - progress : progress;
    
    //    self.titleView.progress = progress;
}



//导航栏 leftBarButtonItem
- (void)leftViewMessage{
    
    NSUserDefaults *ud       = [NSUserDefaults standardUserDefaults];
    NSString *message_count  = [ud valueForKey:@"message_count"];
    NSString *order_count    = [ud valueForKey:@"order_count"];
    self.leftView.countStr =[NSString stringWithFormat:@"%ld",(long)[message_count integerValue]+[order_count integerValue]];
    
    if(!LOGIN) self.leftView.countStr = @"0";
    
    if (LOGIN && [self checkNetWorkReaching]) {
        
        XWeakSelf
        
        [self startAPIRequestWithSelector:kAPISelectorCheckNews parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
            
            NSInteger message_count  = [response[@"message_count"] integerValue];
            NSInteger order_count    = [response[@"order_count"] integerValue];
            [ud setValue:[NSString stringWithFormat:@"%ld",(long)message_count] forKey:@"message_count"];
            [ud setValue:[NSString stringWithFormat:@"%ld",(long)order_count] forKey:@"order_count"];
            [ud synchronize];
            
            weakSelf.leftView.countStr =[NSString stringWithFormat:@"%ld",(long)[response[@"message_count"] integerValue]+[response[@"order_count"] integerValue]];
        }];
        
    }
    
}
//显示侧边菜单
-(void)showLeftMenu{
    
    [self.sideMenuViewController presentLeftMenuViewController];
    
}



#pragma mark FSPageContentViewDelegate

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

