//
//  GuideOverseaViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/11/15.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "GuideOverseaViewController.h"
#import "GuideOverseaModel.h"
#import "GuideProcess.h"
#import "GuideCell.h"
#import "CatigoryViewController.h"
#import "MessageDetaillViewController.h"
#import "MessageTopicViewController.h"
#import "FSSegmentTitleView.h"

@interface GuideOverseaViewController ()<UITableViewDataSource,UITableViewDelegate,FSSegmentTitleViewDelegate>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)GuideOverseaModel *current_guide;

@end

@implementation GuideOverseaViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page留学指南"];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page留学指南"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeData];
    
    [self makeUI];
    
}

- (void)makeData{
 
    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorGuideOversea  parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        [weakSelf.tableView emptyViewWithError: NetRequest_ConnectError];
    }];
}

- (void)makeUI{
    
    [self makeTableView];
    self.title = @"留学指南";
    self.view.backgroundColor = XCOLOR_WHITE;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"咨询" style:UIBarButtonItemStyleDone target:self action:@selector(toHelp)];
    
}

-(void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GuideCell class]) bundle:nil]   forCellReuseIdentifier:NSStringFromClass([GuideCell class])];
    self.tableView.backgroundColor = XCOLOR_WHITE;
    self.tableView.estimatedRowHeight = 255;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

//更新UI
- (void)updateUIWithResponse:(id)response{
    
    self.groups = [GuideOverseaModel mj_objectArrayWithKeyValuesArray:response];
    for (GuideOverseaModel *guideModel  in self.groups) {
        for (NSInteger row = 0; row < guideModel.process.count; row++) {
            GuideProcess *pro = guideModel.process[row];
            pro.current_index = 1;
            pro.row = (row + 1);
        }
        
    }
    
    self.current_guide  = self.groups.count > 0 ? self.groups[0] : nil;
    [self.tableView reloadData];
    self.current_guide ? [self makeTopView:self.groups] :   [self.tableView emptyViewWithError:NetRequest_NoDATA];
}

- (void)makeTopView:(NSArray *)groups{
    
    NSArray *titles = [groups valueForKey:@"coutry"];
    CGFloat top_height = 50;
   FSSegmentTitleView *topView  = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),top_height) titles:titles delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    [self.view addSubview:topView];
    self.tableView.contentInset = UIEdgeInsetsMake(top_height  + 20, 0, XNAV_HEIGHT , 0);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   self.current_guide.process.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GuideCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GuideCell class]) forIndexPath:indexPath];
    cell.process = self.current_guide.process_arr[indexPath.row];
    WeakSelf
    cell.actionBlock = ^(NSString *url){
        [weakSelf guideItemClick:url];
    };

    return cell;
}



#pragma mark : FSSegmentTitleViewDelegate

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
 
    for (GuideProcess *pro  in self.current_guide.process) {
        
         pro.item_offset_x = 0;
         pro.current_index = 1;
        
    }
  
    self.current_guide = self.groups[endIndex];

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tableView reloadData];
    
}


#pragma mark :事件处理

- (void)guideItemClick:(NSString *)url{
/*
 跳转url说明:
 myoffer://article/{id} -> 跳转到指定id的文章页面
 myoffer://topic/{id} -> 跳转到指定id的专题页面
 myoffer://ranking -> 跳转到排名页面
 myoffer://area -> 跳转到地区页面
 */
    
    NSString *item = [url componentsSeparatedByString:@"/"].lastObject;
    
    if ([url hasPrefix:@"myoffer://article"]) {
        
         MessageDetaillViewController *vc = [[MessageDetaillViewController alloc] initWithMessageId:item];
         [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    if ([url hasPrefix:@"myoffer://topic"]) {
        
        MessageTopicViewController *topic = [[MessageTopicViewController alloc] init];
        topic.topic_id = item;
        [self.navigationController pushViewController:topic animated:YES];
        
        return;
    }
    
    [self.tabBarController setSelectedIndex:1];
    UINavigationController *nav  = self.tabBarController.childViewControllers[1];
    CatigoryViewController *catigroy =  (CatigoryViewController *)nav.childViewControllers[0];
    
    if ([url isEqualToString:@"myoffer://ranking"]) {

        [catigroy jumpToRank];
    }
    
    if ([url isEqualToString:@"myoffer://area"]) {
        
        [catigroy jumpToHotCity];
    }
    
    [self dismiss];

    
}

- (void)toHelp{

    WebViewController *help = [[WebViewController alloc] init];
    help.path  = [NSString stringWithFormat:@"%@faq#index=0",DOMAINURL];
    [self.navigationController pushViewController:help animated:YES];
 
}


- (void)dealloc{
    
    KDClassLog(@" GuideOverseaViewController 留学指南");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
